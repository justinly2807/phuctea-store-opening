-- ============================================================
-- FIX: Xoa tat ca policies cu roi tao lai
-- Chay file nay truoc, roi chay lai supabase-schema.sql
-- ============================================================

-- Drop all existing policies
DROP POLICY IF EXISTS "profiles_select" ON profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON profiles;
DROP POLICY IF EXISTS "profiles_admin_all" ON profiles;

DROP POLICY IF EXISTS "stores_select" ON stores;
DROP POLICY IF EXISTS "stores_admin_insert" ON stores;
DROP POLICY IF EXISTS "stores_admin_update" ON stores;
DROP POLICY IF EXISTS "stores_admin_delete" ON stores;

DROP POLICY IF EXISTS "project_data_select" ON project_data;
DROP POLICY IF EXISTS "project_data_admin" ON project_data;
DROP POLICY IF EXISTS "project_data_partner" ON project_data;
DROP POLICY IF EXISTS "project_data_insert" ON project_data;

DROP POLICY IF EXISTS "marketing_data_select" ON marketing_data;
DROP POLICY IF EXISTS "marketing_data_admin" ON marketing_data;
DROP POLICY IF EXISTS "marketing_data_partner" ON marketing_data;
DROP POLICY IF EXISTS "marketing_data_insert" ON marketing_data;

DROP POLICY IF EXISTS "project_template_select" ON project_template;
DROP POLICY IF EXISTS "project_template_admin" ON project_template;
DROP POLICY IF EXISTS "marketing_template_select" ON marketing_template;
DROP POLICY IF EXISTS "marketing_template_admin" ON marketing_template;

DROP POLICY IF EXISTS "handbook_select" ON handbook;
DROP POLICY IF EXISTS "handbook_admin" ON handbook;

DROP POLICY IF EXISTS "quiz_bank_select" ON quiz_bank;
DROP POLICY IF EXISTS "quiz_bank_admin" ON quiz_bank;

DROP POLICY IF EXISTS "quiz_results_own" ON quiz_results;
DROP POLICY IF EXISTS "quiz_results_admin_select" ON quiz_results;
DROP POLICY IF EXISTS "quiz_results_insert" ON quiz_results;

-- Drop trigger cu
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- ============================================================
-- Tao lai tat ca policies
-- ============================================================

-- Helper functions
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_user_store_code()
RETURNS TEXT AS $$
  SELECT store_code FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Auto-create profile trigger
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, username, display_name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'viewer')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Clone templates function
CREATE OR REPLACE FUNCTION clone_templates_for_store(p_store_code TEXT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO project_data (store_code, task_no, status)
  SELECT p_store_code, task_no, 'Chua bat dau'
  FROM project_template
  ORDER BY sort_order;

  INSERT INTO marketing_data (store_code, task_no, status)
  SELECT p_store_code, task_no, 'Chua bat dau'
  FROM marketing_template
  ORDER BY sort_order;
END;
$$ LANGUAGE plpgsql;

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_template ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_template ENABLE ROW LEVEL SECURITY;
ALTER TABLE handbook ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_bank ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;

-- PROFILES
CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE USING (id = auth.uid());
CREATE POLICY "profiles_admin_all" ON profiles FOR ALL USING (get_user_role() = 'admin');

-- STORES
CREATE POLICY "stores_select" ON stores FOR SELECT USING (true);
CREATE POLICY "stores_admin_insert" ON stores FOR INSERT WITH CHECK (get_user_role() = 'admin');
CREATE POLICY "stores_admin_update" ON stores FOR UPDATE USING (get_user_role() = 'admin');
CREATE POLICY "stores_admin_delete" ON stores FOR DELETE USING (get_user_role() = 'admin');

-- PROJECT_DATA
CREATE POLICY "project_data_select" ON project_data FOR SELECT USING (true);
CREATE POLICY "project_data_admin" ON project_data FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "project_data_partner" ON project_data FOR UPDATE
  USING (get_user_role() = 'partner' AND store_code = get_user_store_code());
CREATE POLICY "project_data_insert" ON project_data FOR INSERT WITH CHECK (get_user_role() = 'admin');

-- MARKETING_DATA
CREATE POLICY "marketing_data_select" ON marketing_data FOR SELECT USING (true);
CREATE POLICY "marketing_data_admin" ON marketing_data FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "marketing_data_partner" ON marketing_data FOR UPDATE
  USING (get_user_role() = 'partner' AND store_code = get_user_store_code());
CREATE POLICY "marketing_data_insert" ON marketing_data FOR INSERT WITH CHECK (get_user_role() = 'admin');

-- TEMPLATES
CREATE POLICY "project_template_select" ON project_template FOR SELECT USING (true);
CREATE POLICY "project_template_admin" ON project_template FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "marketing_template_select" ON marketing_template FOR SELECT USING (true);
CREATE POLICY "marketing_template_admin" ON marketing_template FOR ALL USING (get_user_role() = 'admin');

-- HANDBOOK
CREATE POLICY "handbook_select" ON handbook FOR SELECT USING (true);
CREATE POLICY "handbook_admin" ON handbook FOR ALL USING (get_user_role() = 'admin');

-- QUIZ_BANK
CREATE POLICY "quiz_bank_select" ON quiz_bank FOR SELECT USING (true);
CREATE POLICY "quiz_bank_admin" ON quiz_bank FOR ALL USING (get_user_role() = 'admin');

-- QUIZ_RESULTS
CREATE POLICY "quiz_results_own" ON quiz_results FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "quiz_results_admin_select" ON quiz_results FOR SELECT USING (get_user_role() = 'admin');
CREATE POLICY "quiz_results_insert" ON quiz_results FOR INSERT WITH CHECK (user_id = auth.uid());

-- View
CREATE OR REPLACE VIEW store_progress AS
SELECT
  s.store_code, s.store_name, s.status, s.address, s.city,
  s.partner_name, s.partner_phone, s.soft_opening_date, s.grand_opening_date,
  s.created_at, s.notes,
  COALESCE(pp.total, 0) AS project_total,
  COALESCE(pp.completed, 0) AS project_completed,
  CASE WHEN COALESCE(pp.total, 0) > 0
    THEN ROUND(COALESCE(pp.completed, 0)::numeric / pp.total * 100)
    ELSE 0
  END AS project_progress,
  COALESCE(mp.total, 0) AS marketing_total,
  COALESCE(mp.completed, 0) AS marketing_completed,
  CASE WHEN COALESCE(mp.total, 0) > 0
    THEN ROUND(COALESCE(mp.completed, 0)::numeric / mp.total * 100)
    ELSE 0
  END AS marketing_progress
FROM stores s
LEFT JOIN (
  SELECT store_code, COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'Hoan thanh') AS completed
  FROM project_data GROUP BY store_code
) pp ON pp.store_code = s.store_code
LEFT JOIN (
  SELECT store_code, COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'Hoan thanh') AS completed
  FROM marketing_data GROUP BY store_code
) mp ON mp.store_code = s.store_code;

-- Indexes
CREATE INDEX IF NOT EXISTS idx_project_data_store ON project_data(store_code);
CREATE INDEX IF NOT EXISTS idx_marketing_data_store ON marketing_data(store_code);
CREATE INDEX IF NOT EXISTS idx_quiz_bank_chapter ON quiz_bank(chapter_id);
CREATE INDEX IF NOT EXISTS idx_quiz_results_user ON quiz_results(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles(username);
