import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Agency, AgencyPerformance, AgencySubmission } from '../models/agency-referral.model';

@Injectable({ providedIn: 'root' })
export class AgencyService {
  private readonly baseUrl = `${environment.apiUrl}/agency`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<Agency[]> { return this.http.get<Agency[]>(this.baseUrl); }
  create(agency: Agency): Observable<{ id: number }> { return this.http.post<{ id: number }>(this.baseUrl, agency); }
  createUser(agencyId: number, fullName: string, email: string, password: string): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/users`, { agencyId, fullName, email, password });
  }
  getPerformance(): Observable<AgencyPerformance[]> { return this.http.get<AgencyPerformance[]>(`${this.baseUrl}/performance`); }
  getAllSubmissions(): Observable<AgencySubmission[]> { return this.http.get<AgencySubmission[]>(`${this.baseUrl}/submissions`); }
  getMySubmissions(): Observable<AgencySubmission[]> { return this.http.get<AgencySubmission[]>(`${this.baseUrl}/submissions/mine`); }
  submit(payload: any): Observable<{ candidateId: number }> { return this.http.post<{ candidateId: number }>(`${this.baseUrl}/submissions`, payload); }
}
