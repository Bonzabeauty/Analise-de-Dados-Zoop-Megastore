-- =====================================================
-- SANITY CHECK - Validação de Integridade dos Dados
-- Zoop Megastore - Black Friday
-- =====================================================
-- Este script valida a carga de dados e integridade
-- básica do banco de dados após a execução dos scripts
-- de schema e carga de dados.
-- =====================================================

USE zoop_megastore;

-- =====================================================
-- 1. VALIDAÇÃO DE CARGA DE DADOS
-- =====================================================

SELECT '========================================' AS '';
SELECT 'VALIDAÇÃO DE CARGA DE DADOS' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

-- 1.1. Contagem de registros por tabela
SELECT 'Contagem de Registros:' AS '';
SELECT '  - Categorias' AS tabela, COUNT(*) AS registros, '8 esperado' AS status FROM categorias
UNION ALL
SELECT '  - Produtos', COUNT(*), '28 esperado' FROM produtos
UNION ALL
SELECT '  - Clientes', COUNT(*), '15 esperado' FROM clientes
UNION ALL
SELECT '  - Vendas', COUNT(*), '30 esperado' FROM vendas
UNION ALL
SELECT '  - Itens de Venda', COUNT(*), '60+ esperado' FROM itens_venda;

SELECT '' AS '';

-- 1.2. Validação de vendas Black Friday vs Normal
SELECT 'Distribuição de Vendas:' AS '';
SELECT 
    CONCAT('  - ', CASE WHEN is_black_friday = TRUE THEN 'Black Friday' ELSE 'Período Normal' END) AS tipo,
    COUNT(*) AS vendas,
    CONCAT(CASE 
        WHEN is_black_friday = TRUE AND COUNT(*) = 20 THEN '✓ OK (20 esperado)'
        WHEN is_black_friday = FALSE AND COUNT(*) = 10 THEN '✓ OK (10 esperado)'
        ELSE '✗ ERRO'
    END) AS status
FROM vendas
GROUP BY is_black_friday;

SELECT '' AS '';

-- =====================================================
-- 2. VALIDAÇÃO DE INTEGRIDADE REFERENCIAL
-- =====================================================

SELECT '========================================' AS '';
SELECT 'VALIDAÇÃO DE INTEGRIDADE REFERENCIAL' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

-- 2.1. Produtos sem categoria
SELECT 'Produtos sem Categoria:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todos os produtos têm categoria'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' produto(s) sem categoria')
    END AS status
FROM produtos p
LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE c.id_categoria IS NULL;

SELECT '' AS '';

-- 2.2. Vendas sem cliente
SELECT 'Vendas sem Cliente:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todas as vendas têm cliente'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' venda(s) sem cliente')
    END AS status
FROM vendas v
LEFT JOIN clientes cl ON v.id_cliente = cl.id_cliente
WHERE cl.id_cliente IS NULL;

SELECT '' AS '';

-- 2.3. Itens de venda órfãos
SELECT 'Itens de Venda sem Venda ou Produto:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todos os itens têm venda e produto associados'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' item(ns) órfão(s)')
    END AS status
FROM itens_venda iv
LEFT JOIN vendas v ON iv.id_venda = v.id_venda
LEFT JOIN produtos p ON iv.id_produto = p.id_produto
WHERE v.id_venda IS NULL OR p.id_produto IS NULL;

SELECT '' AS '';

-- =====================================================
-- 3. VALIDAÇÃO DE CONSISTÊNCIA DE DADOS
-- =====================================================

SELECT '========================================' AS '';
SELECT 'VALIDAÇÃO DE CONSISTÊNCIA DE DADOS' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

-- 3.1. Vendas com valores inconsistentes
SELECT 'Vendas com Valor Total Negativo ou Zero:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todas as vendas têm valores válidos'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' venda(s) com valor inválido')
    END AS status
FROM vendas
WHERE valor_total <= 0;

SELECT '' AS '';

-- 3.2. Produtos com preços inconsistentes
SELECT 'Produtos com Preços Inválidos:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todos os produtos têm preços válidos'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' produto(s) com preço inválido')
    END AS status
FROM produtos
WHERE preco_original <= 0 
   OR (preco_black_friday IS NOT NULL AND preco_black_friday <= 0)
   OR (preco_black_friday IS NOT NULL AND preco_black_friday > preco_original);

SELECT '' AS '';

-- 3.3. Itens com quantidade ou preços inválidos
SELECT 'Itens com Quantidade ou Preços Inválidos:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todos os itens têm valores válidos'
        ELSE CONCAT('  ✗ ERRO - ', COUNT(*), ' item(ns) com valores inválidos')
    END AS status
FROM itens_venda
WHERE quantidade <= 0 
   OR preco_unitario <= 0 
   OR subtotal <= 0
   OR ABS(subtotal - (quantidade * preco_unitario)) > 0.01;

SELECT '' AS '';

-- 3.4. Clientes com emails duplicados
SELECT 'Clientes com Emails Duplicados:' AS '';
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todos os emails são únicos'
        ELSE CONCAT('  ✗ AVISO - ', COUNT(*), ' email(s) duplicado(s)')
    END AS status
FROM (
    SELECT email, COUNT(*) as cnt
    FROM clientes
    GROUP BY email
    HAVING cnt > 1
) AS duplicados;

SELECT '' AS '';

-- =====================================================
-- 4. VALIDAÇÃO DE DADOS BLACK FRIDAY
-- =====================================================

SELECT '========================================' AS '';
SELECT 'VALIDAÇÃO ESPECÍFICA BLACK FRIDAY' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

-- 4.1. Vendas Black Friday com desconto zero
SELECT 'Vendas Black Friday sem Desconto:' AS '';
SELECT 
    COUNT(*) AS quantidade,
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todas as vendas BF têm desconto'
        ELSE '  ⚠ AVISO - Algumas vendas BF sem desconto aplicado'
    END AS status
FROM vendas
WHERE is_black_friday = TRUE AND desconto_aplicado = 0;

SELECT '' AS '';

-- 4.2. Datas de vendas Black Friday fora do período esperado
SELECT 'Vendas Black Friday Fora do Período (24-27 Nov 2023):' AS '';
SELECT 
    COUNT(*) AS quantidade,
    CASE 
        WHEN COUNT(*) = 0 THEN '  ✓ OK - Todas as vendas BF no período correto'
        ELSE '  ⚠ AVISO - Algumas vendas BF fora do período'
    END AS status
FROM vendas
WHERE is_black_friday = TRUE 
  AND (DATE(data_venda) < '2023-11-24' OR DATE(data_venda) > '2023-11-27');

SELECT '' AS '';

-- =====================================================
-- 5. ESTATÍSTICAS GERAIS
-- =====================================================

SELECT '========================================' AS '';
SELECT 'ESTATÍSTICAS GERAIS' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

-- 5.1. Resumo de vendas
SELECT 'Resumo de Vendas:' AS '';
SELECT 
    CONCAT('  - Total de Vendas: ', COUNT(*)) AS metrica
FROM vendas
UNION ALL
SELECT CONCAT('  - Receita Total: R$ ', FORMAT(SUM(valor_total), 2, 'pt_BR'))
FROM vendas
UNION ALL
SELECT CONCAT('  - Ticket Médio: R$ ', FORMAT(AVG(valor_total), 2, 'pt_BR'))
FROM vendas
UNION ALL
SELECT CONCAT('  - Total de Descontos: R$ ', FORMAT(SUM(desconto_aplicado), 2, 'pt_BR'))
FROM vendas;

SELECT '' AS '';

-- 5.2. Produtos mais vendidos (top 5)
SELECT 'Top 5 Produtos Mais Vendidos:' AS '';
SELECT 
    CONCAT('  ', ROW_NUMBER() OVER (ORDER BY SUM(iv.quantidade) DESC), '. ', p.nome_produto, ' (', SUM(iv.quantidade), ' unidades)') AS produto
FROM itens_venda iv
JOIN produtos p ON iv.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome_produto
ORDER BY SUM(iv.quantidade) DESC
LIMIT 5;

SELECT '' AS '';

-- 5.3. Distribuição de clientes por estado (top 5)
SELECT 'Top 5 Estados com Mais Clientes:' AS '';
SELECT 
    CONCAT('  ', estado, ': ', COUNT(*), ' cliente(s)') AS distribuicao
FROM clientes
GROUP BY estado
ORDER BY COUNT(*) DESC
LIMIT 5;

SELECT '' AS '';

-- =====================================================
-- 6. VALIDAÇÃO DE ÍNDICES
-- =====================================================

SELECT '========================================' AS '';
SELECT 'VALIDAÇÃO DE ÍNDICES' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

SELECT 'Índices Criados:' AS '';
SELECT 
    CONCAT('  - ', TABLE_NAME, '.', INDEX_NAME, ' (', COLUMN_NAME, ')') AS indice
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'zoop_megastore'
  AND TABLE_NAME IN ('vendas', 'itens_venda', 'produtos', 'clientes', 'categorias')
  AND INDEX_NAME != 'PRIMARY'
ORDER BY TABLE_NAME, INDEX_NAME;

SELECT '' AS '';

-- =====================================================
-- RESUMO FINAL
-- =====================================================

SELECT '========================================' AS '';
SELECT 'RESUMO DA VALIDAÇÃO' AS '';
SELECT '========================================' AS '';
SELECT '' AS '';

SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM categorias) = 8
         AND (SELECT COUNT(*) FROM produtos) = 28
         AND (SELECT COUNT(*) FROM clientes) = 15
         AND (SELECT COUNT(*) FROM vendas) = 30
         AND (SELECT COUNT(*) FROM itens_venda) >= 60
        THEN '✓✓✓ BANCO DE DADOS VALIDADO COM SUCESSO ✓✓✓'
        ELSE '✗✗✗ PROBLEMAS DETECTADOS - REVISAR ACIMA ✗✗✗'
    END AS resultado;

SELECT '' AS '';
SELECT 'Execute as análises com:' AS '';
SELECT '  mysql -u root -p zoop_megastore < 03_analises_black_friday.sql' AS comando;
SELECT '' AS '';
SELECT '========================================' AS '';

