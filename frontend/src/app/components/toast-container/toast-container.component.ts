import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ToastService } from '../../services/toast.service';

@Component({
  selector: 'app-toast-container',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="toast-stack">
      <div
        *ngFor="let toast of toastService.items()"
        class="toast"
        [ngClass]="'toast-' + toast.type"
        (click)="toastService.dismiss(toast.id)"
      >
        {{ toast.message }}
      </div>
    </div>
  `
})
export class ToastContainerComponent {
  constructor(public toastService: ToastService) {}
}
