import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  CandidateNote, CandidateSearchRequest, CandidateSearchResult, CandidateTag,
  SavedSearch, TalentPool, TalentPoolMember, TalentPoolSummary
} from '../models/talent.model';

@Injectable({ providedIn: 'root' })
export class TalentService {
  private readonly baseUrl = `${environment.apiUrl}/talent`;

  constructor(private http: HttpClient) {}

  getNotes(candidateId: number): Observable<CandidateNote[]> {
    return this.http.get<CandidateNote[]>(`${this.baseUrl}/candidates/${candidateId}/notes`);
  }

  addNote(candidateId: number, note: string): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/candidates/${candidateId}/notes`, { note });
  }

  getTags(candidateId: number): Observable<CandidateTag[]> {
    return this.http.get<CandidateTag[]>(`${this.baseUrl}/candidates/${candidateId}/tags`);
  }

  addTag(candidateId: number, tag: string): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/candidates/${candidateId}/tags`, { tag });
  }

  removeTag(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/tags/${id}`);
  }

  getAllTags(): Observable<string[]> {
    return this.http.get<string[]>(`${this.baseUrl}/tags`);
  }

  getPools(): Observable<TalentPool[]> {
    return this.http.get<TalentPool[]>(`${this.baseUrl}/pools`);
  }

  createPool(name: string, description?: string): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/pools`, { name, description });
  }

  getPoolMembers(poolId: number): Observable<TalentPoolMember[]> {
    return this.http.get<TalentPoolMember[]>(`${this.baseUrl}/pools/${poolId}/members`);
  }

  addPoolMember(poolId: number, candidateId: number): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/pools/${poolId}/members/${candidateId}`, {});
  }

  removePoolMember(poolId: number, candidateId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/pools/${poolId}/members/${candidateId}`);
  }

  getPoolsForCandidate(candidateId: number): Observable<TalentPoolSummary[]> {
    return this.http.get<TalentPoolSummary[]>(`${this.baseUrl}/candidates/${candidateId}/pools`);
  }

  search(request: CandidateSearchRequest): Observable<CandidateSearchResult[]> {
    return this.http.post<CandidateSearchResult[]>(`${this.baseUrl}/search`, request);
  }

  getSavedSearches(): Observable<SavedSearch[]> {
    return this.http.get<SavedSearch[]>(`${this.baseUrl}/saved-searches`);
  }

  saveSearch(name: string, request: CandidateSearchRequest): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/saved-searches`, { name, ...request });
  }

  deleteSavedSearch(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/saved-searches/${id}`);
  }
}
