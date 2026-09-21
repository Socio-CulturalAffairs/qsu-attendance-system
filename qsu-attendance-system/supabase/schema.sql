-- QSU Practice Attendance System
create extension if not exists pgcrypto;

do $$ begin
  create type public.user_role as enum ('admin','user');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.attendance_status as enum ('present','late','absent');
exception when duplicate_object then null; end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  role public.user_role not null default 'user',
  organization text,
  created_at timestamptz not null default now()
);

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
  insert into public.profiles(id,full_name,email,role,organization)
  values(new.id,coalesce(new.raw_user_meta_data->>'full_name','New User'),new.email,'user',new.raw_user_meta_data->>'organization')
  on conflict(id) do nothing;
  return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create table if not exists public.practice_sessions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  practice_date date not null,
  start_time time not null,
  end_time time not null,
  venue text,
  qr_token uuid not null unique default gen_random_uuid(),
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);
create table if not exists public.attendance (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.practice_sessions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  check_in_at timestamptz not null default now(),
  status public.attendance_status not null default 'present',
  unique(session_id,user_id)
);

create or replace function public.is_admin(uid uuid) returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from public.profiles where id=uid and role='admin'); $$;

alter table public.profiles enable row level security;
alter table public.practice_sessions enable row level security;
alter table public.attendance enable row level security;

drop policy if exists "profiles own or admin read" on public.profiles;
create policy "profiles own or admin read" on public.profiles for select using (id=auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "admin manage profiles" on public.profiles;
create policy "admin manage profiles" on public.profiles for all using (public.is_admin(auth.uid())) with check (public.is_admin(auth.uid()));

drop policy if exists "authenticated read sessions" on public.practice_sessions;
create policy "authenticated read sessions" on public.practice_sessions for select using (auth.uid() is not null);
drop policy if exists "admin insert sessions" on public.practice_sessions;
create policy "admin insert sessions" on public.practice_sessions for insert with check (public.is_admin(auth.uid()));
drop policy if exists "admin update sessions" on public.practice_sessions;
create policy "admin update sessions" on public.practice_sessions for update using (public.is_admin(auth.uid())) with check (public.is_admin(auth.uid()));
drop policy if exists "admin delete sessions" on public.practice_sessions;
create policy "admin delete sessions" on public.practice_sessions for delete using (public.is_admin(auth.uid()));

drop policy if exists "users read own attendance or admin" on public.attendance;
create policy "users read own attendance or admin" on public.attendance for select using (user_id=auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "users insert own attendance" on public.attendance;
create policy "users insert own attendance" on public.attendance for insert with check (user_id=auth.uid());
drop policy if exists "users update own attendance" on public.attendance;
create policy "users update own attendance" on public.attendance for update using (user_id=auth.uid() or public.is_admin(auth.uid())) with check (user_id=auth.uid() or public.is_admin(auth.uid()));

-- Run after creating your first auth user to make them admin:
-- insert into public.profiles(id,full_name,email,role) select id,coalesce(raw_user_meta_data->>'full_name',email),email,'admin' from auth.users where email='YOUR_ADMIN_EMAIL' on conflict(id) do update set role='admin';
