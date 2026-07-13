import { getBrevoTransactionalEmailsApi, BREVO_SENDER_EMAIL, BREVO_SENDER_NAME } from '../config/brevo.js';

export class EmailService {
  private api = getBrevoTransactionalEmailsApi();

  async sendVerificationCode(email: string, code: string, fullName: string) {
    try {
      const sendSmtpEmail = {
        sender: { email: BREVO_SENDER_EMAIL, name: BREVO_SENDER_NAME },
        to: [{ email }],
        subject: 'Verifica tu correo - Agenda Nexus',
        htmlContent: `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f9fafb; margin: 0; padding: 20px; }
              .container { max-width: 480px; margin: 0 auto; background: white; border-radius: 12px; padding: 40px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
              .code { font-size: 36px; font-weight: 700; letter-spacing: 8px; text-align: center; color: #000; padding: 20px; background: #f3f4f6; border-radius: 8px; margin: 24px 0; }
              .text { color: #374151; font-size: 14px; line-height: 1.6; }
              .footer { color: #9ca3af; font-size: 12px; margin-top: 32px; text-align: center; }
            </style>
          </head>
          <body>
            <div class="container">
              <h2 style="text-align:center; color:#000; margin-bottom:8px;">Agenda Nexus</h2>
              <p class="text">Hola <strong>${fullName}</strong>,</p>
              <p class="text">Tu codigo de verificacion es:</p>
              <div class="code">${code}</div>
              <p class="text">Este codigo expira en <strong>15 minutos</strong>.</p>
              <p class="text">Si no solicitaste esta cuenta, puedes ignorar este mensaje.</p>
              <div class="footer">Agenda Nexus &copy; ${new Date().getFullYear()}</div>
            </div>
          </body>
          </html>
        `,
      };

      await this.api.sendTransacEmail(sendSmtpEmail);
      console.log(`Verification email sent to ${email}`);
    } catch (error: any) {
      console.error('Error sending verification email:', error.message);
      throw new Error('Error al enviar el correo de verificacion');
    }
  }

  async sendBillingReminder(
    email: string,
    fullName: string,
    companyName: string,
    amount: number | null,
    currency: string,
    reminderDate: string,
    daysBefore: number
  ) {
    try {
      const formattedAmount = amount
        ? `$${amount.toLocaleString('es-CO')} ${currency}`
        : 'Monto no especificado';

      const dateObj = new Date(reminderDate + 'T12:00:00');
      const formattedDate = dateObj.toLocaleDateString('es-CO', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      });

      const sendSmtpEmail = {
        sender: { email: BREVO_SENDER_EMAIL, name: BREVO_SENDER_NAME },
        to: [{ email }],
        subject: `Recordatorio: Cobro de ${companyName} en ${daysBefore} dias`,
        htmlContent: `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f9fafb; margin: 0; padding: 20px; }
              .container { max-width: 480px; margin: 0 auto; background: white; border-radius: 12px; padding: 40px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
              .amount { font-size: 28px; font-weight: 700; color: #000; text-align: center; margin: 20px 0; }
              .detail { background: #f9fafb; border-radius: 8px; padding: 16px; margin: 16px 0; }
              .detail-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #e5e7eb; }
              .detail-row:last-child { border-bottom: none; }
              .detail-label { color: #6b7280; font-size: 13px; }
              .detail-value { color: #111827; font-size: 13px; font-weight: 600; }
              .text { color: #374151; font-size: 14px; line-height: 1.6; }
              .footer { color: #9ca3af; font-size: 12px; margin-top: 32px; text-align: center; }
            </style>
          </head>
          <body>
            <div class="container">
              <h2 style="text-align:center; color:#000; margin-bottom:8px;">Agenda Nexus</h2>
              <p class="text">Hola <strong>${fullName}</strong>,</p>
              <p class="text">Tienes un cobro proximo pendiente:</p>
              <div class="amount">${formattedAmount}</div>
              <div class="detail">
                <div class="detail-row">
                  <span class="detail-label">Empresa</span>
                  <span class="detail-value">${companyName}</span>
                </div>
                <div class="detail-row">
                  <span class="detail-label">Fecha de cobro</span>
                  <span class="detail-value">${formattedDate}</span>
                </div>
                <div class="detail-row">
                  <span class="detail-label">Faltan</span>
                  <span class="detail-value">${daysBefore} dias</span>
                </div>
              </div>
              <p class="text">No olvides registrar el pago una vez se haya realizado.</p>
              <div class="footer">Agenda Nexus &copy; ${new Date().getFullYear()}</div>
            </div>
          </body>
          </html>
        `,
      };

      await this.api.sendTransacEmail(sendSmtpEmail);
      console.log(`Billing reminder sent to ${email} for ${companyName}`);
    } catch (error: any) {
      console.error('Error sending billing reminder:', error.message);
    }
  }
}
