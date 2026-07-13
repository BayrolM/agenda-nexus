export interface ApiResponse<T = unknown> {
  data?: T;
  error?: string;
  message?: string;
}

export interface UserProfile {
  id: string;
  full_name: string;
  role: 'admin' | 'user';
  created_at: string;
}

export interface Company {
  id: string;
  user_id: string;
  name: string;
  description?: string;
  contact_email?: string;
  contact_phone?: string;
  billing_day?: number;
  billing_amount?: number;
  currency: string;
  notes?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface CompanyService {
  id: string;
  company_id: string;
  service_type: string;
  service_name: string;
  url?: string;
  username?: string;
  password?: string;
  api_key?: string;
  expiration_date?: string;
  monthly_cost?: number;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface BillingReminder {
  id: string;
  company_id: string;
  reminder_date: string;
  amount?: number;
  status: 'pending' | 'paid' | 'overdue';
  created_at: string;
}
