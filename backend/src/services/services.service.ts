import { supabase } from '../config/supabase.js';
import type { CompanyService } from '../types/index.js';

export class ServicesService {
  async getByCompanyId(companyId: string) {
    const { data, error } = await supabase
      .from('company_services')
      .select('*')
      .eq('company_id', companyId)
      .order('created_at', { ascending: false });

    if (error) throw error;
    return data;
  }

  async getById(id: string) {
    const { data, error } = await supabase
      .from('company_services')
      .select('*')
      .eq('id', id)
      .single();

    if (error) throw error;
    return data;
  }

  async create(service: Omit<CompanyService, 'id' | 'created_at' | 'updated_at'>) {
    const { data, error } = await supabase
      .from('company_services')
      .insert({
        company_id: service.company_id,
        service_type: service.service_type,
        service_name: service.service_name,
        url: service.url,
        username: service.username,
        password: service.password,
        api_key: service.api_key,
        expiration_date: service.expiration_date,
        monthly_cost: service.monthly_cost,
        notes: service.notes,
      })
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async update(id: string, updates: Partial<CompanyService>) {
    const { data, error } = await supabase
      .from('company_services')
      .update({
        service_type: updates.service_type,
        service_name: updates.service_name,
        url: updates.url,
        username: updates.username,
        password: updates.password,
        api_key: updates.api_key,
        expiration_date: updates.expiration_date,
        monthly_cost: updates.monthly_cost,
        notes: updates.notes,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;
    return data;
  }

  async delete(id: string) {
    const { error } = await supabase
      .from('company_services')
      .delete()
      .eq('id', id);

    if (error) throw error;
  }
}
