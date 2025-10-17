
CREATE TABLE empresa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);


CREATE TABLE planos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    preco NUMERIC,
    armazenamento VARCHAR(255)
);


CREATE TABLE unidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    estado VARCHAR(255),
    cidade VARCHAR(255),
    cnpj VARCHAR(255),
    senha VARCHAR(255),
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

CREATE TABLE daily_active_users(
    id INTEGER,
    id_usuario INTEGER,
    tipo_usuario VARCHAR(50),
    hora_entrada TIMESTAMP
);

ALTER TABLE unidade
ADD COLUMN senha VARCHAR(255);
