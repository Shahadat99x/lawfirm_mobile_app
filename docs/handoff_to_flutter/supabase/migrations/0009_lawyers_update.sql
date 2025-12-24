-- Add sort_order to lawyers if missing (is_active exists, serves as is_published)
ALTER TABLE lawyers 
ADD COLUMN IF NOT EXISTS sort_order int DEFAULT 0;

-- Update RLS for lawyers (public view only active) - already done in 0001_init.sql policy "Active lawyers are viewable by everyone."
