
CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);


CREATE TABLE planos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    preco NUMERIC,
    armazenaento VARCHAR(255)
);


CREATE TABLE unidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    estado VARCHAR(255),
    cidade VARCHAR(255),
    cnpj VARCHAR(255),
    id_plano INTEGER NOT NULL REFERENCES planos(id),
    id_empresa INTEGER NOT NULL REFERENCES empresa(id)
);


CREATE TABLE turno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    inicio TIME,
    fim TIME,
    id_unidade INTEGER NOT NULL REFERENCES unidade(id)
);


CREATE TABLE condena (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    tipo VARCHAR(255)
);


CREATE TABLE Gestor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    cpf VARCHAR(255),
    id_unidade INTEGER NOT NULL REFERENCES unidade(id)
);


CREATE TABLE lider (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    senha VARCHAR(255),
    cpf VARCHAR(255),
    area VARCHAR(255),
    id_unidade INTEGER NOT NULL REFERENCES unidade(id)
);


CREATE TABLE condena_gestor (
    id_condena INTEGER NOT NULL REFERENCES condena(id),
    id_gestor INTEGER NOT NULL REFERENCES Gestor(id),
    PRIMARY KEY(id_condena, id_gestor)
);


CREATE TABLE admin (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255)
);


CREATE TABLE admin_log (
    id SERIAL PRIMARY KEY,
    tabela VARCHAR(255),
    id_afetado INTEGER,
    operacao VARCHAR(255),
    id_admin INTEGER NOT NULL REFERENCES admin(id),
    data_hora TIMESTAMP
);


CREATE TABLE gestor_log (
    id SERIAL PRIMARY KEY,
    tabela VARCHAR(255),
    id_afetado INTEGER,
    operacao VARCHAR(255),
    id_gestor INTEGER NOT NULL,
    data_hora TIMESTAMP
);

CREATE TABLE empresa_log (
    id SERIAL PRIMARY KEY,
    tabela VARCHAR(255),
    id_afetado INTEGER,
    operacao VARCHAR(255),
    id_empresa INTEGER NOT NULL REFERENCES empresa(id),
    id_unidade INTEGER NOT NULL REFERENCES unidade(id),
    data_hora TIMESTAMP
);
-- 1) PLANOS
INSERT INTO planos (nome, preco, armazenaento) VALUES
('Básico', 49.90, '2 TB'),
('Intermediário', 199.90, '3 TB'),
('Corporativo', 299.90, '4 TB'),
('Empresarial', 399.90, '5 TB'),
('Mega Plan', 999.90, '12 TB');

-- 2) EMPRESA
INSERT INTO empresa (nome) VALUES
('Panatem'),
('BIMO'),
('Khiata'),
('Tropicalias'),
('Athleta'),
('Ficção'),
('Demeter'),
('Eos'),
('ChickenCare'),
('KFC');

-- 3) UNIDADE
INSERT INTO unidade (nome, estado, cidade, cnpj, id_plano, id_empresa) VALUES
('Panatem Osasco', 'SP', 'Osasco', '12.345.678/0001-90', 1, 1),
('BIMO São Paulo', 'SP', 'São Paulo', '23.456.789/0001-81', 2, 2),
('Khiata Maranhão', 'MA', 'São Luís', '34.567.890/0001-72', 3, 3),
('Tropicalias Barueri', 'SP', 'Barueri', '45.678.901/0001-63', 4, 4),
('Athleta BH', 'MG', 'Belo Horizonte', '56.789.012/0001-54', 5, 5),
('Ficção Porto Alegre', 'RS', 'Porto Alegre', '67.890.123/0001-45', 1, 6),
('Demeter Carpazinha', 'RS', 'Carpazinha', '78.901.234/0001-36', 2, 7),
('Eos Recife', 'PE', 'Recife', '89.012.345/0001-27', 3, 8),
('ChickenCare Carapicuíba', 'SP', 'Carapicuíba', '90.123.456/0001-18', 4, 9),
('KFC Salvador', 'BA', 'Salvador', '01.234.567/0001-09', 5, 10),
('Panatem Campinas', 'SP', 'Campinas', '11.223.344/0001-55', 1, 1),
('BIMO Rio de Janeiro', 'RJ', 'Rio de Janeiro', '22.334.455/0001-66', 2, 2),
('Khiata Fortaleza', 'CE', 'Fortaleza', '33.445.566/0001-77', 3, 3),
('Tropicalias Curitiba', 'PR', 'Curitiba', '44.556.677/0001-88', 4, 4),
('Athleta Vitória', 'ES', 'Vitória', '55.667.788/0001-99', 5, 5),
('Ficção Florianópolis', 'SC', 'Florianópolis', '66.778.899/0001-00', 1, 6),
('Demeter Goiânia', 'GO', 'Goiânia', '77.889.900/0001-11', 2, 7),
('Eos Manaus', 'AM', 'Manaus', '88.990.011/0001-22', 3, 8),
('ChickenCare Belém', 'PA', 'Belém', '99.001.122/0001-33', 4, 9),
('KFC Brasília', 'DF', 'Brasília', '10.112.233/0001-44', 5, 10);

-- 4) GESTOR
INSERT INTO Gestor (nome, email, senha, cpf, id_unidade) VALUES
('Daniel Freitas', 'daniel.freitas@gmail.com', '1234', '111.111.111-11', 1),
('João Veigas Sobral', 'joao.veigas@gmail.com', '1234', '222.222.222-22', 2),
('Paulo Vaz', 'paulo.vaz@gmail.com', '1234', '333.333.333-33', 3),
('Pedro Teixeira', 'pedro.teixeira@gmail.com', '1234', '444.444.444-44', 4),
('Daniel Severo', 'daniel.severo@gmail.com', '1234', '555.555.555-55', 5),
('Gabriel Bento', 'gabriel.bento@gmail.com', '1234', '676.676.767-67', 1);

-- 5) LIDER
INSERT INTO lider (nome, email, senha, cpf, area, id_unidade) VALUES
('Thiago Gabriel Marinho Cardoso', 'thiago.gabriel@gmail.com', 'abcd', '676.767.676-76', 'Área 1', 1),
('Matheus Bastos', 'matheus.bastos@gmail.com', 'abcd', '777.777.777-77', 'Área 2', 2),
('Marcelo Grilo', 'marcelo.grilo@gmail.com', 'abcd', '888.888.888-88', 'Área 3', 3),
('Marcelo Modolo', 'marcelo.modolo@gmail.com', 'abcd', '999.999.999-99', 'Área 4', 4),
('Alex Santos', 'alex.santos@gmail.com', 'abcd', '000.000.000-00', 'Área 5', 5),
('Igor Malaquias', 'igor.malaquias@gmail.com', 'abcd', '123.321.222-23', 'Escaldagem', 1);

-- 6) TURNO
INSERT INTO turno (nome, inicio, fim, id_unidade) VALUES
('Manhã', '00:00', '08:00', 1),
('Tarde', '08:00', '16:00', 2),
('Noite', '16:00', '23:59', 3);

-- 7) CONDENA
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

-- 8) CONDENA_GESTOR
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

-- 9) ADMIN
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
