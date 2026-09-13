export interface PreJoiningChecklist {
  id: number;
  candidateId: number;
  offerId: number;
  joiningDate?: string | null;
  bgvStatus: string;
  createdAt: string;
  updatedAt?: string | null;
}

export interface PreJoiningTask {
  id: number;
  checklistId: number;
  taskName: string;
  isCompleted: boolean;
  completedAt?: string | null;
  notes?: string | null;
  sortOrder: number;
}

export interface HireEvent {
  id: number;
  candidateId: number;
  offerId: number;
  firstName?: string;
  lastName?: string;
  payload: string;
  status: string;
  createdAt: string;
  sentAt?: string | null;
}

export const BGV_STATUSES = ['NotStarted', 'InProgress', 'Cleared', 'Flagged'];
