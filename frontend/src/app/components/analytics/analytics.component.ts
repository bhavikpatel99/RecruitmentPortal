import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AnalyticsService } from '../../services/analytics.service';
import {
  InterviewTurnaroundRow, OfferStatsRow, RecruiterProductivityRow, SourceEffectivenessRow,
  StageFunnelRow, TimeToFillRow, TimeToHireRow
} from '../../models/analytics.model';

@Component({
  selector: 'app-analytics',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './analytics.component.html'
})
export class AnalyticsComponent implements OnInit {
  loading = signal(true);
  timeToFill = signal<TimeToFillRow[]>([]);
  timeToHire = signal<TimeToHireRow[]>([]);
  sourceEffectiveness = signal<SourceEffectivenessRow[]>([]);
  stageFunnel = signal<StageFunnelRow[]>([]);
  recruiterProductivity = signal<RecruiterProductivityRow[]>([]);
  interviewTurnaround = signal<InterviewTurnaroundRow[]>([]);
  offerStats = signal<OfferStatsRow[]>([]);

  constructor(private analyticsService: AnalyticsService) {}

  ngOnInit(): void {
    this.analyticsService.getTimeToFill().subscribe({ next: (d) => this.timeToFill.set(d) });
    this.analyticsService.getTimeToHire().subscribe({ next: (d) => this.timeToHire.set(d) });
    this.analyticsService.getSourceEffectiveness().subscribe({ next: (d) => this.sourceEffectiveness.set(d) });
    this.analyticsService.getStageFunnel().subscribe({ next: (d) => this.stageFunnel.set(d) });
    this.analyticsService.getRecruiterProductivity().subscribe({ next: (d) => this.recruiterProductivity.set(d) });
    this.analyticsService.getInterviewTurnaround().subscribe({ next: (d) => this.interviewTurnaround.set(d) });
    this.analyticsService.getOfferStats().subscribe({ next: (d) => { this.offerStats.set(d); this.loading.set(false); } });
  }

  get avgTimeToFill(): number {
    const rows = this.timeToFill();
    if (rows.length === 0) return 0;
    return Math.round(rows.reduce((sum, r) => sum + r.daysToFill, 0) / rows.length);
  }

  get avgTimeToHire(): number {
    const rows = this.timeToHire();
    if (rows.length === 0) return 0;
    return Math.round(rows.reduce((sum, r) => sum + r.daysToHire, 0) / rows.length);
  }

  get offerAcceptanceRate(): number {
    const rows = this.offerStats();
    const accepted = rows.find((r) => r.status === 'Accepted')?.count ?? 0;
    const responded = rows.filter((r) => ['Accepted', 'Rejected', 'Withdrawn'].includes(r.status)).reduce((s, r) => s + r.count, 0);
    return responded === 0 ? 0 : Math.round((accepted / responded) * 100);
  }

  get maxFunnelCount(): number {
    return Math.max(1, ...this.stageFunnel().map((s) => s.candidateCount));
  }

  funnelBarWidth(count: number): string {
    return `${Math.round((count / this.maxFunnelCount) * 100)}%`;
  }
}
