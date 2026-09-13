import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { TalentService } from '../../services/talent.service';
import { ToastService } from '../../services/toast.service';
import { TalentPool, TalentPoolMember } from '../../models/talent.model';

@Component({
  selector: 'app-talent-pools',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './talent-pools.component.html'
})
export class TalentPoolsComponent implements OnInit {
  pools = signal<TalentPool[]>([]);
  loading = signal(true);
  showForm = signal(false);
  newPoolName = '';
  newPoolDescription = '';

  expandedPoolId = signal<number | null>(null);
  members = signal<TalentPoolMember[]>([]);

  constructor(private talentService: TalentService, private toast: ToastService, private router: Router) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.talentService.getPools().subscribe({
      next: (p) => { this.pools.set(p); this.loading.set(false); },
      error: () => { this.toast.error('Could not load talent pools.'); this.loading.set(false); }
    });
  }

  createPool(): void {
    if (!this.newPoolName) return;
    this.talentService.createPool(this.newPoolName, this.newPoolDescription).subscribe({
      next: () => {
        this.toast.success('Talent pool created.');
        this.showForm.set(false);
        this.newPoolName = '';
        this.newPoolDescription = '';
        this.load();
      },
      error: () => this.toast.error('Could not create pool.')
    });
  }

  toggleExpand(pool: TalentPool): void {
    if (this.expandedPoolId() === pool.id) {
      this.expandedPoolId.set(null);
      return;
    }
    this.expandedPoolId.set(pool.id);
    this.talentService.getPoolMembers(pool.id).subscribe({ next: (m) => this.members.set(m) });
  }

  removeMember(poolId: number, candidateId: number): void {
    this.talentService.removePoolMember(poolId, candidateId).subscribe({
      next: () => this.members.update((list) => list.filter((m) => m.id !== candidateId)),
      error: () => this.toast.error('Could not remove member.')
    });
  }

  openCandidate(id: number): void {
    this.router.navigate(['/workspace/candidates', id]);
  }
}
