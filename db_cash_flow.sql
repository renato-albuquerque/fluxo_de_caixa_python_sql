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

-- Transformações

-- Tabelas "st_bancos" e "st_contas" (Staging), não houve transformações.

-- Transformação tabela st_movimentos (Staging).
-- Coluna Tipo: Entradas = E, Saídas = S.
UPDATE staging.st_movimentos
SET "Tipo" = 'E'
WHERE "Tipo" = 'Entradas';

UPDATE staging.st_movimentos
SET "Tipo" = 'S'
WHERE "Tipo" = 'Saídas';

select * from staging.st_movimentos;

-- Coluna Valor, transformar para "Número decimal fixo".
ALTER TABLE staging.st_movimentos
ALTER COLUMN "Valor" TYPE numeric(15,2)
USING ROUND("Valor"::numeric, 2);

select * from staging.st_movimentos;

-- Transformação tabela st_saldo (Staging).
ALTER TABLE staging.st_saldo
ALTER COLUMN "Valor" TYPE numeric(15,2)
USING ROUND("Valor"::numeric, 2);

select * from staging.st_saldo;
