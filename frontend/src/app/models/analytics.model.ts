export interface TimeToFillRow { jobId: number; title: string; postedDate: string; firstHiredAt: string; daysToFill: number; }
export interface TimeToHireRow { candidateId: number; firstName: string; lastName: string; appliedAt: string; hiredAt: string; daysToHire: number; }
export interface SourceEffectivenessRow { source: string; totalApplications: number; shortlisted: number; hired: number; }
export interface StageFunnelRow { stage: string; candidateCount: number; }
export interface RecruiterProductivityRow { userId: number; fullName: string; requisitionsCreated: number; stageMovesMade: number; interviewsScheduled: number; offersCreated: number; }
export interface InterviewTurnaroundRow { interviewId: number; scheduledAt?: string | null; lastFeedbackAt?: string | null; hoursToFeedback: number; }
export interface OfferStatsRow { status: string; count: number; }
