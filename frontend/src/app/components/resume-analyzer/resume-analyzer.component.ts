import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { ResumeService } from '../../services/resume.service';
import { ResumeAnalysis } from '../../models/resume.model';

@Component({
  selector: 'app-resume-analyzer',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './resume-analyzer.component.html',
  styleUrls: ['./resume-analyzer.component.css']
})
export class ResumeAnalyzerComponent implements OnInit {
  resumeText = signal('');
  analysis = signal<ResumeAnalysis | null>(null);
  loading = signal(false);
  analyzed = signal(false);
  errorMessage = signal('');
  activeTab = signal<'overview' | 'suggestions' | 'skills' | 'jobs'>('overview');

  constructor(
    public auth: AuthService,
    private resumeService: ResumeService,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Pre-fill with sample resume text for demo
    this.resumeText.set(`Senior Full Stack Developer
6+ years of experience in web development

SKILLS:
JavaScript, TypeScript, Angular, React, Node.js, Python, SQL, REST API Design, Git, GitHub, CSS, HTML

EXPERIENCE:
Senior Developer - Tech Corp (2022-Present)
- Led development of customer portal using Angular and Node.js
- Mentored junior developers
- Improved API performance by 40%

Full Stack Developer - StartUp Inc (2020-2022)
- Developed full stack applications using MEAN stack
- Implemented microservices architecture
- Reduced load time by 35%

Junior Developer - Digital Agency (2018-2020)
- Created responsive websites using HTML, CSS, JavaScript
- Maintained and updated legacy systems
- Client satisfaction score: 95%

EDUCATION:
Bachelor of Technology in Computer Science
State University (2018)

PROJECTS:
E-commerce Platform - Built full stack platform handling 10k+ transactions/day
Real-time Chat Application - Developed WebSocket-based chat system
Admin Dashboard - Created analytics dashboard with real-time data visualization`);
  }

  analyzeResume(): void {
    if (!this.resumeText().trim()) {
      this.errorMessage.set('Please enter your resume content.');
      return;
    }

    this.loading.set(true);
    this.errorMessage.set('');

    this.resumeService.analyzeResume(this.resumeText()).subscribe({
      next: (data) => {
        this.analysis.set(data);
        this.analyzed.set(true);
        this.loading.set(false);
      },
      error: () => {
        this.errorMessage.set('Could not analyze resume. Please try again.');
        this.loading.set(false);
      }
    });
  }

  getScoreColor(score: number): string {
    if (score >= 80) return 'excellent';
    if (score >= 60) return 'good';
    if (score >= 40) return 'fair';
    return 'poor';
  }

  getScoreText(score: number): string {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  getPriorityColor(priority: string): string {
    switch (priority) {
      case 'High':
        return 'priority-high';
      case 'Medium':
        return 'priority-medium';
      case 'Low':
        return 'priority-low';
      default:
        return '';
    }
  }

  getSkillLevelColor(level: string): string {
    switch (level) {
      case 'Beginner':
        return 'level-beginner';
      case 'Intermediate':
        return 'level-intermediate';
      case 'Advanced':
        return 'level-advanced';
      case 'Expert':
        return 'level-expert';
      default:
        return '';
    }
  }

  reset(): void {
    this.resumeText.set('');
    this.analysis.set(null);
    this.analyzed.set(false);
    this.errorMessage.set('');
  }

  downloadSuggestions(): void {
    if (!this.analysis()) return;

    const suggestions = this.analysis()?.suggestions.map(s =>
      `[${s.priority}] ${s.category} - ${s.title}\n${s.description}\n`
    ).join('\n');

    const text = `Resume Analysis Report\n${'='.repeat(50)}\n\nOverall Score: ${this.analysis()?.overallScore}/100\nCompletion: ${this.analysis()?.completionPercentage}%\n\nSuggestions:\n${suggestions}`;

    const blob = new Blob([text], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'resume-analysis.txt';
    a.click();
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
