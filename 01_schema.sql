-- =====================================================
-- Schema da Base de Dados - Zoop Megastore
-- Análise de Vendas para Black Friday
-- =====================================================

-- Criar database
CREATE DATABASE IF NOT EXISTS zoop_megastore;
USE zoop_megastore;

-- Tabela de Categorias de Produtos
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de Produtos
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(200) NOT NULL,
    id_categoria INT,
    preco_original DECIMAL(10, 2) NOT NULL,
    preco_black_friday DECIMAL(10, 2),
    estoque INT DEFAULT 0,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE,
    telefone VARCHAR(20),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    data_cadastro DATE NOT NULL
);

-- Tabela de Vendas
CREATE TABLE IF NOT EXISTS vendas (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_venda DATETIME NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    desconto_aplicado DECIMAL(10, 2) DEFAULT 0,
    forma_pagamento VARCHAR(50),
    status_venda VARCHAR(50) DEFAULT 'Concluída',
    is_black_friday BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Tabela de Itens da Venda
CREATE TABLE IF NOT EXISTS itens_venda (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Índices para melhorar performance das consultas
CREATE INDEX idx_vendas_data ON vendas(data_venda);
CREATE INDEX idx_vendas_cliente ON vendas(id_cliente);
CREATE INDEX idx_vendas_black_friday ON vendas(is_black_friday);
CREATE INDEX idx_itens_venda ON itens_venda(id_venda);
CREATE INDEX idx_itens_produto ON itens_venda(id_produto);
