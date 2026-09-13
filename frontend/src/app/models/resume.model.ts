export interface ResumeSuggestion {
  id: number;
  category: string;
  title: string;
  description: string;
  priority: 'High' | 'Medium' | 'Low';
}

export interface ResomeSkill {
  name: string;
  level: 'Beginner' | 'Intermediate' | 'Advanced' | 'Expert';
  yearsOfExperience: number;
}

export interface ResumeAnalysis {
  overallScore: number;
  strengths: string[];
  weaknesses: string[];
  suggestions: ResumeSuggestion[];
  extractedSkills: ResomeSkill[];
  recommendedJobs: RecommendedJob[];
  completionPercentage: number;
}

export interface RecommendedJob {
  id: number;
  jobTitle: string;
  matchScore: number;
  matchedSkills: string[];
  missingSkills: string[];
  reason: string;
}

export interface ResumeSection {
  title: string;
  content: string;
  completeness: number;
}
