import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { InterviewFeedback, InterviewPanelist, ScheduledInterview } from '../models/interview-management.model';

export interface ScheduleInterviewPayload {
  candidateId: number;
  jobId?: number | null;
  roundNumber: number;
  interviewType?: string | null;
  scheduledAt?: string | null;
  durationMinutes?: number | null;
  mode?: string | null;
  meetingLink?: string | null;
  location?: string | null;
  panelistIds: number[];
  leadInterviewerId?: number | null;
}

@Injectable({ providedIn: 'root' })
export class InterviewManagementService {
  private readonly baseUrl = `${environment.apiUrl}/interviews`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<ScheduledInterview[]> {
    return this.http.get<ScheduledInterview[]>(this.baseUrl);
  }

  getByCandidate(candidateId: number): Observable<ScheduledInterview[]> {
    return this.http.get<ScheduledInterview[]>(`${this.baseUrl}/candidate/${candidateId}`);
  }

  getById(id: number): Observable<ScheduledInterview> {
    return this.http.get<ScheduledInterview>(`${this.baseUrl}/${id}`);
  }

  getUpcoming(fromDate?: string): Observable<ScheduledInterview[]> {
    const params: Record<string, string> = {};
    if (fromDate) params['fromDate'] = fromDate;
    return this.http.get<ScheduledInterview[]>(`${this.baseUrl}/upcoming`, { params });
  }

  getPanelists(id: number): Observable<InterviewPanelist[]> {
    return this.http.get<InterviewPanelist[]>(`${this.baseUrl}/${id}/panelists`);
  }

  getFeedback(id: number): Observable<InterviewFeedback[]> {
    return this.http.get<InterviewFeedback[]>(`${this.baseUrl}/${id}/feedback`);
  }

  schedule(payload: ScheduleInterviewPayload): Observable<ScheduledInterview> {
    return this.http.post<ScheduledInterview>(this.baseUrl, payload);
  }

  reschedule(id: number, scheduledAt: string, durationMinutes?: number | null, mode?: string | null, meetingLink?: string | null, location?: string | null): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/reschedule`, { scheduledAt, durationMinutes, mode, meetingLink, location });
  }

  updateStatus(id: number, status: string, cancellationReason?: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/status`, { status, cancellationReason });
  }

  addPanelist(id: number, interviewerId: number, isLead = false): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/panelists/${interviewerId}?isLead=${isLead}`, {});
  }

  removePanelist(id: number, interviewerId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}/panelists/${interviewerId}`);
  }

  submitFeedback(id: number, feedback: { rating?: number | null; recommendation?: string | null; strengths?: string | null; concerns?: string | null; comments?: string | null }): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/feedback`, feedback);
  }
}
