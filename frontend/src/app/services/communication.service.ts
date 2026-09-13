import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { EmailLog, EmailTemplate, SmtpSettings } from '../models/communication.model';

@Injectable({ providedIn: 'root' })
export class CommunicationService {
  private readonly baseUrl = `${environment.apiUrl}/communication`;

  constructor(private http: HttpClient) {}

  getSmtpSettings(): Observable<SmtpSettings | null> {
    return this.http.get<SmtpSettings | null>(`${this.baseUrl}/smtp-settings`);
  }

  saveSmtpSettings(settings: SmtpSettings): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/smtp-settings`, settings);
  }

  sendTestEmail(toEmail: string): Observable<{ message: string }> {
    return this.http.post<{ message: string }>(`${this.baseUrl}/smtp-settings/test`, { toEmail });
  }

  getTemplates(): Observable<EmailTemplate[]> {
    return this.http.get<EmailTemplate[]>(`${this.baseUrl}/templates`);
  }

  createTemplate(template: EmailTemplate): Observable<EmailTemplate> {
    return this.http.post<EmailTemplate>(`${this.baseUrl}/templates`, template);
  }

  updateTemplate(id: number, template: EmailTemplate): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/templates/${id}`, template);
  }

  deleteTemplate(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/templates/${id}`);
  }

  sendEmail(candidateId: number, templateCode: string, placeholders?: Record<string, string>): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/send`, { candidateId, templateCode, placeholders });
  }

  getLog(): Observable<EmailLog[]> {
    return this.http.get<EmailLog[]>(`${this.baseUrl}/log`);
  }

  getLogForCandidate(candidateId: number): Observable<EmailLog[]> {
    return this.http.get<EmailLog[]>(`${this.baseUrl}/log/candidate/${candidateId}`);
  }
}
