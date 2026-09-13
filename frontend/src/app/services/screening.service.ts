import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { ScreeningAnswer, ScreeningForm, ScreeningQuestion, ScreeningResponse } from '../models/screening.model';

@Injectable({ providedIn: 'root' })
export class ScreeningService {
  private readonly baseUrl = `${environment.apiUrl}/screening`;

  constructor(private http: HttpClient) {}

  getForms(): Observable<ScreeningForm[]> {
    return this.http.get<ScreeningForm[]>(`${this.baseUrl}/forms`);
  }

  getForm(id: number): Observable<ScreeningForm> {
    return this.http.get<ScreeningForm>(`${this.baseUrl}/forms/${id}`);
  }

  createForm(form: ScreeningForm): Observable<ScreeningForm> {
    return this.http.post<ScreeningForm>(`${this.baseUrl}/forms`, form);
  }

  getQuestions(formId: number): Observable<ScreeningQuestion[]> {
    return this.http.get<ScreeningQuestion[]>(`${this.baseUrl}/forms/${formId}/questions`);
  }

  addQuestion(formId: number, question: ScreeningQuestion): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/forms/${formId}/questions`, question);
  }

  deleteQuestion(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/questions/${id}`);
  }

  submitResponse(payload: { candidateId: number; screeningFormId: number; recruiterNotes?: string; answers: { questionId: number; answerText: string }[] }): Observable<{ id: number }> {
    return this.http.post<{ id: number }>(`${this.baseUrl}/responses`, payload);
  }

  getResponsesForCandidate(candidateId: number): Observable<ScreeningResponse[]> {
    return this.http.get<ScreeningResponse[]>(`${this.baseUrl}/candidates/${candidateId}/responses`);
  }

  getAnswers(responseId: number): Observable<ScreeningAnswer[]> {
    return this.http.get<ScreeningAnswer[]>(`${this.baseUrl}/responses/${responseId}/answers`);
  }

  updateRecommendation(responseId: number, recommendation: string, overallScore?: number | null, recruiterNotes?: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/responses/${responseId}/recommendation`, { recommendation, overallScore, recruiterNotes });
  }
}
