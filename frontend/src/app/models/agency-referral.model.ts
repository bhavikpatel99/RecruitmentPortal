export interface Agency {
  id?: number;
  name: string;
  contactEmail?: string | null;
  contactPhone?: string | null;
  isActive?: boolean;
  createdAt?: string;
}

export interface AgencyPerformance {
  id: number;
  name: string;
  totalSubmissions: number;
  duplicateSubmissions: number;
  hires: number;
}

export interface AgencySubmission {
  id: number;
  agencyId: number;
  agencyName?: string | null;
  jobId?: number | null;
  jobTitle?: string | null;
  candidateId?: number | null;
  firstName?: string | null;
  lastName?: string | null;
  candidateStatus?: string | null;
  submittedBy: number;
  submittedAt: string;
  wasDuplicate: boolean;
}

export interface Referral {
  id: number;
  referrerUserId: number;
  referrerName?: string | null;
  jobId: number;
  jobTitle?: string | null;
  candidateId?: number | null;
  firstName?: string | null;
  lastName?: string | null;
  referralCode: string;
  status: string;
  bonusAmount?: number | null;
  bonusStatus: string;
  createdAt: string;
}

export const BONUS_STATUSES = ['NotEligible', 'Pending', 'Approved', 'Paid'];
