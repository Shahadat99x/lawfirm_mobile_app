-- Add is_published and sort_order to practice_areas
ALTER TABLE practice_areas 
ADD COLUMN IF NOT EXISTS is_published boolean DEFAULT true,
ADD COLUMN IF NOT EXISTS sort_order int DEFAULT 0;

-- Update RLS for practice_areas to only show published for public
DROP POLICY IF EXISTS "Public practice_areas are viewable by everyone." ON practice_areas;
CREATE POLICY "Public practice_areas are viewable by everyone." ON practice_areas FOR SELECT USING (is_published = true);

-- Ensure Admin RLS (already in 0006 but assumes auth)
-- But we'll rely on our Admin Client actions mostly for writes, RLS for Reads.
