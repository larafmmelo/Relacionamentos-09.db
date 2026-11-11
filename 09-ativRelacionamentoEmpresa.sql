-- 09 - Projeto Empresa: exercicios
-- Execute depois de exemplo_projeto_empresa.sql.
USE empresa;

-- 1) O INSERT da apostila conflita com o CNPJ ja cadastrado (PK duplicada).
-- Alem disso, ao omitir telefone, o DEFAULT '3140001010' tambem conflita
-- com a restricao UNIQUE da Filial Centro. Para testar o segundo conflito
-- isoladamente, use CNPJ novo (este comando falhara pelo telefone repetido):
-- INSERT INTO Filial (cnpj, nome, endereco)
-- VALUES ('40404040000140', 'Filial Teste', 'Rua Teste, 10 - Belo Horizonte/MG');

-- 2) Estoque com preco zero.
SELECT * FROM Estoque WHERE preco = 0;
-- 3) Estoque com quantidade zero.
SELECT * FROM Estoque WHERE quantidade = 0;
-- 4) Preco e quantidade iguais a zero.
SELECT * FROM Estoque WHERE preco = 0 AND quantidade = 0;
-- 5) Dados da Filial Savassi.
SELECT * FROM Filial WHERE nome = 'Filial Savassi';
-- 6) Produtos do fornecedor informado.
SELECT * FROM Produto WHERE cnpj_fornecedor = '11111111000101';
-- 7) Produtos com validade 2026-09-30 (por meio do estoque).
SELECT p.*, e.cnpj_filial, e.validade
FROM Produto p INNER JOIN Estoque e ON p.id = e.id_produto
WHERE e.validade = '2026-09-30';
-- 8) Validade posterior a 2026-09-30 e anterior a 2027-01-15.
SELECT * FROM Estoque
WHERE validade > '2026-09-30' AND validade < '2027-01-15';
-- 9) Validade posterior a 2027-01-01.
SELECT * FROM Estoque WHERE validade > '2027-01-01';
-- 10) Validade anterior a 2026-10-01.
SELECT * FROM Estoque WHERE validade < '2026-10-01';
-- 11) Identificacoes com a expressao alta demanda.
SELECT * FROM Identificacao WHERE observacao LIKE '%alta demanda%';
-- 12) Identificacoes sob encomenda.
SELECT * FROM Identificacao WHERE observacao LIKE '%sob encomenda%';
-- 13) Identificacoes sem gluten ou sem conservante.
SELECT * FROM Identificacao
WHERE observacao LIKE '%sem glúten%' OR observacao LIKE '%sem conservante%';
-- 14) Produtos vendidos por quilograma.
SELECT * FROM Produto WHERE nome LIKE '%kg%';
-- 15) Filiais que nao estao em Belo Horizonte.
SELECT * FROM Filial WHERE endereco NOT LIKE '%Belo Horizonte%';

-- 16) Testes de CHECK: devem gerar erro em MySQL 8.0.16 ou superior.
-- UPDATE Estoque SET preco = -1.00
-- WHERE id_produto = 1 AND cnpj_filial = '10101010000110';
-- 17) Validade anterior a 1900: deve gerar erro.
-- UPDATE Estoque SET validade = '1899-12-31'
-- WHERE id_produto = 1 AND cnpj_filial = '10101010000110';
-- 18) INSERT com preco negativo: deve gerar erro.
-- INSERT INTO Estoque (id_produto, cnpj_filial, preco, quantidade, validade)
-- VALUES (2, '20202020000120', -5.00, 1, '2027-01-01');
-- 19) INSERT com validade anterior a 1900: deve gerar erro.
-- INSERT INTO Estoque (id_produto, cnpj_filial, preco, quantidade, validade)
-- VALUES (2, '20202020000120', 5.00, 1, '1899-12-31');

-- 20) Novo fornecedor, produtos, identificacoes e estoques.
INSERT INTO Fornecedor (cnpj, nome, telefone, endereco)
VALUES ('99999999000199', 'Nova Fornecedora Ltda', '3199999999',
        'Rua das Acácias, 900 - Belo Horizonte/MG');
INSERT INTO Produto (cnpj_fornecedor, nome) VALUES
('99999999000199', 'Cafe Especial 500g'),
('99999999000199', 'Cha de Camomila 20 unidades');
-- IDs 7 e 8 se os dados iniciais foram executados sem outros produtos.
INSERT INTO Identificacao (id, descricao, observacao) VALUES
(7, 'Cafe especial torrado e moido, pacote de 500g', 'Armazenar em local seco'),
(8, 'Cha de camomila, caixa com 20 unidades', 'Produto natural');
INSERT INTO Estoque (id_produto, cnpj_filial, preco, quantidade, validade) VALUES
(7, '10101010000110', 24.90, 20, '2027-12-31'),
(7, '20202020000120', 25.90, 15, '2027-12-31'),
(7, '30303030000130', 26.50, 10, '2027-12-31'),
(8, '10101010000110', 12.90, 30, '2027-08-31'),
(8, '20202020000120', 13.50, 25, '2027-08-31'),
(8, '30303030000130', 13.90, 18, '2027-08-31');
SELECT f.nome AS fornecedor, p.id, p.nome AS produto, i.descricao, i.observacao,
       e.cnpj_filial, e.preco, e.quantidade, e.validade
FROM Fornecedor f
INNER JOIN Produto p ON f.cnpj = p.cnpj_fornecedor
INNER JOIN Identificacao i ON p.id = i.id
INNER JOIN Estoque e ON p.id = e.id_produto
WHERE f.cnpj = '99999999000199'
ORDER BY p.id, e.cnpj_filial;

-- 21) Promocao: cada promocao pertence a um item de Estoque.
-- Um item pode ter varias promocoes; a FK composta aponta para a PK composta.
CREATE TABLE Promocao (
    id INT AUTO_INCREMENT,
    id_produto INT NOT NULL,
    cnpj_filial VARCHAR(14) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    preco_custo DECIMAL(10,2) NOT NULL,
    preco_promocional DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT check_periodo CHECK (data_fim >= data_inicio),
    CONSTRAINT check_preco CHECK (preco_promocional >= preco_custo),
    FOREIGN KEY (id_produto, cnpj_filial)
        REFERENCES Estoque (id_produto, cnpj_filial)
);
INSERT INTO Promocao
(id_produto, cnpj_filial, data_inicio, data_fim, preco_custo, preco_promocional)
VALUES
(1, '10101010000110', '2026-11-01', '2026-11-30', 18.00, 20.00),
(1, '10101010000110', '2026-12-01', '2026-12-15', 18.00, 19.50),
(3, '20202020000120', '2026-11-05', '2026-11-20', 4.50, 5.50);
SELECT * FROM Promocao;

-- 22) Funcionario: FK para Filial e auto-relacionamento do supervisor.
CREATE TABLE Funcionario (
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE NOT NULL,
    data_contratacao DATE NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    cnpj_filial VARCHAR(14) NOT NULL,
    cpf_supervisor VARCHAR(11),
    PRIMARY KEY (cpf),
    FOREIGN KEY (cnpj_filial) REFERENCES Filial(cnpj),
    FOREIGN KEY (cpf_supervisor) REFERENCES Funcionario(cpf),
    CHECK (salario >= 0)
);
-- Inserir primeiro o presidente, que nao possui supervisor.
INSERT INTO Funcionario
(cpf, nome, data_nascimento, data_contratacao, endereco, telefone,
 cargo, salario, cnpj_filial, cpf_supervisor)
VALUES
('10000000001', 'Mariana Oliveira', '1980-04-12', '2010-03-01',
 'Rua A, 100 - Belo Horizonte/MG', '31988880001', 'Presidente',
 18000.00, '10101010000110', NULL);
-- Depois inserir funcionarios que apontam para supervisores existentes.
INSERT INTO Funcionario
(cpf, nome, data_nascimento, data_contratacao, endereco, telefone,
 cargo, salario, cnpj_filial, cpf_supervisor)
VALUES
('10000000002', 'Rafael Santos', '1988-07-20', '2015-06-10',
 'Rua B, 200 - Belo Horizonte/MG', '31988880002', 'Gerente',
 9500.00, '10101010000110', '10000000001'),
('10000000003', 'Camila Ferreira', '1995-02-08', '2020-01-15',
 'Rua C, 300 - Belo Horizonte/MG', '31988880003', 'Vendedora',
 3200.00, '20202020000120', '10000000002'),
('10000000004', 'Lucas Almeida', '1992-11-03', '2018-09-01',
 'Rua D, 400 - Contagem/MG', '31988880004', 'Analista de Estoque',
 4100.00, '30303030000130', '10000000002');
SELECT * FROM Funcionario;
-- Consulta opcional: mostrar tambem o nome do supervisor.
SELECT f.nome AS funcionario, f.cargo, s.nome AS supervisor
FROM Funcionario f
LEFT JOIN Funcionario s ON f.cpf_supervisor = s.cpf
ORDER BY f.nome;
