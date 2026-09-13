import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Referral } from '../models/agency-referral.model';

@Injectable({ providedIn: 'root' })
export class ReferralService {
  private readonly baseUrl = `${environment.apiUrl}/referral`;

  constructor(private http: HttpClient) {}

  createLink(jobId: number): Observable<{ id: number; referralCode: string }> {
    return this.http.post<{ id: number; referralCode: string }>(`${this.baseUrl}/link`, { jobId });
  }

  validate(code: string): Observable<{ jobId: number; jobTitle: string }> {
    return this.http.get<{ jobId: number; jobTitle: string }>(`${this.baseUrl}/validate/${code}`);
  }

  getMine(): Observable<Referral[]> { return this.http.get<Referral[]>(`${this.baseUrl}/mine`); }
  getAll(): Observable<Referral[]> { return this.http.get<Referral[]>(this.baseUrl); }
  updateBonus(id: number, bonusAmount: number | null, bonusStatus: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/bonus`, { bonusAmount, bonusStatus });
  }
}
