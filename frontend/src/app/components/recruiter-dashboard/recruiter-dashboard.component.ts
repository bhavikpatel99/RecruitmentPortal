import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { forkJoin } from 'rxjs';
import { JobService } from '../../services/job.service';
import { JobRequisitionService } from '../../services/job-requisition.service';
import { CandidateService } from '../../services/candidate.service';
import { InterviewManagementService } from '../../services/interview-management.service';
import { AuthService } from '../../services/auth.service';
import { ToastService } from '../../services/toast.service';
import { Job } from '../../models/job.model';
import { JobRequisition } from '../../models/job-requisition.model';
import { Candidate } from '../../models/candidate.model';
import { ScheduledInterview } from '../../models/interview-management.model';
import { TERMINAL_STAGES, stageBadgeClass } from '../../models/pipeline.model';

@Component({
  selector: 'app-recruiter-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './recruiter-dashboard.component.html'
})
export class RecruiterDashboardComponent implements OnInit {
  loading = signal(true);
  jobs = signal<Job[]>([]);
  requisitions = signal<JobRequisition[]>([]);
  candidates = signal<Candidate[]>([]);
  interviews = signal<ScheduledInterview[]>([]);
  readonly stageBadgeClass = stageBadgeClass;

  constructor(
    private jobService: JobService,
    private reqService: JobRequisitionService,
    private candidateService: CandidateService,
    private interviewService: InterviewManagementService,
    public auth: AuthService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    forkJoin({
      jobs: this.jobService.getAll(),
      requisitions: this.reqService.getAll(),
      candidates: this.candidateService.getAll(),
      interviews: this.interviewService.getAll()
    }).subscribe({
      next: ({ jobs, requisitions, candidates, interviews }) => {
        this.jobs.set(jobs);
        this.requisitions.set(requisitions);
        this.candidates.set(candidates);
        this.interviews.set(interviews);
        this.loading.set(false);
      },
      error: () => { this.toast.error('Could not load dashboard data.'); this.loading.set(false); }
    });
  }

  get openJobsCount(): number {
    return this.jobs().filter((j) => j.status === 'Open').length;
  }

  get pendingApprovalCount(): number {
    return this.requisitions().filter((r) => r.status === 'PendingApproval').length;
  }

  get activeCandidatesCount(): number {
    return this.candidates().filter((c) => !TERMINAL_STAGES.includes(c.status || '')).length;
  }

  get interviewsTodayCount(): number {
    const today = new Date().toDateString();
    return this.interviews().filter((i) => i.status === 'Scheduled' && i.scheduledAt && new Date(i.scheduledAt).toDateString() === today).length;
  }

  get upcomingInterviews(): ScheduledInterview[] {
    const now = new Date();
    return this.interviews()
      .filter((i) => i.status === 'Scheduled' && i.scheduledAt && new Date(i.scheduledAt) >= now)
      .sort((a, b) => new Date(a.scheduledAt!).getTime() - new Date(b.scheduledAt!).getTime())
      .slice(0, 5);
  }

  get recentCandidates(): Candidate[] {
    return [...this.candidates()]
      .sort((a, b) => new Date(b.createdAt || 0).getTime() - new Date(a.createdAt || 0).getTime())
      .slice(0, 5);
  }

  candidateName(id: number): string {
    const c = this.candidates().find((x) => x.id === id);
    return c ? `${c.firstName} ${c.lastName}` : `Candidate #${id}`;
  }

  funnelCount(stage: string): number {
    return this.candidates().filter((c) => c.status === stage).length;
  }
}
