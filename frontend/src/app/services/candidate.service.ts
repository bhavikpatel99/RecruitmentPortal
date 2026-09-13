import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Candidate } from '../models/candidate.model';
import { CandidateStageHistory } from '../models/pipeline.model';

export interface ResumeUploadResult {
  resumeUrl: string;
  resumeFileName: string;
}

@Injectable({ providedIn: 'root' })
export class CandidateService {
  private readonly baseUrl = `${environment.apiUrl}/candidates`;
  /** Origin the API serves uploaded files from (apiUrl minus the trailing /api). */
  private readonly fileOrigin = environment.apiUrl.replace(/\/api\/?$/, '');

  constructor(private http: HttpClient) {}

  /** Uploads/replaces a candidate's resume file (PDF/DOC/DOCX, 5 MB max). */
  uploadResume(id: number, file: File): Observable<ResumeUploadResult> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post<ResumeUploadResult>(`${this.baseUrl}/${id}/resume`, formData);
  }

  /** Builds a full, directly-openable URL from a stored resumeUrl (relative path or absolute external link). */
  resumeFileUrl(resumeUrl: string | null | undefined): string | null {
    if (!resumeUrl) return null;
    return /^https?:\/\//i.test(resumeUrl) ? resumeUrl : `${this.fileOrigin}${resumeUrl}`;
  }

  getAll(): Observable<Candidate[]> {
    return this.http.get<Candidate[]>(this.baseUrl);
  }

  getByUserId(userId: number): Observable<Candidate[]> {
    return this.http.get<Candidate[]>(`${this.baseUrl}/user/${userId}`);
  }

  getById(id: number): Observable<Candidate> {
    return this.http.get<Candidate>(`${this.baseUrl}/${id}`);
  }

  create(candidate: Candidate): Observable<Candidate> {
    return this.http.post<Candidate>(this.baseUrl, candidate);
  }

  update(id: number, candidate: Candidate): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, candidate);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  changeStage(id: number, newStatus: string, reason?: string, notes?: string): Observable<void> {
    return this.http.patch<void>(`${this.baseUrl}/${id}/stage`, { newStatus, reason, notes });
  }

  getStageHistory(id: number): Observable<CandidateStageHistory[]> {
    return this.http.get<CandidateStageHistory[]>(`${this.baseUrl}/${id}/stage-history`);
  }
}
