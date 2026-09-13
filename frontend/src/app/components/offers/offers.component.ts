import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { OfferService } from '../../services/offer.service';
import { CandidateService } from '../../services/candidate.service';
import { ToastService } from '../../services/toast.service';
import { Offer, offerStatusBadgeClass } from '../../models/offer.model';
import { Candidate } from '../../models/candidate.model';

@Component({
  selector: 'app-offers',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './offers.component.html'
})
export class OffersComponent implements OnInit {
  offers = signal<Offer[]>([]);
  candidates = signal<Candidate[]>([]);
  loading = signal(true);
  readonly offerStatusBadgeClass = offerStatusBadgeClass;

  constructor(
    private offerService: OfferService,
    private candidateService: CandidateService,
    private toast: ToastService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.candidateService.getAll().subscribe({ next: (c) => this.candidates.set(c) });
    this.offerService.getAll().subscribe({
      next: (o) => { this.offers.set(o); this.loading.set(false); },
      error: () => { this.toast.error('Could not load offers.'); this.loading.set(false); }
    });
  }

  candidateName(id: number): string {
    const c = this.candidates().find((x) => x.id === id);
    return c ? `${c.firstName} ${c.lastName}` : `Candidate #${id}`;
  }

  openCandidate(offer: Offer): void {
    this.router.navigate(['/workspace/candidates', offer.candidateId]);
  }
}
