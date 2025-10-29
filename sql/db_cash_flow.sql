-- Visualizar tabelas db_cash_flow, schema public (Raw data).
select * from public.bancos;
select * from public.contas;
select * from public.movimentos limit 50;
select * from public.saldo;

-- Criar schema staging.
create schema staging;

-- Copiar tabelas do schema public (Raw data) para o schema staging.
create table staging.st_bancos as table public.bancos;
create table staging.st_contas as table public.contas;
create table staging.st_movimentos as table public.movimentos;
create table staging.st_saldo as table public.saldo;

-- Visualizar tabelas db_cash_flow, schema public (Raw data).
select * from staging.st_bancos;
select * from staging.st_contas;
select * from staging.st_movimentos limit 50;
select * from staging.st_saldo;



