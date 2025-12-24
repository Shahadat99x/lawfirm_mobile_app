-- Seed Practice Areas
INSERT INTO practice_areas (title, slug, excerpt, content, icon) VALUES
('Immigration Law', 'immigration', 'Expert assistance with TRP, Blue Cards, and family reunification in Lithuania.', '<h2>Lithuanian Immigration Services</h2><p>We provide comprehensive support for individuals and families looking to relocate to Lithuania...</p>', 'Globe'),
('Business Setup', 'business-setup', 'Company formation (MB, UAB), compliance, and banking solutions for foreign investors.', '<h2>Start Your Business in Lithuania</h2><p>Lithuania offers a favorable environment for startups and established businesses...</p>', 'Briefcase'),
('Employment Law', 'employment', 'Drafting contracts and resolving disputes for employers and employees.', '<h2>Employment Law Solutions</h2><p>Navigate the Lithuanian Labor Code with confidence...</p>', 'Users');

-- Seed Lawyers
INSERT INTO lawyers (name, title, slug, bio, languages, photo_url) VALUES
('Elena Petrauskienė', 'Managing Partner', 'elena-petrauskiene', 'With over 15 years of experience in corporate law and business immigration, Elena helps international clients navigate the Lithuanian legal landscape.', '{English,Lithuanian,Russian}', '/images/lawyer1.jpg'),
('Tomas Vaitkus', 'Senior Associate', 'tomas-vaitkus', 'Specializing in employment law and dispute resolution, Tomas ensures your rights are protected in the workplace.', '{English,Lithuanian}', '/images/lawyer2.jpg');

-- Seed Testimonials
INSERT INTO testimonials (name, text, rating, country) VALUES
('Sarah J.', 'LexNova made my relocation process seamless. They handled all the paperwork for my Blue Card efficiently.', 5, 'USA'),
('Michael Chen', 'Excellent service for setting up my company in Vilnius. Highly recommended for foreign investors.', 5, 'Canada'),
('Olga K.', 'Professional and responsive team. They helped me with a complex employment contract issue.', 5, 'Ukraine');

-- Seed Blog Posts
INSERT INTO blog_posts (title, slug, excerpt, content, status, published_at, author, reading_time, tags) VALUES
('Guide to the EU Blue Card in Lithuania (2025)', 'eu-blue-card-guide-lithuania', 'Everything you need to know about the requirements, salary thresholds, and application process for the EU Blue Card.', '<p>The EU Blue Card is a residence permit for highly skilled non-EU citizens...</p>', 'published', NOW() - INTERVAL '2 days', 'Elena Petrauskienė', '5 min read', '{Immigration,Relocation}'),
('Setting up an MB vs UAB: Which is right for you?', 'mb-vs-uab-business-setup', 'Comparing the Small Partnership (MB) and Private Limited Liability Company (UAB) structures for foreign entrepreneurs.', '<p>Choosing the right legal entity is crucial for your business success...</p>', 'published', NOW() - INTERVAL '5 days', 'Elena Petrauskienė', '7 min read', '{Business,Startups}'),
('Changes to Lithuanian Labor Law in 2025', 'lithuania-labor-law-changes-2025', 'New regulations affecting overtime pay, remote work, and termination notices.', '<p>The new year brings important updates to the Labor Code...</p>', 'published', NOW() - INTERVAL '10 days', 'Tomas Vaitkus', '4 min read', '{Employment Law,Compliance}');

-- Seed Site Settings
INSERT INTO site_settings (id, firm_name, phone, email, whatsapp, address, city) VALUES
(1, 'LexNova Legal', '+370 600 00000', 'info@lexnova.lt', '+370 600 00000', 'Gedimino pr. 1', 'Vilnius')
ON CONFLICT (id) DO UPDATE 
SET firm_name = EXCLUDED.firm_name;
