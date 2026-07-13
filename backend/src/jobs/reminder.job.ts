import cron from 'node-cron';
import { supabase } from '../config/supabase.js';
import { EmailService } from '../services/email.service.js';
import { BillingService } from '../services/billing.service.js';

const emailService = new EmailService();
const billingService = new BillingService();

async function checkAndSendReminders() {
  console.log('[ReminderJob] Checking for upcoming billing reminders...');

  const today = new Date();
  const date7 = new Date(today);
  date7.setDate(date7.getDate() + 7);
  const date7Str = date7.toISOString().split('T')[0];

  const date3 = new Date(today);
  date3.setDate(date3.getDate() + 3);
  const date3Str = date3.toISOString().split('T')[0];

  try {
    const overdueReminders = await billingService.markOverdue();
    if (overdueReminders && overdueReminders.length > 0) {
      console.log(`[ReminderJob] Marked ${overdueReminders.length} reminders as overdue`);
    }

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
        currency
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

  // Get ALL verified users
  const { data: users, error: usersError } = await supabase
    .from('users')
    .select('id, email, full_name')
    .eq('email_verified', true);

  if (usersError || !users || users.length === 0) {
    console.error('[ReminderJob] No verified users found:', usersError?.message);
    return;
  }

  console.log(`[ReminderJob] Sending to ${users.length} verified users`);

  // Send each reminder to ALL verified users
  for (const reminder of reminders) {
    const company = reminder.companies as any;
    if (!company) continue;

    for (const user of users) {
      try {
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
        console.error(`[ReminderJob] Error sending reminder ${reminder.id} to ${user.email}:`, error.message);
      }
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
