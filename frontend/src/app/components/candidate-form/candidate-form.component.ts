import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { Observable } from 'rxjs';
import { CandidateService } from '../../services/candidate.service';
import { JobService } from '../../services/job.service';
import { LookupService } from '../../services/lookup.service';
import { Candidate } from '../../models/candidate.model';
import { Job } from '../../models/job.model';
import { Country, StateItem } from '../../models/lookup.model';
import {
  Validators,
  phoneValidator,
  urlValidator,
  notFutureDate,
  minAge,
  expectedCtcNotBelowCurrent,
  optionalPattern
} from '../../shared/validators';

@Component({
  selector: 'app-candidate-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './candidate-form.component.html'
})
export class CandidateFormComponent implements OnInit {
  private fb = inject(FormBuilder);
  private candidateService = inject(CandidateService);
  private jobService = inject(JobService);
  private lookup = inject(LookupService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);

  Object = Object;
  submitting = false;
  errorMessage = '';
  successMessage = '';
  validationErrors: Record<string, string[]> = {};
  candidateId: number | null = null;
  jobId: number | null = null;
  selectedJob: Job | null = null;
  referralCode: string | null = null;

  // Resume upload
  selectedResumeFile: File | null = null;
  resumeFileError = '';
  existingResumeFileName: string | null = null;
  existingResumeUrl: string | null = null;
  uploadingResume = false;
  private static readonly ALLOWED_RESUME_TYPES = ['.pdf', '.doc', '.docx'];
  private static readonly MAX_RESUME_SIZE = 5 * 1024 * 1024; // 5 MB

  // Dropdown option lists — loaded dynamically from the backend
  countries: Country[] = [];
  states: StateItem[] = [];
  loadingStates = false;
  genders: string[] = [];
  maritalStatuses: string[] = [];
  employmentTypes: string[] = [];
  sources: string[] = [];

  form = this.fb.nonNullable.group(
    {
      jobId: [null as number | null],
      // Personal details
      firstName: ['', [Validators.required, Validators.minLength(2), Validators.maxLength(100)]],
      middleName: ['', [Validators.maxLength(100)]],
      lastName: ['', [Validators.required, Validators.minLength(2), Validators.maxLength(100)]],
      email: ['', [Validators.required, Validators.email, Validators.maxLength(256)]],
      phone: ['', [phoneValidator]],
      alternatePhone: ['', [phoneValidator]],
      dateOfBirth: ['', [notFutureDate, minAge(16)]],
      gender: [''],
      maritalStatus: [''],
      nationality: ['', [Validators.maxLength(100)]],

      // Address
      address: ['', [Validators.maxLength(500)]],
      city: ['', [Validators.maxLength(100)]],
      state: ['', [Validators.maxLength(100)]],
      country: ['', [Validators.maxLength(100)]],
      postalCode: ['', [Validators.maxLength(20), optionalPattern(/^[A-Za-z0-9\s-]{3,20}$/)]],

      // Professional details
      positionApplied: ['', [Validators.maxLength(150)]],
      employmentType: [''],
      totalExperience: [null as number | null, [Validators.min(0), Validators.max(60)]],
      currentCompany: ['', [Validators.maxLength(150)]],
      currentCtc: [null as number | null, [Validators.min(0)]],
      expectedCtc: [null as number | null, [Validators.min(0)]],
      noticePeriodDays: [null as number | null, [Validators.min(0), Validators.max(365)]],
      preferredLocation: ['', [Validators.maxLength(150)]],
      willingToRelocate: [false],
      availableFrom: [''],
      highestQualification: ['', [Validators.maxLength(150)]],
      skills: ['', [Validators.maxLength(1000)]],

      // Links & documents
      linkedInUrl: ['', [urlValidator, Validators.maxLength(300)]],
      portfolioUrl: ['', [urlValidator, Validators.maxLength(300)]],
      gitHubUrl: ['', [urlValidator, Validators.maxLength(300)]],
      resumeUrl: ['', [urlValidator, Validators.maxLength(300)]],
      coverLetter: ['', [Validators.maxLength(4000)]],

      // References & meta
      referenceName: ['', [Validators.maxLength(150)]],
      referenceContact: ['', [Validators.maxLength(150)]],
      source: ['']
    },
    { validators: expectedCtcNotBelowCurrent('currentCtc', 'expectedCtc') }
  );

  get f() {
    return this.form.controls;
  }

  get isEdit(): boolean {
    return this.candidateId !== null;
  }

  onFieldFocus(fieldName: string): void {
    this.form.get(fieldName)?.markAsUntouched();
  }

  onResumeFileSelected(event: Event): void {
    this.resumeFileError = '';
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0] ?? null;
    if (!file) {
      this.selectedResumeFile = null;
      return;
    }

    const extension = file.name.substring(file.name.lastIndexOf('.')).toLowerCase();
    if (!CandidateFormComponent.ALLOWED_RESUME_TYPES.includes(extension)) {
      this.resumeFileError = 'Resume must be a PDF, DOC, or DOCX file.';
      this.selectedResumeFile = null;
      input.value = '';
      return;
    }
    if (file.size > CandidateFormComponent.MAX_RESUME_SIZE) {
      this.resumeFileError = 'Resume file must be 5 MB or smaller.';
      this.selectedResumeFile = null;
      input.value = '';
      return;
    }

    this.selectedResumeFile = file;
  }

  private convertDateToBackendFormat(dateString: string | null): string | null {
    if (!dateString) return null;
    const date = new Date(dateString);
    return date.toISOString();
  }

  ngOnInit(): void {
    this.loadLookups();

    // Check for jobId in query params
    this.route.queryParams.subscribe((params) => {
      if (params['jobId']) {
        this.jobId = Number(params['jobId']);
        this.loadJob(this.jobId);
      }
      if (params['ref']) {
        this.referralCode = params['ref'];
      }
    });

    // Countries must be available before we can resolve a saved candidate's
    // country name to an id (to load its states), so load candidate after.
    this.lookup.getCountries().subscribe({
      next: (countries) => {
        this.countries = countries;
        const idParam = this.route.snapshot.paramMap.get('id');
        if (idParam) {
          this.candidateId = Number(idParam);
          this.loadCandidate(this.candidateId);
        }
      },
      error: () => (this.errorMessage = 'Could not load country list.')
    });
  }

  private loadLookups(): void {
    this.lookup.getCategory('Gender').subscribe((v) => (this.genders = v));
    this.lookup.getCategory('MaritalStatus').subscribe((v) => (this.maritalStatuses = v));
    this.lookup.getCategory('EmploymentType').subscribe((v) => (this.employmentTypes = v));
    this.lookup.getCategory('Source').subscribe((v) => (this.sources = v));
  }

  private loadJob(jobId: number): void {
    this.jobService.getById(jobId).subscribe({
      next: (job) => {
        this.selectedJob = job;
        this.form.patchValue({
          jobId: job.id,
          positionApplied: job.title,
          employmentType: job.employmentType || '',
          preferredLocation: job.location,
          skills: job.skills || ''
        });
      },
      error: () => (this.errorMessage = 'Could not load job details.')
    });
  }

  /** Fired when the country dropdown changes — loads matching states and clears the old state. */
  onCountryChange(): void {
    const countryName = this.form.controls.country.value;
    this.states = [];
    this.form.controls.state.setValue('');
    this.loadStatesForCountry(countryName);
  }

  private loadStatesForCountry(countryName: string): void {
    const country = this.countries.find((c) => c.name === countryName);
    if (!country) return;

    this.loadingStates = true;
    this.lookup.getStates(country.id).subscribe({
      next: (states) => {
        this.states = states;
        this.loadingStates = false;
      },
      error: () => {
        this.states = [];
        this.loadingStates = false;
      }
    });
  }

  private loadCandidate(id: number): void {
    this.candidateService.getById(id).subscribe({
      next: (c) => {
        this.form.patchValue({
          firstName: c.firstName ?? '',
          middleName: c.middleName ?? '',
          lastName: c.lastName ?? '',
          email: c.email ?? '',
          phone: c.phone ?? '',
          alternatePhone: c.alternatePhone ?? '',
          dateOfBirth: c.dateOfBirth ? c.dateOfBirth.substring(0, 10) : '',
          gender: c.gender ?? '',
          maritalStatus: c.maritalStatus ?? '',
          nationality: c.nationality ?? '',
          address: c.address ?? '',
          city: c.city ?? '',
          state: c.state ?? '',
          country: c.country ?? '',
          postalCode: c.postalCode ?? '',
          positionApplied: c.positionApplied ?? '',
          employmentType: c.employmentType ?? '',
          totalExperience: c.totalExperience ?? null,
          currentCompany: c.currentCompany ?? '',
          currentCtc: c.currentCtc ?? null,
          expectedCtc: c.expectedCtc ?? null,
          noticePeriodDays: c.noticePeriodDays ?? null,
          preferredLocation: c.preferredLocation ?? '',
          willingToRelocate: c.willingToRelocate ?? false,
          availableFrom: c.availableFrom ? c.availableFrom.substring(0, 10) : '',
          highestQualification: c.highestQualification ?? '',
          skills: c.skills ?? '',
          linkedInUrl: c.linkedInUrl ?? '',
          portfolioUrl: c.portfolioUrl ?? '',
          gitHubUrl: c.gitHubUrl ?? '',
          resumeUrl: c.resumeUrl ?? '',
          coverLetter: c.coverLetter ?? '',
          referenceName: c.referenceName ?? '',
          referenceContact: c.referenceContact ?? '',
          source: c.source ?? ''
        });

        this.existingResumeFileName = c.resumeFileName ?? null;
        this.existingResumeUrl = this.candidateService.resumeFileUrl(c.resumeUrl);

        // Load the states for the saved country so the state dropdown shows it.
        if (c.country) {
          this.loadStatesForCountry(c.country);
        }
      },
      error: () => (this.errorMessage = 'Could not load candidate details.')
    });
  }

  submit(): void {
    this.errorMessage = '';
    this.successMessage = '';
    this.validationErrors = {};

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      this.errorMessage = 'Please fix the highlighted fields before submitting.';
      return;
    }

    this.submitting = true;
    const formValue = this.form.getRawValue() as Candidate;

    // Convert empty strings to null and format dates
    const payload: any = { ...formValue };

    // Convert dates to ISO format
    if (formValue.dateOfBirth) {
      payload.dateOfBirth = this.convertDateToBackendFormat(formValue.dateOfBirth);
    } else {
      payload.dateOfBirth = null;
    }
    if (formValue.availableFrom) {
      payload.availableFrom = this.convertDateToBackendFormat(formValue.availableFrom);
    } else {
      payload.availableFrom = null;
    }

    // Convert empty strings to null for optional fields
    const optionalFields = [
      'middleName', 'phone', 'alternatePhone', 'gender', 'maritalStatus', 'nationality',
      'address', 'city', 'state', 'country', 'postalCode', 'positionApplied', 'employmentType',
      'currentCompany', 'preferredLocation', 'highestQualification', 'skills',
      'linkedInUrl', 'portfolioUrl', 'gitHubUrl', 'resumeUrl', 'coverLetter',
      'referenceName', 'referenceContact', 'source'
    ];

    optionalFields.forEach(field => {
      if (payload[field] === '') {
        payload[field] = null;
      }
    });

    if (!this.isEdit && this.referralCode) {
      payload.referralCode = this.referralCode;
    }

    const request$: Observable<Candidate | void> = this.isEdit
      ? this.candidateService.update(this.candidateId!, payload)
      : this.candidateService.create(payload);

    request$.subscribe({
      next: (result) => {
        const savedId = this.isEdit ? this.candidateId! : (result as Candidate).id!;

        if (this.selectedResumeFile) {
          this.uploadingResume = true;
          this.candidateService.uploadResume(savedId, this.selectedResumeFile).subscribe({
            next: () => this.finishSubmit(true),
            error: () => {
              // The application itself saved fine; only the resume attachment failed.
              this.uploadingResume = false;
              this.submitting = false;
              this.successMessage = this.isEdit
                ? 'Application updated, but the resume file could not be uploaded. You can try again below.'
                : 'Application submitted, but the resume file could not be uploaded. You can add it later from your dashboard.';
            }
          });
        } else {
          this.finishSubmit(false);
        }
      },
      error: (err) => {
        console.error('Save error:', err);
        console.error('Error status:', err?.status);
        console.error('Error response body:', JSON.stringify(err?.error, null, 2));
        this.submitting = false;

        // Handle validation errors from backend
        if (err?.error?.errors && typeof err.error.errors === 'object') {
          this.validationErrors = err.error.errors;
          this.errorMessage = err.error.message || 'Validation failed. Please check the errors below.';
        } else {
          const errorMsg = err?.error?.message || err?.error?.title || err?.message || 'Could not save the application.';
          this.errorMessage = errorMsg;
        }
      }
    });
  }

  private finishSubmit(resumeUploaded: boolean): void {
    this.uploadingResume = false;
    this.submitting = false;
    this.successMessage = this.isEdit
      ? 'Application updated successfully.'
      : 'Application submitted successfully.';
    setTimeout(() => this.router.navigate(['/jobs']), resumeUploaded ? 1200 : 800);
  }
}
