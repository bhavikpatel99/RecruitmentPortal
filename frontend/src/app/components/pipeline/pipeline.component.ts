import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CdkDragDrop, DragDropModule, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { CandidateService } from '../../services/candidate.service';
import { JobService } from '../../services/job.service';
import { ToastService } from '../../services/toast.service';
import { Candidate } from '../../models/candidate.model';
import { Job } from '../../models/job.model';
import { PIPELINE_STAGES, TERMINAL_STAGES } from '../../models/pipeline.model';

interface Column {
  stage: string;
  candidates: Candidate[];
}

@Component({
  selector: 'app-pipeline',
  standalone: true,
  imports: [CommonModule, FormsModule, DragDropModule],
  templateUrl: './pipeline.component.html',
  styleUrls: ['./pipeline.component.css']
})
export class PipelineComponent implements OnInit {
  jobs = signal<Job[]>([]);
  selectedJobId = signal<number | null>(null);
  columns = signal<Column[]>([]);
  loading = signal(false);
  allStages = [...PIPELINE_STAGES, ...TERMINAL_STAGES];
  connectedColumnIds: string[] = this.allStages.map((s) => 'col-' + s);

  constructor(
    private candidateService: CandidateService,
    private jobService: JobService,
    private toast: ToastService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.jobService.getAll().subscribe({
      next: (jobs) => {
        this.jobs.set(jobs);
        const queryJobId = Number(this.route.snapshot.queryParamMap.get('jobId'));
        const initial = queryJobId || jobs[0]?.id || null;
        if (initial) {
          this.selectedJobId.set(initial);
          this.load();
        }
      },
      error: () => this.toast.error('Could not load jobs.')
    });
  }

  onJobChange(): void {
    this.load();
  }

  load(): void {
    const jobId = this.selectedJobId();
    if (!jobId) return;
    this.loading.set(true);
    this.candidateService.getAll().subscribe({
      next: (all) => {
        const forJob = all.filter((c) => c.jobId === jobId);
        this.columns.set(
          this.allStages.map((stage) => ({
            stage,
            candidates: forJob.filter((c) => c.status === stage)
          }))
        );
        this.loading.set(false);
      },
      error: () => { this.toast.error('Could not load candidates.'); this.loading.set(false); }
    });
  }

  drop(event: CdkDragDrop<Candidate[]>): void {
    if (event.previousContainer === event.container) {
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
      return;
    }

    const candidate = event.previousContainer.data[event.previousIndex];
    const newStage = this.stageForColumnData(event.container.data);
    if (!candidate.id || !newStage) return;

    transferArrayItem(event.previousContainer.data, event.container.data, event.previousIndex, event.currentIndex);
    this.columns.set([...this.columns()]);

    this.candidateService.changeStage(candidate.id, newStage).subscribe({
      next: () => this.toast.success(`Moved ${candidate.firstName} ${candidate.lastName} to ${newStage}.`),
      error: () => {
        this.toast.error('Could not move candidate — reverting.');
        this.load();
      }
    });
  }

  private stageForColumnData(data: Candidate[]): string | undefined {
    return this.columns().find((col) => col.candidates === data)?.stage;
  }

  openDetail(candidate: Candidate): void {
    if (candidate.id) {
      this.router.navigate(['/workspace/candidates', candidate.id]);
    }
  }
}
