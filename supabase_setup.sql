-- Run this once in Supabase → SQL Editor → New query → Run.
-- Creates the two tables the app needs and locks them down so only
-- signed-in users (you and your wife) can read or write anything.

create extension if not exists pgcrypto;

create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  monthly_budget numeric not null default 0,
  sort_order int not null default 0
);

create table if not exists expenses (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  date date not null,
  amount numeric not null,
  category text not null,
  note text,
  paid_by text
);

alter table categories enable row level security;
alter table expenses enable row level security;

-- Any logged-in user (only the 2 accounts you create) can read/write.
create policy "authenticated read categories" on categories for select using (auth.role() = 'authenticated');
create policy "authenticated write categories" on categories for insert with check (auth.role() = 'authenticated');
create policy "authenticated update categories" on categories for update using (auth.role() = 'authenticated');
create policy "authenticated delete categories" on categories for delete using (auth.role() = 'authenticated');

create policy "authenticated read expenses" on expenses for select using (auth.role() = 'authenticated');
create policy "authenticated write expenses" on expenses for insert with check (auth.role() = 'authenticated');
create policy "authenticated update expenses" on expenses for update using (auth.role() = 'authenticated');
create policy "authenticated delete expenses" on expenses for delete using (auth.role() = 'authenticated');

-- Starter categories based on your spreadsheet — edit amounts anytime in the app's Settings screen.
insert into categories (name, monthly_budget, sort_order) values
  ('Groceries', 600, 1),
  ('Dining & Entertainment', 200, 2),
  ('Utilities', 130, 3),
  ('Subscriptions', 30, 4),
  ('Transportation', 180, 5),
  ('Other / Misc.', 500, 6)
on conflict do nothing;

-- Enable realtime updates for both tables so changes show up instantly on both phones.
alter publication supabase_realtime add table expenses;
alter publication supabase_realtime add table categories;
