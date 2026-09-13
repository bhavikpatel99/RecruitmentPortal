/** Recruiter-side interview scheduling/panel/scorecard types (distinct from the candidate-facing AI interview-prep feature). */
export interface ScheduledInterview {
  id?: number;
  candidateId: number;
  jobId?: number | null;
  roundNumber: number;
  interviewType?: string | null;
  scheduledAt?: string | null;
  durationMinutes?: number | null;
  mode?: string | null;
  meetingLink?: string | null;
  location?: string | null;
  status?: string;
  cancellationReason?: string | null;
  scheduledBy?: number | null;
  createdAt?: string;
  updatedAt?: string | null;
}

export interface InterviewPanelist {
  id: number;
  interviewId: number;
  interviewerId: number;
  isLead: boolean;
  interviewerName?: string;
  interviewerEmail?: string;
}

export interface InterviewFeedback {
  id: number;
  interviewId: number;
  interviewerId: number;
  interviewerName?: string;
  rating?: number | null;
  recommendation?: string | null;
  strengths?: string | null;
  concerns?: string | null;
  comments?: string | null;
  submittedAt?: string | null;
  createdAt: string;
}

export const INTERVIEW_TYPES = ['Phone', 'Technical', 'HR', 'Panel', 'Final'];
export const INTERVIEW_MODES = ['Onsite', 'Video', 'Phone'];
export const INTERVIEW_RECOMMENDATIONS = ['StrongHire', 'Hire', 'NoHire', 'StrongNoHire'];
