import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { EMPTY, catchError, throwError } from 'rxjs';
import { AuthService } from '../services/auth.service';
import { ToastService } from '../services/toast.service';

let sessionExpiredNoticeShown = false;

/**
 * Attaches the JWT bearer token to outgoing requests and,
 * on a 401, clears the session and redirects to login.
 *
 * A 401 on an *authenticated* request (one that carried a bearer token) is
 * handled exclusively here: it's swallowed with EMPTY instead of being
 * rethrown, so the many per-component `error:` handlers (each of which
 * shows its own "Could not load X" toast) never fire for it. Without this,
 * every in-flight background call that hit the expired session would
 * additionally pop its own generic error toast at the exact moment the
 * user is being redirected to login — a burst of confusing, seemingly
 * -random notifications on page load/navigation.
 *
 * A 401 on an *anonymous* request (no token attached — e.g. a failed
 * login/register attempt) is NOT session expiry, so it's left alone and
 * rethrown for the calling component to show its own "invalid credentials"
 * message as usual.
 */
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const router = inject(Router);
  const toast = inject(ToastService);
  const token = auth.getToken();

  const authReq = token
    ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } })
    : req;

  return next(authReq).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401 && token) {
        auth.logout();
        if (!sessionExpiredNoticeShown) {
          sessionExpiredNoticeShown = true;
          toast.info('Your session has expired. Please log in again.');
          setTimeout(() => { sessionExpiredNoticeShown = false; }, 4000);
        }
        router.navigate(['/login']);
        return EMPTY;
      }
      return throwError(() => error);
    })
  );
};
