export interface CandidateNote {
  id: number;
  candidateId: number;
  note: string;
  createdBy?: number | null;
  createdByName?: string | null;
  createdAt: string;
}

export interface CandidateTag {
  id: number;
  candidateId: number;
  tag: string;
  createdBy?: number | null;
  createdAt: string;
}

export interface TalentPool {
  id: number;
  name: string;
  description?: string | null;
  createdBy?: number | null;
  createdAt: string;
  memberCount: number;
}

export interface TalentPoolMember {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  positionApplied?: string | null;
  totalExperience?: number | null;
  skills?: string | null;
  status?: string | null;
  addedAt: string;
}

export interface TalentPoolSummary {
  id: number;
  name: string;
}

export interface CandidateSearchResult {
  id: number;
  userId?: number | null;
  jobId?: number | null;
  firstName: string;
  lastName: string;
  email: string;
  phone?: string | null;
  positionApplied?: string | null;
  employmentType?: string | null;
  totalExperience?: number | null;
  currentCompany?: string | null;
  expectedCtc?: number | null;
  preferredLocation?: string | null;
  city?: string | null;
  country?: string | null;
  skills?: string | null;
  source?: string | null;
  status: string;
  createdAt: string;
}

export interface CandidateSearchRequest {
  keyword?: string;
  minExperience?: number | null;
  maxExperience?: number | null;
  location?: string;
  status?: string;
  source?: string;
  tag?: string;
}

export interface SavedSearch extends CandidateSearchRequest {
  id: number;
  userId: number;
  name: string;
  createdAt: string;
}
