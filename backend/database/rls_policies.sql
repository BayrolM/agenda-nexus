-- =============================================
-- RLS Policies for Agenda Nexus
-- Ejecutar en SQL Editor de Supabase
-- =============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_reminders ENABLE ROW LEVEL SECURITY;

-- =============================================
-- user_profiles: Los usuarios ven y editan su propio perfil
-- =============================================
CREATE POLICY "Users can view own profile" ON user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON user_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON user_profiles
  FOR UPDATE USING (auth.uid() = id);

-- =============================================
-- companies: Los usuarios ven y manejan sus propias empresas
-- =============================================
CREATE POLICY "Users can view own companies" ON companies
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own companies" ON companies
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own companies" ON companies
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own companies" ON companies
  FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- company_services: Acceso a través de la empresa
-- =============================================
CREATE POLICY "Users can view services of own companies" ON company_services
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = company_services.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert services to own companies" ON company_services
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = company_services.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update services of own companies" ON company_services
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = company_services.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete services of own companies" ON company_services
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = company_services.company_id
      AND companies.user_id = auth.uid()
    )
  );

-- =============================================
-- billing_reminders: Acceso a través de la empresa
-- =============================================
CREATE POLICY "Users can view billing of own companies" ON billing_reminders
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = billing_reminders.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert billing to own companies" ON billing_reminders
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = billing_reminders.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update billing of own companies" ON billing_reminders
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = billing_reminders.company_id
      AND companies.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete billing of own companies" ON billing_reminders
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM companies
      WHERE companies.id = billing_reminders.company_id
      AND companies.user_id = auth.uid()
    )
  );
