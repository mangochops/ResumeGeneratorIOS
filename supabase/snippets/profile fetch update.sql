-- This function inserts a row into your profiles table automatically
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, credits)
  values (new.id, new.raw_user_meta_data->>'full_name', 5);
  return new;
end;
$$ language plpgsql security definer;

-- This trigger fires the function above after a signup
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();