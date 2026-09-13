import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { TalentService } from '../../services/talent.service';
import { ToastService } from '../../services/toast.service';
import { CandidateSearchRequest, CandidateSearchResult, SavedSearch, TalentPool } from '../../models/talent.model';
import { stageBadgeClass } from '../../models/pipeline.model';

@Component({
  selector: 'app-talent-search',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './talent-search.component.html'
})
export class TalentSearchComponent implements OnInit {
  filters: CandidateSearchRequest = {};
  results = signal<CandidateSearchResult[]>([]);
  loading = signal(false);
  searched = signal(false);
  readonly stageBadgeClass = stageBadgeClass;

  savedSearches = signal<SavedSearch[]>([]);
  saveSearchName = '';
  showSaveForm = signal(false);

  pools = signal<TalentPool[]>([]);
  addToPoolCandidateId: number | null = null;
  selectedPoolId: number | null = null;

  constructor(private talentService: TalentService, private toast: ToastService, private router: Router) {}

  ngOnInit(): void {
    this.talentService.getSavedSearches().subscribe({ next: (s) => this.savedSearches.set(s) });
    this.talentService.getPools().subscribe({ next: (p) => this.pools.set(p) });
  }

  runSearch(): void {
    this.loading.set(true);
    this.searched.set(true);
    this.talentService.search(this.filters).subscribe({
      next: (r) => { this.results.set(r); this.loading.set(false); },
      error: () => { this.toast.error('Search failed.'); this.loading.set(false); }
    });
  }

  clearFilters(): void {
    this.filters = {};
    this.results.set([]);
    this.searched.set(false);
  }

  applySavedSearch(s: SavedSearch): void {
    this.filters = { keyword: s.keyword, minExperience: s.minExperience, maxExperience: s.maxExperience, location: s.location, status: s.status, source: s.source };
    this.runSearch();
  }

  saveCurrentSearch(): void {
    if (!this.saveSearchName) return;
    this.talentService.saveSearch(this.saveSearchName, this.filters).subscribe({
      next: () => {
        this.toast.success('Search saved.');
        this.showSaveForm.set(false);
        this.saveSearchName = '';
        this.talentService.getSavedSearches().subscribe({ next: (s) => this.savedSearches.set(s) });
      },
      error: () => this.toast.error('Could not save search.')
    });
  }

  deleteSavedSearch(s: SavedSearch): void {
    this.talentService.deleteSavedSearch(s.id).subscribe({
      next: () => this.savedSearches.update((list) => list.filter((x) => x.id !== s.id)),
      error: () => this.toast.error('Could not delete saved search.')
    });
  }

  openCandidate(c: CandidateSearchResult): void {
    this.router.navigate(['/workspace/candidates', c.id]);
  }

  addToPool(candidateId: number, poolId: number, event: Event): void {
    event.stopPropagation();
    this.talentService.addPoolMember(poolId, candidateId).subscribe({
      next: () => this.toast.success('Added to talent pool.'),
      error: () => this.toast.error('Could not add to pool.')
    });
  }
}
