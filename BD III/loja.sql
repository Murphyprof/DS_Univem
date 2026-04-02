-- Criar Banco
CREATE DATABASE loja_3ds;
USE loja_3ds;

-- Criar Tabelas
CREATE TABLE tbcliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

-- criando tabela de produtos
CREATE TABLE tbproduto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100),
    preco DECIMAL(10,2),
    estoque INT
);

-- criando tabela de pedidos
CREATE TABLE tbpedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATE,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES tbcliente(id_cliente)
);

--  criando tabela de itens do pedido
CREATE TABLE tbitem_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (id_pedido) REFERENCES tbpedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES tbproduto(id_produto)
);

-- Inserir Dados
-- Clientes
INSERT INTO tbcliente (nome, email, cidade) VALUES
('João Silva', 'joao@email.com', 'Marília'),
('Maria Souza', 'maria@email.com', 'Bauru'),
('Carlos Lima', 'carlos@email.com', 'Assis');
-- Produtos
INSERT INTO tbproduto (nome_produto, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse', 80.00, 50),
('Teclado', 150.00, 30),
('Monitor', 900.00, 15);
-- Pedidos
INSERT INTO tbpedido (data_pedido, id_cliente) VALUES
('2025-05-01', 1),
('2025-05-02', 2),
('2025-05-03', 1);
-- Itens
INSERT INTO tbitem_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),
(1, 2, 2, 80.00),
(2, 3, 1, 150.00),
(3, 4, 1, 900.00),
(3, 2, 1, 80.00);

-- Atualizações
-- Atualizar preço
UPDATE tbproduto
SET preco = 3600.00
WHERE id_produto = 1;
-- Atualizar cidade
UPDATE tbcliente
SET cidade = 'São Paulo'
WHERE id_cliente = 3;

-- Exclusões
-- Excluir item
DELETE FROM tbitem_pedido
WHERE id_item = 5;
-- Excluir cliente sem pedido
DELETE FROM tbcliente
WHERE id_cliente = 1
AND id_cliente NOT IN (SELECT id_cliente FROM tbpedido);

--DQL Queries
-- Ordenação (Order By)
-- 1 Listar clientes em ordem alfabética.
select id_cliente, nome, cidade
from tbcliente
order by nome ASC;

-- 2 Listar produtos por preço do mais caro para o mais barato.
select id_produto, nome_produto, preco, estoque
from tbproduto
order by preco DESC;

-- Like (Busca por padrão)
-- 1 Encontrar clientes que moram em cidades que começam com 'M'.
select id_cliente, nome, cidade, email
from tbcliente
where cidade like 'M%';

-- Encontrar produtos que contêm 'ad' no nome.
select id_produto, nome_produto, preco, estoque
from tbproduto
where nome_produto like '%ad%';

-- AND (Múltiplas condições)
-- 1 Produtos que custam mais 100 E têm estoque maior que 20.
select id_produto, nome_produto, preco, estoque
from tbproduto
where preco > 100 AND estoque > 20;


-- OR (Condições alternativas)
-- 1 Produtos que custam mais de 100 ou têm estoque menor que 20.
select id_produto, nome_produto, preco, estoque
from tbproduto
where preco > 100 OR estoque < 20;

-- 2 Clientes de Marília OU de Bauru
select id_cliente, nome, cidade, email
from tbcliente
where cidade = 'Marília' OR cidade = 'Bauru';

-- IN (Multiplos Valores)
-- 1 Produtos com ID 1, 3 ou 4
Select id_produto, nome_produto, preco, estoque
from tbproduto
WHERE id_produto IN(1, 3, 4);

-- 2 Pedidos de clientes com ID 1 ou 2
Select id_pedido, data_pedido, id_cliente
From tbpedido
WHERE id_cliente IN (1, 2);
