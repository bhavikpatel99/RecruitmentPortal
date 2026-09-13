export interface Offer {
  id?: number;
  candidateId: number;
  jobId?: number | null;
  baseSalary: number;
  bonus?: number | null;
  equityDetails?: string | null;
  otherBenefits?: string | null;
  totalCtc?: number | null;
  validUntil?: string | null;
  status?: string;
  signedDocumentUrl?: string | null;
  approvedBy?: number | null;
  approvedAt?: string | null;
  sentAt?: string | null;
  respondedAt?: string | null;
  createdBy?: number | null;
  createdAt?: string;
  updatedAt?: string | null;
}

export interface OfferAudit {
  id: number;
  offerId: number;
  action: string;
  fromStatus?: string | null;
  toStatus?: string | null;
  performedBy?: number | null;
  notes?: string | null;
  performedAt: string;
}

export function offerStatusBadgeClass(status?: string): string {
  switch (status) {
    case 'Accepted': return 'badge-success';
    case 'Rejected':
    case 'Withdrawn': return 'badge-danger';
    case 'Sent': return 'badge-purple';
    case 'Approved': return 'badge-info';
    case 'PendingApproval': return 'badge-warning';
    default: return 'badge-neutral'; // Draft
  }
}
