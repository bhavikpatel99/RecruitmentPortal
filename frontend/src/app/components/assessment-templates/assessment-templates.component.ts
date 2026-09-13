import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AssessmentService } from '../../services/assessment.service';
import { ToastService } from '../../services/toast.service';
import { ASSESSMENT_TYPES, AssessmentTemplate } from '../../models/assessment.model';

const EMPTY: AssessmentTemplate = {
  title: '',
  assessmentType: 'Technical',
  description: '',
  vendorName: '',
  externalLink: '',
  passingScore: 70,
  durationMinutes: 60
};

@Component({
  selector: 'app-assessment-templates',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './assessment-templates.component.html'
})
export class AssessmentTemplatesComponent implements OnInit {
  templates = signal<AssessmentTemplate[]>([]);
  loading = signal(true);
  showForm = signal(false);
  form: AssessmentTemplate = { ...EMPTY };
  types = ASSESSMENT_TYPES;

  constructor(private service: AssessmentService, private toast: ToastService) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.service.getTemplates().subscribe({
      next: (t) => { this.templates.set(t); this.loading.set(false); },
      error: () => { this.toast.error('Could not load assessment templates.'); this.loading.set(false); }
    });
  }

  openCreate(): void {
    this.form = { ...EMPTY };
    this.showForm.set(true);
  }

  submit(): void {
    this.service.createTemplate(this.form).subscribe({
      next: () => { this.toast.success('Assessment template created.'); this.showForm.set(false); this.load(); },
      error: () => this.toast.error('Could not create template.')
    });
  }

  remove(t: AssessmentTemplate): void {
    if (!confirm(`Deactivate "${t.title}"?`)) return;
    this.service.deleteTemplate(t.id!).subscribe({
      next: () => { this.toast.info('Template deactivated.'); this.load(); },
      error: () => this.toast.error('Could not deactivate template.')
    });
  }
}
