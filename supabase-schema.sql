-- ============================================================
--  PHUC TEA - STORE OPENING MANAGER
--  Supabase PostgreSQL Schema
-- ============================================================
--  Chay file nay trong Supabase SQL Editor
--  Project > SQL Editor > New Query > Paste & Run
-- ============================================================

-- 1. BANG PROFILES (lien ket voi Supabase Auth)
-- ============================================================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL DEFAULT '',
  role TEXT NOT NULL DEFAULT 'viewer' CHECK (role IN ('admin', 'partner', 'viewer')),
  store_code TEXT DEFAULT 'ALL',
  phone TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile when new user signs up
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

-- Trigger to auto-create profile
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();


-- 2. BANG STORES (cua hang)
-- ============================================================
CREATE TABLE IF NOT EXISTS stores (
  id SERIAL PRIMARY KEY,
  store_code TEXT UNIQUE NOT NULL,
  store_name TEXT NOT NULL,
  address TEXT DEFAULT '',
  city TEXT DEFAULT '',
  partner_name TEXT DEFAULT '',
  partner_phone TEXT DEFAULT '',
  status TEXT DEFAULT 'Chuan bi' CHECK (status IN ('Chuan bi', 'Dang khai truong', 'Hoat dong')),
  soft_opening_date DATE,
  grand_opening_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  notes TEXT DEFAULT ''
);


-- 3. BANG PROJECT_TEMPLATE (mau 57 tasks du an)
-- ============================================================
CREATE TABLE IF NOT EXISTS project_template (
  id SERIAL PRIMARY KEY,
  task_no INTEGER NOT NULL,
  phase TEXT NOT NULL,
  category TEXT NOT NULL,
  task_name TEXT NOT NULL,
  description TEXT DEFAULT '',
  owner TEXT DEFAULT '',
  duration_days INTEGER DEFAULT 0,
  sort_order INTEGER DEFAULT 0
);


-- 4. BANG MARKETING_TEMPLATE (mau 40 tasks marketing)
-- ============================================================
CREATE TABLE IF NOT EXISTS marketing_template (
  id SERIAL PRIMARY KEY,
  task_no INTEGER NOT NULL,
  phase TEXT NOT NULL,
  task_name TEXT NOT NULL,
  ctkm_related TEXT DEFAULT '',
  owner TEXT DEFAULT '',
  channel TEXT DEFAULT '',
  guideline TEXT DEFAULT '',
  deadline_relative TEXT DEFAULT '',
  kpi TEXT DEFAULT '',
  cost_bearer TEXT DEFAULT '',
  sort_order INTEGER DEFAULT 0
);


-- 5. BANG PROJECT_DATA (du lieu thuc te du an theo tung store)
-- ============================================================
CREATE TABLE IF NOT EXISTS project_data (
  id SERIAL PRIMARY KEY,
  store_code TEXT NOT NULL REFERENCES stores(store_code) ON DELETE CASCADE,
  task_no INTEGER NOT NULL,
  assignee TEXT DEFAULT '',
  status TEXT DEFAULT 'Chua bat dau' CHECK (status IN ('Chua bat dau', 'Dang thuc hien', 'Hoan thanh', 'Bi chan')),
  start_date DATE,
  due_date DATE,
  completed_date DATE,
  notes TEXT DEFAULT '',
  updated_by TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(store_code, task_no)
);


-- 6. BANG MARKETING_DATA (du lieu thuc te MKT theo tung store)
-- ============================================================
CREATE TABLE IF NOT EXISTS marketing_data (
  id SERIAL PRIMARY KEY,
  store_code TEXT NOT NULL REFERENCES stores(store_code) ON DELETE CASCADE,
  task_no INTEGER NOT NULL,
  assignee TEXT DEFAULT '',
  status TEXT DEFAULT 'Chua bat dau' CHECK (status IN ('Chua bat dau', 'Dang thuc hien', 'Hoan thanh', 'Bi chan')),
  due_date DATE,
  completed_date DATE,
  kpi_target TEXT DEFAULT '',
  kpi_actual TEXT DEFAULT '',
  budget NUMERIC(12,0) DEFAULT 0,
  actual_cost NUMERIC(12,0) DEFAULT 0,
  notes TEXT DEFAULT '',
  updated_by TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(store_code, task_no)
);


-- 7. BANG HANDBOOK (cam nang 90 ngay)
-- ============================================================
CREATE TABLE IF NOT EXISTS handbook (
  id SERIAL PRIMARY KEY,
  stage TEXT NOT NULL,
  chapter_no INTEGER NOT NULL,
  title TEXT NOT NULL,
  content TEXT DEFAULT 'Noi dung se duoc cap nhat sau.',
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 8. BANG QUIZ_BANK (ngan hang cau hoi)
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_bank (
  id SERIAL PRIMARY KEY,
  chapter_id INTEGER NOT NULL REFERENCES handbook(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_answer TEXT NOT NULL CHECK (correct_answer IN ('A', 'B', 'C', 'D')),
  explanation TEXT DEFAULT ''
);


-- 9. BANG QUIZ_RESULTS (ket qua quiz)
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_results (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  chapter_id INTEGER NOT NULL REFERENCES handbook(id) ON DELETE CASCADE,
  score INTEGER NOT NULL DEFAULT 0,
  total_questions INTEGER NOT NULL DEFAULT 0,
  passed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);


-- ============================================================
--  VIEW: Store Progress (tinh tien do tu dong)
-- ============================================================
CREATE OR REPLACE VIEW store_progress AS
SELECT
  s.store_code,
  s.store_name,
  s.status,
  s.address,
  s.city,
  s.partner_name,
  s.partner_phone,
  s.soft_opening_date,
  s.grand_opening_date,
  s.created_at,
  s.notes,
  -- Project progress
  COALESCE(pp.total, 0) AS project_total,
  COALESCE(pp.completed, 0) AS project_completed,
  CASE WHEN COALESCE(pp.total, 0) > 0
    THEN ROUND(COALESCE(pp.completed, 0)::numeric / pp.total * 100)
    ELSE 0
  END AS project_progress,
  -- Marketing progress
  COALESCE(mp.total, 0) AS marketing_total,
  COALESCE(mp.completed, 0) AS marketing_completed,
  CASE WHEN COALESCE(mp.total, 0) > 0
    THEN ROUND(COALESCE(mp.completed, 0)::numeric / mp.total * 100)
    ELSE 0
  END AS marketing_progress
FROM stores s
LEFT JOIN (
  SELECT store_code,
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'Hoan thanh') AS completed
  FROM project_data
  GROUP BY store_code
) pp ON pp.store_code = s.store_code
LEFT JOIN (
  SELECT store_code,
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'Hoan thanh') AS completed
  FROM marketing_data
  GROUP BY store_code
) mp ON mp.store_code = s.store_code;


-- ============================================================
--  FUNCTION: Clone templates khi tao store moi
-- ============================================================
CREATE OR REPLACE FUNCTION clone_templates_for_store(p_store_code TEXT)
RETURNS VOID AS $$
BEGIN
  -- Clone project template
  INSERT INTO project_data (store_code, task_no, status)
  SELECT p_store_code, task_no, 'Chua bat dau'
  FROM project_template
  ORDER BY sort_order;

  -- Clone marketing template
  INSERT INTO marketing_data (store_code, task_no, status)
  SELECT p_store_code, task_no, 'Chua bat dau'
  FROM marketing_template
  ORDER BY sort_order;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
--  ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_template ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_template ENABLE ROW LEVEL SECURITY;
ALTER TABLE handbook ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_bank ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;

-- Helper function: get user role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Helper function: get user store_code
CREATE OR REPLACE FUNCTION get_user_store_code()
RETURNS TEXT AS $$
  SELECT store_code FROM profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- PROFILES: Users can read all profiles, update own
CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE USING (id = auth.uid());
CREATE POLICY "profiles_admin_all" ON profiles FOR ALL USING (get_user_role() = 'admin');

-- STORES: Everyone can read, admin can write
CREATE POLICY "stores_select" ON stores FOR SELECT USING (true);
CREATE POLICY "stores_admin_insert" ON stores FOR INSERT WITH CHECK (get_user_role() = 'admin');
CREATE POLICY "stores_admin_update" ON stores FOR UPDATE USING (get_user_role() = 'admin');
CREATE POLICY "stores_admin_delete" ON stores FOR DELETE USING (get_user_role() = 'admin');

-- PROJECT_DATA: Everyone reads, admin edits all, partner edits own store
CREATE POLICY "project_data_select" ON project_data FOR SELECT USING (true);
CREATE POLICY "project_data_admin" ON project_data FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "project_data_partner" ON project_data FOR UPDATE
  USING (get_user_role() = 'partner' AND store_code = get_user_store_code());
CREATE POLICY "project_data_insert" ON project_data FOR INSERT WITH CHECK (get_user_role() = 'admin');

-- MARKETING_DATA: Same as project_data
CREATE POLICY "marketing_data_select" ON marketing_data FOR SELECT USING (true);
CREATE POLICY "marketing_data_admin" ON marketing_data FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "marketing_data_partner" ON marketing_data FOR UPDATE
  USING (get_user_role() = 'partner' AND store_code = get_user_store_code());
CREATE POLICY "marketing_data_insert" ON marketing_data FOR INSERT WITH CHECK (get_user_role() = 'admin');

-- TEMPLATES: Everyone reads, admin writes
CREATE POLICY "project_template_select" ON project_template FOR SELECT USING (true);
CREATE POLICY "project_template_admin" ON project_template FOR ALL USING (get_user_role() = 'admin');
CREATE POLICY "marketing_template_select" ON marketing_template FOR SELECT USING (true);
CREATE POLICY "marketing_template_admin" ON marketing_template FOR ALL USING (get_user_role() = 'admin');

-- HANDBOOK: Everyone reads, admin writes
CREATE POLICY "handbook_select" ON handbook FOR SELECT USING (true);
CREATE POLICY "handbook_admin" ON handbook FOR ALL USING (get_user_role() = 'admin');

-- QUIZ_BANK: Everyone reads, admin writes
CREATE POLICY "quiz_bank_select" ON quiz_bank FOR SELECT USING (true);
CREATE POLICY "quiz_bank_admin" ON quiz_bank FOR ALL USING (get_user_role() = 'admin');

-- QUIZ_RESULTS: Users see own, admin sees all
CREATE POLICY "quiz_results_own" ON quiz_results FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "quiz_results_admin_select" ON quiz_results FOR SELECT USING (get_user_role() = 'admin');
CREATE POLICY "quiz_results_insert" ON quiz_results FOR INSERT WITH CHECK (user_id = auth.uid());


-- ============================================================
--  INDEXES (toi uu truy van)
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_project_data_store ON project_data(store_code);
CREATE INDEX IF NOT EXISTS idx_marketing_data_store ON marketing_data(store_code);
CREATE INDEX IF NOT EXISTS idx_quiz_bank_chapter ON quiz_bank(chapter_id);
CREATE INDEX IF NOT EXISTS idx_quiz_results_user ON quiz_results(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles(username);
