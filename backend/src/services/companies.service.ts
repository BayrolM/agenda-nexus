import { supabase } from '../config/supabase.js';
import type { Company } from '../types/index.js';

export class CompaniesService {
  async getAll(userId: string) {
    const { data, error } = await supabase
      .from('companies')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data;
  }

  async getById(id: string, userId: string) {
    const { data, error } = await supabase
      .from('companies')
      .select('*')
      .eq('id', id)
      .eq('user_id', userId)
      .single();

    if (error) throw error;
    return data;
  }

  async create(company: Omit<Company, 'id' | 'created_at' | 'updated_at'>) {
    const { data, error } = await supabase
      .from('companies')
      .insert({
        user_id: company.user_id,
        name: company.name,
        description: company.description,
        contact_email: company.contact_email,
        contact_phone: company.contact_phone,
        billing_day: company.billing_day,
        billing_amount: company.billing_amount,
        currency: company.currency,
        notes: company.notes,
        is_active: company.is_active,
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async update(id: string, userId: string, updates: Partial<Company>) {
    const { data, error } = await supabase
      .from('companies')
      .update({
        name: updates.name,
        description: updates.description,
        contact_email: updates.contact_email,
        contact_phone: updates.contact_phone,
        billing_day: updates.billing_day,
        billing_amount: updates.billing_amount,
        currency: updates.currency,
        notes: updates.notes,
        is_active: updates.is_active,
      })
      .eq('id', id)
      .eq('user_id', userId)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async delete(id: string, userId: string) {
    const { error } = await supabase
      .from('companies')
      .delete()
      .eq('id', id)
      .eq('user_id', userId);

    if (error) throw error;
  }
}
