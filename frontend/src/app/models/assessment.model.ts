export interface AssessmentTemplate {
  id?: number;
  title: string;
  assessmentType: string;
  description?: string | null;
  vendorName?: string | null;
  externalLink?: string | null;
  passingScore?: number | null;
  durationMinutes?: number | null;
  isActive?: boolean;
  createdBy?: number | null;
  createdAt?: string;
}

export interface AssessmentInvitation {
  id: number;
  candidateId: number;
  assessmentTemplateId: number;
  assessmentTitle: string;
  assessmentType: string;
  invitedBy?: number | null;
  invitedAt: string;
  deadline?: string | null;
  status: string;
  score?: number | null;
  passFail?: string | null;
  completedAt?: string | null;
  notes?: string | null;
}

export const ASSESSMENT_TYPES = ['Technical', 'Aptitude', 'Behavioral'];
