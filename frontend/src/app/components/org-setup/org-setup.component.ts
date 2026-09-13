import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OrgSetupService } from '../../services/org-setup.service';
import { UserService } from '../../services/user.service';
import { ToastService } from '../../services/toast.service';
import {
  ApprovalMatrix, Competency, Department, InterviewPanelMaster, InterviewPanelMasterMember,
  JobFamily, OfficeLocation, SalaryBand, SkillMaster
} from '../../models/org-setup.model';
import { UserSummary } from '../../models/user-summary.model';

type TabId = 'departments' | 'locations' | 'jobFamilies' | 'skills' | 'competencies' | 'salaryBands' | 'approvals' | 'panels';

@Component({
  selector: 'app-org-setup',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './org-setup.component.html'
})
export class OrgSetupComponent implements OnInit {
  activeTab = signal<TabId>('departments');

  departments = signal<Department[]>([]);
  locations = signal<OfficeLocation[]>([]);
  jobFamilies = signal<JobFamily[]>([]);
  skills = signal<SkillMaster[]>([]);
  competencies = signal<Competency[]>([]);
  salaryBands = signal<SalaryBand[]>([]);
  approvalMatrices = signal<ApprovalMatrix[]>([]);
  panels = signal<InterviewPanelMaster[]>([]);
  users = signal<UserSummary[]>([]);

  newName = '';
  newDescription = '';
  newCity = '';
  newCountry = '';

  bandDraft: SalaryBand = { level: '', minSalary: 0, maxSalary: 0, currency: 'INR', jobFamilyId: null };
  matrixDraft: ApprovalMatrix = { name: '', requiredApproverRole: 'Admin', minAmount: null, maxAmount: null };

  expandedPanelId = signal<number | null>(null);
  panelMembers = signal<InterviewPanelMasterMember[]>([]);
  selectedUserId: number | null = null;

  constructor(private orgSetupService: OrgSetupService, private userService: UserService, private toast: ToastService) {}

  ngOnInit(): void {
    this.loadAll();
    this.userService.getAll().subscribe({ next: (u) => this.users.set(u.filter((x) => x.role !== 'Candidate')) });
  }

  loadAll(): void {
    this.orgSetupService.getDepartments().subscribe({ next: (d) => this.departments.set(d) });
    this.orgSetupService.getLocations().subscribe({ next: (l) => this.locations.set(l) });
    this.orgSetupService.getJobFamilies().subscribe({ next: (f) => this.jobFamilies.set(f) });
    this.orgSetupService.getSkills().subscribe({ next: (s) => this.skills.set(s) });
    this.orgSetupService.getCompetencies().subscribe({ next: (c) => this.competencies.set(c) });
    this.orgSetupService.getSalaryBands().subscribe({ next: (b) => this.salaryBands.set(b) });
    this.orgSetupService.getApprovalMatrices().subscribe({ next: (m) => this.approvalMatrices.set(m) });
    this.orgSetupService.getInterviewPanels().subscribe({ next: (p) => this.panels.set(p) });
  }

  setTab(tab: TabId): void {
    this.activeTab.set(tab);
    this.newName = '';
    this.newDescription = '';
  }

  addDepartment(): void {
    if (!this.newName) return;
    this.orgSetupService.createDepartment(this.newName).subscribe({ next: () => { this.newName = ''; this.loadAll(); }, error: () => this.toast.error('Could not add department.') });
  }
  removeDepartment(id: number): void {
    this.orgSetupService.deleteDepartment(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove department.') });
  }

  addLocation(): void {
    if (!this.newName) return;
    this.orgSetupService.createLocation(this.newName, this.newCity, this.newCountry).subscribe({
      next: () => { this.newName = ''; this.newCity = ''; this.newCountry = ''; this.loadAll(); },
      error: () => this.toast.error('Could not add location.')
    });
  }
  removeLocation(id: number): void {
    this.orgSetupService.deleteLocation(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove location.') });
  }

  addJobFamily(): void {
    if (!this.newName) return;
    this.orgSetupService.createJobFamily(this.newName, this.newDescription).subscribe({ next: () => { this.newName = ''; this.newDescription = ''; this.loadAll(); }, error: () => this.toast.error('Could not add job family.') });
  }
  removeJobFamily(id: number): void {
    this.orgSetupService.deleteJobFamily(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove job family.') });
  }

  addSkill(): void {
    if (!this.newName) return;
    this.orgSetupService.createSkill(this.newName, this.newDescription).subscribe({ next: () => { this.newName = ''; this.newDescription = ''; this.loadAll(); }, error: () => this.toast.error('Could not add skill.') });
  }
  removeSkill(id: number): void {
    this.orgSetupService.deleteSkill(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove skill.') });
  }

  addCompetency(): void {
    if (!this.newName) return;
    this.orgSetupService.createCompetency(this.newName, this.newDescription).subscribe({ next: () => { this.newName = ''; this.newDescription = ''; this.loadAll(); }, error: () => this.toast.error('Could not add competency.') });
  }
  removeCompetency(id: number): void {
    this.orgSetupService.deleteCompetency(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove competency.') });
  }

  addSalaryBand(): void {
    if (!this.bandDraft.level) return;
    this.orgSetupService.createSalaryBand(this.bandDraft).subscribe({
      next: () => { this.bandDraft = { level: '', minSalary: 0, maxSalary: 0, currency: 'INR', jobFamilyId: null }; this.loadAll(); },
      error: () => this.toast.error('Could not add salary band.')
    });
  }
  removeSalaryBand(id: number): void {
    this.orgSetupService.deleteSalaryBand(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove salary band.') });
  }

  addApprovalMatrix(): void {
    if (!this.matrixDraft.name) return;
    this.orgSetupService.createApprovalMatrix(this.matrixDraft).subscribe({
      next: () => { this.matrixDraft = { name: '', requiredApproverRole: 'Admin', minAmount: null, maxAmount: null }; this.loadAll(); },
      error: () => this.toast.error('Could not add approval rule.')
    });
  }
  removeApprovalMatrix(id: number): void {
    this.orgSetupService.deleteApprovalMatrix(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove approval rule.') });
  }

  addPanel(): void {
    if (!this.newName) return;
    this.orgSetupService.createInterviewPanel(this.newName, this.newDescription).subscribe({ next: () => { this.newName = ''; this.newDescription = ''; this.loadAll(); }, error: () => this.toast.error('Could not create panel.') });
  }
  removePanel(id: number): void {
    this.orgSetupService.deleteInterviewPanel(id).subscribe({ next: () => this.loadAll(), error: () => this.toast.error('Could not remove panel.') });
  }
  togglePanel(panel: InterviewPanelMaster): void {
    if (this.expandedPanelId() === panel.id) { this.expandedPanelId.set(null); return; }
    this.expandedPanelId.set(panel.id!);
    this.orgSetupService.getInterviewPanelMembers(panel.id!).subscribe({ next: (m) => this.panelMembers.set(m) });
  }
  addPanelMember(panelId: number): void {
    if (!this.selectedUserId) return;
    this.orgSetupService.addInterviewPanelMember(panelId, this.selectedUserId).subscribe({
      next: () => { this.orgSetupService.getInterviewPanelMembers(panelId).subscribe({ next: (m) => this.panelMembers.set(m) }); this.loadAll(); }
    });
  }
  removePanelMember(panelId: number, userId: number): void {
    this.orgSetupService.removeInterviewPanelMember(panelId, userId).subscribe({
      next: () => { this.panelMembers.update((list) => list.filter((m) => m.userId !== userId)); this.loadAll(); }
    });
  }
}
