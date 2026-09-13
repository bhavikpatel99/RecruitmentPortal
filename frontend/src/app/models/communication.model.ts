export interface SmtpSettings {
  id?: number;
  provider: string;
  host: string;
  port: number;
  secureSocketMode: string;
  username: string;
  password?: string;
  fromEmail: string;
  fromName?: string | null;
  isActive?: boolean;
  createdAt?: string;
  hasPassword?: boolean;
}

export interface EmailTemplate {
  id?: number;
  code?: string;
  name: string;
  subject: string;
  bodyHtml: string;
  category: string;
  isSystem?: boolean;
  isActive?: boolean;
  createdAt?: string;
  updatedAt?: string | null;
}

export interface EmailLog {
  id: number;
  toEmail: string;
  subject: string;
  body?: string;
  templateCode?: string | null;
  candidateId?: number | null;
  status: string;
  errorMessage?: string | null;
  sentBy?: number | null;
  createdAt: string;
  sentAt?: string | null;
}

/** Auto-fill presets for common providers - the backend accepts ANY SMTP host/port, these just save typing. */
export const SMTP_PROVIDER_PRESETS: Record<string, { host: string; port: number; secureSocketMode: string }> = {
  Gmail: { host: 'smtp.gmail.com', port: 587, secureSocketMode: 'StartTls' },
  Zoho: { host: 'smtp.zoho.com', port: 587, secureSocketMode: 'StartTls' },
  Zimbra: { host: 'mail.yourdomain.com', port: 587, secureSocketMode: 'StartTls' },
  Office365: { host: 'smtp.office365.com', port: 587, secureSocketMode: 'StartTls' },
  Custom: { host: '', port: 587, secureSocketMode: 'Auto' }
};

export const SECURE_SOCKET_MODES = ['Auto', 'SslOnConnect', 'StartTls', 'StartTlsWhenAvailable', 'None'];
