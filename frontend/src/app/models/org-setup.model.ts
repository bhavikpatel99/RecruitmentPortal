export interface Department { id?: number; name: string; isActive?: boolean; }
export interface OfficeLocation { id?: number; name: string; city?: string | null; country?: string | null; isActive?: boolean; }
export interface JobFamily { id?: number; name: string; description?: string | null; isActive?: boolean; }
export interface SkillMaster { id?: number; name: string; category?: string | null; isActive?: boolean; }
export interface Competency { id?: number; name: string; description?: string | null; isActive?: boolean; }
export interface SalaryBand {
  id?: number;
  jobFamilyId?: number | null;
  jobFamilyName?: string | null;
  level: string;
  minSalary: number;
  maxSalary: number;
  currency: string;
}
export interface ApprovalMatrix {
  id?: number;
  name: string;
  description?: string | null;
  minAmount?: number | null;
  maxAmount?: number | null;
  requiredApproverRole: string;
}
export interface InterviewPanelMaster {
  id?: number;
  name: string;
  description?: string | null;
  memberCount?: number;
}
export interface InterviewPanelMasterMember {
  id: number;
  panelId: number;
  userId: number;
  fullName: string;
  email: string;
}
