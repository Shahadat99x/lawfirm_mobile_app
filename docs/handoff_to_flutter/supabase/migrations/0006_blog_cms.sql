-- RLS Policies for Admin Access
-- Assumes authenticated users are admins (simple admin model)

-- Blog Posts
CREATE POLICY "Admins can insert blog_posts" ON blog_posts FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Admins can update blog_posts" ON blog_posts FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can delete blog_posts" ON blog_posts FOR DELETE USING (auth.role() = 'authenticated');
-- Read is already covered by public policy for published, but admins need to see drafts
CREATE POLICY "Admins can view all blog_posts" ON blog_posts FOR SELECT USING (auth.role() = 'authenticated');


-- Practice Areas
CREATE POLICY "Admins can insert practice_areas" ON practice_areas FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Admins can update practice_areas" ON practice_areas FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can delete practice_areas" ON practice_areas FOR DELETE USING (auth.role() = 'authenticated');
-- Read is public, but explicit admin read is good
CREATE POLICY "Admins can view all practice_areas" ON practice_areas FOR SELECT USING (auth.role() = 'authenticated');

-- Lawyers
CREATE POLICY "Admins can insert lawyers" ON lawyers FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Admins can update lawyers" ON lawyers FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can delete lawyers" ON lawyers FOR DELETE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can view all lawyers" ON lawyers FOR SELECT USING (auth.role() = 'authenticated');

-- Testimonials
CREATE POLICY "Admins can insert testimonials" ON testimonials FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Admins can update testimonials" ON testimonials FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can delete testimonials" ON testimonials FOR DELETE USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can view all testimonials" ON testimonials FOR SELECT USING (auth.role() = 'authenticated');

-- Site Settings
CREATE POLICY "Admins can update site_settings" ON site_settings FOR UPDATE USING (auth.role() = 'authenticated');
-- Insert might be needed if row 1 doesn't exist, but usually seeded.
CREATE POLICY "Admins can insert site_settings" ON site_settings FOR INSERT WITH CHECK (auth.role() = 'authenticated');
-- Delete usually not needed for singleton
