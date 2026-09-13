import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { InterviewService } from '../../services/interview.service';
import { InterviewGuidance, ChecklistItem } from '../../models/interview.model';

@Component({
  selector: 'app-interview-guidance',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './interview-guidance.component.html',
  styleUrls: ['./interview-guidance.component.css']
})
export class InterviewGuidanceComponent implements OnInit {
  guidance = signal<InterviewGuidance | null>(null);
  loading = signal(true);
  errorMessage = signal('');
  checklist = signal<ChecklistItem[]>([]);
  activeTab = signal<'tips' | 'questions' | 'checklist'>('tips');
  selectedQuestion = signal<number | null>(null);

  constructor(
    public auth: AuthService,
    private interviewService: InterviewService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.route.queryParams.subscribe((params) => {
      const jobTitle = params['jobTitle'] || 'Software Engineer';
      const department = params['department'] || 'Engineering';
      this.loadGuidance(jobTitle, department);
    });
  }

  loadGuidance(jobTitle: string, department: string): void {
    this.loading.set(true);
    this.interviewService.getInterviewGuidance(jobTitle, department).subscribe({
      next: (data) => {
        this.guidance.set(data);
        this.checklist.set(data.checklist);
        this.loading.set(false);
      },
      error: () => {
        this.errorMessage.set('Could not load interview guidance.');
        this.loading.set(false);
      }
    });
  }

  toggleChecklistItem(item: ChecklistItem): void {
    item.completed = !item.completed;
    this.checklist.update((items) =>
      items.map((i) => (i.id === item.id ? item : i))
    );
  }

  toggleQuestion(questionId: number): void {
    this.selectedQuestion.set(
      this.selectedQuestion() === questionId ? null : questionId
    );
  }

  getDifficultyColor(difficulty: string): string {
    return difficulty === 'Easy' ? 'easy' : difficulty === 'Medium' ? 'medium' : 'hard';
  }

  getChecklistProgress(): number {
    const completed = this.checklist().filter((item) => item.completed).length;
    return Math.round((completed / this.checklist().length) * 100);
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
