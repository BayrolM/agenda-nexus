import { supabase } from '../config/supabase.js';
import type { BillingReminder } from '../types/index.js';

export class BillingService {
  async getPending() {
    const { data, error } = await supabase
      .from('billing_reminders')
      .select('*')
      .eq('status', 'pending')
      .order('reminder_date', { ascending: true });

    if (error) throw error;
    return data;
  }

  async getByDateRange(startDate: string, endDate: string) {
    const { data, error } = await supabase
      .from('billing_reminders')
      .select('*')
      .gte('reminder_date', startDate)
      .lte('reminder_date', endDate)
      .order('reminder_date', { ascending: true });

    if (error) throw error;
    return data;
  }

  async create(record: Omit<BillingReminder, 'id' | 'created_at'>) {
    const { data, error } = await supabase
      .from('billing_reminders')
      .insert({
        company_id: record.company_id,
        reminder_date: record.reminder_date,
        amount: record.amount,
        status: record.status,
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async update(id: string, updates: Partial<BillingReminder>) {
    const { data, error } = await supabase
      .from('billing_reminders')
      .update({
        status: updates.status,
        amount: updates.amount,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async delete(id: string) {
    const { error } = await supabase
      .from('billing_reminders')
      .delete()
      .eq('id', id);

    if (error) throw error;
  }

  async markOverdue() {
    const today = new Date().toISOString().split('T')[0];

    const { data, error } = await supabase
      .from('billing_reminders')
      .update({ status: 'overdue' })
      .lt('reminder_date', today)
      .eq('status', 'pending')
      .select();

    if (error) throw error;
    return data;
  }

  async deleteByCompanyId(companyId: string) {
    const { error } = await supabase
      .from('billing_reminders')
      .delete()
      .eq('company_id', companyId)
      .eq('status', 'pending');

    if (error) throw error;
  }

  async regenerateForCompany(
    companyId: string,
    billingDay: number,
    billingAmount: number | null,
  ) {
    await this.deleteByCompanyId(companyId);

    const now = new Date();
    for (let i = 0; i < 12; i++) {
      let month = now.getMonth() + i;
      let year = now.getFullYear();
      if (month > 11) {
        month -= 12;
        year += 1;
      }

      const lastDay = new Date(year, month + 1, 0).getDate();
      const day = billingDay > lastDay ? lastDay : billingDay;
      const reminderDate = new Date(year, month, day);

      const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      if (reminderDate < today) continue;

      await this.create({
        company_id: companyId,
        reminder_date: reminderDate.toISOString().split('T')[0],
        amount: billingAmount ?? undefined,
        status: 'pending',
      });
    }
  }
}
