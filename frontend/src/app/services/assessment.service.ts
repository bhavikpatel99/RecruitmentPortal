import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { AssessmentInvitation, AssessmentTemplate } from '../models/assessment.model';

@Injectable({ providedIn: 'root' })
export class AssessmentService {
  private readonly baseUrl = `${environment.apiUrl}/assessments`;

  constructor(private http: HttpClient) {}

  getTemplates(): Observable<AssessmentTemplate[]> {
    return this.http.get<AssessmentTemplate[]>(`${this.baseUrl}/templates`);
  }

  createTemplate(template: AssessmentTemplate): Observable<AssessmentTemplate> {
    return this.http.post<AssessmentTemplate>(`${this.baseUrl}/templates`, template);
  }

  deleteTemplate(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/templates/${id}`);
  }

  getAllInvitations(): Observable<AssessmentInvitation[]> {
    return this.http.get<AssessmentInvitation[]>(`${this.baseUrl}/invitations`);
  }

  getInvitationsForCandidate(candidateId: number): Observable<AssessmentInvitation[]> {
    return this.http.get<AssessmentInvitation[]>(`${this.baseUrl}/candidates/${candidateId}/invitations`);
  }

  invite(candidateId: number, assessmentTemplateId: number, deadline?: string | null): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/invitations`, { candidateId, assessmentTemplateId, deadline });
  }

  recordResult(id: number, score: number, notes?: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/invitations/${id}/result`, { score, notes });
  }

  updateStatus(id: number, status: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/invitations/${id}/status`, { status });
  }
}
