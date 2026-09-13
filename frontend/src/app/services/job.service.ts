import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Job, JobPostingChannel } from '../models/job.model';

@Injectable({ providedIn: 'root' })
export class JobService {
  private readonly baseUrl = `${environment.apiUrl}/jobs`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<Job[]> {
    return this.http.get<Job[]>(this.baseUrl);
  }

  getById(id: number): Observable<Job> {
    return this.http.get<Job>(`${this.baseUrl}/${id}`);
  }

  getOpenJobs(): Observable<Job[]> {
    return this.http.get<Job[]>(`${this.baseUrl}/open`);
  }

  create(job: Job): Observable<Job> {
    return this.http.post<Job>(this.baseUrl, job);
  }

  update(id: number, job: Job): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, job);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  getChannels(jobId: number): Observable<JobPostingChannel[]> {
    return this.http.get<JobPostingChannel[]>(`${this.baseUrl}/${jobId}/channels`);
  }

  addChannel(jobId: number, channel: string, externalUrl?: string, expiryDate?: string): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/${jobId}/channels`, { channel, externalUrl, expiryDate });
  }

  updateChannelStatus(channelId: number, status: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/channels/${channelId}/status`, { status });
  }
}
