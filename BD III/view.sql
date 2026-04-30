-- Criação do Banco de Dados.
CREATE DATABASE exemplo_biblioteca;
USE exemplo_biblioteca;


-- Criando a tabela de membros da biblioteca.
CREATE TABLE membros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_cadastro DATE
);


-- Criando a tabela de Livros.
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    autor VARCHAR(100),
    isbn VARCHAR(20),
    ano_publicacao INT
);


-- Criando a tabela de Empréstimos.
CREATE TABLE emprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    membro_id INT,
    livro_id INT,
    data_emprestimo DATE,
    data_devolucao DATE,
    FOREIGN KEY (membro_id) REFERENCES membros(id),
    FOREIGN KEY (livro_id) REFERENCES livros(id)
);


-- Inserindo dados na tabela de Membros.
INSERT INTO membros (nome, email, data_cadastro) VALUES
('Ana Silva', 'ana@email.com', '2024-01-10'),
('Bruno Costa', 'bruno@email.com', '2024-02-15'),
('Carla Mendes', 'carla@email.com', '2024-03-20');


-- Inserindo dados na tabela de Livros.
INSERT INTO livros (titulo, autor, isbn, ano_publicacao) VALUES
('Clean Code', 'Robert Martin', '978-0132350884', 2008),
('Design Patterns', 'Gang of Four', '978-0201633610', 1994),
('The Pragmatic Programmer', 'Hunt & Thomas', '978-0201616224', 1999),
('Refactoring', 'Martin Fowler', '978-0134757599', 2018);


-- Inserindo dados na tabela de Empréstimos.
INSERT INTO emprestimos (membro_id, livro_id, data_emprestimo, data_devolucao) VALUES
(1, 1, '2025-01-05', '2025-01-15'),
(1, 2, '2025-02-01', '2025-02-10'),
(2, 3, '2025-01-10', '2025-01-25'),
(3, 4, '2025-02-15', NULL);
