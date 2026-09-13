export interface CandidateStageHistory {
  id: number;
  candidateId: number;
  fromStatus?: string | null;
  toStatus: string;
  changedBy?: number | null;
  reason?: string | null;
  notes?: string | null;
  changedAt: string;
}

/** Ordered default pipeline stages (spec's recommended flow). Orgs can still set any free-text status. */
export const PIPELINE_STAGES = [
  'Applied',
  'Screening',
  'Shortlisted',
  'Interview',
  'Assessment',
  'Final Evaluation',
  'Offer',
  'Offer Accepted',
  'Pre-Joining',
  'Hired'
];

export const TERMINAL_STAGES = ['Rejected', 'Withdrawn', 'Offer Declined', 'Position Closed'];

export function stageBadgeClass(status: string | undefined): string {
  switch (status) {
    case 'Hired':
    case 'Offer Accepted':
      return 'badge-success';
    case 'Rejected':
    case 'Withdrawn':
    case 'Offer Declined':
    case 'Position Closed':
      return 'badge-danger';
    case 'Offer':
    case 'Pre-Joining':
      return 'badge-purple';
    case 'Interview':
    case 'Assessment':
    case 'Final Evaluation':
      return 'badge-warning';
    case 'Shortlisted':
    case 'Screening':
      return 'badge-info';
    default:
      return 'badge-neutral';
  }
}
