import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { AuthService } from '../../services/auth.service';

interface NavItem {
  path: string;
  label: string;
  icon: string;
  roles?: string[];
}

@Component({
  selector: 'app-workspace-shell',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive, RouterOutlet],
  templateUrl: './workspace-shell.component.html',
  styleUrls: ['./workspace-shell.component.css']
})
export class WorkspaceShellComponent {
  readonly navItems: NavItem[] = [
    { path: '/workspace/dashboard', label: 'Dashboard', icon: '📊' },
    { path: '/workspace/requisitions', label: 'Requisitions', icon: '📋' },
    { path: '/workspace/jobs', label: 'Job Postings', icon: '💼' },
    { path: '/workspace/candidates', label: 'Candidates', icon: '👤' },
    { path: '/workspace/talent-search', label: 'Talent Search', icon: '🔍' },
    { path: '/workspace/talent-pools', label: 'Talent Pools', icon: '🗂️' },
    { path: '/workspace/pipeline', label: 'Pipeline', icon: '🧭' },
    { path: '/workspace/screening-forms', label: 'Screening Forms', icon: '📝' },
    { path: '/workspace/assessment-templates', label: 'Assessment Templates', icon: '🧪' },
    { path: '/workspace/interviews', label: 'Interviews', icon: '🗓️' },
    { path: '/workspace/offers', label: 'Offers', icon: '✉️' },
    { path: '/workspace/communication', label: 'Communication', icon: '💬' },
    { path: '/workspace/agencies', label: 'Agencies', icon: '🏬', roles: ['Admin', 'Recruiter'] },
    { path: '/workspace/referrals', label: 'Referrals', icon: '🤝' },
    { path: '/workspace/analytics', label: 'Analytics', icon: '📈' },
    { path: '/workspace/org-setup', label: 'Org Setup', icon: '🏢', roles: ['Admin'] }
  ];

  sidebarOpen = true;

  constructor(public auth: AuthService, private router: Router) {}

  get visibleNavItems(): NavItem[] {
    const role = this.auth.user()?.role;
    return this.navItems.filter((item) => !item.roles || (role && item.roles.includes(role)));
  }

  toggleSidebar(): void {
    this.sidebarOpen = !this.sidebarOpen;
  }

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
