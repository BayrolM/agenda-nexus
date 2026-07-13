// sib-api-v3-sdk lacks proper TypeScript declarations
const sib = require('sib-api-v3-sdk');

const apiClient = sib.ApiClient.instance;
apiClient.authentications['api-key'].apiKey = process.env.BREVO_API_KEY || '';

export function getBrevoTransactionalEmailsApi() {
  return new sib.TransactionalEmailsApi();
}

export const BREVO_SENDER_EMAIL = process.env.BREVO_SENDER_EMAIL || 'noreply@agendanexus.com';
export const BREVO_SENDER_NAME = process.env.BREVO_SENDER_NAME || 'Agenda Nexus';
