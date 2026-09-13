export interface InterviewTip {
  id: number;
  title: string;
  description: string;
  category: string;
}

export interface InterviewQuestion {
  id: number;
  question: string;
  answer: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
  category: string;
}

export interface InterviewGuidance {
  jobTitle: string;
  department: string;
  tips: InterviewTip[];
  questions: InterviewQuestion[];
  checklist: ChecklistItem[];
  estimatedDuration: number;
}

export interface ChecklistItem {
  id: number;
  item: string;
  completed: boolean;
}
