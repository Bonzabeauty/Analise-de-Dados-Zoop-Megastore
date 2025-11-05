-- =====================================================
-- Inserção de Dados de Exemplo - Zoop Megastore
-- Base de Dados para Análise de Black Friday
-- =====================================================

USE zoop_megastore;

-- Inserir Categorias
INSERT INTO categorias (nome_categoria, descricao) VALUES
('Eletrônicos', 'Produtos eletrônicos como TVs, notebooks, smartphones'),
('Eletrodomésticos', 'Eletrodomésticos para casa como geladeiras, fogões'),
('Utensílios', 'Utensílios domésticos diversos'),
('Alimentos', 'Produtos alimentícios não perecíveis'),
('Móveis', 'Móveis para casa e escritório'),
('Esportes', 'Artigos esportivos e fitness'),
('Livros', 'Livros e material educativo'),
('Moda', 'Roupas, calçados e acessórios');

-- Inserir Produtos
INSERT INTO produtos (nome_produto, id_categoria, preco_original, preco_black_friday, estoque) VALUES
-- Eletrônicos
('Smart TV 55 Polegadas', 1, 2999.99, 1999.99, 150),
('Notebook Intel Core i5', 1, 3499.99, 2499.99, 80),
('Smartphone Android 128GB', 1, 1899.99, 1299.99, 200),
('Fone de Ouvido Bluetooth', 1, 299.99, 199.99, 300),
('Tablet 10 Polegadas', 1, 1299.99, 899.99, 120),

-- Eletrodomésticos
('Geladeira Frost Free 400L', 2, 2799.99, 1999.99, 60),
('Micro-ondas 30L', 2, 599.99, 399.99, 100),
('Máquina de Lavar 12kg', 2, 1899.99, 1399.99, 50),
('Cafeteira Elétrica', 2, 249.99, 149.99, 200),
('Liquidificador', 2, 189.99, 119.99, 150),

-- Utensílios
('Jogo de Panelas 5 Peças', 3, 399.99, 249.99, 180),
('Kit Facas Profissional', 3, 299.99, 199.99, 150),
('Conjunto de Potes', 3, 89.99, 49.99, 250),
('Tábua de Corte em Bambu', 3, 59.99, 39.99, 300),

-- Alimentos
('Cesta de Café da Manhã Premium', 4, 199.99, 149.99, 100),
('Kit Temperos Gourmet', 4, 89.99, 59.99, 200),
('Azeite Extra Virgem 500ml', 4, 49.99, 34.99, 300),

-- Móveis
('Mesa de Jantar 6 Lugares', 5, 1499.99, 999.99, 40),
('Cadeira Escritório Ergonômica', 5, 899.99, 599.99, 80),
('Estante para Livros', 5, 499.99, 349.99, 60),

-- Esportes
('Bicicleta Mountain Bike', 6, 1799.99, 1299.99, 50),
('Kit Halteres 20kg', 6, 299.99, 199.99, 100),
('Esteira Elétrica', 6, 2499.99, 1799.99, 30),

-- Livros
('Box Clássicos da Literatura', 7, 149.99, 99.99, 150),
('Livro Best-seller Nacional', 7, 49.99, 34.99, 250),

-- Moda
('Tênis Esportivo', 8, 299.99, 199.99, 200),
('Jaqueta de Couro', 8, 599.99, 399.99, 100),
('Bolsa Feminina', 8, 249.99, 149.99, 150);

-- Inserir Clientes
INSERT INTO clientes (nome_cliente, email, telefone, cidade, estado, data_cadastro) VALUES
('João Silva', 'joao.silva@email.com', '11987654321', 'São Paulo', 'SP', '2023-01-15'),
('Maria Santos', 'maria.santos@email.com', '11976543210', 'São Paulo', 'SP', '2023-02-20'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '21987654321', 'Rio de Janeiro', 'RJ', '2023-03-10'),
('Ana Costa', 'ana.costa@email.com', '31987654321', 'Belo Horizonte', 'MG', '2023-04-05'),
('Carlos Souza', 'carlos.souza@email.com', '41987654321', 'Curitiba', 'PR', '2023-05-12'),
('Juliana Lima', 'juliana.lima@email.com', '51987654321', 'Porto Alegre', 'RS', '2023-06-08'),
('Roberto Ferreira', 'roberto.ferreira@email.com', '61987654321', 'Brasília', 'DF', '2023-07-20'),
('Fernanda Alves', 'fernanda.alves@email.com', '71987654321', 'Salvador', 'BA', '2023-08-15'),
('Lucas Martins', 'lucas.martins@email.com', '81987654321', 'Recife', 'PE', '2023-09-10'),
('Patricia Rocha', 'patricia.rocha@email.com', '85987654321', 'Fortaleza', 'CE', '2023-10-05'),
('Ricardo Dias', 'ricardo.dias@email.com', '11965432109', 'São Paulo', 'SP', '2023-01-25'),
('Camila Ribeiro', 'camila.ribeiro@email.com', '11954321098', 'São Paulo', 'SP', '2023-02-28'),
('Bruno Carvalho', 'bruno.carvalho@email.com', '21976543210', 'Rio de Janeiro', 'RJ', '2023-03-18'),
('Amanda Silva', 'amanda.silva@email.com', '31965432109', 'Belo Horizonte', 'MG', '2023-04-22'),
('Felipe Santos', 'felipe.santos@email.com', '41954321098', 'Curitiba', 'PR', '2023-05-30');

-- Inserir Vendas (incluindo período de Black Friday e períodos normais)
-- Vendas antes da Black Friday (Outubro 2023)
INSERT INTO vendas (id_cliente, data_venda, valor_total, desconto_aplicado, forma_pagamento, is_black_friday) VALUES
(1, '2023-10-15 10:30:00', 2999.99, 0, 'Cartão de Crédito', FALSE),
(2, '2023-10-16 14:20:00', 599.99, 0, 'PIX', FALSE),
(3, '2023-10-18 11:45:00', 1899.99, 0, 'Cartão de Débito', FALSE),
(4, '2023-10-20 16:30:00', 399.99, 0, 'Boleto', FALSE),
(5, '2023-10-22 09:15:00', 249.99, 0, 'Cartão de Crédito', FALSE);

-- Vendas durante Black Friday (24-27 Novembro 2023)
INSERT INTO vendas (id_cliente, data_venda, valor_total, desconto_aplicado, forma_pagamento, is_black_friday) VALUES
(1, '2023-11-24 08:00:00', 4499.98, 1500.00, 'Cartão de Crédito', TRUE),
(2, '2023-11-24 09:30:00', 2599.98, 800.00, 'PIX', TRUE),
(3, '2023-11-24 10:15:00', 1999.99, 1000.00, 'Cartão de Crédito', TRUE),
(4, '2023-11-24 11:45:00', 1649.98, 550.00, 'Cartão de Crédito', TRUE),
(5, '2023-11-24 13:20:00', 1399.99, 500.00, 'PIX', TRUE),
(6, '2023-11-24 14:30:00', 1299.99, 600.00, 'Cartão de Débito', TRUE),
(7, '2023-11-24 15:45:00', 999.99, 500.00, 'Cartão de Crédito', TRUE),
(8, '2023-11-25 09:00:00', 2899.98, 1000.00, 'Cartão de Crédito', TRUE),
(9, '2023-11-25 10:30:00', 599.99, 300.00, 'PIX', TRUE),
(10, '2023-11-25 12:00:00', 1799.99, 700.00, 'Cartão de Crédito', TRUE),
(11, '2023-11-25 14:20:00', 1049.98, 400.00, 'Cartão de Débito', TRUE),
(12, '2023-11-25 16:00:00', 899.99, 400.00, 'PIX', TRUE),
(13, '2023-11-26 08:30:00', 3499.98, 1200.00, 'Cartão de Crédito', TRUE),
(14, '2023-11-26 11:00:00', 749.98, 300.00, 'PIX', TRUE),
(15, '2023-11-26 13:45:00', 1999.99, 800.00, 'Cartão de Crédito', TRUE),
(1, '2023-11-26 15:30:00', 449.98, 200.00, 'Cartão de Débito', TRUE),
(2, '2023-11-27 09:15:00', 2499.99, 1000.00, 'Cartão de Crédito', TRUE),
(3, '2023-11-27 11:30:00', 549.98, 250.00, 'PIX', TRUE),
(4, '2023-11-27 14:00:00', 1299.99, 500.00, 'Cartão de Crédito', TRUE),
(5, '2023-11-27 16:45:00', 699.98, 300.00, 'Cartão de Débito', TRUE);

-- Vendas depois da Black Friday (Dezembro 2023)
INSERT INTO vendas (id_cliente, data_venda, valor_total, desconto_aplicado, forma_pagamento, is_black_friday) VALUES
(6, '2023-12-05 10:00:00', 2999.99, 0, 'Cartão de Crédito', FALSE),
(7, '2023-12-08 14:30:00', 1299.99, 0, 'PIX', FALSE),
(8, '2023-12-10 11:20:00', 899.99, 0, 'Cartão de Débito', FALSE),
(9, '2023-12-12 15:45:00', 499.99, 0, 'Boleto', FALSE),
(10, '2023-12-15 09:30:00', 1899.99, 0, 'Cartão de Crédito', FALSE);

-- Inserir Itens das Vendas (Outubro - antes da Black Friday)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(1, 1, 1, 2999.99, 2999.99),
(2, 7, 1, 599.99, 599.99),
(3, 8, 1, 1899.99, 1899.99),
(4, 11, 1, 399.99, 399.99),
(5, 9, 1, 249.99, 249.99);

-- Inserir Itens das Vendas (Black Friday - 24 Nov)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(6, 2, 1, 2499.99, 2499.99),
(6, 1, 1, 1999.99, 1999.99),
(7, 6, 1, 1999.99, 1999.99),
(7, 9, 4, 149.99, 599.98),
(8, 1, 1, 1999.99, 1999.99),
(9, 3, 1, 1299.99, 1299.99),
(9, 4, 1, 199.99, 199.99),
(9, 16, 1, 149.99, 149.99),
(10, 8, 1, 1399.99, 1399.99),
(11, 3, 1, 1299.99, 1299.99),
(12, 18, 1, 999.99, 999.99);

-- Inserir Itens das Vendas (Black Friday - 25 Nov)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(13, 2, 1, 2499.99, 2499.99),
(13, 16, 2, 149.99, 299.98),
(13, 24, 1, 99.99, 99.99),
(14, 19, 1, 599.99, 599.99),
(15, 21, 1, 1799.99, 1799.99),
(16, 22, 1, 199.99, 199.99),
(16, 26, 5, 49.99, 249.99),
(17, 10, 1, 899.99, 899.99);

-- Inserir Itens das Vendas (Black Friday - 26 Nov)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(18, 1, 1, 1999.99, 1999.99),
(18, 2, 1, 2499.99, 2499.99),
(18, 4, 5, 199.99, 999.95),
(19, 11, 1, 249.99, 249.99),
(19, 12, 1, 199.99, 199.99),
(19, 13, 5, 49.99, 249.95),
(19, 14, 1, 39.99, 39.99),
(20, 6, 1, 1999.99, 1999.99),
(21, 25, 2, 199.99, 399.98),
(21, 14, 1, 39.99, 39.99),
(21, 17, 1, 59.99, 59.99);

-- Inserir Itens das Vendas (Black Friday - 27 Nov)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(22, 2, 1, 2499.99, 2499.99),
(23, 9, 1, 149.99, 149.99),
(23, 16, 2, 149.99, 299.98),
(23, 24, 1, 99.99, 99.99),
(24, 3, 1, 1299.99, 1299.99),
(25, 19, 1, 599.99, 599.99),
(25, 24, 1, 99.99, 99.99);

-- Inserir Itens das Vendas (Dezembro - depois da Black Friday)
INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario, subtotal) VALUES
(26, 1, 1, 2999.99, 2999.99),
(27, 3, 1, 1299.99, 1299.99),
(28, 19, 1, 899.99, 899.99),
(29, 20, 1, 499.99, 499.99),
(30, 8, 1, 1899.99, 1899.99);
