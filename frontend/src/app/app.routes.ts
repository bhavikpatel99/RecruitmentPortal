import { Routes } from '@angular/router';
import { authGuard } from './guards/auth.guard';
import { recruiterWorkspaceGuard, adminOnlyGuard, agencyOnlyGuard } from './guards/role.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'jobs', pathMatch: 'full' },
  {
    path: 'login',
    loadComponent: () =>
      import('./components/login/login.component').then((m) => m.LoginComponent)
  },
  {
    path: 'register',
    loadComponent: () =>
      import('./components/register/register.component').then((m) => m.RegisterComponent)
  },
  {
    path: 'dashboard',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/dashboard/dashboard.component').then((m) => m.DashboardComponent)
  },
  {
    path: 'jobs',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/jobs-list/jobs-list.component').then((m) => m.JobsListComponent)
  },
  {
    path: 'interview-guidance',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/interview-guidance/interview-guidance.component').then((m) => m.InterviewGuidanceComponent)
  },
  {
    path: 'resume-analyzer',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/resume-analyzer/resume-analyzer.component').then((m) => m.ResumeAnalyzerComponent)
  },
  {
    path: 'candidate/new',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/candidate-form/candidate-form.component').then((m) => m.CandidateFormComponent)
  },
  {
    path: 'candidate/:id',
    canActivate: [authGuard],
    loadComponent: () =>
      import('./components/candidate-form/candidate-form.component').then((m) => m.CandidateFormComponent)
  },
  {
    path: 'workspace',
    canActivate: [recruiterWorkspaceGuard],
    loadComponent: () =>
      import('./components/workspace-shell/workspace-shell.component').then((m) => m.WorkspaceShellComponent),
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadComponent: () =>
          import('./components/recruiter-dashboard/recruiter-dashboard.component').then((m) => m.RecruiterDashboardComponent)
      },
      {
        path: 'requisitions',
        loadComponent: () =>
          import('./components/requisitions/requisitions.component').then((m) => m.RequisitionsComponent)
      },
      {
        path: 'jobs',
        loadComponent: () =>
          import('./components/recruiter-jobs/recruiter-jobs.component').then((m) => m.RecruiterJobsComponent)
      },
      {
        path: 'pipeline',
        loadComponent: () =>
          import('./components/pipeline/pipeline.component').then((m) => m.PipelineComponent)
      },
      {
        path: 'interviews',
        loadComponent: () =>
          import('./components/interviews/interviews.component').then((m) => m.InterviewsComponent)
      },
      {
        path: 'candidates',
        loadComponent: () =>
          import('./components/candidates-list/candidates-list.component').then((m) => m.CandidatesListComponent)
      },
      {
        path: 'candidates/:id',
        loadComponent: () =>
          import('./components/candidate-detail/candidate-detail.component').then((m) => m.CandidateDetailComponent)
      },
      {
        path: 'screening-forms',
        loadComponent: () =>
          import('./components/screening-forms/screening-forms.component').then((m) => m.ScreeningFormsComponent)
      },
      {
        path: 'assessment-templates',
        loadComponent: () =>
          import('./components/assessment-templates/assessment-templates.component').then((m) => m.AssessmentTemplatesComponent)
      },
      {
        path: 'offers',
        loadComponent: () =>
          import('./components/offers/offers.component').then((m) => m.OffersComponent)
      },
      {
        path: 'talent-search',
        loadComponent: () =>
          import('./components/talent-search/talent-search.component').then((m) => m.TalentSearchComponent)
      },
      {
        path: 'talent-pools',
        loadComponent: () =>
          import('./components/talent-pools/talent-pools.component').then((m) => m.TalentPoolsComponent)
      },
      {
        path: 'communication',
        loadComponent: () =>
          import('./components/communication/communication.component').then((m) => m.CommunicationComponent)
      },
      {
        path: 'org-setup',
        canActivate: [adminOnlyGuard],
        loadComponent: () =>
          import('./components/org-setup/org-setup.component').then((m) => m.OrgSetupComponent)
      },
      {
        path: 'agencies',
        loadComponent: () =>
          import('./components/agencies/agencies.component').then((m) => m.AgenciesComponent)
      },
      {
        path: 'referrals',
        loadComponent: () =>
          import('./components/referrals/referrals.component').then((m) => m.ReferralsComponent)
      },
      {
        path: 'analytics',
        loadComponent: () =>
          import('./components/analytics/analytics.component').then((m) => m.AnalyticsComponent)
      }
    ]
  },
  {
    path: 'agency-portal',
    canActivate: [agencyOnlyGuard],
    loadComponent: () =>
      import('./components/agency-portal/agency-portal.component').then((m) => m.AgencyPortalComponent)
  },
  { path: '**', redirectTo: 'login' }
];
