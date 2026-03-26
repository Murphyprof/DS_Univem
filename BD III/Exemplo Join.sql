-- Banco de dados: empresa_db
CREATE DATABASE empresa_db;
USE empresa_db;

-- Tabela: cargos
CREATE TABLE tbcargos (
    codigo_cargo INT PRIMARY KEY AUTO_INCREMENT,
    nome_cargo VARCHAR(50),
    descricao_cargo TEXT
);

-- Tabela: funcionarios
CREATE TABLE tbfuncionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome_funcionario VARCHAR(100),
    cargo_id INT NULL,
    FOREIGN KEY (cargo_id) REFERENCES tbcargos(codigo_cargo)
);

-- Inserindo dados na tabela cargos
INSERT INTO tbcargos (nome_cargo, descricao_cargo) VALUES ('Gerente', 'Gerencia a empresa');
INSERT INTO tbcargos (nome_cargo, descricao_cargo) VALUES ('Analista RH', 'Analisa questões relacionadas a recursos humanos');
INSERT INTO tbcargos (nome_cargo, descricao_cargo) VALUES ('Desenvolvedor', 'Desenvolve software e aplicações');
INSERT INTO tbcargos (nome_cargo, descricao_cargo) VALUES ('Estagiário', 'Auxilia em tarefas diversas e aprende sobre a empresa');
INSERT INTO tbcargos (nome_cargo, descricao_cargo) VALUES ('', '');


-- Inserindo dados na tabela funcionarios
INSERT INTO tbfuncionarios (nome_funcionario, cargo_id) VALUES ('Alice', 1);
INSERT INTO tbfuncionarios (nome_funcionario, cargo_id) VALUES ('Marco', 2);
INSERT INTO tbfuncionarios (nome_funcionario, cargo_id) VALUES ('Marcelo', 3);
INSERT INTO tbfuncionarios (nome_funcionario, cargo_id) VALUES ('João', NULL);
INSERT INTO tbfuncionarios (nome_funcionario, cargo_id) VALUES ('Maria', 4);

