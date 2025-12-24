-- Ensure site_settings singleton row exists
INSERT INTO site_settings (id, firm_name, email)
VALUES (1, 'LexNova', 'info@lexnova.lt')
ON CONFLICT (id) DO NOTHING;
