-- À exécuter une seule fois dans Supabase : SQL Editor > New query > Run
-- Stocke toute la base de l'application (agents, modèles, historique, rôles) dans une ligne "main".

create table if not exists public.rh_store (
  id         text primary key,
  data       jsonb       not null,
  rev        integer     not null default 1,
  updated_at timestamptz not null default now()
);

alter table public.rh_store enable row level security;

drop policy if exists "rh_select" on public.rh_store;
drop policy if exists "rh_insert" on public.rh_store;
drop policy if exists "rh_update" on public.rh_store;

-- Seuls les utilisateurs connectés (Supabase Auth) peuvent lire et écrire.
create policy "rh_select" on public.rh_store for select to authenticated using (true);
create policy "rh_insert" on public.rh_store for insert to authenticated with check (id = 'main');
create policy "rh_update" on public.rh_store for update to authenticated using (id = 'main') with check (id = 'main');
-- Aucune politique de suppression : la ligne ne peut pas être effacée depuis l'application.

create or replace function public.rh_touch() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;
drop trigger if exists rh_touch on public.rh_store;
create trigger rh_touch before update on public.rh_store for each row execute function public.rh_touch();
