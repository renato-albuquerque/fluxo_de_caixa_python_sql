# Projeto Demonstração de Fluxo de Caixa (DFC)

## 📌 Sumário
1. Evolução da Arquitetura do Projeto: ETL com Python & PostgreSQL | Dataviz com Power BI 
2. Arquitetura do Projeto
    * 2.1. Arquitetura do Projeto | Versão 1.0
    * 2.2. Arquitetura do Projeto | Versão 2.0
3. Da Versão 1.0 à Versão 2.0 (Comparativo entre Arquiteturas)
4. Benefícios da Nova Arquitetura (Projeto 2.0)
5. Tecnologias/Ferramentas Utilizadas
6. Desenvolvimento
7. Conclusão

## 🚀 1. Evolução da Arquitetura do Projeto: ETL com Python & PostgreSQL | Dataviz com Power BI
Este documento detalha a evolução da arquitetura do projeto de Demonstração de Fluxo de Caixa (DFC), que migrou de uma abordagem de ETL (Extract, Transform, Load) simples e atrelada ao Power BI para uma solução robusta baseada em um Data Warehouse (DW) com Python e PostgreSQL. <br>

[Clique aqui para ver Artigo no LinkedIn referente ao projeto na versão 1.0.](https://www.linkedin.com/posts/renato-malbuquerque_data-dados-dataabranalytics-activity-7385885975723446272-s__Q?utm_source=share&utm_medium=member_desktop&rcm=ACoAAASmTtwBGZ_oPJdVVzH2BmXOpsUhvTZfQPE) <br>

[Clique aqui para ver Projeto original no GitHub, versão 1.0.](https://github.com/renato-albuquerque/projeto_fluxo_de_caixa_evolve)

## 📝 2. Arquitetura do Projeto

### 2.1. Arquitetura do Projeto | Versão 1.0
Esta arquitetura se refere a primeira solução desenvolvida para o projeto de **Demonstração de Fluxo de Caixa**. 
![arquitetura_projeto_versao_1.0](images/arquitetura_projeto_1.0.PNG)

### 2.2. Arquitetura do Projeto | Versão 2.0
Esta arquitetura é uma evolução da solução de BI para este projeto, com finalidade de aumentar a confiabilidade, a escalabilidade e a performance desta solução de BI.
![arquitetura_projeto_versao_1.0](images/arquitetura_projeto_2.0.PNG)

## 🎯 3. Da Versão 1.0 à Versão 2.0 (Comparativo entre Arquiteturas)
| Característica | Projeto 1.0 (Inicial) | Projeto 2.0 (Otimizado) |
| :--- | :--- | :--- |
| **Arquitetura** | Power BI como ETL (Power Query) | Pipeline Python + PostgreSQL DW |
| **Fluxo de Dados** | Excel ➡️ Power BI (Memória/Modelo) | Excel ➡️ Python ➡️ PostgreSQL ➡️ Power BI |
| **Processamento (T)** | Transformação dependente do Power Query | Exploração e Limpeza em Python |
| **Armazenamento** | Modelo de Dados do Power BI | PostgreSQL (Raw, Staging, DW) |
| **Principal Benefício** | Rapidez de desenvolvimento | Confiabilidade e Desempenho em Escala |

## ✨ 4. Benefícios da Nova Arquitetura (Projeto 2.0)
A introdução do Python e do PostgreSQL, estruturados em um *Data Warehouse* (DW) com múltiplas camadas, estabeleceu uma base sólida de **Business Intelligence (BI)** para a análise de Fluxo de Caixa.

### 4.1. Confiabilidade e Qualidade de Dados (Data Governance)
* **Imutabilidade (Camada Raw):** Os dados brutos originais são preservados, permitindo auditoria e reversão de transformações.
* **Transformação em Python:** Utilização de scripts Python para regras de negócio mais complexas, transparentes e versionáveis, garantindo que a limpeza e padronização sejam aplicadas de forma consistente.
* **Camada Staging:** Ambiente dedicado para validação de qualidade e saneamento dos dados antes da carga final.

### 4.2. Performance e Escalabilidade do Power BI
* **Desacoplamento de Transformação:** O Power BI agora se conecta diretamente à **Camada DW** (PostgreSQL), recebendo dados já limpos e modelados. Isso descarrega o trabalho pesado do Power Query, otimizando o modelo de dados do Power BI.
* **Dashboards Mais Rápidos:** A conexão com o PostgreSQL, otimizada para consultas, garante que os relatórios e dashboards no Power BI sejam carregados e atualizados mais rapidamente, mesmo com o aumento do volume de dados.

### 4.3. Modelagem Dimensional e Consistência Analítica
* **Estrutura de Data Warehouse:** A modelagem dos dados em tabelas Fato (movimentações) e Dimensão (tempo, contas, etc.) dentro do PostgreSQL cria uma base analítica estruturada (Star Schema).
* **Fonte Única da Verdade:** O PostgreSQL se torna o repositório centralizado e oficial das métricas de Fluxo de Caixa, assegurando que todos os cálculos e relatórios (incluindo o Power BI) utilizem definições consistentes. <br>

Em resumo, a versão 2.0 transformou o projeto de uma análise simples em uma solução de dados robusta, garantindo que as decisões financeiras sejam baseadas em dados de **alta qualidade, performance e governança**.

## 5. 💻 Tecnologias/Ferramentas Utilizadas
- `Git & GitHub`: Controle de versionamento durante o desenvolvimento do projeto, em ambiente local ou em nuvem.
- `Visual Studio Code`: Ambiente de desenvolvimento integrado. Software para execução do projeto (IDE: Integrated Development Environment).
- `Python`: Linguagem de programação utilizada para construir o pipeline de ETL (Extração, Transformação e Carga) dos dados.
- `Pandas`: Biblioteca essencial do Python para manipulação, limpeza e exploração eficiente dos dados de Fluxo de Caixa.
- `dotenv`: Biblioteca para gerenciar variáveis de ambiente, utilizada para armazenar chaves de acesso e credenciais de conexão ao banco de dados (PostgreSQL) de forma segura.
- `SQL Alchemy`: Toolkit ORM (Object-Relational Mapping) e de abstração de banco de dados, usado no Python para facilitar a construção de queries e a comunicação com o PostgreSQL.
- `psycopg2`: Adaptador de banco de dados PostgreSQL para Python. É o driver que permite ao Python se conectar nativamente e executar comandos no PostgreSQL.
- `PostgreSQL (pgAdmin4)`: Sistema de gerenciamento de banco de dados relacional (SGBD) utilizado para persistir e modelar os dados nas camadas Raw, Staging e Data Warehouse (DW).
- `Power BI`: Visualização dos dados e geração de insights para o negócio.

## 6. Desenvolvimento

### ✅ 6.1. Etapas de Ingestão dos dados no Python até Carga dos dataframes no PostgreSQL
[Passo a passo descrito no arquivo main.ipynb.](jupyter/main.ipynb).
<br>
<br>

### ✅ 6.2. Etapas de criação do banco de dados no PostgreSQL até desenvolvimento das tabelas do Data Warehouse 

#### ✅ 6.2.1. Criação do banco de dados no PostgreSQL
O banco de dados foi nomeado de: `db_cash_flow`.
<br>
<br>

#### ✅ 6.2.2. Etapas de transformação e carga dos dados no PostgreSQL
[Passo a passo descrito no arquivo db_cash_flow.](sql/db_cash_flow.sql).
<br>
<br>

#### 6.2.3. 🌟 Modelagem de dados do Data Warehouse
![modelagem_dados_dw](images/dw_star_schema_postgresql.PNG) 
<br>
<br>

##### 🌟 Modelo de Dados: Esquema Estrela Otimizado para o projeto DFC

##### 🎯 Objetivo do Modelo
O principal objetivo deste modelo é fornecer uma estrutura dimensionalmente correta para a análise da Demonstração de Fluxo de Caixa (DFC), permitindo que os usuários no Power BI:
- Calculem Saldo Final e Movimentações de forma precisa.
- Analisem o Fluxo de Caixa por diversas dimensões: Tempo (Ano, Mês, Dia), Conta (Grupo/Subgrupo) e Banco.
- Gerem Relatórios de Saldo Inicial/Final de maneira eficiente, separando os fatos de movimentação e saldo.
<br>

##### ✨ Benefícios Chave Desta Modelagem (Esquema Estrela)
1. Performance (Consultas Rápidas):
- As tabelas de Dimensão (dw dim_calendario, dw dim_contas, dw dim_bancos) são pequenas e se conectam diretamente às tabelas de Fato (dw f_movimentos, dw f_saldo).
- Isso permite consultas ágeis aos usuários.

2. Consistência Analítica:
- Fonte Única da Verdade: As definições de Banco, Conta e Tempo são centralizadas nas dimensões, garantindo que a segmentação e os filtros sejam aplicados de forma consistente em todo o relatório.

3. Flexibilidade (Análise Multifacetada):
- A separação em dw f_movimentos e dw f_saldo é uma ótima prática. Permite analisar as transações diárias (movimentos) e os saldos em momentos específicos (como Saldo Inicial/Final) de forma separada e otimizada.
- O modelo está pronto para ser cortado e fatiado por qualquer combinação de Mês/Ano, Conta (Subgrupo) e Banco.

4. Clareza e Manutenibilidade:
- O modelo é intuitivo e fácil de entender. As tabelas de Dimensão filtram as tabelas de Fato. A lógica de negócio é clara para futuros desenvolvedores ou para o próprio usuário na navegação dos dados.
<br>

### 6.3. 📊 Desenvolvimento dos Dashboards (Dataviz)
![Página DFC](images/dashboard_pagina_dfc.PNG)
<br>

![Página Matriz](images/dashboard_pagina_matriz.PNG)

## 7. 🏆 Conclusão
A evolução para a Arquitetura 2.0 mostrou uma transformação na capacidade analítica do projeto de Demonstração de Fluxo de Caixa (DFC). <br>

Ao migrar o processo de ETL para um pipeline dedicado em Python e centralizar o armazenamento em um PostgreSQL com Data Warehouse, o projeto alcançou seus objetivos primários:
- Elevada Governança de Dados: Garantindo que os dados utilizados para a análise de Fluxo de Caixa sejam limpos, consistentes e auditáveis em todas as etapas (Raw, Staging, DW).
- Performance Otimizada: O modelo de dados em Esquema Estrela permitiu que o Power BI focasse na visualização de insights, resultando em dashboards mais rápidos e responsivos.
- Escalabilidade Comprovada: A solução está pronta para absorver um volume crescente de dados sem comprometer a integridade ou a velocidade do relatório.
<br>

Este projeto demonstra a aplicação prática de conceitos modernos de engenharia de dados, convertendo dados brutos em uma Fonte Única da Verdade acionável e robusta para a tomada de decisões financeiras.








