-- 1. PROFILES
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  email text,
  avatar_url text,
  is_pro boolean default false,
  credits integer default 1,
  updated_at timestamptz default now()
);

-- 2. RESUMES
create table public.resumes (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  title text default 'My Master Resume',
  content jsonb,
  file_url text,
  created_at timestamptz default now()
);

-- 3. APPLICATIONS
create table public.applications (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  resume_id uuid references public.resumes(id),
  job_title text,
  company_name text,
  job_description text,
  ats_score integer,
  tailored_resume_url text,
  created_at timestamptz default now()
);
