-- 1. Update the 'resumes' table for template support
-- This adds the template_id column if it's missing and ensures 'content' is jsonb
ALTER TABLE public.resumes 
ADD COLUMN IF NOT EXISTS template_id text DEFAULT '1',
ALTER COLUMN content TYPE jsonb USING content::jsonb;

-- 2. Update the 'profiles' table for model consistency 
-- This ensures 'credits' is an integer as defined in your Profile struct
ALTER TABLE public.profiles 
ALTER COLUMN credits SET DATA TYPE integer,
ALTER COLUMN credits SET DEFAULT 1;

-- 3. Update the 'applications' table
-- Ensuring ats_score is an integer to match your Application struct
ALTER TABLE public.applications
ALTER COLUMN ats_score TYPE integer;