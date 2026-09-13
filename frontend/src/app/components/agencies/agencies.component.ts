import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AgencyService } from '../../services/agency.service';
import { ToastService } from '../../services/toast.service';
import { AuthService } from '../../services/auth.service';
import { Agency, AgencyPerformance, AgencySubmission } from '../../models/agency-referral.model';

@Component({
  selector: 'app-agencies',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './agencies.component.html'
})
export class AgenciesComponent implements OnInit {
  agencies = signal<Agency[]>([]);
  performance = signal<AgencyPerformance[]>([]);
  submissions = signal<AgencySubmission[]>([]);
  loading = signal(true);

  showAgencyForm = signal(false);
  agencyDraft: Agency = { name: '', contactEmail: '', contactPhone: '' };

  showUserForm = signal(false);
  userDraft = { agencyId: null as number | null, fullName: '', email: '', password: '' };

  constructor(private agencyService: AgencyService, private toast: ToastService, public auth: AuthService) {}

  ngOnInit(): void {
    this.load();
  }

  get isAdmin(): boolean {
    return this.auth.user()?.role === 'Admin';
  }

  load(): void {
    this.loading.set(true);
    this.agencyService.getAll().subscribe({
      next: (a) => { this.agencies.set(a); this.loading.set(false); },
      error: () => { this.toast.error('Could not load agencies.'); this.loading.set(false); }
    });
    this.agencyService.getPerformance().subscribe({
      next: (p) => this.performance.set(p),
      error: () => this.toast.error('Could not load agency performance data.')
    });
    this.agencyService.getAllSubmissions().subscribe({
      next: (s) => this.submissions.set(s),
      error: () => this.toast.error('Could not load submissions.')
    });
  }

  perfFor(agencyId: number): AgencyPerformance | undefined {
    return this.performance().find((p) => p.id === agencyId);
  }

  openCreateAgency(): void {
    this.agencyDraft = { name: '', contactEmail: '', contactPhone: '' };
    this.showAgencyForm.set(true);
  }

  submitAgency(): void {
    this.agencyService.create(this.agencyDraft).subscribe({
      next: () => { this.toast.success('Agency created.'); this.showAgencyForm.set(false); this.load(); },
      error: () => this.toast.error('Could not create agency.')
    });
  }

  openCreateUser(agency: Agency): void {
    this.userDraft = { agencyId: agency.id!, fullName: '', email: '', password: '' };
    this.showUserForm.set(true);
  }

  submitUser(): void {
    if (!this.userDraft.agencyId) return;
    this.agencyService.createUser(this.userDraft.agencyId, this.userDraft.fullName, this.userDraft.email, this.userDraft.password).subscribe({
      next: () => { this.toast.success('Agency portal login created.'); this.showUserForm.set(false); },
      error: (err) => this.toast.error(err?.error?.message || 'Could not create agency login.')
    });
  }
}
