import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  ApprovalMatrix, Competency, Department, InterviewPanelMaster, InterviewPanelMasterMember,
  JobFamily, OfficeLocation, SalaryBand, SkillMaster
} from '../models/org-setup.model';

@Injectable({ providedIn: 'root' })
export class OrgSetupService {
  private readonly baseUrl = `${environment.apiUrl}/orgsetup`;

  constructor(private http: HttpClient) {}

  getDepartments(): Observable<Department[]> { return this.http.get<Department[]>(`${this.baseUrl}/departments`); }
  createDepartment(name: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/departments`, { name }); }
  deleteDepartment(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/departments/${id}`); }

  getLocations(): Observable<OfficeLocation[]> { return this.http.get<OfficeLocation[]>(`${this.baseUrl}/locations`); }
  createLocation(name: string, city?: string, country?: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/locations`, { name, city, country }); }
  deleteLocation(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/locations/${id}`); }

  getJobFamilies(): Observable<JobFamily[]> { return this.http.get<JobFamily[]>(`${this.baseUrl}/job-families`); }
  createJobFamily(name: string, description?: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/job-families`, { name, description }); }
  deleteJobFamily(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/job-families/${id}`); }

  getSkills(): Observable<SkillMaster[]> { return this.http.get<SkillMaster[]>(`${this.baseUrl}/skills`); }
  createSkill(name: string, category?: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/skills`, { name, description: category }); }
  deleteSkill(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/skills/${id}`); }

  getCompetencies(): Observable<Competency[]> { return this.http.get<Competency[]>(`${this.baseUrl}/competencies`); }
  createCompetency(name: string, description?: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/competencies`, { name, description }); }
  deleteCompetency(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/competencies/${id}`); }

  getSalaryBands(): Observable<SalaryBand[]> { return this.http.get<SalaryBand[]>(`${this.baseUrl}/salary-bands`); }
  createSalaryBand(band: SalaryBand): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/salary-bands`, band); }
  deleteSalaryBand(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/salary-bands/${id}`); }

  getApprovalMatrices(): Observable<ApprovalMatrix[]> { return this.http.get<ApprovalMatrix[]>(`${this.baseUrl}/approval-matrices`); }
  createApprovalMatrix(m: ApprovalMatrix): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/approval-matrices`, m); }
  deleteApprovalMatrix(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/approval-matrices/${id}`); }

  getInterviewPanels(): Observable<InterviewPanelMaster[]> { return this.http.get<InterviewPanelMaster[]>(`${this.baseUrl}/interview-panels`); }
  createInterviewPanel(name: string, description?: string): Observable<{ id: number }> { return this.http.post<{ id: number }>(`${this.baseUrl}/interview-panels`, { name, description }); }
  deleteInterviewPanel(id: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/interview-panels/${id}`); }
  getInterviewPanelMembers(id: number): Observable<InterviewPanelMasterMember[]> { return this.http.get<InterviewPanelMasterMember[]>(`${this.baseUrl}/interview-panels/${id}/members`); }
  addInterviewPanelMember(id: number, userId: number): Observable<void> { return this.http.post<void>(`${this.baseUrl}/interview-panels/${id}/members/${userId}`, {}); }
  removeInterviewPanelMember(id: number, userId: number): Observable<void> { return this.http.delete<void>(`${this.baseUrl}/interview-panels/${id}/members/${userId}`); }
}
