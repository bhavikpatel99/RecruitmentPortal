export interface JobRequisition {
  id?: number;
  title: string;
  department: string;
  location: string;
  employmentType?: string | null;
  vacancies: number;
  priority: string;
  requisitionType: string;
  targetJoiningDate?: string | null;
  budgetReference?: string | null;
  justificationNotes?: string | null;
  requiredSkills?: string | null;
  hiringManagerId?: number | null;
  recruiterId?: number | null;
  jobId?: number | null;
  status?: string;
  approvedBy?: number | null;
  approvedAt?: string | null;
  rejectionReason?: string | null;
  createdBy?: number | null;
  createdAt?: string;
  updatedAt?: string | null;
}

export interface JobRequisitionAudit {
  id: number;
  jobRequisitionId: number;
  action: string;
  fromStatus?: string | null;
  toStatus?: string | null;
  performedBy?: number | null;
  notes?: string | null;
  performedAt: string;
}

export const REQUISITION_PRIORITIES = ['Low', 'Medium', 'High', 'Urgent'];
export const REQUISITION_TYPES = ['New', 'Replacement'];
