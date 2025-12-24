-- ==========================================
-- EMERGENCY FIX: LEADS TABLE & SCHEMA RELOAD
-- ==========================================
-- Copy and paste this ENTIRE file into your Supabase SQL Editor and run it.

-- 1. Ensure Table Exists
CREATE TABLE IF NOT EXISTS public.leads (
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
    notes text,
    tags text[] DEFAULT '{}',
    created_at timestamptz DEFAULT now()
);

-- 2. Ensure Columns Exist (Safe Alterations)
DO $$
BEGIN
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS full_name text NOT NULL DEFAULT '';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS email text NOT NULL DEFAULT '';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS phone text;
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS city text;
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS practice_area_slug text;
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS message text NOT NULL DEFAULT '';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS gdpr_consent boolean NOT NULL DEFAULT false;
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS source text DEFAULT 'contact_page';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS status text NOT NULL DEFAULT 'new';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS notes text;
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS tags text[] DEFAULT '{}';
    ALTER TABLE public.leads ADD COLUMN IF NOT EXISTS created_at timestamptz DEFAULT now();
EXCEPTION
    WHEN duplicate_column THEN RAISE NOTICE 'Column already exists, skipping.';
END $$;

-- 3. Reset RLS Policies (Strict Admin Access)
ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- Drop all existing know policies to start fresh
DROP POLICY IF EXISTS "Admins can view all leads" ON public.leads;
DROP POLICY IF EXISTS "Admins can update leads" ON public.leads;
DROP POLICY IF EXISTS "Public cannot access leads" ON public.leads;
DROP POLICY IF EXISTS "auth can read leads" ON public.leads;
DROP POLICY IF EXISTS "auth can update leads" ON public.leads;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.leads;

-- Allow Authenticated Users (Admins) to SELECT
CREATE POLICY "auth can read leads"
ON public.leads
FOR SELECT
TO authenticated
USING (true);

-- Allow Authenticated Users (Admins) to UPDATE
CREATE POLICY "auth can update leads"
ON public.leads
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- 4. Verify Indexes
CREATE INDEX IF NOT EXISTS leads_status_idx ON public.leads (status);
CREATE INDEX IF NOT EXISTS leads_created_at_idx ON public.leads (created_at DESC);

-- 5. FORCE SCHEMA CACHE RELOAD
-- This tells PostgREST to refresh its knowledge of the database structure immediately.
NOTIFY pgrst, 'reload schema';
