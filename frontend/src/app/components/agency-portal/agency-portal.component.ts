import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AgencyService } from '../../services/agency.service';
import { JobService } from '../../services/job.service';
import { AuthService } from '../../services/auth.service';
import { ToastService } from '../../services/toast.service';
import { AgencySubmission } from '../../models/agency-referral.model';
import { Job } from '../../models/job.model';

const EMPTY_SUBMISSION = {
  jobId: null as number | null,
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  positionApplied: '',
  totalExperience: null as number | null,
  currentCompany: '',
  expectedCtc: null as number | null,
  skills: '',
  resumeUrl: ''
};

@Component({
  selector: 'app-agency-portal',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './agency-portal.component.html'
})
export class AgencyPortalComponent implements OnInit {
  jobs = signal<Job[]>([]);
  submissions = signal<AgencySubmission[]>([]);
  showForm = signal(false);
  form = { ...EMPTY_SUBMISSION };

  constructor(
    private agencyService: AgencyService,
    private jobService: JobService,
    private toast: ToastService,
    public auth: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.jobService.getOpenJobs().subscribe({ next: (j) => this.jobs.set(j) });
    this.loadSubmissions();
  }

  loadSubmissions(): void {
    this.agencyService.getMySubmissions().subscribe({ next: (s) => this.submissions.set(s) });
  }

  openSubmit(job: Job): void {
    this.form = { ...EMPTY_SUBMISSION, jobId: job.id!, positionApplied: job.title };
    this.showForm.set(true);
  }

  submit(): void {
    this.agencyService.submit(this.form).subscribe({
      next: () => {
        this.toast.success('Candidate submitted successfully.');
        this.showForm.set(false);
        this.loadSubmissions();
      },
      error: (err) => this.toast.error(err?.error?.message || 'Could not submit candidate.')
    });
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
