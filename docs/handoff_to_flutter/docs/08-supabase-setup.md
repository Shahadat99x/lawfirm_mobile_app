# Supabase Setup Guide

This project uses Supabase for the database layer. Follow these steps to set up your local environment.

## 1. Create a Supabase Project
1. Go to [database.new](https://database.new) and create a new project.
2. Note your database password (you won't need it for this setup, but good to have).

## 2. Apply Migrations (SQL Editor)
You need to create the database schema and insert seed data.

1. In your Supabase Dashboard, go to the **SQL Editor** (icon on the left sidebar).
2. Create a new query.
3. Open `supabase/migrations/0001_init.sql` from this repository.
4. Copy the entire content and paste it into the SQL Editor.
5. Click **Run**.
   - *Success check*: You should see "Success. No rows returned."
6. Clear the editor or create a new query.
7. Open `supabase/migrations/0002_seed.sql`.
8. Copy and paste it.
9. Click **Run**.
   - *Success check*: You should see "Success. No rows returned."
10. Clear the editor or create a new query.
11. Open `supabase/migrations/0003_leads_intake.sql`.
12. Copy and paste it.
13. Click **Run**.
   - *Success check*: You should see "Success. No rows returned."
14. Clear the editor.
15. Open `supabase/migrations/0004_admin_rls_leads.sql`, copy, paste, and **Run**.
16. Clear the editor.
17. Open `supabase/migrations/0005_leads_fields.sql`, copy, paste, and **Run**.
18. If you see errors like "Could not find the table 'public.leads' in the schema cache", open `docs/SUPABASE_SQL_APPLY_NOW.sql`, copy all contents, and run it once in the SQL Editor.

## 3. Get API Keys
1. Go to **Project Settings** (gear icon) -> **API**.
2. Copy the **Project URL**.
3. Copy the **anon** (public) key.
4. Copy the **service_role** (secret) key.

## 4. Configure Local Environment
1. Open or create `.env.local` in the root of the project.
2. Add your keys:

```bash
NEXT_PUBLIC_SUPABASE_URL=your_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

## 5. Restart Development Server
1. Stop the running server (Ctrl+C).
2. Run `npm run dev`.
3. The app should now fetch data from your Supabase database instead of local mock files.
