import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { CandidateService } from '../../services/candidate.service';
import { ToastService } from '../../services/toast.service';
import { Candidate } from '../../models/candidate.model';
import { stageBadgeClass } from '../../models/pipeline.model';

@Component({
  selector: 'app-candidates-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './candidates-list.component.html'
})
export class CandidatesListComponent implements OnInit {
  candidates = signal<Candidate[]>([]);
  loading = signal(true);
  search = '';
  readonly stageBadgeClass = stageBadgeClass;

  constructor(private candidateService: CandidateService, private toast: ToastService, private router: Router) {}

  ngOnInit(): void {
    this.loading.set(true);
    this.candidateService.getAll().subscribe({
      next: (c) => { this.candidates.set(c); this.loading.set(false); },
      error: () => { this.toast.error('Could not load candidates.'); this.loading.set(false); }
    });
  }

  get filtered(): Candidate[] {
    const term = this.search.trim().toLowerCase();
    if (!term) return this.candidates();
    return this.candidates().filter((c) =>
      `${c.firstName} ${c.lastName} ${c.email} ${c.skills || ''} ${c.positionApplied || ''}`.toLowerCase().includes(term)
    );
  }

  open(c: Candidate): void {
    this.router.navigate(['/workspace/candidates', c.id]);
  }
}
