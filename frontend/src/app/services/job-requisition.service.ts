import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { JobRequisition, JobRequisitionAudit } from '../models/job-requisition.model';

@Injectable({ providedIn: 'root' })
export class JobRequisitionService {
  private readonly baseUrl = `${environment.apiUrl}/jobrequisitions`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<JobRequisition[]> {
    return this.http.get<JobRequisition[]>(this.baseUrl);
  }

  getById(id: number): Observable<JobRequisition> {
    return this.http.get<JobRequisition>(`${this.baseUrl}/${id}`);
  }

  getAudit(id: number): Observable<JobRequisitionAudit[]> {
    return this.http.get<JobRequisitionAudit[]>(`${this.baseUrl}/${id}/audit`);
  }

  create(requisition: JobRequisition): Observable<JobRequisition> {
    return this.http.post<JobRequisition>(this.baseUrl, requisition);
  }

  update(id: number, requisition: JobRequisition): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, requisition);
  }

  updateStatus(id: number, newStatus: string, rejectionReason?: string, notes?: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/status`, { newStatus, rejectionReason, notes });
  }

  linkJob(id: number, jobId: number): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/link-job/${jobId}`, {});
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
