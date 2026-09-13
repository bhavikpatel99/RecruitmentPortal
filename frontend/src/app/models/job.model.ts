export interface Job {
  id?: number;
  title: string;
  description: string;
  requirements?: string | null;
  responsibilities?: string | null;
  location: string;
  employmentType?: string | null;
  salaryMin?: number | null;
  salaryMax?: number | null;
  experienceYearsMin?: number | null;
  experienceYearsMax?: number | null;
  skills?: string | null;
  department: string;
  status?: string;
  postedDate?: string;
  closedDate?: string | null;
  postedBy?: number | null;
  createdAt?: string;
  updatedAt?: string | null;

  // Job Description Builder
  mustHaveSkills?: string | null;
  niceToHaveSkills?: string | null;
  educationRequirement?: string | null;
  workMode?: string | null;
  benefitsText?: string | null;
  legalText?: string | null;
  jobRequisitionId?: number | null;
}

export interface JobPostingChannel {
  id?: number;
  jobId: number;
  channel: string;
  status?: string;
  externalUrl?: string | null;
  postedAt?: string;
  expiryDate?: string | null;
}

export const JOB_POSTING_CHANNELS = ['CareerSite', 'LinkedIn', 'Indeed', 'Naukri', 'Referral', 'Other'];
