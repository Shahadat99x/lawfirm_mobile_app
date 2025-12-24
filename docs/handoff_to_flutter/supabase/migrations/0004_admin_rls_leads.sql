-- FIX: Re-apply RLS for Leads to ensure Admin Access

ALTER TABLE public.leads ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts/stale states
DROP POLICY IF EXISTS "Admins can view all leads" ON public.leads;
DROP POLICY IF EXISTS "Admins can update leads" ON public.leads;
DROP POLICY IF EXISTS "Public cannot access leads" ON public.leads;
DROP POLICY IF EXISTS "auth can read leads" ON public.leads;
DROP POLICY IF EXISTS "auth can update leads" ON public.leads;

-- Policy 1: Authenticated users (Admins) can SELECT
CREATE POLICY "auth can read leads"
ON public.leads
FOR SELECT
TO authenticated
USING (true);

-- Policy 2: Authenticated users (Admins) can UPDATE
CREATE POLICY "auth can update leads"
ON public.leads
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Policy 3: Explicitly deny public access (Default is deny, but this is for clarity/backup)
-- Actually, we don't need an explicit deny policy if we don't grant public access.
-- The default allow-list behavior of RLS handles this.

-- Note: INSERT is still restricted to Service Role (API Route) only.
