import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { UserSummary } from '../models/user-summary.model';

@Injectable({ providedIn: 'root' })
export class UserService {
  private readonly baseUrl = `${environment.apiUrl}/users`;

  constructor(private http: HttpClient) {}

  getAll(role?: string): Observable<UserSummary[]> {
    const params: Record<string, string> = {};
    if (role) params['role'] = role;
    return this.http.get<UserSummary[]>(this.baseUrl, { params });
  }
}
