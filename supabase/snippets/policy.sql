-- Enable RLS on all tables
alter table public.profiles enable row level security;
alter table public.resumes enable row level security;
alter table public.applications enable row level security;

-- Example Policy for Resumes
create policy "Users can only see their own resumes"
on public.resumes for select
using ( auth.uid() = user_id );

create policy "Users can only insert their own resumes"
on public.resumes for insert
with check ( auth.uid() = user_id );