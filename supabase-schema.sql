-- ═══════════════════════════════════════
-- SW NOTES — Supabase Database Schema
-- Run this in your Supabase SQL Editor
-- ═══════════════════════════════════════

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── NOTEBOOKS ──────────────────────────
create table if not exists notebooks (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  color       text not null default 'sage',
  position    integer default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── NOTES ──────────────────────────────
create table if not exists notes (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid references auth.users(id) on delete cascade not null,
  notebook_id uuid references notebooks(id) on delete set null,
  title       text default '',
  content     text default '',
  tags        jsonb default '[]',
  stickies    jsonb default '[]',
  starred     boolean default false,
  word_count  integer default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- ── USER SETTINGS ──────────────────────
create table if not exists user_settings (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  night_mode  boolean default false,
  sepia_mode  boolean default false,
  font_choice text default '',
  sidebar_collapsed boolean default false,
  updated_at  timestamptz default now()
);

-- ── ROW LEVEL SECURITY ─────────────────
alter table notebooks enable row level security;
alter table notes enable row level security;
alter table user_settings enable row level security;

-- Notebooks policies
create policy "Users see own notebooks" on notebooks
  for select using (auth.uid() = user_id);
create policy "Users insert own notebooks" on notebooks
  for insert with check (auth.uid() = user_id);
create policy "Users update own notebooks" on notebooks
  for update using (auth.uid() = user_id);
create policy "Users delete own notebooks" on notebooks
  for delete using (auth.uid() = user_id);

-- Notes policies
create policy "Users see own notes" on notes
  for select using (auth.uid() = user_id);
create policy "Users insert own notes" on notes
  for insert with check (auth.uid() = user_id);
create policy "Users update own notes" on notes
  for update using (auth.uid() = user_id);
create policy "Users delete own notes" on notes
  for delete using (auth.uid() = user_id);

-- Settings policies
create policy "Users see own settings" on user_settings
  for select using (auth.uid() = user_id);
create policy "Users upsert own settings" on user_settings
  for all using (auth.uid() = user_id);

-- ── INDEXES ────────────────────────────
create index if not exists notes_user_id_idx on notes(user_id);
create index if not exists notes_notebook_id_idx on notes(notebook_id);
create index if not exists notes_updated_at_idx on notes(updated_at desc);
create index if not exists notebooks_user_id_idx on notebooks(user_id);

-- ── AUTO-UPDATE updated_at ─────────────
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger notes_updated_at before update on notes
  for each row execute function update_updated_at();
create trigger notebooks_updated_at before update on notebooks
  for each row execute function update_updated_at();
