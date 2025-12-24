-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Practice Areas
CREATE TABLE practice_areas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text UNIQUE NOT NULL,
  excerpt text,
  content text NOT NULL,
  icon text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 2. Lawyers
CREATE TABLE lawyers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  title text NOT NULL,
  slug text UNIQUE NOT NULL,
  bio text NOT NULL,
  languages text[] DEFAULT '{}',
  photo_url text,
  is_active boolean DEFAULT true,
  sort_order int DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 3. Testimonials
CREATE TABLE testimonials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  text text NOT NULL,
  rating int DEFAULT 5,
  country text,
  is_published boolean DEFAULT true,
  sort_order int DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- 4. Blog Posts
CREATE TABLE blog_posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text UNIQUE NOT NULL,
  excerpt text,
  content text NOT NULL,
  cover_image_url text,
  tags text[] DEFAULT '{}',
  status text NOT NULL DEFAULT 'draft', -- 'draft' or 'published'
  published_at timestamptz,
  author text, -- Storing name for simplicity in this phase
  reading_time text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 5. Site Settings
CREATE TABLE site_settings (
  id int PRIMARY KEY DEFAULT 1,
  firm_name text,
  phone text,
  email text,
  whatsapp text,
  address text,
  city text,
  country text DEFAULT 'Lithuania',
  languages text[] DEFAULT '{English,Lithuanian}',
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT single_row CHECK (id = 1)
);

-- Indexes
CREATE INDEX blog_posts_status_published_at_idx ON blog_posts (status, published_at DESC);

-- RLS Policies
ALTER TABLE practice_areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE lawyers ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Public Read Policies
CREATE POLICY "Public practice_areas are viewable by everyone." ON practice_areas FOR SELECT USING (true);
CREATE POLICY "Active lawyers are viewable by everyone." ON lawyers FOR SELECT USING (is_active = true);
CREATE POLICY "Published testimonials are viewable by everyone." ON testimonials FOR SELECT USING (is_published = true);
CREATE POLICY "Published blog posts are viewable by everyone." ON blog_posts FOR SELECT USING (status = 'published');
CREATE POLICY "Site settings are viewable by everyone." ON site_settings FOR SELECT USING (true);

-- Admin Policies (Placeholder)
-- CREATE POLICY "Admins can insert practice_areas" ON practice_areas FOR INSERT WITH CHECK (auth.role() = 'authenticated');
-- ... and so on for full CRUD later.
