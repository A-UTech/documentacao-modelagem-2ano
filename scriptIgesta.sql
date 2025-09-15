CREATE TABLE planos (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    preco NUMERIC NOT NULL,
    armazenaento VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE empresa (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(255) NOT NULL,
    id_plano INTEGER NOT NULL REFERENCES planos(id),
    PRIMARY KEY(id)
);

CREATE TABLE turno (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    inicio TIME NOT NULL,
    fim TIME NOT NULL,
    id_empresa INTEGER REFERENCES empresa(id),
    PRIMARY KEY(id)
);

CREATE TABLE condena (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Gestor (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    cpf VARCHAR(255),
    id_empresa INTEGER REFERENCES empresa(id),
    PRIMARY KEY(id)
);

CREATE TABLE condena_gestor (
    id SERIAL NOT NULL UNIQUE,
    id_condena INTEGER NOT NULL REFERENCES condena(id),
    id_gestor INTEGER NOT NULL REFERENCES Gestor(id),
    PRIMARY KEY(id)
);

CREATE TABLE usuario_log (
    id SERIAL NOT NULL UNIQUE,
    tabela VARCHAR(255) NOT NULL,
    id_afetado INTEGER NOT NULL,
    operacao VARCHAR(255) NOT NULL,
    id_usuario INTEGER NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE admin (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE admin_log (
    id SERIAL NOT NULL UNIQUE,
    tabela VARCHAR(255) NOT NULL,
    id_afetado INTEGER NOT NULL,
    operacao VARCHAR(255) NOT NULL,
    id_admin INTEGER NOT NULL REFERENCES admin(id),
    data_hora TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE lider (
    id SERIAL NOT NULL UNIQUE,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    cpf VARCHAR(255),
    area VARCHAR(255),
    id_empresa INTEGER REFERENCES empresa(id),
    PRIMARY KEY(id)
);


-- 1) PLANOS
INSERT INTO planos (nome, preco, armazenaento) VALUES
('Básico', 49.90, '2 TB'),
('Intermediário', 199.90, '3 TB'),
('Corporativo', 299.90, '4 TB'),
('Empresarial', 399.90, '5 TB'),
('Mega Plan', 999.90, '12 TB');

-- 2) EMPRESA
INSERT INTO empresa (nome, cnpj, id_plano) VALUES
('Panatem', '12.345.678/0001-90', 1),
('BIMO', '23.456.789/0001-81', 2),
('Khiata', '34.567.890/0001-72', 3),
('Tropicalias', '45.678.901/0001-63', 4),
('Athleta', '56.789.012/0001-54', 5),
('Ficção', '67.890.123/0001-45', 1),
('Demeter', '78.901.234/0001-36', 2),
('Eos', '89.012.345/0001-27', 3),
('ChickenCare', '90.123.456/0001-18', 4),
('KFC', '01.234.567/0001-09', 5);

-- 3) GESTOR
INSERT INTO Gestor (nome, email, senha, cpf, id_empresa) VALUES
('Daniel Freitas', 'daniel.freitas@gmail.com', '1234', '111.111.111-11', 1),
('João Veigas Sobral', 'joao.veigas@gmail.com', '1234', '222.222.222-22', 2),
('Paulo Vaz', 'paulo.vaz@gmail.com', '1234', '333.333.333-33', 3),
('Pedro Teixeira', 'pedro.teixeira@gmail.com', '1234', '444.444.444-44', 4),
('Daniel Severo', 'daniel.severo@gmail.com', '1234', '555.555.555-55', 5);

-- 4) LIDER
INSERT INTO lider (nome, email, senha, cpf, area, id_empresa) VALUES
('Thiago Gabriel Marinho Cardoso', 'thiago.gabriel@gmail.com', 'abcd', '666.666.666-66', 'Área 1', 1),
('Matheus Bastos', 'matheus.bastos@gmail.com', 'abcd', '777.777.777-77', 'Área 2', 2),
('Marcelo Grilo', 'marcelo.grilo@gmail.com', 'abcd', '888.888.888-88', 'Área 3', 3),
('Marcelo Modolo', 'marcelo.modolo@gmail.com', 'abcd', '999.999.999-99', 'Área 4', 4),
('Alex Santos', 'alex.santos@gmail.com', 'abcd', '000.000.000-00', 'Área 5', 5);

-- 5) TURNO
INSERT INTO turno (nome, inicio, fim, id_empresa) VALUES
('Manhã', '00:00', '08:00', 1),
('Tarde', '08:00', '16:00', 2),
('Noite', '16:00', '23:59', 3);

-- 6) CONDENA
INSERT INTO condena (nome, tipo) VALUES
('Aero Saculite T', 'Total'),
('Artrite T', 'Total'),
('Aspectos Repugnantes P', 'Parcial'),
('Caquexia P', 'Parcial'),
('Celulite P', 'Parcial'),
('Condenação gastrointestinal e biler T', 'Total'),
('Condenação não gastrointestinal e biler T', 'Total'),
('Falha tecnólogica T', 'Total'),
('Lesão da pele P', 'Parcial'),
('Sangria inadequada', 'Parcial');

-- 7) CONDENA_GESTOR 
INSERT INTO condena_gestor (id_condena, id_gestor) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,1),
(7,2),
(8,3),
(9,4),
(10,5);

-- 8) ADMIN
INSERT INTO admin (nome, email) VALUES
('Gabriel Martins', 'gabriel.martins@gmail.com'),
('Rafaela Barreta', 'rafaela.barreta@gmail.com'),
('Gabriel Loureiro', 'gabriel.loureiro@gmail.com'),
('Lucas', 'lucas@gmail.com'),
('Maite Pereira', 'maite.pereira@gmail.com'),
('Samuel Evangelista', 'samuel.evangelista@gmail.com'),
('Fellipe Meira', 'fellipe.meira@gmail.com'),
('Julia', 'julia@gmail.com'),
('Matheus Daddio', 'matheus.daddio@gmail.com'),
('Felipe Kogake', 'felipe.kogake@gmail.com'),
('Arthur', 'arthur@gmail.com'),
('Kaua', 'kaua@gmail.com'),
('Emanuelly', 'emanuelly@gmail.com'),
('Beatriz', 'beatriz@gmail.com');