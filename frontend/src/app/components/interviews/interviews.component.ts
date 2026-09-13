import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { InterviewManagementService } from '../../services/interview-management.service';
import { CandidateService } from '../../services/candidate.service';
import { JobService } from '../../services/job.service';
import { UserService } from '../../services/user.service';
import { ToastService } from '../../services/toast.service';
import { AuthService } from '../../services/auth.service';
import {
  INTERVIEW_MODES,
  INTERVIEW_RECOMMENDATIONS,
  INTERVIEW_TYPES,
  InterviewFeedback,
  InterviewPanelist,
  ScheduledInterview
} from '../../models/interview-management.model';
import { Candidate } from '../../models/candidate.model';
import { Job } from '../../models/job.model';
import { UserSummary } from '../../models/user-summary.model';

interface ScheduleForm {
  candidateId: number | null;
  jobId: number | null;
  roundNumber: number;
  interviewType: string;
  scheduledAt: string;
  durationMinutes: number;
  mode: string;
  meetingLink: string;
  location: string;
  panelistIds: number[];
  leadInterviewerId: number | null;
}

const EMPTY_SCHEDULE: ScheduleForm = {
  candidateId: null,
  jobId: null,
  roundNumber: 1,
  interviewType: 'Technical',
  scheduledAt: '',
  durationMinutes: 45,
  mode: 'Video',
  meetingLink: '',
  location: '',
  panelistIds: [],
  leadInterviewerId: null
};

function statusBadgeClass(status?: string): string {
  switch (status) {
    case 'Completed': return 'badge-success';
    case 'Cancelled': return 'badge-danger';
    case 'NoShow': return 'badge-warning';
    default: return 'badge-info'; // Scheduled
  }
}

@Component({
  selector: 'app-interviews',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './interviews.component.html'
})
export class InterviewsComponent implements OnInit {
  interviews = signal<ScheduledInterview[]>([]);
  candidates = signal<Candidate[]>([]);
  jobs = signal<Job[]>([]);
  interviewers = signal<UserSummary[]>([]);
  loading = signal(true);

  showScheduleForm = signal(false);
  form: ScheduleForm = { ...EMPTY_SCHEDULE };

  detail = signal<ScheduledInterview | null>(null);
  panelists = signal<InterviewPanelist[]>([]);
  feedbackList = signal<InterviewFeedback[]>([]);
  feedbackForm = { rating: 4, recommendation: 'Hire', strengths: '', concerns: '', comments: '' };
  recommendations = INTERVIEW_RECOMMENDATIONS;

  interviewTypes = INTERVIEW_TYPES;
  interviewModes = INTERVIEW_MODES;

  constructor(
    private interviewService: InterviewManagementService,
    private candidateService: CandidateService,
    private jobService: JobService,
    private userService: UserService,
    private toast: ToastService,
    public auth: AuthService
  ) {}

  ngOnInit(): void {
    this.candidateService.getAll().subscribe({ next: (c) => this.candidates.set(c) });
    this.jobService.getAll().subscribe({ next: (j) => this.jobs.set(j) });
    this.userService.getAll().subscribe({
      next: (users) => this.interviewers.set(users.filter((u) => u.role !== 'Candidate'))
    });
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.interviewService.getAll().subscribe({
      next: (data) => { this.interviews.set(data); this.loading.set(false); },
      error: () => { this.toast.error('Could not load interviews.'); this.loading.set(false); }
    });
  }

  candidateName(id: number): string {
    const c = this.candidates().find((x) => x.id === id);
    return c ? `${c.firstName} ${c.lastName}` : `Candidate #${id}`;
  }

  interviewerName(id: number): string {
    return this.interviewers().find((u) => u.id === id)?.fullName ?? `User #${id}`;
  }

  readonly statusBadgeClass = statusBadgeClass;

  openSchedule(): void {
    this.form = { ...EMPTY_SCHEDULE };
    this.showScheduleForm.set(true);
  }

  closeSchedule(): void {
    this.showScheduleForm.set(false);
  }

  togglePanelist(userId: number): void {
    const idx = this.form.panelistIds.indexOf(userId);
    if (idx >= 0) this.form.panelistIds.splice(idx, 1);
    else this.form.panelistIds.push(userId);
  }

  submitSchedule(): void {
    if (!this.form.candidateId) {
      this.toast.error('Select a candidate.');
      return;
    }
    this.interviewService.schedule({
      candidateId: this.form.candidateId,
      jobId: this.form.jobId,
      roundNumber: this.form.roundNumber,
      interviewType: this.form.interviewType,
      scheduledAt: this.form.scheduledAt ? new Date(this.form.scheduledAt).toISOString() : null,
      durationMinutes: this.form.durationMinutes,
      mode: this.form.mode,
      meetingLink: this.form.meetingLink,
      location: this.form.location,
      panelistIds: this.form.panelistIds,
      leadInterviewerId: this.form.leadInterviewerId
    }).subscribe({
      next: () => { this.toast.success('Interview scheduled.'); this.showScheduleForm.set(false); this.load(); },
      error: (err) => this.toast.error(err?.error?.message || 'Could not schedule interview.')
    });
  }

  openDetail(interview: ScheduledInterview): void {
    this.detail.set(interview);
    this.feedbackForm = { rating: 4, recommendation: 'Hire', strengths: '', concerns: '', comments: '' };
    this.interviewService.getPanelists(interview.id!).subscribe({ next: (p) => this.panelists.set(p) });
    this.interviewService.getFeedback(interview.id!).subscribe({ next: (f) => this.feedbackList.set(f) });
  }

  closeDetail(): void {
    this.detail.set(null);
  }

  markStatus(status: string): void {
    const interview = this.detail();
    if (!interview?.id) return;
    let reason: string | undefined;
    if (status === 'Cancelled') {
      reason = prompt('Cancellation reason?') || undefined;
    }
    this.interviewService.updateStatus(interview.id, status, reason).subscribe({
      next: () => {
        this.toast.success(`Interview marked ${status}.`);
        this.closeDetail();
        this.load();
      },
      error: () => this.toast.error('Could not update interview status.')
    });
  }

  submitFeedback(): void {
    const interview = this.detail();
    if (!interview?.id) return;
    this.interviewService.submitFeedback(interview.id, this.feedbackForm).subscribe({
      next: () => {
        this.toast.success('Feedback submitted.');
        this.interviewService.getFeedback(interview.id!).subscribe({ next: (f) => this.feedbackList.set(f) });
      },
      error: () => this.toast.error('Could not submit feedback.')
    });
  }
}
