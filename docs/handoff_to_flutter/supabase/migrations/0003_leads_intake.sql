-- Create Leads Table
CREATE TABLE IF NOT EXISTS leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  email text NOT NULL,
  phone text,
  city text,
  practice_area_slug text,
  message text NOT NULL,
  gdpr_consent boolean NOT NULL DEFAULT false,
  source text DEFAULT 'contact_page',
  status text NOT NULL DEFAULT 'new',
  created_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS leads_status_idx ON leads (status);
CREATE INDEX IF NOT EXISTS leads_created_at_idx ON leads (created_at DESC);

-- Enable RLS
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- Policies
-- 1. Admins should be able to do everything (placeholder for now/manual queries)
--    In this phase, we access leads solely via service_role key, bypassing RLS.
--    But for robustness, we can explicitly deny public access.

-- Deny public all
CREATE POLICY "Public cannot access leads" ON leads
  FOR ALL
  USING (false);

-- Note: We do NOT create a public INSERT policy because we want strict validation
-- via our API route using the service_role key.
