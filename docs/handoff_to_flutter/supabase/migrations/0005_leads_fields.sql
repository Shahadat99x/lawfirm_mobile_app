-- FIX: Ensure Leads schema has all required fields

-- Status column (ensure it exists and defaults to 'new')
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'status') THEN
        ALTER TABLE leads ADD COLUMN status text NOT NULL DEFAULT 'new';
    ELSE
        ALTER TABLE leads ALTER COLUMN status SET DEFAULT 'new';
    END IF;
END $$;

-- Notes column
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'notes') THEN
        ALTER TABLE leads ADD COLUMN notes text;
    END IF;
END $$;

-- Tags column
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'leads' AND column_name = 'tags') THEN
        ALTER TABLE leads ADD COLUMN tags text[] DEFAULT '{}';
    END IF;
END $$;
