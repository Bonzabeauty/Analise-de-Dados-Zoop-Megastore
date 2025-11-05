## Instruções para agentes AI (Copilot)

**Objetivo:** tornar um agente de codificação imediatamente produtivo neste repositório SQL de análise de vendas (Black Friday).

### Contexto do projeto
- **Tipo:** Análise de dados de vendas da Zoop Megastore usando SQL puro (MySQL 5.7+)
- **Domínio:** Varejo brasileiro (Black Friday 2023 vs períodos normais)
- **Artefatos principais:**
  - `01_schema.sql` — estrutura do banco (5 tabelas normalizadas)
  - `02_dados_exemplo.sql` — 30 vendas fictícias + 28 produtos + 15 clientes
  - `03_analises_black_friday.sql` — 30+ queries organizadas em 8 seções temáticas
  - `04_questionamentos_negocios.sql` — 15 perguntas de negócio respondidas
  - `sanity_check.sql` — validação automatizada de carga de dados
- **Fluxo de trabalho:** aplicar schema → carregar dados → executar análises → validar resultados
- **Documentação de apoio:** `GUIA_EXECUCAO.md` (passo a passo), `INICIO_RAPIDO.txt` (quick start), `EXEMPLOS_RESULTADOS.md` (outputs esperados)

### O que o agente deve saber primeiro
- **Escopo técnico:** Não há código de aplicação (backend/frontend/API). O trabalho é 100% focado em SQL analítico e documentação markdown. Evite propor stacks web/Python/Node sem confirmação explícita do usuário.
- **Chave arquitetural crítica:** A coluna `is_black_friday` (BOOLEAN) na tabela `vendas` é o pivô central das análises — sempre use-a para segmentar BF vs período normal.
- **Modelo de dados (5 tabelas):**
  ```
  categorias (8 registros) → produtos (28) → itens_venda (60+)
                                              ↓
  clientes (15) → vendas (30: 20 BF + 10 normal)
  ```
- **Convenção de nomes:** Tabelas em minúsculas plural (`categorias`, `produtos`, `clientes`, `vendas`, `itens_venda`). Colunas em snake_case português (`nome_produto`, `preco_original`, `is_black_friday`).

### Como executar/validar mudanças (comandos reais)
```bash
# 1. Criar banco e schema
mysql -u root -p < 01_schema.sql

# 2. Carregar dados de exemplo
mysql -u root -p < 02_dados_exemplo.sql

# 3. Executar todas as análises (30+ queries)
mysql -u root -p zoop_megastore < 03_analises_black_friday.sql

# 4. Responder questionamentos de negócio (15 perguntas)
mysql -u root -p zoop_megastore < 04_questionamentos_negocios.sql

# 5. Validar integridade dos dados (sanity-check)
mysql -u root -p zoop_megastore < sanity_check.sql
```

**Validações rápidas no console MySQL:**
```sql
-- Checar carga básica
SELECT COUNT(*) FROM vendas;           -- Esperado: 30
SELECT COUNT(*) FROM itens_venda;      -- Esperado: 60+
SELECT COUNT(*) FROM produtos;         -- Esperado: 28

-- Validar segmentação BF
SELECT is_black_friday, COUNT(*) 
FROM vendas 
GROUP BY is_black_friday;              -- Esperado: FALSE=10, TRUE=20
```

### Padrões e convenções do repositório
- **Organização de queries:** O arquivo `03_analises_black_friday.sql` tem 8 seções temáticas (1. Tendências, 2. Produtos, 3. Clientes, 4. Pagamento, 5. Descontos, 6. Sazonalidade, 7. Análises Avançadas, 8. Resumo). Ao adicionar análises, siga esse agrupamento e comente a seção.
- **Formatação numérica:** Use `ROUND(valor, 2)` para valores monetários. Aliases em português (ex.: `receita_total`, `ticket_medio`, `total_vendas`) para consistência com outputs existentes.
- **Comentários inline:** Cada query deve ter cabeçalho explicativo com objetivo e interpretação esperada. Exemplo:
  ```sql
  -- =====================================================
  -- 2.1. Top 10 Produtos Mais Vendidos na Black Friday
  -- Objetivo: Identificar produtos-estrela por volume
  -- =====================================================
  SELECT p.nome_produto, SUM(iv.quantidade) AS quantidade_vendida
  FROM itens_venda iv
  JOIN vendas v ON iv.id_venda = v.id_venda
  WHERE v.is_black_friday = TRUE
  GROUP BY p.id_produto
  ORDER BY quantidade_vendida DESC
  LIMIT 10;
  ```

### Pontos de integração e dependências
- **Dependência externa:** MySQL (versão 5.7+). Não há APIs externas nem pipelines automatizados no repositório.
- **Integração esperada com ferramentas de BI:** Resultados podem ser exportados para Power BI/Tableau — preparar saídas tabulares limpas com aliases descritivos.
- **Padrões SQL:** Compatível com MySQL 5.7+ (usar funções como `ROUND()`, `DATE()`, `HOUR()`, `MONTHNAME()` conforme sintaxe MySQL).

### Snippets SQL comuns do repositório

**Filtro padrão para Black Friday:**
```sql
WHERE v.is_black_friday = TRUE
```

**Agregação típica com formatação:**
```sql
SELECT 
    ROUND(SUM(valor_total), 2) AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    COUNT(*) AS total_vendas
FROM vendas
WHERE is_black_friday = TRUE;
```

**Join padrão entre tabelas principais:**
```sql
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
JOIN clientes cl ON v.id_cliente = cl.id_cliente
```

**Comparação BF vs Normal:**
```sql
SELECT 
    CASE 
        WHEN is_black_friday = TRUE THEN 'Black Friday'
        ELSE 'Período Normal'
    END AS periodo,
    COUNT(*) AS total_vendas
FROM vendas
GROUP BY is_black_friday;
```

### Como contribuir com novas análises

1. **Escolha a seção apropriada** em `03_analises_black_friday.sql` (1-8) ou crie uma nova se necessário
2. **Siga o padrão de comentários:**
   ```sql
   -- =====================================================
   -- [SEÇÃO].[NÚMERO]. Título Descritivo da Análise
   -- Objetivo: [descreva o que a query faz]
   -- Interpretação: [como usar os resultados]
   -- =====================================================
   ```
3. **Use aliases descritivos em português** (`receita_total`, `ticket_medio`, `quantidade_vendida`)
4. **Aplique ROUND(valor, 2)** para valores monetários e percentuais
5. **Teste com dados de exemplo** antes de commitar
6. **Documente no EXEMPLOS_RESULTADOS.md** se a query retornar insights importantes
7. **Atualize GUIA_EXECUCAO.md** se adicionar novo arquivo SQL ou alterar ordem de execução

**Exemplo de contribuição:**
```sql
-- =====================================================
-- 3.4. Clientes VIP por Estado
-- Objetivo: Identificar clientes de alto valor por região
-- Interpretação: Usar para estratégias regionalizadas
-- =====================================================
SELECT 
    cl.estado,
    cl.nome_cliente,
    COUNT(v.id_venda) AS total_compras,
    ROUND(SUM(v.valor_total), 2) AS valor_total_gasto,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio
FROM vendas v
JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE v.is_black_friday = TRUE
GROUP BY cl.estado, cl.id_cliente, cl.nome_cliente
HAVING total_compras >= 2
ORDER BY cl.estado, valor_total_gasto DESC;
```
### Boas ações de um agente ao editar/estender o projeto
  - Ao adicionar queries, incluir comentários top-down com objetivo, entrada esperada e interpretação do output.
  - Testar localmente com os dados de exemplo antes de commitar. Documentar comandos de validação usados.
  - Manter a ordem de execução nos README/GUIA_EXECUCAO.md se alterar scripts.

### Restrições e avisos
  - Não reescrever os scripts de carga para outro SGBD sem pedir validação — o SQL assume funções e tipos compatíveis com MySQL.
  - Não adicionar dependências externas (Python, Node etc.) sem proposta clara e arquivo de manifesto correspondente.

### Onde olhar primeiro (prioridade)
  1. **`GUIA_EXECUCAO.md`** — procedimentos de execução passo a passo, interpretação de resultados, recomendações estratégicas e próximos passos.
  2. **`01_schema.sql`** — modelo de dados normalizado (5 tabelas), índices otimizados para análises, relacionamentos e constraints.
  3. **`02_dados_exemplo.sql`** — volume de dados (30 vendas: 20 BF + 10 normal), distribuição geográfica (15 clientes em 10 estados), mix de produtos (28 itens em 8 categorias).
  4. **`03_analises_black_friday.sql` e `04_questionamentos_negocios.sql`** — padrões de consulta estabelecidos (joins, agregações, formatações), estrutura de comentários, nomenclatura de aliases.
  5. **`README.md` / `RESUMO_PROJETO.md`** — visão geral do produto, objetivos de negócio, KPIs principais, casos de uso esperados.
  6. **`EXEMPLOS_RESULTADOS.md`** — outputs esperados das principais queries, interpretação de métricas, benchmarks de performance.

### Perguntas que agente deve fazer ao autor humano antes de mudanças grandes
  - Deseja manter os exemplos de dados (fictícios) ou substituir por uma amostra real? (impacta testes)
  - Podemos adicionar arquivos auxiliares (scripts de export CSV/ETL) ou prefere manter tudo em SQL?
  - Há necessidade de compatibilidade com versões específicas do MySQL além da 5.7?

---

Se precisar de ajustes neste arquivo (escopo, exemplos, linguagem), me peça e eu atualizo conforme o feedback.
