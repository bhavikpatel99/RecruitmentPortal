import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { InterviewGuidance, InterviewTip, InterviewQuestion, ChecklistItem } from '../models/interview.model';

@Injectable({ providedIn: 'root' })
export class InterviewService {

  getInterviewGuidance(jobTitle: string, department: string): Observable<InterviewGuidance> {
    const guidance = this.getMockGuidance(jobTitle, department);
    return of(guidance);
  }

  private getMockGuidance(jobTitle: string, department: string): InterviewGuidance {
    return {
      jobTitle,
      department,
      tips: this.getMockTips(jobTitle),
      questions: this.getMockQuestions(jobTitle),
      checklist: this.getMockChecklist(),
      estimatedDuration: 45
    };
  }

  private getMockTips(jobTitle: string): InterviewTip[] {
    const tips: InterviewTip[] = [
      {
        id: 1,
        title: 'Research the Company',
        description: 'Spend time researching the company\'s mission, values, recent news, and product/services. This shows genuine interest.',
        category: 'Preparation'
      },
      {
        id: 2,
        title: 'Practice Common Questions',
        description: 'Prepare answers for: "Tell me about yourself", "Why do you want this job?", "What are your strengths and weaknesses?"',
        category: 'Preparation'
      },
      {
        id: 3,
        title: 'Arrive Early',
        description: 'Plan to arrive 10-15 minutes before the interview. This shows respect for their time and reduces anxiety.',
        category: 'On the Day'
      },
      {
        id: 4,
        title: 'Dress Professionally',
        description: 'Wear appropriate business attire. When in doubt, overdress rather than underdress for a professional interview.',
        category: 'On the Day'
      },
      {
        id: 5,
        title: 'Strong Body Language',
        description: 'Make eye contact, offer a firm handshake, sit up straight, and lean slightly forward to show engagement.',
        category: 'During Interview'
      },
      {
        id: 6,
        title: 'Use the STAR Method',
        description: 'For behavioral questions, use STAR (Situation, Task, Action, Result) to structure your answer clearly.',
        category: 'During Interview'
      },
      {
        id: 7,
        title: 'Ask Smart Questions',
        description: 'Prepare 3-5 thoughtful questions about the role, team, and company culture. This shows genuine interest.',
        category: 'Closing'
      },
      {
        id: 8,
        title: 'Follow Up',
        description: 'Send a thank you email within 24 hours. Reiterate your interest and highlight key discussion points.',
        category: 'After Interview'
      }
    ];

    return tips;
  }

  private getMockQuestions(jobTitle: string): InterviewQuestion[] {
    const questions: InterviewQuestion[] = [
      {
        id: 1,
        question: 'Tell me about yourself.',
        answer: 'Provide a brief 2-3 minute overview of your professional background. Include: 1) Your current/most recent role, 2) Key achievements, 3) Relevant skills, 4) Why you\'re interested in this position. Keep it focused on what\'s relevant to the job.',
        difficulty: 'Easy',
        category: 'General'
      },
      {
        id: 2,
        question: 'Why are you interested in this role?',
        answer: 'Research the company and explain how the role aligns with your career goals. Mention specific aspects of the job, company culture, or products that appeal to you. Show you\'ve done your homework.',
        difficulty: 'Easy',
        category: 'Motivation'
      },
      {
        id: 3,
        question: 'What are your greatest strengths?',
        answer: 'Mention 2-3 strengths that are relevant to the job. Provide specific examples of how you\'ve used these strengths. Use skills from the job description.',
        difficulty: 'Easy',
        category: 'Personal'
      },
      {
        id: 4,
        question: 'What are your weaknesses?',
        answer: 'Choose a real weakness but show self-awareness and growth. Explain: 1) What the weakness is, 2) How you\'ve worked to improve it, 3) What you\'ve learned. Avoid saying "I don\'t have weaknesses."',
        difficulty: 'Medium',
        category: 'Personal'
      },
      {
        id: 5,
        question: 'Describe a time you faced a challenge at work. How did you handle it?',
        answer: 'Use the STAR method. Situation: What was the challenge? Task: What was your responsibility? Action: What did you do? Result: What was the outcome? Focus on positive resolution and learning.',
        difficulty: 'Medium',
        category: 'Behavioral'
      },
      {
        id: 6,
        question: 'Give an example of when you had to work in a team.',
        answer: 'Describe your role in the team, how you collaborated, what challenges you faced, and how you contributed to success. Highlight communication and teamwork skills.',
        difficulty: 'Medium',
        category: 'Behavioral'
      },
      {
        id: 7,
        question: 'How do you handle pressure and tight deadlines?',
        answer: 'Provide a specific example. Explain your approach: prioritization, time management, communication, and staying calm. Show you can deliver quality work under pressure.',
        difficulty: 'Medium',
        category: 'Work Style'
      },
      {
        id: 8,
        question: 'Where do you see yourself in 5 years?',
        answer: 'Demonstrate ambition and growth mindset without appearing overambitious. Align your goals with the company\'s direction. Focus on skill development and career progression relevant to the role.',
        difficulty: 'Hard',
        category: 'Career Goals'
      },
      {
        id: 9,
        question: 'What is your biggest professional failure and what did you learn from it?',
        answer: 'Be honest about a real failure. Explain what went wrong, take responsibility, and describe what you learned and how you\'ve improved. Show growth and resilience.',
        difficulty: 'Hard',
        category: 'Behavioral'
      },
      {
        id: 10,
        question: 'Why should we hire you?',
        answer: 'Summarize your key strengths, relevant experience, and what unique value you bring. Connect your skills to the job requirements. Show enthusiasm and confidence.',
        difficulty: 'Hard',
        category: 'General'
      }
    ];

    return questions;
  }

  private getMockChecklist(): ChecklistItem[] {
    return [
      { id: 1, item: 'Research company background and recent news', completed: false },
      { id: 2, item: 'Review job description and required skills', completed: false },
      { id: 3, item: 'Prepare stories using STAR method', completed: false },
      { id: 4, item: 'Practice common interview questions', completed: false },
      { id: 5, item: 'Prepare 3-5 questions to ask the interviewer', completed: false },
      { id: 6, item: 'Check interview time, location, and parking', completed: false },
      { id: 7, item: 'Prepare copies of your resume and portfolio', completed: false },
      { id: 8, item: 'Choose and prepare professional outfit', completed: false },
      { id: 9, item: 'Get a good night\'s sleep before the interview', completed: false },
      { id: 10, item: 'Prepare thank you email template', completed: false }
    ];
  }
}
