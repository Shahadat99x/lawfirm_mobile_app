# Supabase Handoff Pack (Source of Truth)

This folder contains the database contract for the LexNova mobile app.

## Contents
- `supabase/migrations/` - SQL migrations (tables, policies, RLS)
- `supabase/config.toml` - Supabase local config (reference)
- `docs/` - setup notes and one-time SQL scripts
- `env.example.mobile.txt` - required Flutter env keys (NO secrets)

## Mobile App Rules
- Flutter uses Supabase ANON key + RLS
- Never ship service role keys in the mobile app
- Public read: practice_areas, lawyers(active), testimonials(published), blog_posts(published), site_settings
- Public write: appointment/lead intake only (no public reads)
