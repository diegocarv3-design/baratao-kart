-- Libera o ranking da pista nova "Circuito Manaus" (rodar UMA vez).
-- Supabase → SQL Editor → cole tudo → Run.
alter table public.kart_ranking drop constraint if exists kart_ranking_pista_check;
alter table public.kart_ranking add constraint kart_ranking_pista_check check (pista in ('horti', 'frio', 'manaus'));
