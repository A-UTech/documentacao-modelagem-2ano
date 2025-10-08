
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
('Demeter'),
('ChickenCare');

-- 3) UNIDADE
INSERT INTO unidade (nome, estado, cidade, cnpj, id_plano, id_empresa) VALUES
('Panatem Osasco', 'SP', 'Osasco', '12.345.678/0001-90', 1, 1),
('BIMO São Paulo', 'SP', 'São Paulo', '23.456.789/0001-81', 2, 2),
('Khiata Maranhão', 'MA', 'São Luís', '34.567.890/0001-72', 3, 3),
('Tropicalias Barueri', 'SP', 'Barueri', '45.678.901/0001-63', 4, 4),
('Athleta BH', 'MG', 'Belo Horizonte', '56.789.012/0001-54', 5, 5),
('Demeter Carpazinha', 'RS', 'Carpazinha', '78.901.234/0001-36', 2, 7),
('ChickenCare Carapicuíba', 'SP', 'Carapicuíba', '90.123.456/0001-18', 4, 9),
('Panatem Campinas', 'SP', 'Campinas', '11.223.344/0001-55', 1, 1),
('BIMO Rio de Janeiro', 'RJ', 'Rio de Janeiro', '22.334.455/0001-66', 2, 2),
('Khiata Fortaleza', 'CE', 'Fortaleza', '33.445.566/0001-77', 3, 3),
('Tropicalias Curitiba', 'PR', 'Curitiba', '44.556.677/0001-88', 4, 4),
('Athleta Vitória', 'ES', 'Vitória', '55.667.788/0001-99', 5, 5),
('Demeter Goiânia', 'GO', 'Goiânia', '77.889.900/0001-11', 2, 7),
('ChickenCare Belém', 'PA', 'Belém', '99.001.122/0001-33', 4, 9),
('Panatem Ribeirão Preto', 'SP', 'Ribeirão Preto', '12.131.415/0001-56', 1, 1),
('Panatem Santos', 'SP', 'Santos', '21.314.151/0001-65', 2, 1),
('Panatem Natal', 'RN', 'Natal', '32.415.161/0001-74', 3, 1),
('Panatem Maceió', 'AL', 'Maceió', '43.516.171/0001-83', 4, 1),
('Panatem Manaus', 'AM', 'Manaus', '54.617.181/0001-92', 5, 1),
('Demeter Caxias do Sul', 'RS', 'Caxias do Sul', '65.718.191/0001-03', 2, 7),
('Demeter Novo Hamburgo', 'RS', 'Novo Hamburgo', '98.021.221/0001-36', 5, 7),
('Khiata Teresina', 'PI', 'Teresina', '29.322.232/0001-47', 4, 3),
('Khiata São Bernardo do Campo', 'SP', 'São Bernardo do Campo', '30.423.242/0001-58', 3, 3),
('Athleta Juiz de Fora', 'MG', 'Juiz de Fora', '41.524.252/0001-69', 2, 5),
('Athleta Uberlândia', 'MG', 'Uberlândia', '52.625.262/0001-70', 1, 5),
('Tropicalias Londrina', 'PR', 'Londrina', '63.726.272/0001-81', 4, 4)
('Tropicalias Maringá', 'PR', 'Maringá', '74.827.282/0001-92', 5, 4)
;

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
('Rafael Barreto', 'rafael.barreto@gmail.com'),
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
