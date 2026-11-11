-- 09 - Projeto Empresa: criacao das tabelas e dados iniciais
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;

-- Remover tabelas filhas antes das tabelas maes.
DROP TABLE IF EXISTS Promocao;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Identificacao;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Filial;
DROP TABLE IF EXISTS Fornecedor;

CREATE TABLE Fornecedor (
    cnpj VARCHAR(14) NOT NULL,
    nome VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL UNIQUE,
    endereco VARCHAR(200) NOT NULL,
    PRIMARY KEY (cnpj)
);

CREATE TABLE Filial (
    cnpj VARCHAR(14) NOT NULL DEFAULT '10101010000110',
    nome VARCHAR(100) NOT NULL UNIQUE DEFAULT 'Filial Centro',
    telefone VARCHAR(15) NOT NULL UNIQUE DEFAULT '3140001010',
    endereco VARCHAR(200) NOT NULL DEFAULT 'Rua Tupis, 50 - Belo Horizonte/MG',
    PRIMARY KEY (cnpj)
);

CREATE TABLE Produto (
    id INT AUTO_INCREMENT,
    cnpj_fornecedor VARCHAR(14) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (cnpj_fornecedor) REFERENCES Fornecedor(cnpj)
);

CREATE TABLE Identificacao (
    id INT NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    observacao VARCHAR(200) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Produto(id)
);

CREATE TABLE Estoque (
    id_produto INT NOT NULL,
    cnpj_filial VARCHAR(14) NOT NULL,
    preco DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (preco >= 0),
    quantidade INT NOT NULL DEFAULT 0,
    validade DATE NOT NULL,
    PRIMARY KEY (id_produto, cnpj_filial),
    FOREIGN KEY (id_produto) REFERENCES Produto(id),
    FOREIGN KEY (cnpj_filial) REFERENCES Filial(cnpj),
    CONSTRAINT check_validade_minima CHECK (validade > '1900-01-01')
);

DESCRIBE Fornecedor;
DESCRIBE Filial;
DESCRIBE Produto;
DESCRIBE Identificacao;
DESCRIBE Estoque;

INSERT INTO Fornecedor (cnpj, nome, telefone, endereco) VALUES
('11111111000101', 'Distribuidora Alfa Ltda', '3132221111', 'Rua das Flores, 100 - Belo Horizonte/MG'),
('22222222000102', 'Comercial Beta S.A.', '3132222222', 'Av. Brasil, 200 - Belo Horizonte/MG'),
('33333333000103', 'Gama Alimentos Ltda', '3132223333', 'Rua da Bahia, 300 - Belo Horizonte/MG'),
('44444444000104', 'Delta Bebidas Ltda', '3132224444', 'Av. Afonso Pena, 400 - Belo Horizonte/MG'),
('55555555000105', 'Epsilon Higiene e Limpeza Ltda', '3132225555', 'Rua Curitiba, 500 - Belo Horizonte/MG'),
('66666666000106', 'Zeta Papelaria ME', '3132226666', 'Rua Rio de Janeiro, 600 - Belo Horizonte/MG'),
('77777777000107', 'Eta Eletrônicos Ltda', '3132227777', 'Rua Curitiba, 700 - Belo Horizonte/MG'),
('88888888000108', 'Theta Móveis e Decoração Ltda', '3132228888', 'Av. do Contorno, 800 - Belo Horizonte/MG');

-- Insere a Filial Centro com todos os valores DEFAULT.
INSERT INTO Filial () VALUES ();
INSERT INTO Filial (cnpj, nome, telefone, endereco) VALUES
('20202020000120', 'Filial Savassi', '3140002020', 'Rua Pernambuco, 400 - Belo Horizonte/MG'),
('30303030000130', 'Filial Contagem', '3140003030', 'Av. João César de Oliveira, 1000 - Contagem/MG');

INSERT INTO Produto (id, cnpj_fornecedor, nome) VALUES
(1, '11111111000101', 'Arroz Tipo 1 5kg'),
(2, '11111111000101', 'Feijao Carioca 1kg'),
(3, '22222222000102', 'Refrigerante Cola 2L'),
(4, '33333333000103', 'Macarrao Espaguete'),
(5, '44444444000104', 'Suco de Laranja 1L'),
(6, '77777777000107', 'Fone de Ouvido Bluetooth');

INSERT INTO Identificacao (id, descricao, observacao) VALUES
(1, 'Arroz branco tipo 1, pacote de 5kg', 'Produto de giro rápido, alta demanda'),
(2, 'Feijao carioca tipo 1, pacote de 1kg', 'Sensível à umidade, armazenar em local seco'),
(3, 'Refrigerante sabor cola, garrafa de 2 litros', 'Manter refrigerado apos aberto'),
(4, 'Macarrao tipo espaguete, pacote 500g', 'Sem glúten disponível sob encomenda'),
(5, 'Suco de laranja integral, garrafa 1 litro', 'Sem conservantes, validade curta'),
(6, 'Fone de ouvido bluetooth intra-auricular', 'Garantia de 12 meses do fabricante');

INSERT INTO Estoque (id_produto, cnpj_filial, preco, quantidade, validade) VALUES
(1, '10101010000110', 22.90, 50, '2027-01-15'),
(1, '20202020000120', 23.50, 30, '2027-01-15'),
(2, '10101010000110', 8.90, 100, '2026-11-01'),
(3, '10101010000110', 6.50, 80, '2026-09-30'),
(3, '20202020000120', 6.90, 40, '2026-09-30'),
(4, '10101010000110', 12.50, 40, '2026-12-20'),
(5, '20202020000120', 9.90, 25, '2026-10-05'),
(6, '10101010000110', 199.90, 15, '2027-06-01'),
(6, '20202020000120', 209.90, 10, '2027-06-01');

-- Preco DEFAULT zero.
INSERT INTO Estoque (id_produto, cnpj_filial, quantidade, validade) VALUES
(1, '30303030000130', 6, '2027-01-15'),
(3, '30303030000130', 7, '2026-09-30');
-- Quantidade DEFAULT zero.
INSERT INTO Estoque (id_produto, cnpj_filial, preco, validade) VALUES
(5, '30303030000130', 9.90, '2026-10-05');
-- Preco e quantidade DEFAULT zero.
INSERT INTO Estoque (id_produto, cnpj_filial, validade) VALUES
(6, '30303030000130', '2027-06-01');

SELECT * FROM Fornecedor;
SELECT * FROM Filial;
SELECT * FROM Produto;
SELECT * FROM Identificacao;
SELECT * FROM Estoque;
