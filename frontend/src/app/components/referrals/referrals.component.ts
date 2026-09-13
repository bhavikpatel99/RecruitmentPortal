import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ReferralService } from '../../services/referral.service';
import { JobService } from '../../services/job.service';
import { ToastService } from '../../services/toast.service';
import { AuthService } from '../../services/auth.service';
import { BONUS_STATUSES, Referral } from '../../models/agency-referral.model';
import { Job } from '../../models/job.model';

@Component({
  selector: 'app-referrals',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './referrals.component.html'
})
export class ReferralsComponent implements OnInit {
  jobs = signal<Job[]>([]);
  myReferrals = signal<Referral[]>([]);
  allReferrals = signal<Referral[]>([]);
  selectedJobId: number | null = null;
  generatedLink = signal<string | null>(null);
  bonusStatuses = BONUS_STATUSES;
  bonusDraft: Record<number, { amount: number | null; status: string }> = {};

  constructor(
    private referralService: ReferralService,
    private jobService: JobService,
    private toast: ToastService,
    public auth: AuthService
  ) {}

  ngOnInit(): void {
    this.jobService.getOpenJobs().subscribe({ next: (j) => this.jobs.set(j) });
    this.loadMine();
    if (this.isAdmin) this.loadAll();
  }

  get isAdmin(): boolean {
    return this.auth.user()?.role === 'Admin';
  }

  loadMine(): void {
    this.referralService.getMine().subscribe({ next: (r) => this.myReferrals.set(r) });
  }

  loadAll(): void {
    this.referralService.getAll().subscribe({ next: (r) => this.allReferrals.set(r) });
  }

  generateLink(): void {
    if (!this.selectedJobId) return;
    this.referralService.createLink(this.selectedJobId).subscribe({
      next: (res) => {
        const url = `${window.location.origin}/jobs?ref=${res.referralCode}`;
        this.generatedLink.set(url);
        this.loadMine();
      },
      error: () => this.toast.error('Could not generate referral link.')
    });
  }

  copyLink(): void {
    const link = this.generatedLink();
    if (!link) return;
    navigator.clipboard?.writeText(link).then(() => this.toast.success('Link copied to clipboard.')).catch(() => {});
  }

  getDraft(r: Referral) {
    if (!this.bonusDraft[r.id]) this.bonusDraft[r.id] = { amount: r.bonusAmount ?? null, status: r.bonusStatus };
    return this.bonusDraft[r.id];
  }

  saveBonus(r: Referral): void {
    const draft = this.getDraft(r);
    this.referralService.updateBonus(r.id, draft.amount, draft.status).subscribe({
      next: () => { this.toast.success('Bonus updated.'); this.loadAll(); },
      error: () => this.toast.error('Could not update bonus.')
    });
  }
}
