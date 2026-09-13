import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { ResumeAnalysis, ResumeSuggestion, ResomeSkill, RecommendedJob } from '../models/resume.model';

@Injectable({ providedIn: 'root' })
export class ResumeService {

  analyzeResume(resumeText: string): Observable<ResumeAnalysis> {
    const analysis = this.getMockAnalysis(resumeText);
    return of(analysis);
  }

  private getMockAnalysis(resumeText: string): ResumeAnalysis {
    return {
      overallScore: 72,
      strengths: [
        'Strong technical background with 5+ years experience',
        'Multiple programming languages mentioned',
        'Good project experience and portfolio links',
        'Education from recognized institutions'
      ],
      weaknesses: [
        'Limited leadership or management experience mentioned',
        'No certifications or professional achievements listed',
        'Gap between dates - needs explanation',
        'Soft skills section missing',
        'No metrics or quantifiable achievements in some roles'
      ],
      suggestions: this.getMockSuggestions(),
      extractedSkills: this.getMockSkills(),
      recommendedJobs: this.getMockRecommendedJobs(),
      completionPercentage: 72
    };
  }

  private getMockSuggestions(): ResumeSuggestion[] {
    return [
      {
        id: 1,
        category: 'Content',
        title: 'Add Quantifiable Achievements',
        description: 'Include numbers and metrics in your accomplishments. For example: "Improved system performance by 30%", "Led team of 5 developers", "Increased user engagement by 25%".',
        priority: 'High'
      },
      {
        id: 2,
        category: 'Content',
        title: 'Include Certifications',
        description: 'Add any professional certifications (AWS, Google Cloud, Azure, etc.). This significantly improves your chances with tech companies.',
        priority: 'High'
      },
      {
        id: 3,
        category: 'Structure',
        title: 'Add a Professional Summary',
        description: 'Start with a 2-3 line professional summary highlighting your key strengths, years of experience, and career goals.',
        priority: 'High'
      },
      {
        id: 4,
        category: 'Content',
        title: 'Highlight Leadership Skills',
        description: 'Add a section or bullets about leadership experiences. Even if not in title, mention mentoring, team coordination, or project leadership.',
        priority: 'Medium'
      },
      {
        id: 5,
        category: 'Skills',
        title: 'Add Soft Skills Section',
        description: 'Include soft skills like Communication, Problem Solving, Project Management, Team Collaboration. These matter for most positions.',
        priority: 'Medium'
      },
      {
        id: 6,
        category: 'Content',
        title: 'Explain Employment Gaps',
        description: 'If there are gaps between jobs, briefly explain them (e.g., "Upskilling in AI/ML", "Freelance work", etc.).',
        priority: 'Medium'
      },
      {
        id: 7,
        category: 'Format',
        title: 'Use ATS-Friendly Format',
        description: 'Avoid fancy fonts and complex formatting. Use standard fonts and simple structure. Many companies use Applicant Tracking Systems.',
        priority: 'Low'
      },
      {
        id: 8,
        category: 'Content',
        title: 'Add Impact Statements',
        description: 'Use action verbs and show impact: "Designed", "Implemented", "Optimized", "Automated" instead of just listing tasks.',
        priority: 'Low'
      }
    ];
  }

  private getMockSkills(): ResomeSkill[] {
    return [
      { name: 'JavaScript', level: 'Expert', yearsOfExperience: 6 },
      { name: 'TypeScript', level: 'Advanced', yearsOfExperience: 4 },
      { name: 'Angular', level: 'Advanced', yearsOfExperience: 5 },
      { name: 'React', level: 'Advanced', yearsOfExperience: 3 },
      { name: 'Node.js', level: 'Advanced', yearsOfExperience: 4 },
      { name: 'Python', level: 'Intermediate', yearsOfExperience: 2 },
      { name: 'SQL', level: 'Intermediate', yearsOfExperience: 5 },
      { name: 'REST API Design', level: 'Advanced', yearsOfExperience: 4 },
      { name: 'Problem Solving', level: 'Expert', yearsOfExperience: 6 },
      { name: 'Git/GitHub', level: 'Advanced', yearsOfExperience: 5 }
    ];
  }

  private getMockRecommendedJobs(): RecommendedJob[] {
    return [
      {
        id: 1,
        jobTitle: 'Senior Full Stack Developer',
        matchScore: 88,
        matchedSkills: ['JavaScript', 'TypeScript', 'Angular', 'Node.js', 'REST API Design', 'SQL'],
        missingSkills: ['Docker', 'Kubernetes'],
        reason: 'Your skills perfectly match this role. You have 5+ years in the required tech stack.'
      },
      {
        id: 2,
        jobTitle: 'Frontend Architect',
        matchScore: 82,
        matchedSkills: ['Angular', 'React', 'TypeScript', 'Problem Solving'],
        missingSkills: ['System Design', 'Performance Optimization'],
        reason: 'Strong frontend expertise. Consider adding system design and optimization experience.'
      },
      {
        id: 3,
        jobTitle: 'Tech Lead - Web Development',
        matchScore: 79,
        matchedSkills: ['Angular', 'JavaScript', 'Problem Solving', 'TypeScript'],
        missingSkills: ['Leadership Experience', 'Team Management'],
        reason: 'Good technical foundation. Adding leadership experiences would strengthen candidacy.'
      },
      {
        id: 4,
        jobTitle: 'Full Stack Engineer (Startup)',
        matchScore: 85,
        matchedSkills: ['JavaScript', 'Node.js', 'React', 'SQL'],
        missingSkills: ['DevOps', 'Cloud Deployment'],
        reason: 'Excellent match for a startup environment. Your versatility is a key asset.'
      },
      {
        id: 5,
        jobTitle: 'Backend Engineer',
        matchScore: 76,
        matchedSkills: ['Node.js', 'Python', 'SQL', 'REST API Design'],
        missingSkills: ['Database Optimization', 'Microservices'],
        reason: 'Good backend skills. Adding database optimization and microservices would increase match score.'
      }
    ];
  }
}
