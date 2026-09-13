import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

/** Restricts a route to one of the given roles (recruiter-workspace pages). */
export function roleGuard(allowedRoles: string[]): CanActivateFn {
  return () => {
    const auth = inject(AuthService);
    const router = inject(Router);

    if (!auth.isLoggedIn()) {
      return router.createUrlTree(['/login']);
    }

    const role = auth.user()?.role;
    if (role && allowedRoles.includes(role)) {
      return true;
    }

    return router.createUrlTree(['/jobs']);
  };
}

export const recruiterWorkspaceGuard = roleGuard(['Admin', 'Recruiter', 'HiringManager']);
export const adminOnlyGuard = roleGuard(['Admin']);
export const agencyOnlyGuard = roleGuard(['Agency']);
