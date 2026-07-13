import cron from 'node-cron';
import { supabase } from '../config/supabase.js';
import { EmailService } from '../services/email.service.js';

const emailService = new EmailService();

async function checkAndSendReminders() {
  console.log('[ReminderJob] Checking for upcoming billing reminders...');

  const today = new Date();
  const todayStr = today.toISOString().split('T')[0];

  const date7 = new Date(today);
  date7.setDate(date7.getDate() + 7);
  const date7Str = date7.toISOString().split('T')[0];

  const date3 = new Date(today);
  date3.setDate(date3.getDate() + 3);
  const date3Str = date3.toISOString().split('T')[0];

  try {
    await sendRemindersForDate(date7Str, 7);
    await sendRemindersForDate(date3Str, 3);

    console.log('[ReminderJob] Done.');
  } catch (error: any) {
    console.error('[ReminderJob] Error:', error.message);
  }
}

async function sendRemindersForDate(targetDate: string, daysBefore: number) {
  const { data: reminders, error } = await supabase
    .from('billing_reminders')
    .select(`
      id,
      company_id,
      reminder_date,
      amount,
      companies (
        id,
        name,
        user_id,
        currency,
        users (
          id,
          email,
          full_name,
          email_verified
        )
      )
    `)
    .eq('reminder_date', targetDate)
    .eq('status', 'pending');

  if (error) {
    console.error(`[ReminderJob] Error querying reminders for ${targetDate}:`, error.message);
    return;
  }

  if (!reminders || reminders.length === 0) {
    console.log(`[ReminderJob] No reminders found for ${targetDate} (${daysBefore} days)`);
    return;
  }

  console.log(`[ReminderJob] Found ${reminders.length} reminders for ${targetDate} (${daysBefore} days)`);

  for (const reminder of reminders) {
    try {
      const company = reminder.companies as any;
      if (!company) continue;

      const user = company.users as any;
      if (!user || !user.email_verified) continue;

      await emailService.sendBillingReminder(
        user.email,
        user.full_name,
        company.name,
        reminder.amount,
        company.currency || 'COP',
        reminder.reminder_date,
        daysBefore
      );
    } catch (error: any) {
      console.error(`[ReminderJob] Error sending reminder ${reminder.id}:`, error.message);
    }
  }
}

export function startReminderJob() {
  cron.schedule('0 8 * * *', () => {
    checkAndSendReminders();
  }, {
    timezone: 'America/Bogota',
  });

  console.log('[ReminderJob] Scheduled daily at 8:00 AM (America/Bogota)');
}
