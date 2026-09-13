import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { JobService } from '../../services/job.service';
import { Job } from '../../models/job.model';

@Component({
  selector: 'app-jobs-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './jobs-list.component.html',
  styleUrls: ['./jobs-list.component.css']
})
export class JobsListComponent implements OnInit {
  jobs = signal<Job[]>([]);
  loading = signal(true);
  errorMessage = signal('');
  selectedJob = signal<Job | null>(null);

  constructor(
    public auth: AuthService,
    private jobService: JobService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.jobService.getOpenJobs().subscribe({
      next: (data) => {
        this.jobs.set(data);
        this.loading.set(false);
      },
      error: () => {
        this.errorMessage.set('Could not load jobs.');
        this.loading.set(false);
      }
    });
  }

  applyForJob(jobId?: number): void {
    if (jobId) {
      this.router.navigate(['/candidate/new'], { queryParams: { jobId } });
    }
  }

  viewDetails(job: Job): void {
    this.selectedJob.set(job);
  }

  closeDetails(): void {
    this.selectedJob.set(null);
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
