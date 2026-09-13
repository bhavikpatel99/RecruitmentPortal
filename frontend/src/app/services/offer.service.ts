import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Offer, OfferAudit } from '../models/offer.model';

@Injectable({ providedIn: 'root' })
export class OfferService {
  private readonly baseUrl = `${environment.apiUrl}/offers`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<Offer[]> {
    return this.http.get<Offer[]>(this.baseUrl);
  }

  getById(id: number): Observable<Offer> {
    return this.http.get<Offer>(`${this.baseUrl}/${id}`);
  }

  getByCandidate(candidateId: number): Observable<Offer[]> {
    return this.http.get<Offer[]>(`${this.baseUrl}/candidate/${candidateId}`);
  }

  getAudit(id: number): Observable<OfferAudit[]> {
    return this.http.get<OfferAudit[]>(`${this.baseUrl}/${id}/audit`);
  }

  create(offer: Offer): Observable<Offer> {
    return this.http.post<Offer>(this.baseUrl, offer);
  }

  update(id: number, offer: Offer): Observable<void> {
    return this.http.put<void>(`${this.baseUrl}/${id}`, offer);
  }

  updateStatus(id: number, newStatus: string, notes?: string, signedDocumentUrl?: string): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/status`, { newStatus, notes, signedDocumentUrl });
  }

  logNegotiation(id: number, notes: string, newBaseSalary?: number | null, newTotalCtc?: number | null): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${id}/negotiation`, { notes, newBaseSalary, newTotalCtc });
  }
}
