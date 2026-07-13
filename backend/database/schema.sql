-- =============================================
-- AGENDA NEXUS - Database Schema (Custom Auth)
-- =============================================

-- Tabla de usuarios (custom, sin Supabase Auth)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user')),
  email_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de verificacion de email
CREATE TABLE IF NOT EXISTS email_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de empresas
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  contact_email TEXT,
  contact_phone TEXT,
  billing_day INTEGER CHECK (billing_day BETWEEN 1 AND 31),
  billing_amount DECIMAL(10,2),
  currency TEXT DEFAULT 'COP',
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de servicios/cuentas de cada empresa
CREATE TABLE IF NOT EXISTS company_services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  service_type TEXT NOT NULL CHECK (service_type IN (
    'google', 'github', 'database', 'hosting',
    'backend', 'email', 'domain', 'other'
  )),
  service_name TEXT NOT NULL,
  url TEXT,
  username TEXT,
  password TEXT,
  api_key TEXT,
  expiration_date DATE,
  monthly_cost DECIMAL(10,2),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabla de recordatorios de cobro
CREATE TABLE IF NOT EXISTS billing_reminders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  reminder_date DATE NOT NULL,
  amount DECIMAL(10,2),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- INDEXES
-- =============================================
CREATE INDEX IF NOT EXISTS idx_companies_user_id ON companies(user_id);
CREATE INDEX IF NOT EXISTS idx_company_services_company_id ON company_services(company_id);
CREATE INDEX IF NOT EXISTS idx_billing_reminders_company_id ON billing_reminders(company_id);
CREATE INDEX IF NOT EXISTS idx_billing_reminders_date ON billing_reminders(reminder_date);
CREATE INDEX IF NOT EXISTS idx_email_verifications_user_id ON email_verifications(user_id);

-- =============================================
-- TRIGGER: Auto-update updated_at
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_companies_updated_at ON companies;
CREATE TRIGGER update_companies_updated_at
  BEFORE UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_company_services_updated_at ON company_services;
CREATE TRIGGER update_company_services_updated_at
  BEFORE UPDATE ON company_services
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- Usuario admin por defecto (password: 123456)
-- =============================================
INSERT INTO users (email, password, full_name, role, email_verified)
VALUES ('admin@test.com', '$2b$10$HQJNAeLFlcdqlGqO14udPOnuKkW8TdzqcHBFxwRvNepgkbOrF1Ijy', 'Admin', 'admin', true)
ON CONFLICT (email) DO NOTHING;
