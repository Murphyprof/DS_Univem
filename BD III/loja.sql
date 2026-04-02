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


-- Exercício 1: Clientes com Gastos Acima da Média
-- Crie uma consulta SQL que liste os nomes dos clientes que têm pelo menos um pedido com valor total (soma de quantidade * preco_unitario dos itens) superior à média dos valores totais de todos os pedidos. Use uma subquery para calcular a média geral dos valores totais dos pedidos.
SELECT DISTINCT c.nome
FROM tbcliente c
JOIN tbpedido p ON c.id_cliente = p.id_cliente
JOIN tbitem_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido, c.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > (
    SELECT AVG(total_pedido) FROM (
        SELECT SUM(quantidade * preco_unitario) AS total_pedido
        FROM tbitem_pedido
        GROUP BY id_pedido
    ) AS sub
);

-- Sem Join

SELECT nome
FROM tbcliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM tbpedido
    WHERE id_pedido IN (
        SELECT id_pedido
        FROM tbitem_pedido
        GROUP BY id_pedido
        HAVING SUM(quantidade * preco_unitario) >
        (
            SELECT AVG(total_pedido)
            FROM (
                SELECT SUM(quantidade * preco_unitario) AS total_pedido
                FROM tbitem_pedido
                GROUP BY id_pedido
            ) AS media_pedidos
        )
    )
);

-- Exercício 2: Produtos Vendidos em Mais Pedidos que a Média
-- Crie uma consulta SQL que liste os nomes dos produtos que foram vendidos em um número de pedidos diferente (contagem de pedidos únicos onde o produto aparece) maior que a média de pedidos por produto. Use uma subquery correlacionada para calcular o número de pedidos por produto e compará-lo com a média geral.
SELECT pr.nome_produto
FROM tbproduto pr
JOIN tbitem_pedido ip ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome_produto
HAVING COUNT(DISTINCT ip.id_pedido) > (
    SELECT AVG(num_pedidos) FROM (
        SELECT COUNT(DISTINCT id_pedido) AS num_pedidos
        FROM tbitem_pedido
        GROUP BY id_produto
    ) AS sub
);

-- Sem Join
-- 
SELECT id_produto, nome_produto
FROM tbproduto p
WHERE 
( --Conta quantos pedidos esse produto atual tem.
    SELECT COUNT(DISTINCT id_pedido)
    FROM tbitem_pedido i
    WHERE i.id_produto = p.id_produto
)
>
(
    -- Calcula a média de pedidos de todos os produtos.
    SELECT AVG(total_pedidos)
    FROM (
        SELECT COUNT(DISTINCT id_pedido) AS total_pedidos
        FROM tbitem_pedido
        GROUP BY id_produto
    ) AS media_produtos
);
