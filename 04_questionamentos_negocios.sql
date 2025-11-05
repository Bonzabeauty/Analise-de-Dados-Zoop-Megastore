-- =====================================================
-- QUESTIONAMENTOS DE NEGÓCIO - RESPOSTAS COM SQL
-- Zoop Megastore - Black Friday
-- =====================================================

USE zoop_megastore;

-- =====================================================
-- QUESTÃO 1: Qual foi o aumento de vendas na Black Friday 
-- comparado ao período normal?
-- =====================================================

SELECT 
    'Período Normal' AS periodo,
    COUNT(*) AS total_vendas,
    ROUND(SUM(valor_total), 2) AS receita_total
FROM vendas 
WHERE is_black_friday = FALSE

UNION ALL

SELECT 
    'Black Friday' AS periodo,
    COUNT(*) AS total_vendas,
    ROUND(SUM(valor_total), 2) AS receita_total
FROM vendas 
WHERE is_black_friday = TRUE

UNION ALL

SELECT 
    'Crescimento (%)' AS periodo,
    ROUND(((SELECT COUNT(*) FROM vendas WHERE is_black_friday = TRUE) - 
           (SELECT COUNT(*) FROM vendas WHERE is_black_friday = FALSE)) * 100.0 / 
           (SELECT COUNT(*) FROM vendas WHERE is_black_friday = FALSE), 2) AS crescimento_vendas,
    ROUND(((SELECT SUM(valor_total) FROM vendas WHERE is_black_friday = TRUE) - 
           (SELECT SUM(valor_total) FROM vendas WHERE is_black_friday = FALSE)) * 100.0 / 
           (SELECT SUM(valor_total) FROM vendas WHERE is_black_friday = FALSE), 2) AS crescimento_receita;

-- =====================================================
-- QUESTÃO 2: Quais são os 5 produtos que geraram mais 
-- receita durante a Black Friday?
-- =====================================================

SELECT 
    p.nome_produto,
    c.nome_categoria,
    p.preco_original,
    p.preco_black_friday,
    ROUND(p.preco_original - p.preco_black_friday, 2) AS desconto_aplicado,
    SUM(iv.quantidade) AS unidades_vendidas,
    ROUND(SUM(iv.subtotal), 2) AS receita_gerada
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY p.id_produto, p.nome_produto, c.nome_categoria, p.preco_original, p.preco_black_friday
ORDER BY receita_gerada DESC
LIMIT 5;

-- =====================================================
-- QUESTÃO 3: Qual categoria de produtos teve melhor 
-- desempenho na Black Friday?
-- =====================================================

SELECT 
    c.nome_categoria,
    COUNT(DISTINCT p.id_produto) AS produtos_diferentes,
    SUM(iv.quantidade) AS total_unidades_vendidas,
    ROUND(SUM(iv.subtotal), 2) AS receita_total,
    ROUND(AVG(iv.subtotal / iv.quantidade), 2) AS preco_medio_venda,
    ROUND(SUM(iv.subtotal) * 100.0 / 
        (SELECT SUM(iv2.subtotal) 
         FROM itens_venda iv2 
         JOIN vendas v2 ON iv2.id_venda = v2.id_venda 
         WHERE v2.is_black_friday = TRUE), 2) AS percentual_receita_total
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE v.is_black_friday = TRUE
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY receita_total DESC;

-- =====================================================
-- QUESTÃO 4: Qual é o perfil dos clientes que mais 
-- compraram na Black Friday?
-- =====================================================

SELECT 
    cl.estado,
    COUNT(DISTINCT cl.id_cliente) AS numero_clientes,
    COUNT(v.id_venda) AS total_compras,
    ROUND(SUM(v.valor_total), 2) AS valor_total_comprado,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio,
    ROUND(SUM(v.valor_total) * 100.0 / 
        (SELECT SUM(valor_total) FROM vendas WHERE is_black_friday = TRUE), 2) AS percentual_receita
FROM vendas v
JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE v.is_black_friday = TRUE
GROUP BY cl.estado
ORDER BY valor_total_comprado DESC;

-- =====================================================
-- QUESTÃO 5: Os descontos oferecidos na Black Friday 
-- compensaram em termos de volume de vendas?
-- =====================================================

SELECT 
    'Análise de Descontos' AS analise,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita_com_desconto,
    ROUND(SUM(desconto_aplicado), 2) AS valor_total_descontos,
    ROUND(SUM(valor_total + desconto_aplicado), 2) AS receita_sem_desconto,
    ROUND(SUM(desconto_aplicado) * 100.0 / SUM(valor_total + desconto_aplicado), 2) AS percentual_desconto,
    ROUND(SUM(valor_total) / SUM(desconto_aplicado), 2) AS retorno_por_real_investido
FROM vendas
WHERE is_black_friday = TRUE;

-- Detalhamento por dia
SELECT 
    DATE(data_venda) AS dia,
    COUNT(*) AS vendas,
    ROUND(SUM(valor_total), 2) AS receita,
    ROUND(SUM(desconto_aplicado), 2) AS descontos,
    ROUND(SUM(desconto_aplicado) * 100.0 / SUM(valor_total + desconto_aplicado), 2) AS perc_desconto
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY DATE(data_venda)
ORDER BY dia;

-- =====================================================
-- QUESTÃO 6: Qual foi o horário de maior movimento 
-- durante a Black Friday?
-- =====================================================

SELECT 
    HOUR(data_venda) AS hora_do_dia,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    CONCAT(ROUND(COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM vendas WHERE is_black_friday = TRUE), 2), '%') AS percentual_vendas
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY HOUR(data_venda)
ORDER BY numero_vendas DESC;

-- =====================================================
-- QUESTÃO 7: Qual foi a forma de pagamento mais 
-- utilizada e qual gerou mais receita?
-- =====================================================

SELECT 
    forma_pagamento,
    COUNT(*) AS numero_transacoes,
    ROUND(SUM(valor_total), 2) AS receita_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    CONCAT(ROUND(COUNT(*) * 100.0 / 
        (SELECT COUNT(*) FROM vendas WHERE is_black_friday = TRUE), 2), '%') AS percentual_uso,
    CONCAT(ROUND(SUM(valor_total) * 100.0 / 
        (SELECT SUM(valor_total) FROM vendas WHERE is_black_friday = TRUE), 2), '%') AS percentual_receita
FROM vendas
WHERE is_black_friday = TRUE
GROUP BY forma_pagamento
ORDER BY receita_total DESC;

-- =====================================================
-- QUESTÃO 8: Quantos produtos em média os clientes 
-- compram na Black Friday vs período normal?
-- =====================================================

SELECT 
    CASE 
        WHEN v.is_black_friday = TRUE THEN 'Black Friday'
        ELSE 'Período Normal'
    END AS periodo,
    COUNT(DISTINCT v.id_venda) AS total_vendas,
    SUM(iv.quantidade) AS total_produtos,
    ROUND(AVG(produtos_por_venda), 2) AS media_produtos_por_venda,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio
FROM vendas v
JOIN (
    SELECT 
        id_venda,
        SUM(quantidade) AS produtos_por_venda
    FROM itens_venda
    GROUP BY id_venda
) AS iv ON v.id_venda = iv.id_venda
GROUP BY v.is_black_friday
ORDER BY v.is_black_friday DESC;

-- =====================================================
-- QUESTÃO 9: Existe alguma correlação entre o tamanho 
-- do desconto e o volume de vendas do produto?
-- =====================================================

SELECT 
    CASE 
        WHEN ((p.preco_original - p.preco_black_friday) / p.preco_original * 100) < 20 THEN 'Desconto Baixo (< 20%)'
        WHEN ((p.preco_original - p.preco_black_friday) / p.preco_original * 100) < 35 THEN 'Desconto Médio (20-35%)'
        ELSE 'Desconto Alto (> 35%)'
    END AS faixa_desconto,
    COUNT(DISTINCT p.id_produto) AS numero_produtos,
    SUM(iv.quantidade) AS total_unidades_vendidas,
    ROUND(AVG(iv.quantidade), 2) AS media_unidades_por_produto,
    ROUND(SUM(iv.subtotal), 2) AS receita_total
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id_venda
JOIN produtos p ON iv.id_produto = p.id_produto
WHERE v.is_black_friday = TRUE AND p.preco_black_friday IS NOT NULL
GROUP BY faixa_desconto
ORDER BY 
    CASE faixa_desconto
        WHEN 'Desconto Baixo (< 20%)' THEN 1
        WHEN 'Desconto Médio (20-35%)' THEN 2
        ELSE 3
    END;

-- =====================================================
-- QUESTÃO 10: Quais clientes compraram na Black Friday 
-- mas não compraram antes ou depois?
-- =====================================================

SELECT 
    cl.nome_cliente,
    cl.email,
    cl.cidade,
    cl.estado,
    COUNT(v.id_venda) AS compras_black_friday,
    ROUND(SUM(v.valor_total), 2) AS valor_total_gasto
FROM clientes cl
JOIN vendas v ON cl.id_cliente = v.id_cliente
WHERE v.is_black_friday = TRUE
  AND cl.id_cliente NOT IN (
      SELECT DISTINCT id_cliente 
      FROM vendas 
      WHERE is_black_friday = FALSE
  )
GROUP BY cl.id_cliente, cl.nome_cliente, cl.email, cl.cidade, cl.estado
ORDER BY valor_total_gasto DESC;

-- =====================================================
-- QUESTÃO 11: Qual foi o ticket médio por estado 
-- durante a Black Friday?
-- =====================================================

SELECT 
    cl.estado,
    COUNT(v.id_venda) AS numero_vendas,
    COUNT(DISTINCT cl.id_cliente) AS clientes_unicos,
    ROUND(SUM(v.valor_total), 2) AS receita_total,
    ROUND(AVG(v.valor_total), 2) AS ticket_medio,
    ROUND(SUM(v.valor_total) / COUNT(DISTINCT cl.id_cliente), 2) AS gasto_medio_por_cliente
FROM vendas v
JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE v.is_black_friday = TRUE
GROUP BY cl.estado
ORDER BY receita_total DESC;

-- =====================================================
-- QUESTÃO 12: Qual a taxa de conversão de vendas 
-- por categoria na Black Friday?
-- =====================================================

SELECT 
    c.nome_categoria,
    COUNT(DISTINCT p.id_produto) AS produtos_disponiveis,
    COUNT(DISTINCT iv.id_produto) AS produtos_vendidos,
    ROUND(COUNT(DISTINCT iv.id_produto) * 100.0 / COUNT(DISTINCT p.id_produto), 2) AS taxa_conversao_produtos,
    SUM(iv.quantidade) AS total_unidades_vendidas,
    ROUND(SUM(iv.subtotal), 2) AS receita_categoria
FROM categorias c
JOIN produtos p ON c.id_categoria = p.id_categoria
LEFT JOIN itens_venda iv ON p.id_produto = iv.id_produto
LEFT JOIN vendas v ON iv.id_venda = v.id_venda AND v.is_black_friday = TRUE
GROUP BY c.id_categoria, c.nome_categoria
ORDER BY receita_categoria DESC;

-- =====================================================
-- QUESTÃO 13: Qual seria a receita se não houvesse 
-- descontos? Análise de oportunidade perdida.
-- =====================================================

SELECT 
    'Black Friday com Desconto' AS cenario,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita_real,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM vendas
WHERE is_black_friday = TRUE

UNION ALL

SELECT 
    'Black Friday sem Desconto (Teórico)' AS cenario,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total + desconto_aplicado), 2) AS receita_teorica,
    ROUND(AVG(valor_total + desconto_aplicado), 2) AS ticket_medio
FROM vendas
WHERE is_black_friday = TRUE

UNION ALL

SELECT 
    'Diferença (Custo do Desconto)' AS cenario,
    NULL AS numero_vendas,
    ROUND(SUM(desconto_aplicado), 2) AS custo_desconto,
    NULL AS ticket_medio
FROM vendas
WHERE is_black_friday = TRUE;

-- =====================================================
-- QUESTÃO 14: Comparação de Performance: 
-- Primeiro dia vs Último dia da Black Friday
-- =====================================================

SELECT 
    CASE 
        WHEN data_venda >= '2023-11-24 00:00:00' AND data_venda < '2023-11-25 00:00:00' THEN 'Primeiro Dia (24/11)'
        WHEN data_venda >= '2023-11-27 00:00:00' AND data_venda < '2023-11-28 00:00:00' THEN 'Último Dia (27/11)'
    END AS dia,
    COUNT(*) AS numero_vendas,
    ROUND(SUM(valor_total), 2) AS receita,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    ROUND(SUM(desconto_aplicado), 2) AS descontos_concedidos
FROM vendas
WHERE is_black_friday = TRUE
    AND (
        (data_venda >= '2023-11-24 00:00:00' AND data_venda < '2023-11-25 00:00:00')
        OR
        (data_venda >= '2023-11-27 00:00:00' AND data_venda < '2023-11-28 00:00:00')
    )
GROUP BY dia
ORDER BY dia;

-- =====================================================
-- QUESTÃO 15: Resumo Executivo Completo - Dashboard
-- =====================================================

-- KPIs Principais da Black Friday
SELECT 'KPIs PRINCIPAIS DA BLACK FRIDAY' AS secao, '' AS metrica, '' AS valor
UNION ALL
SELECT '', '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', ''
UNION ALL
SELECT '', 'Total de Vendas', CAST(COUNT(*) AS CHAR)
FROM vendas WHERE is_black_friday = TRUE
UNION ALL
SELECT '', 'Receita Total', CONCAT('R$ ', FORMAT(SUM(valor_total), 2, 'pt_BR'))
FROM vendas WHERE is_black_friday = TRUE
UNION ALL
SELECT '', 'Ticket Médio', CONCAT('R$ ', FORMAT(AVG(valor_total), 2, 'pt_BR'))
FROM vendas WHERE is_black_friday = TRUE
UNION ALL
SELECT '', 'Total de Descontos', CONCAT('R$ ', FORMAT(SUM(desconto_aplicado), 2, 'pt_BR'))
FROM vendas WHERE is_black_friday = TRUE
UNION ALL
SELECT '', 'Clientes Únicos', CAST(COUNT(DISTINCT id_cliente) AS CHAR)
FROM vendas WHERE is_black_friday = TRUE
UNION ALL
SELECT '', 'Produtos Vendidos', CAST(SUM(iv.quantidade) AS CHAR)
FROM itens_venda iv JOIN vendas v ON iv.id_venda = v.id_venda WHERE v.is_black_friday = TRUE;
