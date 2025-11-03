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

-- Coluna Data, transformar para data abreviada.
ALTER TABLE staging.st_movimentos
ALTER COLUMN "Data" TYPE date
USING "Data"::date;

select * from staging.st_movimentos;

-- Inserindo colunas Banco_ID e Conta_ID. 
-- Excluindo colunas Banco e Conta.
create table staging.st_movimentos_transf as 
select
	b."Banco_ID",
	c."Conta_ID",
	m."Tipo",
	m."Data",
	m."Valor"
from staging.st_movimentos m
left join staging.st_bancos b on m."Banco" = b."Banco"
left join staging.st_contas c on m."Conta" = c."Conta";

select * from staging.st_movimentos_transf;

-- Transformação tabela st_saldo (Staging).
ALTER TABLE staging.st_saldo
ALTER COLUMN "Valor" TYPE numeric(15,2)
USING ROUND("Valor"::numeric, 2);

select * from staging.st_saldo;

-- Criar schema dw (Data warehouse).
create schema dw;

-- Tabelas dimensão x fato a serem criadas:
-- dim_bancos, dim_contas, dim_calendario, f_movimentos, f_saldo

-- Criar tabela dimensão dim_bancos.
create table dw.dim_bancos as table staging.st_bancos;

-- Definir coluna Banco_ID como primary key.
ALTER TABLE dw.dim_bancos
ADD CONSTRAINT pk_dim_bancos PRIMARY KEY ("Banco_ID");

select * from dw.dim_bancos;

-- Criar tabela dimensão dim_contas.
create table dw.dim_contas as table staging.st_contas;

-- Definir coluna Conta_ID como primary key.
ALTER TABLE dw.dim_contas
ADD CONSTRAINT pk_dim_contas PRIMARY KEY ("Conta_ID");

select * from dw.dim_contas;

-- Criar tabela dimensão dim_calendario.
create table dw.dim_calendario (
    id_tempo SERIAL PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    nome_dia_semana VARCHAR(20),
    nome_mes VARCHAR(20),
    trimestre INT,
    bimestre INT,
    semestre INT
);

-- Inserir dados na tabela dim_calendario
INSERT INTO dw.dim_calendario (data, ano, mes, dia, nome_dia_semana, nome_mes, trimestre, bimestre, semestre)
SELECT 
    dt AS data,
    EXTRACT(YEAR FROM dt) AS ano,
    EXTRACT(MONTH FROM dt) AS mes,
    EXTRACT(DAY FROM dt) AS dia,
    TO_CHAR(dt, 'Day') AS nome_dia_semana,  -- Nome do dia da semana (Ex: Segunda, Terça)
    TO_CHAR(dt, 'Month') AS nome_mes,        -- Nome do mês (Ex: Janeiro, Fevereiro)
    EXTRACT(QUARTER FROM dt) AS trimestre,   -- Trimestre (1, 2, 3, 4)
    (EXTRACT(MONTH FROM dt) + 1) / 2 AS bimestre, -- Bimestre (1, 2, 3, 4, 5, 6)
    CASE 
        WHEN EXTRACT(MONTH FROM dt) <= 6 THEN 1
        ELSE 2
    END AS semestre                          -- Semestre (1 ou 2)
FROM
    generate_series('2023-01-02'::DATE, '2024-05-10'::DATE, '1 day'::INTERVAL) AS dt;

select * from dw.dim_calendario;

-- Criar tabela fato f_saldo.
create table dw.f_saldo as table staging.st_saldo;

-- Inserir coluna saldo_id (PK).
alter table dw.f_saldo
add column saldo_id BIGSERIAL PRIMARY KEY;

-- Renomear nome coluna saldo_id.
ALTER TABLE dw.f_saldo
RENAME COLUMN "Saldo_id" TO "Saldo_ID";

-- Definir coluna Banco_ID como foreign key.
ALTER TABLE dw.f_saldo
ADD CONSTRAINT fk_f_saldo_dim_bancos
FOREIGN KEY ("Banco_ID")
REFERENCES dw.dim_bancos ("Banco_ID");

ALTER TABLE dw.f_saldo
DROP CONSTRAINT IF EXISTS fk_f_saldo_dim_bancos;

ALTER TABLE dw.f_saldo
ADD CONSTRAINT fk_f_saldo_dim_bancos
FOREIGN KEY ("Banco_ID")
REFERENCES dw.dim_bancos("Banco_ID");

select * from dw.f_saldo;

-- Criar tabela fato f_movimentos
create table dw.f_movimentos (
	"Movimentos_ID" SERIAL NOT NULL PRIMARY KEY,
	"Banco_ID" BIGINT REFERENCES dw.dim_bancos ("Banco_ID"),
	"Conta_ID" BIGINT REFERENCES dw.dim_contas ("Conta_ID"),
	"Saldo_ID" BIGINT REFERENCES dw.f_saldo ("Saldo_ID"),
	id_tempo INTEGER REFERENCES dw.dim_calendario(id_tempo),
	"Tipo" TEXT,
	"Valor" NUMERIC
);

insert into dw.f_movimentos(
	"Banco_ID",
	"Conta_ID",
	"Saldo_ID",
	id_tempo,
	"Tipo",
	"Valor"
) 
select 
	mt."Banco_ID",
	mt."Conta_ID",
	s."Saldo_ID",
	dcal.id_tempo as "Tempo_ID",
	mt."Tipo",
	mt."Valor"
from staging.st_movimentos_transf mt
left join dw.f_saldo s on mt."Banco_ID" = s."Banco_ID"
left join dw.dim_calendario dcal on mt."Data" = dcal.data; 

select * from dw.f_movimentos;

-- End.