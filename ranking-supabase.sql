-- Ranking de colaboradores do Baratão Kart GP
-- Como usar: Supabase → SQL Editor → cole tudo → Run.
-- Depois copie a Project URL e a anon key (Project Settings → API) para
-- const RANKING = { url: '...', anonKey: '...' } no index.html.

create table if not exists public.kart_ranking (
  id         bigint generated always as identity primary key,
  nome       text not null check (char_length(nome) between 2 and 20),
  setor      text not null default '' check (char_length(setor) <= 24),
  pista      text not null check (pista in ('horti', 'frio')),
  tempo      numeric(7,2) not null check (tempo between 30 and 900), -- segundos; barra tempos impossíveis
  piloto     text not null default '' check (char_length(piloto) <= 20),
  criado_em  timestamptz not null default now()
);

create index if not exists kart_ranking_pista_tempo on public.kart_ranking (pista, tempo);

-- Segurança (RLS): o jogo só pode LER e INSERIR. Editar/apagar só pelo painel do Supabase.
alter table public.kart_ranking enable row level security;

drop policy if exists "ranking leitura publica" on public.kart_ranking;
create policy "ranking leitura publica" on public.kart_ranking
  for select to anon using (true);

drop policy if exists "ranking insercao publica" on public.kart_ranking;
create policy "ranking insercao publica" on public.kart_ranking
  for insert to anon with check (true);

-- Moderação: para remover um nome impróprio, use Table Editor → kart_ranking → apagar a linha.
