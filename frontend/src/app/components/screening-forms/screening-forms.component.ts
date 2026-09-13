import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ScreeningService } from '../../services/screening.service';
import { JobService } from '../../services/job.service';
import { ToastService } from '../../services/toast.service';
import { QUESTION_TYPES, ScreeningForm, ScreeningQuestion } from '../../models/screening.model';
import { Job } from '../../models/job.model';

@Component({
  selector: 'app-screening-forms',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './screening-forms.component.html'
})
export class ScreeningFormsComponent implements OnInit {
  forms = signal<ScreeningForm[]>([]);
  jobs = signal<Job[]>([]);
  loading = signal(true);

  showFormModal = signal(false);
  formDraft: ScreeningForm = { title: '', description: '', jobId: null };

  expandedFormId = signal<number | null>(null);
  questions = signal<ScreeningQuestion[]>([]);
  questionDraft: ScreeningQuestion = this.emptyQuestion(0);
  questionTypes = QUESTION_TYPES;

  constructor(private screeningService: ScreeningService, private jobService: JobService, private toast: ToastService) {}

  ngOnInit(): void {
    this.jobService.getAll().subscribe({ next: (j) => this.jobs.set(j) });
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.screeningService.getForms().subscribe({
      next: (f) => { this.forms.set(f); this.loading.set(false); },
      error: () => { this.toast.error('Could not load screening forms.'); this.loading.set(false); }
    });
  }

  jobTitle(jobId?: number | null): string {
    return this.jobs().find((j) => j.id === jobId)?.title || 'All jobs';
  }

  openCreate(): void {
    this.formDraft = { title: '', description: '', jobId: null };
    this.showFormModal.set(true);
  }

  submitForm(): void {
    this.screeningService.createForm(this.formDraft).subscribe({
      next: () => { this.toast.success('Screening form created.'); this.showFormModal.set(false); this.load(); },
      error: () => this.toast.error('Could not create form.')
    });
  }

  toggleExpand(form: ScreeningForm): void {
    if (this.expandedFormId() === form.id) {
      this.expandedFormId.set(null);
      return;
    }
    this.expandedFormId.set(form.id!);
    this.questionDraft = this.emptyQuestion(form.id!);
    this.loadQuestions(form.id!);
  }

  loadQuestions(formId: number): void {
    this.screeningService.getQuestions(formId).subscribe({ next: (q) => this.questions.set(q) });
  }

  addQuestion(formId: number): void {
    this.screeningService.addQuestion(formId, this.questionDraft).subscribe({
      next: () => {
        this.toast.success('Question added.');
        this.questionDraft = this.emptyQuestion(formId);
        this.loadQuestions(formId);
      },
      error: () => this.toast.error('Could not add question.')
    });
  }

  removeQuestion(id: number, formId: number): void {
    this.screeningService.deleteQuestion(id).subscribe({
      next: () => this.loadQuestions(formId),
      error: () => this.toast.error('Could not remove question.')
    });
  }

  private emptyQuestion(formId: number): ScreeningQuestion {
    return { screeningFormId: formId, questionText: '', questionType: 'YesNo', isKnockout: false, sortOrder: 0 };
  }
}
