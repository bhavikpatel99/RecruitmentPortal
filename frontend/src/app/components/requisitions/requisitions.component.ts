import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { JobRequisitionService } from '../../services/job-requisition.service';
import { ToastService } from '../../services/toast.service';
import { JobRequisition, JobRequisitionAudit, REQUISITION_PRIORITIES, REQUISITION_TYPES } from '../../models/job-requisition.model';

const EMPTY_FORM: JobRequisition = {
  title: '',
  department: '',
  location: '',
  employmentType: 'Full-time',
  vacancies: 1,
  priority: 'Medium',
  requisitionType: 'New',
  budgetReference: '',
  justificationNotes: '',
  requiredSkills: ''
};

function statusBadgeClass(status?: string): string {
  switch (status) {
    case 'Approved': return 'badge-success';
    case 'Rejected': return 'badge-danger';
    case 'PendingApproval': return 'badge-warning';
    case 'OnHold': return 'badge-purple';
    case 'Closed': return 'badge-neutral';
    default: return 'badge-info'; // Draft
  }
}

@Component({
  selector: 'app-requisitions',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './requisitions.component.html',
  styleUrls: ['./requisitions.component.css']
})
export class RequisitionsComponent implements OnInit {
  requisitions = signal<JobRequisition[]>([]);
  loading = signal(true);
  statusFilter = signal<string>('All');
  showForm = signal(false);
  form: JobRequisition = { ...EMPTY_FORM };
  priorities = REQUISITION_PRIORITIES;
  types = REQUISITION_TYPES;

  showRejectModal = signal(false);
  rejectTargetId: number | null = null;
  rejectionReason = '';

  auditTrail = signal<JobRequisitionAudit[]>([]);
  auditForId = signal<number | null>(null);

  readonly statusBadgeClass = statusBadgeClass;

  constructor(private reqService: JobRequisitionService, private toast: ToastService) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.reqService.getAll().subscribe({
      next: (data) => { this.requisitions.set(data); this.loading.set(false); },
      error: () => { this.toast.error('Could not load requisitions.'); this.loading.set(false); }
    });
  }

  get filtered(): JobRequisition[] {
    const filter = this.statusFilter();
    if (filter === 'All') return this.requisitions();
    return this.requisitions().filter((r) => r.status === filter);
  }

  openCreate(): void {
    this.form = { ...EMPTY_FORM };
    this.showForm.set(true);
  }

  closeForm(): void {
    this.showForm.set(false);
  }

  submit(): void {
    this.reqService.create(this.form).subscribe({
      next: () => {
        this.toast.success('Requisition created as Draft.');
        this.showForm.set(false);
        this.load();
      },
      error: (err) => this.toast.error(err?.error?.message || 'Failed to create requisition.')
    });
  }

  submitForApproval(r: JobRequisition): void {
    this.reqService.updateStatus(r.id!, 'PendingApproval').subscribe({
      next: () => { this.toast.success('Submitted for approval.'); this.load(); },
      error: () => this.toast.error('Could not submit for approval.')
    });
  }

  approve(r: JobRequisition): void {
    this.reqService.updateStatus(r.id!, 'Approved').subscribe({
      next: () => { this.toast.success('Requisition approved.'); this.load(); },
      error: () => this.toast.error('Could not approve requisition.')
    });
  }

  openReject(r: JobRequisition): void {
    this.rejectTargetId = r.id!;
    this.rejectionReason = '';
    this.showRejectModal.set(true);
  }

  confirmReject(): void {
    if (!this.rejectTargetId) return;
    this.reqService.updateStatus(this.rejectTargetId, 'Rejected', this.rejectionReason).subscribe({
      next: () => { this.toast.info('Requisition rejected.'); this.showRejectModal.set(false); this.load(); },
      error: () => this.toast.error('Could not reject requisition.')
    });
  }

  hold(r: JobRequisition): void {
    this.reqService.updateStatus(r.id!, 'OnHold').subscribe({
      next: () => { this.toast.info('Requisition put on hold.'); this.load(); },
      error: () => this.toast.error('Could not update status.')
    });
  }

  reopen(r: JobRequisition): void {
    this.reqService.updateStatus(r.id!, 'PendingApproval').subscribe({
      next: () => { this.toast.info('Requisition reopened for approval.'); this.load(); },
      error: () => this.toast.error('Could not reopen requisition.')
    });
  }

  close(r: JobRequisition): void {
    if (!confirm(`Close requisition "${r.title}"?`)) return;
    this.reqService.updateStatus(r.id!, 'Closed').subscribe({
      next: () => { this.toast.info('Requisition closed.'); this.load(); },
      error: () => this.toast.error('Could not close requisition.')
    });
  }

  viewAudit(r: JobRequisition): void {
    this.auditForId.set(r.id!);
    this.reqService.getAudit(r.id!).subscribe({
      next: (data) => this.auditTrail.set(data),
      error: () => this.toast.error('Could not load audit trail.')
    });
  }

  closeAudit(): void {
    this.auditForId.set(null);
  }
}
