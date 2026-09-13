import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  InterviewTurnaroundRow, OfferStatsRow, RecruiterProductivityRow, SourceEffectivenessRow,
  StageFunnelRow, TimeToFillRow, TimeToHireRow
} from '../models/analytics.model';

@Injectable({ providedIn: 'root' })
export class AnalyticsService {
  private readonly baseUrl = `${environment.apiUrl}/analytics`;

  constructor(private http: HttpClient) {}

  getTimeToFill(): Observable<TimeToFillRow[]> { return this.http.get<TimeToFillRow[]>(`${this.baseUrl}/time-to-fill`); }
  getTimeToHire(): Observable<TimeToHireRow[]> { return this.http.get<TimeToHireRow[]>(`${this.baseUrl}/time-to-hire`); }
  getSourceEffectiveness(): Observable<SourceEffectivenessRow[]> { return this.http.get<SourceEffectivenessRow[]>(`${this.baseUrl}/source-effectiveness`); }
  getStageFunnel(): Observable<StageFunnelRow[]> { return this.http.get<StageFunnelRow[]>(`${this.baseUrl}/stage-funnel`); }
  getRecruiterProductivity(): Observable<RecruiterProductivityRow[]> { return this.http.get<RecruiterProductivityRow[]>(`${this.baseUrl}/recruiter-productivity`); }
  getInterviewTurnaround(): Observable<InterviewTurnaroundRow[]> { return this.http.get<InterviewTurnaroundRow[]>(`${this.baseUrl}/interview-turnaround`); }
  getOfferStats(): Observable<OfferStatsRow[]> { return this.http.get<OfferStatsRow[]>(`${this.baseUrl}/offer-stats`); }
}
