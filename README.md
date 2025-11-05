# Análise de Dados - Zoop Megastore
## Projeto de Análise de Vendas para Black Friday

Análise de Dados da Zoop Megastore, uma empresa de varejo que comercializa desde utensílios e eletrodomésticos até produtos alimentícios. Este projeto foca na análise de vendas durante a Black Friday para apoiar decisões estratégicas de marketing e vendas.

## 📋 Sobre o Projeto

A Zoop Megastore deseja veicular ações estratégicas durante a Black Friday e precisa de insights baseados em dados para maximizar os resultados. Este projeto utiliza **SQL** para:

- Identificar tendências de vendas
- Analisar sazonalidades
- Responder questionamentos estratégicos do negócio
- Comparar performance da Black Friday com períodos normais
- Avaliar efetividade de descontos e promoções

## 🗂️ Estrutura do Projeto

```
📁 Analise-de-Dados-Zoop-Megastore/
├── 01_schema.sql                    # Estrutura do banco de dados
├── 02_dados_exemplo.sql             # Dados de exemplo para análise
├── 03_analises_black_friday.sql     # Queries de análise
└── README.md                        # Documentação do projeto
```

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

1. **categorias** - Categorias de produtos
2. **produtos** - Catálogo de produtos com preços normais e Black Friday
3. **clientes** - Base de clientes cadastrados
4. **vendas** - Registro de todas as vendas realizadas
5. **itens_venda** - Detalhamento dos itens em cada venda

### Categorias de Produtos

- Eletrônicos (TVs, notebooks, smartphones)
- Eletrodomésticos (geladeiras, fogões, micro-ondas)
- Utensílios (panelas, facas, potes)
- Alimentos (cestas, temperos, azeites)
- Móveis (mesas, cadeiras, estantes)
- Esportes (bicicletas, halteres, esteiras)
- Livros
- Moda (tênis, jaquetas, bolsas)

## 🚀 Como Usar

### 1. Configurar o Banco de Dados

```bash
# Conectar ao MySQL
mysql -u seu_usuario -p

# Executar os scripts na ordem
mysql -u seu_usuario -p < 01_schema.sql
mysql -u seu_usuario -p < 02_dados_exemplo.sql
```

### 2. Executar as Análises

```bash
# Executar todas as análises
mysql -u seu_usuario -p zoop_megastore < 03_analises_black_friday.sql

# Ou executar queries individuais conforme necessidade
mysql -u seu_usuario -p zoop_megastore
```

## 📊 Análises Disponíveis

### 1. Análise de Tendências e Comparações
- Comparação Black Friday vs Períodos Normais
- Vendas por dia durante a Black Friday
- Horários de pico de vendas

### 2. Análise de Produtos e Categorias
- Top 10 produtos mais vendidos
- Performance por categoria
- Produtos com maior receita

### 3. Análise de Clientes
- Clientes que mais compraram
- Distribuição geográfica
- Taxa de conversão

### 4. Análise de Formas de Pagamento
- Preferências de pagamento
- Comparação entre períodos

### 5. Análise de Descontos e Lucratividade
- Impacto dos descontos
- ROI da Black Friday
- Análise por categoria

### 6. Sazonalidade e Tendências Temporais
- Comparação mensal
- Crescimento de vendas

### 7. Análises Avançadas
- Performance de produtos
- Análise de cesta de compras
- Média de itens por venda

### 8. Resumo Executivo
- Dashboard com principais métricas

## 🔍 Principais Insights e Métricas

As análises respondem a perguntas como:

1. **Qual foi o impacto da Black Friday nas vendas?**
   - Comparação de receita total, número de vendas e ticket médio

2. **Quais produtos tiveram melhor performance?**
   - Ranking por quantidade vendida e receita gerada

3. **Quais categorias são mais lucrativas?**
   - Análise de receita e margem por categoria

4. **Como os clientes se comportam na Black Friday?**
   - Análise de cesta de compras, ticket médio e frequência

5. **Os descontos são efetivos?**
   - ROI e análise de custo-benefício das promoções

6. **Qual o melhor momento para vender?**
   - Análise de horários de pico e dias mais movimentados

7. **Quais formas de pagamento são preferidas?**
   - Distribuição e valor médio por forma de pagamento

## 📈 Exemplos de Resultados Esperados

### Comparação Black Friday vs Período Normal
```sql
-- Exemplo de resultado esperado:
-- Período          | Total Vendas | Receita Total | Ticket Médio
-- Black Friday     | 20           | R$ 29.999,80  | R$ 1.499,99
-- Período Normal   | 10           | R$ 10.499,95  | R$ 1.049,99
```

### Top Produtos na Black Friday
```sql
-- Exemplo de resultado:
-- Produto                    | Categoria      | Quantidade | Receita
-- Smart TV 55"               | Eletrônicos    | 5          | R$ 9.999,95
-- Notebook Intel Core i5     | Eletrônicos    | 4          | R$ 9.999,96
```

## 🛠️ Tecnologias Utilizadas

- **SQL** (MySQL) - Linguagem principal de análise
- **MySQL Database** - Sistema de gerenciamento de banco de dados

## 📝 Requisitos

- MySQL 5.7 ou superior
- Cliente MySQL (mysql-client ou MySQL Workbench)

## 🤝 Contribuindo

Este é um projeto de análise de dados. Sugestões de novas análises ou melhorias são bem-vindas!

## 📄 Licença

Este projeto é para fins educacionais e de demonstração de análise de dados com SQL.

## 👥 Autores

Desenvolvido como projeto de análise de dados para Zoop Megastore.

---

**Nota**: Os dados utilizados neste projeto são fictícios e criados apenas para fins de demonstração e análise educacional.
