import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CommunicationService } from '../../services/communication.service';
import { ToastService } from '../../services/toast.service';
import { AuthService } from '../../services/auth.service';
import {
  EmailLog, EmailTemplate, SECURE_SOCKET_MODES, SmtpSettings, SMTP_PROVIDER_PRESETS
} from '../../models/communication.model';

type TabId = 'smtp' | 'templates' | 'log';

const EMPTY_TEMPLATE: EmailTemplate = { name: '', subject: '', bodyHtml: '', category: 'General' };
const EMPTY_SMTP: SmtpSettings = { provider: 'Gmail', host: 'smtp.gmail.com', port: 587, secureSocketMode: 'StartTls', username: '', fromEmail: '', fromName: 'Recruitment Portal' };

@Component({
  selector: 'app-communication',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './communication.component.html'
})
export class CommunicationComponent implements OnInit {
  activeTab = signal<TabId>('templates');
  providers = Object.keys(SMTP_PROVIDER_PRESETS);
  secureSocketModes = SECURE_SOCKET_MODES;

  // SMTP
  smtp: SmtpSettings = { ...EMPTY_SMTP };
  hasExistingSmtp = signal(false);
  testEmailAddress = '';
  smtpLoading = signal(false);

  // Templates
  templates = signal<EmailTemplate[]>([]);
  showTemplateForm = signal(false);
  editingTemplateId: number | null = null;
  templateDraft: EmailTemplate = { ...EMPTY_TEMPLATE };

  // Log
  log = signal<EmailLog[]>([]);

  constructor(private commService: CommunicationService, private toast: ToastService, public auth: AuthService) {}

  ngOnInit(): void {
    if (this.isAdmin) {
      this.loadSmtp();
    } else {
      this.activeTab.set('templates');
    }
    this.loadTemplates();
  }

  get isAdmin(): boolean {
    return this.auth.user()?.role === 'Admin';
  }

  setTab(tab: TabId): void {
    this.activeTab.set(tab);
    if (tab === 'log') this.loadLog();
  }

  // ---- SMTP ----
  loadSmtp(): void {
    this.commService.getSmtpSettings().subscribe({
      next: (s) => {
        if (s) {
          this.smtp = { ...s, password: '' };
          this.hasExistingSmtp.set(!!s.hasPassword);
        }
      },
      error: () => this.toast.error('Could not load SMTP settings.')
    });
  }

  applyPreset(): void {
    const preset = SMTP_PROVIDER_PRESETS[this.smtp.provider];
    if (preset && this.smtp.provider !== 'Custom') {
      this.smtp.host = preset.host;
      this.smtp.port = preset.port;
      this.smtp.secureSocketMode = preset.secureSocketMode;
    }
  }

  saveSmtp(): void {
    this.smtpLoading.set(true);
    this.commService.saveSmtpSettings(this.smtp).subscribe({
      next: () => {
        this.toast.success('SMTP settings saved.');
        this.smtpLoading.set(false);
        this.loadSmtp();
      },
      error: (err) => { this.toast.error(err?.error?.message || 'Could not save SMTP settings.'); this.smtpLoading.set(false); }
    });
  }

  sendTest(): void {
    if (!this.testEmailAddress) return;
    this.commService.sendTestEmail(this.testEmailAddress).subscribe({
      next: (res) => this.toast.success(res.message),
      error: (err) => this.toast.error(err?.error?.message || 'Test email failed.')
    });
  }

  // ---- Templates ----
  loadTemplates(): void {
    this.commService.getTemplates().subscribe({ next: (t) => this.templates.set(t) });
  }

  openCreateTemplate(): void {
    this.editingTemplateId = null;
    this.templateDraft = { ...EMPTY_TEMPLATE };
    this.showTemplateForm.set(true);
  }

  openEditTemplate(t: EmailTemplate): void {
    this.editingTemplateId = t.id!;
    this.templateDraft = { ...t };
    this.showTemplateForm.set(true);
  }

  submitTemplate(): void {
    if (this.editingTemplateId) {
      this.commService.updateTemplate(this.editingTemplateId, this.templateDraft).subscribe({
        next: () => { this.toast.success('Template updated.'); this.showTemplateForm.set(false); this.loadTemplates(); },
        error: () => this.toast.error('Could not update template.')
      });
    } else {
      this.commService.createTemplate(this.templateDraft).subscribe({
        next: () => { this.toast.success('Template created.'); this.showTemplateForm.set(false); this.loadTemplates(); },
        error: () => this.toast.error('Could not create template.')
      });
    }
  }

  deleteTemplate(t: EmailTemplate): void {
    if (!confirm(`Delete template "${t.name}"?`)) return;
    this.commService.deleteTemplate(t.id!).subscribe({
      next: () => { this.toast.success('Template deleted.'); this.loadTemplates(); },
      error: (err) => this.toast.error(err?.error?.message || 'Could not delete template.')
    });
  }

  // ---- Log ----
  loadLog(): void {
    this.commService.getLog().subscribe({ next: (l) => this.log.set(l) });
  }
}
