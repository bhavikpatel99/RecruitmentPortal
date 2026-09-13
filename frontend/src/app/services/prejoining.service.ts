import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { HireEvent, PreJoiningChecklist, PreJoiningTask } from '../models/prejoining.model';

@Injectable({ providedIn: 'root' })
export class PreJoiningService {
  private readonly baseUrl = `${environment.apiUrl}/prejoining`;

  constructor(private http: HttpClient) {}

  getByCandidate(candidateId: number): Observable<PreJoiningChecklist[]> {
    return this.http.get<PreJoiningChecklist[]>(`${this.baseUrl}/candidate/${candidateId}`);
  }

  getTasks(checklistId: number): Observable<PreJoiningTask[]> {
    return this.http.get<PreJoiningTask[]>(`${this.baseUrl}/${checklistId}/tasks`);
  }

  setJoiningDate(checklistId: number, joiningDate: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${checklistId}/joining-date`, { joiningDate });
  }

  updateBgvStatus(checklistId: number, bgvStatus: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${checklistId}/bgv-status`, { bgvStatus });
  }

  addTask(checklistId: number, taskName: string, sortOrder = 99): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/${checklistId}/tasks`, { taskName, sortOrder });
  }

  toggleTask(id: number, isCompleted: boolean): Observable<void> {
    return this.http.patch<void>(`${this.baseUrl}/tasks/${id}`, { isCompleted });
  }

  getAllHireEvents(): Observable<HireEvent[]> {
    return this.http.get<HireEvent[]>(`${this.baseUrl}/hire-events`);
  }

  getHireEventsForCandidate(candidateId: number): Observable<HireEvent[]> {
    return this.http.get<HireEvent[]>(`${this.baseUrl}/hire-events/candidate/${candidateId}`);
  }

  markHireEventSent(id: number): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/hire-events/${id}/mark-sent`, {});
  }
}
