import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { JobService } from '../../services/job.service';
import { ToastService } from '../../services/toast.service';
import { Job, JobPostingChannel, JOB_POSTING_CHANNELS } from '../../models/job.model';

const EMPTY_JOB: Job = {
  title: '',
  description: '',
  requirements: '',
  responsibilities: '',
  location: '',
  employmentType: 'Full-time',
  department: '',
  skills: '',
  mustHaveSkills: '',
  niceToHaveSkills: '',
  educationRequirement: '',
  workMode: 'Onsite',
  benefitsText: '',
  legalText: 'We are an equal opportunity employer and consider all qualified applicants without regard to race, color, religion, gender, gender identity, sexual orientation, national origin, disability, or age.'
};

@Component({
  selector: 'app-recruiter-jobs',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './recruiter-jobs.component.html'
})
export class RecruiterJobsComponent implements OnInit {
  jobs = signal<Job[]>([]);
  loading = signal(true);
  showForm = signal(false);
  editingId: number | null = null;
  form: Job = { ...EMPTY_JOB };

  showPublishFor = signal<Job | null>(null);
  channels = signal<JobPostingChannel[]>([]);
  channelOptions = JOB_POSTING_CHANNELS;
  newChannel = 'CareerSite';
  newChannelUrl = '';
  newChannelExpiry = '';

  constructor(private jobService: JobService, private toast: ToastService, private router: Router) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.jobService.getAll().subscribe({
      next: (data) => { this.jobs.set(data); this.loading.set(false); },
      error: () => { this.toast.error('Could not load jobs.'); this.loading.set(false); }
    });
  }

  openCreate(): void {
    this.editingId = null;
    this.form = { ...EMPTY_JOB };
    this.showForm.set(true);
  }

  openEdit(job: Job): void {
    this.editingId = job.id!;
    this.form = { ...job };
    this.showForm.set(true);
  }

  closeForm(): void {
    this.showForm.set(false);
  }

  submit(): void {
    if (this.editingId) {
      this.jobService.update(this.editingId, this.form).subscribe({
        next: () => { this.toast.success('Job updated.'); this.showForm.set(false); this.load(); },
        error: () => this.toast.error('Could not update job.')
      });
    } else {
      this.jobService.create(this.form).subscribe({
        next: () => { this.toast.success('Job posted.'); this.showForm.set(false); this.load(); },
        error: (err) => this.toast.error(err?.error?.message || 'Could not create job.')
      });
    }
  }

  closeJob(job: Job): void {
    if (!confirm(`Close job posting "${job.title}"?`)) return;
    this.jobService.update(job.id!, { ...job, status: 'Closed', closedDate: new Date().toISOString() }).subscribe({
      next: () => { this.toast.info('Job closed.'); this.load(); },
      error: () => this.toast.error('Could not close job.')
    });
  }

  viewPipeline(job: Job): void {
    this.router.navigate(['/workspace/pipeline'], { queryParams: { jobId: job.id } });
  }

  openPublish(job: Job): void {
    this.showPublishFor.set(job);
    this.newChannel = 'CareerSite';
    this.newChannelUrl = '';
    this.newChannelExpiry = '';
    this.jobService.getChannels(job.id!).subscribe({ next: (c) => this.channels.set(c) });
  }

  closePublish(): void {
    this.showPublishFor.set(null);
  }

  addChannel(): void {
    const job = this.showPublishFor();
    if (!job) return;
    this.jobService.addChannel(job.id!, this.newChannel, this.newChannelUrl, this.newChannelExpiry || undefined).subscribe({
      next: () => {
        this.toast.success(`Marked as published to ${this.newChannel}.`);
        this.jobService.getChannels(job.id!).subscribe({ next: (c) => this.channels.set(c) });
      },
      error: () => this.toast.error('Could not add channel.')
    });
  }

  removeChannel(channel: JobPostingChannel): void {
    this.jobService.updateChannelStatus(channel.id!, 'Removed').subscribe({
      next: () => {
        const job = this.showPublishFor();
        if (job) this.jobService.getChannels(job.id!).subscribe({ next: (c) => this.channels.set(c) });
      },
      error: () => this.toast.error('Could not update channel.')
    });
  }
}
