-- 1. Create a function that inserts a row into public.profiles
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, credits)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', -- Extracts name from Auth metadata
    new.email,
    10 -- Default starting credits
  );
  return new;
end;
$$;

-- 2. Create a trigger that runs the function every time a user is created in auth.users
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();