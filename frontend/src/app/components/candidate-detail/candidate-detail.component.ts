import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { CandidateService } from '../../services/candidate.service';
import { ScreeningService } from '../../services/screening.service';
import { AssessmentService } from '../../services/assessment.service';
import { InterviewManagementService } from '../../services/interview-management.service';
import { OfferService } from '../../services/offer.service';
import { PreJoiningService } from '../../services/prejoining.service';
import { TalentService } from '../../services/talent.service';
import { CommunicationService } from '../../services/communication.service';
import { ToastService } from '../../services/toast.service';
import { CandidateNote, CandidateTag } from '../../models/talent.model';
import { EmailLog, EmailTemplate } from '../../models/communication.model';
import { Candidate } from '../../models/candidate.model';
import { CandidateStageHistory, stageBadgeClass } from '../../models/pipeline.model';
import { ScreeningAnswer, ScreeningForm, ScreeningQuestion, ScreeningResponse, RECOMMENDATION_OPTIONS } from '../../models/screening.model';
import { AssessmentInvitation, AssessmentTemplate } from '../../models/assessment.model';
import { ScheduledInterview } from '../../models/interview-management.model';
import { Offer, OfferAudit, offerStatusBadgeClass } from '../../models/offer.model';
import { HireEvent, PreJoiningChecklist, PreJoiningTask, BGV_STATUSES } from '../../models/prejoining.model';

type TabId = 'overview' | 'pipeline' | 'screening' | 'assessments' | 'interviews' | 'offer' | 'onboarding' | 'communication';

@Component({
  selector: 'app-candidate-detail',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './candidate-detail.component.html'
})
export class CandidateDetailComponent implements OnInit {
  candidateId!: number;
  candidate = signal<Candidate | null>(null);
  activeTab = signal<TabId>('overview');
  readonly stageBadgeClass = stageBadgeClass;

  // Pipeline
  stageHistory = signal<CandidateStageHistory[]>([]);

  // Screening
  screeningForms = signal<ScreeningForm[]>([]);
  screeningResponses = signal<ScreeningResponse[]>([]);
  showRunScreening = signal(false);
  selectedFormId: number | null = null;
  activeQuestions = signal<ScreeningQuestion[]>([]);
  answers: Record<number, string> = {};
  recruiterNotes = '';
  expandedResponseId = signal<number | null>(null);
  responseAnswers = signal<ScreeningAnswer[]>([]);
  recommendations = RECOMMENDATION_OPTIONS;

  // Assessments
  assessmentTemplates = signal<AssessmentTemplate[]>([]);
  candidateInvitations = signal<AssessmentInvitation[]>([]);
  showInviteForm = signal(false);
  inviteTemplateId: number | null = null;
  inviteDeadline = '';
  resultDraft: Record<number, { score: number; notes: string }> = {};

  // Interviews
  candidateInterviews = signal<ScheduledInterview[]>([]);

  // Offer
  offers = signal<Offer[]>([]);
  showOfferForm = signal(false);
  offerDraft: Offer = this.emptyOffer();
  offerAudit = signal<OfferAudit[]>([]);
  expandedOfferId = signal<number | null>(null);
  negotiationNotes = '';
  negotiationSalary: number | null = null;
  readonly offerStatusBadgeClass = offerStatusBadgeClass;

  // Onboarding
  checklists = signal<PreJoiningChecklist[]>([]);
  tasks = signal<PreJoiningTask[]>([]);
  hireEvents = signal<HireEvent[]>([]);
  joiningDateDraft = '';
  bgvStatuses = BGV_STATUSES;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private candidateService: CandidateService,
    private screeningService: ScreeningService,
    private assessmentService: AssessmentService,
    private interviewService: InterviewManagementService,
    private offerService: OfferService,
    private preJoiningService: PreJoiningService,
    private talentService: TalentService,
    private commService: CommunicationService,
    private toast: ToastService
  ) {}

  notes = signal<CandidateNote[]>([]);
  tags = signal<CandidateTag[]>([]);
  newNote = '';
  newTag = '';

  // Resume upload
  uploadingResume = signal(false);
  resumeFileError = '';
  private static readonly ALLOWED_RESUME_TYPES = ['.pdf', '.doc', '.docx'];
  private static readonly MAX_RESUME_SIZE = 5 * 1024 * 1024; // 5 MB

  get resumeDownloadUrl(): string | null {
    return this.candidateService.resumeFileUrl(this.candidate()?.resumeUrl);
  }

  ngOnInit(): void {
    this.candidateId = Number(this.route.snapshot.paramMap.get('id'));
    this.candidateService.getById(this.candidateId).subscribe({
      next: (c) => this.candidate.set(c),
      error: () => this.toast.error('Could not load candidate.')
    });
    this.loadPipeline();
    this.loadNotesAndTags();
  }

  onResumeFileSelected(event: Event): void {
    this.resumeFileError = '';
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0] ?? null;
    if (!file) return;

    const extension = file.name.substring(file.name.lastIndexOf('.')).toLowerCase();
    if (!CandidateDetailComponent.ALLOWED_RESUME_TYPES.includes(extension)) {
      this.resumeFileError = 'Resume must be a PDF, DOC, or DOCX file.';
      input.value = '';
      return;
    }
    if (file.size > CandidateDetailComponent.MAX_RESUME_SIZE) {
      this.resumeFileError = 'Resume file must be 5 MB or smaller.';
      input.value = '';
      return;
    }

    this.uploadingResume.set(true);
    this.candidateService.uploadResume(this.candidateId, file).subscribe({
      next: ({ resumeUrl, resumeFileName }) => {
        this.candidate.update((c) => (c ? { ...c, resumeUrl, resumeFileName } : c));
        this.uploadingResume.set(false);
        this.toast.success('Resume uploaded.');
        input.value = '';
      },
      error: (err) => {
        this.uploadingResume.set(false);
        this.toast.error(err?.error?.message || 'Could not upload resume.');
        input.value = '';
      }
    });
  }

  loadNotesAndTags(): void {
    this.talentService.getNotes(this.candidateId).subscribe({ next: (n) => this.notes.set(n) });
    this.talentService.getTags(this.candidateId).subscribe({ next: (t) => this.tags.set(t) });
  }

  addNote(): void {
    if (!this.newNote.trim()) return;
    this.talentService.addNote(this.candidateId, this.newNote).subscribe({
      next: () => { this.newNote = ''; this.loadNotesAndTags(); },
      error: () => this.toast.error('Could not add note.')
    });
  }

  addTag(): void {
    if (!this.newTag.trim()) return;
    this.talentService.addTag(this.candidateId, this.newTag).subscribe({
      next: () => { this.newTag = ''; this.loadNotesAndTags(); },
      error: () => this.toast.error('Could not add tag.')
    });
  }

  removeTag(tag: CandidateTag): void {
    this.talentService.removeTag(tag.id).subscribe({
      next: () => this.loadNotesAndTags(),
      error: () => this.toast.error('Could not remove tag.')
    });
  }

  setTab(tab: TabId): void {
    this.activeTab.set(tab);
    if (tab === 'screening' && this.screeningForms().length === 0) this.loadScreening();
    if (tab === 'assessments' && this.assessmentTemplates().length === 0) this.loadAssessments();
    if (tab === 'interviews' && this.candidateInterviews().length === 0) this.loadInterviews();
    if (tab === 'offer') this.loadOffers();
    if (tab === 'onboarding') this.loadOnboarding();
    if (tab === 'communication') this.loadCommunication();
  }

  loadPipeline(): void {
    this.candidateService.getStageHistory(this.candidateId).subscribe({
      next: (h) => this.stageHistory.set(h)
    });
  }

  changeStage(newStatus: string): void {
    const reason = prompt(`Reason for moving to "${newStatus}"?`) || undefined;
    this.candidateService.changeStage(this.candidateId, newStatus, reason).subscribe({
      next: () => {
        this.toast.success(`Moved to ${newStatus}.`);
        this.candidate.update((c) => (c ? { ...c, status: newStatus } : c));
        this.loadPipeline();
      },
      error: () => this.toast.error('Could not change stage.')
    });
  }

  // ---- Screening ----
  loadScreening(): void {
    this.screeningService.getForms().subscribe({ next: (f) => this.screeningForms.set(f) });
    this.screeningService.getResponsesForCandidate(this.candidateId).subscribe({ next: (r) => this.screeningResponses.set(r) });
  }

  openRunScreening(): void {
    this.selectedFormId = this.screeningForms()[0]?.id ?? null;
    this.answers = {};
    this.recruiterNotes = '';
    this.showRunScreening.set(true);
    if (this.selectedFormId) this.loadQuestions();
  }

  loadQuestions(): void {
    if (!this.selectedFormId) return;
    this.screeningService.getQuestions(this.selectedFormId).subscribe({ next: (q) => this.activeQuestions.set(q) });
  }

  submitScreening(): void {
    if (!this.selectedFormId) return;
    const answers = this.activeQuestions().map((q) => ({ questionId: q.id!, answerText: this.answers[q.id!] || '' }));
    this.screeningService.submitResponse({
      candidateId: this.candidateId,
      screeningFormId: this.selectedFormId,
      recruiterNotes: this.recruiterNotes,
      answers
    }).subscribe({
      next: () => {
        this.toast.success('Screening submitted.');
        this.showRunScreening.set(false);
        this.loadScreening();
        this.loadPipeline();
        this.refreshCandidate();
      },
      error: () => this.toast.error('Could not submit screening.')
    });
  }

  toggleResponseDetail(response: ScreeningResponse): void {
    if (this.expandedResponseId() === response.id) {
      this.expandedResponseId.set(null);
      return;
    }
    this.expandedResponseId.set(response.id);
    this.screeningService.getAnswers(response.id).subscribe({ next: (a) => this.responseAnswers.set(a) });
  }

  decide(response: ScreeningResponse, recommendation: string): void {
    this.screeningService.updateRecommendation(response.id, recommendation).subscribe({
      next: () => {
        this.toast.success(`Marked as ${recommendation}.`);
        this.loadScreening();
        this.loadPipeline();
        this.refreshCandidate();
      },
      error: () => this.toast.error('Could not update recommendation.')
    });
  }

  // ---- Assessments ----
  loadAssessments(): void {
    this.assessmentService.getTemplates().subscribe({ next: (t) => this.assessmentTemplates.set(t) });
    this.assessmentService.getInvitationsForCandidate(this.candidateId).subscribe({ next: (i) => this.candidateInvitations.set(i) });
  }

  openInvite(): void {
    this.inviteTemplateId = this.assessmentTemplates()[0]?.id ?? null;
    this.inviteDeadline = '';
    this.showInviteForm.set(true);
  }

  submitInvite(): void {
    if (!this.inviteTemplateId) return;
    this.assessmentService.invite(this.candidateId, this.inviteTemplateId, this.inviteDeadline || null).subscribe({
      next: () => {
        this.toast.success('Assessment invitation sent.');
        this.showInviteForm.set(false);
        this.loadAssessments();
        this.loadPipeline();
        this.refreshCandidate();
      },
      error: () => this.toast.error('Could not send invitation.')
    });
  }

  recordResult(invitation: AssessmentInvitation): void {
    const draft = this.resultDraft[invitation.id] || { score: 0, notes: '' };
    this.assessmentService.recordResult(invitation.id, draft.score, draft.notes).subscribe({
      next: () => {
        this.toast.success('Result recorded.');
        this.loadAssessments();
        this.loadPipeline();
        this.refreshCandidate();
      },
      error: () => this.toast.error('Could not record result.')
    });
  }

  getDraft(id: number) {
    if (!this.resultDraft[id]) this.resultDraft[id] = { score: 0, notes: '' };
    return this.resultDraft[id];
  }

  // ---- Interviews ----
  loadInterviews(): void {
    this.interviewService.getByCandidate(this.candidateId).subscribe({ next: (i) => this.candidateInterviews.set(i) });
  }

  // ---- Offer ----
  loadOffers(): void {
    this.offerService.getByCandidate(this.candidateId).subscribe({ next: (o) => this.offers.set(o) });
  }

  openCreateOffer(): void {
    this.offerDraft = this.emptyOffer();
    this.showOfferForm.set(true);
  }

  submitOffer(): void {
    this.offerDraft.candidateId = this.candidateId;
    this.offerService.create(this.offerDraft).subscribe({
      next: () => { this.toast.success('Offer created as Draft.'); this.showOfferForm.set(false); this.loadOffers(); },
      error: (err) => this.toast.error(err?.error?.message || 'Could not create offer.')
    });
  }

  offerAction(offer: Offer, newStatus: string): void {
    let notes: string | undefined;
    if (newStatus === 'Rejected' || newStatus === 'Withdrawn') {
      notes = prompt(`Reason for marking as ${newStatus}?`) || undefined;
    }
    this.offerService.updateStatus(offer.id!, newStatus, notes).subscribe({
      next: () => {
        this.toast.success(`Offer moved to ${newStatus}.`);
        this.loadOffers();
        this.refreshCandidate();
      },
      error: () => this.toast.error('Could not update offer.')
    });
  }

  toggleOfferAudit(offer: Offer): void {
    if (this.expandedOfferId() === offer.id) {
      this.expandedOfferId.set(null);
      return;
    }
    this.expandedOfferId.set(offer.id!);
    this.negotiationNotes = '';
    this.negotiationSalary = null;
    this.offerService.getAudit(offer.id!).subscribe({ next: (a) => this.offerAudit.set(a) });
  }

  submitNegotiation(offer: Offer): void {
    if (!this.negotiationNotes) return;
    this.offerService.logNegotiation(offer.id!, this.negotiationNotes, this.negotiationSalary ?? undefined).subscribe({
      next: () => {
        this.toast.success('Negotiation logged.');
        this.negotiationNotes = '';
        this.negotiationSalary = null;
        this.loadOffers();
        this.offerService.getAudit(offer.id!).subscribe({ next: (a) => this.offerAudit.set(a) });
      },
      error: () => this.toast.error('Could not log negotiation.')
    });
  }

  private emptyOffer(): Offer {
    return { candidateId: this.candidateId, baseSalary: 0, bonus: null, totalCtc: null, validUntil: null };
  }

  // ---- Onboarding ----
  loadOnboarding(): void {
    this.preJoiningService.getByCandidate(this.candidateId).subscribe({
      next: (lists) => {
        this.checklists.set(lists);
        const active = lists[0];
        if (active) {
          this.joiningDateDraft = active.joiningDate ? active.joiningDate.substring(0, 10) : '';
          this.preJoiningService.getTasks(active.id).subscribe({ next: (t) => this.tasks.set(t) });
        }
      }
    });
    this.preJoiningService.getHireEventsForCandidate(this.candidateId).subscribe({ next: (h) => this.hireEvents.set(h) });
  }

  get activeChecklist(): PreJoiningChecklist | undefined {
    return this.checklists()[0];
  }

  saveJoiningDate(): void {
    const checklist = this.activeChecklist;
    if (!checklist || !this.joiningDateDraft) return;
    this.preJoiningService.setJoiningDate(checklist.id, this.joiningDateDraft).subscribe({
      next: () => { this.toast.success('Joining date saved.'); this.loadOnboarding(); },
      error: () => this.toast.error('Could not save joining date.')
    });
  }

  updateBgv(status: string): void {
    const checklist = this.activeChecklist;
    if (!checklist) return;
    this.preJoiningService.updateBgvStatus(checklist.id, status).subscribe({
      next: () => { this.toast.success('BGV status updated.'); this.loadOnboarding(); },
      error: () => this.toast.error('Could not update BGV status.')
    });
  }

  toggleTask(task: PreJoiningTask): void {
    this.preJoiningService.toggleTask(task.id, !task.isCompleted).subscribe({
      next: () => this.loadOnboarding(),
      error: () => this.toast.error('Could not update task.')
    });
  }

  markHireEventSent(event: HireEvent): void {
    this.preJoiningService.markHireEventSent(event.id).subscribe({
      next: () => { this.toast.success('Hire event marked as sent to HR/ERP.'); this.loadOnboarding(); },
      error: () => this.toast.error('Could not update hire event.')
    });
  }

  private refreshCandidate(): void {
    this.candidateService.getById(this.candidateId).subscribe({ next: (c) => this.candidate.set(c) });
  }

  // ---- Communication ----
  emailTemplates = signal<EmailTemplate[]>([]);
  emailLog = signal<EmailLog[]>([]);
  selectedTemplateCode = '';

  loadCommunication(): void {
    this.commService.getTemplates().subscribe({ next: (t) => this.emailTemplates.set(t.filter((x) => x.isActive)) });
    this.commService.getLogForCandidate(this.candidateId).subscribe({ next: (l) => this.emailLog.set(l) });
  }

  sendSelectedTemplate(): void {
    if (!this.selectedTemplateCode) return;
    this.commService.sendEmail(this.candidateId, this.selectedTemplateCode).subscribe({
      next: () => {
        this.toast.success('Email queued for sending.');
        setTimeout(() => this.loadCommunication(), 800);
      },
      error: () => this.toast.error('Could not send email.')
    });
  }
}
