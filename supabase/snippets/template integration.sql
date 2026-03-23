-- 1. Update the 'resumes' table
-- Adds template_id and ensures 'content' can store AI-generated JSON Data
ALTER TABLE public.resumes 
ADD COLUMN IF NOT EXISTS template_id text DEFAULT '1',
ALTER COLUMN content TYPE jsonb USING content::jsonb;

-- 2. Update the 'profiles' table
-- Ensures 'credits' matches your Swift Int and default value
ALTER TABLE public.profiles 
ALTER COLUMN credits SET DATA TYPE integer,
ALTER COLUMN credits SET DEFAULT 1;

-- 3. Update the 'applications' table
-- Matches the ats_score to an integer for your Application struct
ALTER TABLE public.applications
ALTER COLUMN ats_score TYPE integer;

-- 4. Enable RLS (Security)
-- This prevents users from seeing each other's resumes
ALTER TABLE public.resumes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own resumes" ON public.resumes 
    FOR ALL USING (auth.uid() = user_id);