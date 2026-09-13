export interface ScreeningForm {
  id?: number;
  jobId?: number | null;
  title: string;
  description?: string | null;
  isActive?: boolean;
  createdBy?: number | null;
  createdAt?: string;
}

export interface ScreeningQuestion {
  id?: number;
  screeningFormId: number;
  questionText: string;
  questionType: string;
  options?: string | null;
  isKnockout: boolean;
  expectedAnswer?: string | null;
  sortOrder: number;
}

export interface ScreeningResponse {
  id: number;
  candidateId: number;
  screeningFormId: number;
  formTitle: string;
  submittedAt: string;
  knockoutFailed: boolean;
  overallScore?: number | null;
  recommendation?: string | null;
  recruiterNotes?: string | null;
  evaluatedBy?: number | null;
  evaluatedAt?: string | null;
}

export interface ScreeningAnswer {
  id: number;
  screeningResponseId: number;
  questionId: number;
  questionText: string;
  isKnockout: boolean;
  answerText: string;
  passedKnockout?: boolean | null;
}

export const QUESTION_TYPES = ['YesNo', 'Text', 'Numeric', 'MultipleChoice'];
export const RECOMMENDATION_OPTIONS = ['Shortlist', 'Reject', 'Hold'];
