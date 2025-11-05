-- =====================================================
-- ANÁLISE DE DADOS - BLACK FRIDAY
-- Zoop Megastore - Queries SQL para Análise de Vendas
-- =====================================================

USE zoop_megastore;

-- =====================================================
-- 1. ANÁLISE DE TENDÊNCIAS E COMPARAÇÕES
-- =====================================================

-- 1.1. Comparação de Vendas: Black Friday vs Períodos Normais
SELECT 
    CASE 
        WHEN is_black_friday = TRUE THEN 'Black Friday'
        ELSE 'Período Normal'
    END AS periodo,
    COUNT(*) AS total_vendas,
    ROUND(SUM(valor_total), 2) AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    ROUND(SUM(desconto_aplicado), 2) AS total_descontos
FROM vendas
GROUP BY is_black_friday
ORDER BY receita_total DESC;

-- 1.2. Vendas por Dia durante a Black Friday
SELECT 
    DATE(data_venda) AS data,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita_dia,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    ROUND(SUM(desconto_aplicado), 2) AS descontos_concedidos
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY DATE(data_venda)
ORDER BY data;

-- 1.3. Horários de Pico de Vendas na Black Friday
SELECT 
    HOUR(data_venda) AS hora,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY HOUR(data_venda)
ORDER BY numero_vendas DESC;

-- =====================================================
-- 2. ANÁLISE DE PRODUTOS E CATEGORIAS
-- =====================================================

-- 2.1. Top 10 Produtos Mais Vendidos na Black Friday
SELECT 
    p.nome_produto,
    c.nome_categoria,
    SUM(iv.quantidade) AS quantidade_vendida,
    ROUND(SUM(iv.subtotal), 2) AS receita_total,
    ROUND(p.preco_original - p.preco_black_friday, 2) AS desconto_unitario,
    ROUND(((p.preco_original - p.preco_black_friday) / p.preco_original) * 100, 2) AS percentual_desconto
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria, p.preco_original, p.preco_black_friday
ORDER BY quantidade_vendida DESC
LIMIT 10;

-- 2.2. Performance de Categorias na Black Friday
SELECT 
    c.nome_categoria,
    COUNT(DISTINCT iv.id_produto) AS produtos_vendidos,
    SUM(iv.quantidade) AS quantidade_total,
    ROUND(SUM(iv.subtotal), 2) AS receita_categoria,
    ROUND(AVG(iv.preco_unitario), 2) AS preco_medio
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY receita_categoria DESC;

-- 2.3. Produtos com Maior Receita na Black Friday
SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.preco_original,
    p.preco_black_friday,
    SUM(iv.quantidade) AS unidades_vendidas,
    ROUND(SUM(iv.subtotal), 2) AS receita_total,
    ROUND(SUM(iv.subtotal) / SUM(iv.quantidade), 2) AS preco_medio_venda
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria, p.preco_original, p.preco_black_friday
ORDER BY receita_total DESC
LIMIT 10;

-- =====================================================
-- 3. ANÁLISE DE CLIENTES
-- =====================================================

-- 3.1. Clientes que Mais Compraram na Black Friday
SELECT 
    cl.nome_cliente,
    cl.cidade,
    cl.estado,
    COUNT(v.id_venda) AS numero_compras,
    ROUND(SUM(v.valor_total), 2) AS valor_total_gasto,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio_cliente
FROM vendas v
JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE v.is_black_friday = TRUE
GROUP BY cl.id_cliente, cl.nome_cliente, cl.cidade, cl.estado
ORDER BY valor_total_gasto DESC
LIMIT 10;

-- 3.2. Distribuição de Clientes por Estado na Black Friday
SELECT 
    cl.estado,
    COUNT(DISTINCT v.id_cliente) AS numero_clientes,
    COUNT(v.id_venda) AS total_compras,
    ROUND(SUM(v.valor_total), 2) AS receita_estado
FROM vendas v
JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE v.is_black_friday = TRUE
GROUP BY cl.estado
ORDER BY receita_estado DESC;

-- 3.3. Taxa de Conversão de Clientes na Black Friday
SELECT 
    COUNT(DISTINCT id_cliente) AS total_clientes_cadastrados,
    COUNT(DISTINCT CASE WHEN is_black_friday = TRUE THEN id_cliente END) AS clientes_black_friday,
    ROUND((COUNT(DISTINCT CASE WHEN is_black_friday = TRUE THEN id_cliente END) * 100.0 / 
           COUNT(DISTINCT id_cliente)), 2) AS taxa_conversao_percentual
FROM vendas;

-- =====================================================
-- 4. ANÁLISE DE FORMAS DE PAGAMENTO
-- =====================================================

-- 4.1. Preferências de Pagamento na Black Friday
SELECT 
    forma_pagamento,
    COUNT(*) AS numero_transacoes,
    ROUND(SUM(valor_total), 2) AS valor_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vendas WHERE is_black_friday = TRUE)), 2) AS percentual_uso
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY forma_pagamento
ORDER BY numero_transacoes DESC;

-- 4.2. Comparação de Formas de Pagamento: Black Friday vs Normal
SELECT 
    forma_pagamento,
    CASE 
        WHEN is_black_friday = TRUE THEN 'Black Friday'
        ELSE 'Período Normal'
    END AS periodo,
    COUNT(*) AS numero_transacoes,
    ROUND(SUM(valor_total), 2) AS valor_total
FROM vendas
GROUP BY forma_pagamento, is_black_friday
ORDER BY forma_pagamento, is_black_friday DESC;

-- =====================================================
-- 5. ANÁLISE DE DESCONTOS E LUCRATIVIDADE
-- =====================================================

-- 5.1. Impacto dos Descontos na Black Friday
SELECT 
    ROUND(SUM(valor_total), 2) AS receita_total,
    ROUND(SUM(desconto_aplicado), 2) AS total_descontos,
    ROUND(SUM(valor_total + desconto_aplicado), 2) AS valor_sem_desconto,
    ROUND((SUM(desconto_aplicado) * 100.0 / SUM(valor_total + desconto_aplicado)), 2) AS percentual_desconto_medio
FROM vendas
WHERE is_black_friday = TRUE;

-- 5.2. Análise de Desconto por Categoria
SELECT 
    c.nome_categoria,
    COUNT(DISTINCT v.id_venda) AS numero_vendas,
    ROUND(AVG(p.preco_original), 2) AS preco_medio_original,
    ROUND(AVG(p.preco_black_friday), 2) AS preco_medio_black_friday,
    ROUND(AVG(p.preco_original - p.preco_black_friday), 2) AS desconto_medio,
    ROUND(AVG(((p.preco_original - p.preco_black_friday) / p.preco_original) * 100), 2) AS percentual_desconto
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY percentual_desconto DESC;

-- =====================================================
-- 6. SAZONALIDADE E TENDÊNCIAS TEMPORAIS
-- =====================================================

-- 6.1. Vendas Mensais (Comparação Outubro, Novembro, Dezembro)
SELECT 
    MONTH(data_venda) AS mes,
    MONTHNAME(data_venda) AS nome_mes,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM vendas
GROUP BY MONTH(data_venda), MONTHNAME(data_venda)
ORDER BY mes;

-- 6.2. Crescimento de Vendas na Black Friday
SELECT 
    'Outubro (Antes)' AS periodo,
    COUNT(*) AS vendas,
    ROUND(SUM(valor_total), 2) AS receita
FROM vendas
WHERE MONTH(data_venda) = 10
UNION ALL
SELECT 
    'Novembro - Black Friday' AS periodo,
    COUNT(*) AS vendas,
    ROUND(SUM(valor_total), 2) AS receita
FROM vendas
WHERE is_black_friday = TRUE
UNION ALL
SELECT 
    'Dezembro (Depois)' AS periodo,
    COUNT(*) AS vendas,
    ROUND(SUM(valor_total), 2) AS receita
FROM vendas
WHERE MONTH(data_venda) = 12;

-- =====================================================
-- 7. ANÁLISES AVANÇADAS E INSIGHTS
-- =====================================================

-- 7.1. Produtos com Melhor Performance (Quantidade x Receita)
SELECT 
    p.nome_produto,
    c.nome_categoria,
    SUM(iv.quantidade) AS quantidade_vendida,
    ROUND(SUM(iv.subtotal), 2) AS receita,
    ROUND((SUM(iv.subtotal) / SUM(iv.quantidade)), 2) AS valor_medio_venda,
    ROUND((p.preco_original - p.preco_black_friday) / p.preco_original * 100, 2) AS desconto_percentual
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria, p.preco_original, p.preco_black_friday
HAVING quantidade_vendida >= 2
ORDER BY receita DESC;

-- 7.2. Análise de Cesta de Compras (Produtos por Venda)
SELECT 
    v.id_venda,
    v.data_venda,
    COUNT(iv.id_produto) AS itens_na_cesta,
    ROUND(v.valor_total, 2) AS valor_total,
    ROUND(v.valor_total / COUNT(iv.id_produto), 2) AS valor_medio_por_item
FROM vendas v
JOIN itens_venda iv ON v.id_venda = iv.id_venda
WHERE v.is_black_friday = TRUE
GROUP BY v.id_venda, v.data_venda, v.valor_total
ORDER BY itens_na_cesta DESC;

-- 7.3. Média de Itens por Venda: Black Friday vs Normal
SELECT 
    CASE 
        WHEN v.is_black_friday = TRUE THEN 'Black Friday'
        ELSE 'Período Normal'
    END AS periodo,
    ROUND(AVG(itens_por_venda), 2) AS media_itens_por_venda,
    MAX(itens_por_venda) AS max_itens_por_venda,
    MIN(itens_por_venda) AS min_itens_por_venda
FROM (
    SELECT 
        v.id_venda,
        v.is_black_friday,
        COUNT(iv.id_produto) AS itens_por_venda
    FROM vendas v
    JOIN itens_venda iv ON v.id_venda = iv.id_venda
    GROUP BY v.id_venda, v.is_black_friday
) AS subquery
GROUP BY is_black_friday;

-- 7.4. ROI da Black Friday (Retorno sobre Investimento)
SELECT 
    ROUND(SUM(v.valor_total), 2) AS receita_black_friday,
    ROUND(SUM(v.desconto_aplicado), 2) AS investimento_descontos,
    ROUND((SUM(v.valor_total) / SUM(v.desconto_aplicado)), 2) AS roi_razao,
    ROUND(((SUM(v.valor_total) - SUM(v.desconto_aplicado)) / SUM(v.desconto_aplicado) * 100), 2) AS roi_percentual
FROM vendas v
WHERE v.is_black_friday = TRUE;

-- =====================================================
-- 8. RESUMO EXECUTIVO
-- =====================================================

-- 8.1. Dashboard Resumo da Black Friday
SELECT 
    'Total de Vendas' AS metrica,
    COUNT(*) AS valor
FROM vendas
WHERE is_black_friday = TRUE
UNION ALL
SELECT 
    'Receita Total (R$)' AS metrica,
    ROUND(SUM(valor_total), 2) AS valor
FROM vendas
WHERE is_black_friday = TRUE
UNION ALL
SELECT 
    'Ticket Médio (R$)' AS metrica,
    ROUND(AVG(valor_total), 2) AS valor
FROM vendas
WHERE is_black_friday = TRUE
UNION ALL
SELECT 
    'Total de Clientes Únicos' AS metrica,
    COUNT(DISTINCT id_cliente) AS valor
FROM vendas
WHERE is_black_friday = TRUE
UNION ALL
SELECT 
    'Total de Produtos Vendidos' AS metrica,
    SUM(iv.quantidade) AS valor
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
WHERE v.is_black_friday = TRUE
UNION ALL
SELECT 
    'Descontos Concedidos (R$)' AS metrica,
    ROUND(SUM(desconto_aplicado), 2) AS valor
FROM vendas
WHERE is_black_friday = TRUE;
