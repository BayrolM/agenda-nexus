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
}
