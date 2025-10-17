-- 1) PLANOS
INSERT INTO planos (id, nome, preco, armazenamento) VALUES
(1, 'Básico', 49.90, '2 TB'),
(2, 'Intermediário', 199.90, '3 TB'),
(3, 'Corporativo', 299.90, '4 TB'),
(4, 'Empresarial', 399.90, '5 TB'),
(5, 'Mega Plan', 999.90, '12 TB');

-- 2) EMPRESA
INSERT INTO empresa (id, nome) VALUES
(1, 'Panatem'),
(2, 'BIMO'),
(3, 'Khiata'),
(4, 'Tropicalias'),
(5, 'Athleta'),
(6, 'Demeter'),
(7, 'ChickenCare');

-- 3) UNIDADE
INSERT INTO unidade (id, nome, estado, cidade, cnpj, senha, id_plano, id_empresa) VALUES
(1, 'Panatem Osasco', 'SP', 'Osasco', '12.345.678/0001-90', 'senha1', 1, 1),
(2, 'BIMO São Paulo', 'SP', 'São Paulo', '23.456.789/0001-81', 'senha2', 2, 2),
(3, 'Khiata Maranhão', 'MA', 'São Luís', '34.567.890/0001-72', 'senha3', 3, 3),
(4, 'Tropicalias Barueri', 'SP', 'Barueri', '45.678.901/0001-63', 'senha4', 4, 4),
(5, 'Athleta BH', 'MG', 'Belo Horizonte', '56.789.012/0001-54', 'senha5', 5, 5),
(6, 'Demeter Carpazinha', 'RS', 'Carpazinha', '78.901.234/0001-36', 'senha6', 2, 6),
(7, 'ChickenCare Carapicuíba', 'SP', 'Carapicuíba', '90.123.456/0001-18', 'senha7', 4, 7),
(8, 'Panatem Campinas', 'SP', 'Campinas', '11.223.344/0001-55', 'senha8', 1, 1),
(9, 'BIMO Rio de Janeiro', 'RJ', 'Rio de Janeiro', '22.334.455/0001-66', 'senha9', 2, 2),
(10, 'Khiata Fortaleza', 'CE', 'Fortaleza', '33.445.566/0001-77', 'senha10', 3, 3),
(11, 'Tropicalias Curitiba', 'PR', 'Curitiba', '44.556.677/0001-88', 'senha11', 4, 4),
(12, 'Athleta Vitória', 'ES', 'Vitória', '55.667.788/0001-99', 'senha12', 5, 5),
(13, 'Demeter Goiânia', 'GO', 'Goiânia', '77.889.900/0001-11', 'senha13', 2, 6),
(14, 'ChickenCare Belém', 'PA', 'Belém', '99.001.122/0001-33', 'senha14', 4, 7),
(15, 'Panatem Ribeirão Preto', 'SP', 'Ribeirão Preto', '12.131.415/0001-56', 'senha15', 1, 1),
(16, 'Panatem Santos', 'SP', 'Santos', '21.314.151/0001-65', 'senha16', 2, 1),
(17, 'Panatem Natal', 'RN', 'Natal', '32.415.161/0001-74', 'senha17', 3, 1),
(18, 'Panatem Maceió', 'AL', 'Maceió', '43.516.171/0001-83', 'senha18', 4, 1),
(19, 'Panatem Manaus', 'AM', 'Manaus', '54.617.181/0001-92', 'senha19', 5, 1),
(20, 'Demeter Caxias do Sul', 'RS', 'Caxias do Sul', '65.718.191/0001-03', 'senha20', 2, 6),
(21, 'Demeter Novo Hamburgo', 'RS', 'Novo Hamburgo', '98.021.221/0001-36', 'senha21', 5, 6),
(22, 'Khiata Teresina', 'PI', 'Teresina', '29.322.232/0001-47', 'senha22', 4, 3),
(23, 'Khiata São Bernardo do Campo', 'SP', 'São Bernardo do Campo', '30.423.242/0001-58', 'senha23', 3, 3),
(24, 'Athleta Juiz de Fora', 'MG', 'Juiz de Fora', '41.524.252/0001-69', 'senha24', 2, 5),
(25, 'Athleta Uberlândia', 'MG', 'Uberlândia', '52.625.262/0001-70', 'senha25', 1, 5),
(26, 'Tropicalias Londrina', 'PR', 'Londrina', '63.726.272/0001-81', 'senha26', 4, 4),
(27, 'Tropicalias Maringá', 'PR', 'Maringá', '74.827.282/0001-92', 'senha27', 5, 4)
;

-- 4) GESTOR
INSERT INTO Gestor (id, nome, email, senha, cpf, id_unidade) VALUES
(1, 'Daniel Freitas', 'daniel.freitas@gmail.com', '1234', '111.111.111-11', 1),
(2, 'João Veigas Sobral', 'joao.veigas@gmail.com', '1234', '222.222.222-22', 2),
(3, 'Paulo Vaz', 'paulo.vaz@gmail.com', '1234', '333.333.333-33', 3),
(4, 'Pedro Teixeira', 'pedro.teixeira@gmail.com', '1234', '444.444.444-44', 4),
(5, 'Daniel Severo', 'daniel.severo@gmail.com', '1234', '555.555.555-55', 5),
(6, 'Gabriel Bento', 'gabriel.bento@gmail.com', '1234', '676.676.767-67', 1);

-- 5) LIDER
INSERT INTO lider (id, nome, email, senha, cpf, area, id_unidade) VALUES
(1, 'Thiago Gabriel Marinho Cardoso', 'thiago.gabriel@gmail.com', 'abcd', '676.767.676-76', 'Área 1', 1),
(2, 'Matheus Bastos', 'matheus.bastos@gmail.com', 'abcd', '777.777.777-77', 'Área 2', 2),
(3, 'Marcelo Grilo', 'marcelo.grilo@gmail.com', 'abcd', '888.888.888-88', 'Área 3', 3),
(4, 'Marcelo Modolo', 'marcelo.modolo@gmail.com', 'abcd', '999.999.999-99', 'Área 4', 4),
(5, 'Alex Santos', 'alex.santos@gmail.com', 'abcd', '000.000.000-00', 'Área 5', 5),
(6, 'Igor Malaquias', 'igor.malaquias@gmail.com', 'abcd', '123.321.222-23', 'Escaldagem', 1);

-- 6) TURNO
INSERT INTO turno (id, nome, inicio, fim, id_unidade) VALUES
('Manhã', '00:00', '08:00', 1),
('Tarde', '08:00', '16:00', 2),
('Noite', '16:00', '23:59', 3);

-- 7) CONDENA
INSERT INTO condena (id, nome, tipo) VALUES
(1, 'Aero Saculite T', 'Total'),
(2, 'Artrite T', 'Total'),
(3, 'Aspectos Repugnantes P', 'Parcial'),
(4, 'Caquexia P', 'Parcial'),
(5, 'Celulite P', 'Parcial'),
(6, 'Condenação gastrointestinal e biler T', 'Total'),
(7, 'Condenação não gastrointestinal e biler T', 'Total'),
(8, 'Falha tecnólogica T', 'Total'),
(9, 'Lesão da pele P', 'Parcial'),
(10, 'Sangria inadequada', 'Parcial');

-- 8) CONDENA_GESTOR
INSERT INTO condena_gestor (id, id_condena, id_gestor) VALUES
(1,1,1),
(2,2,2),
(3,3,3),
(4,4,4),
(5,5,5),
(6,6,1),
(7,7,2),
(8,8,3),
(9,9,4),
(10,10,5);

-- 9) ADMIN
INSERT INTO admin (id, nome, email) VALUES
(1, 'Gabriel Martins', 'gabriel.martins@gmail.com'),
(2, 'Rafael Barreto', 'rafael.barreto@gmail.com'),
(3, 'Gabriel Loureiro', 'gabriel.loureiro@gmail.com'),
(4, 'Lucas', 'lucas@gmail.com'),
(5, 'Maite Pereira', 'maite.pereira@gmail.com'),
(6, 'Samuel Evangelista', 'samuel.evangelista@gmail.com'),
(7, 'Fellipe Meira', 'fellipe.meira@gmail.com'),
(8, 'Julia', 'julia@gmail.com'),
(9, 'Matheus Daddio', 'matheus.daddio@gmail.com'),
(10, 'Felipe Kogake', 'felipe.kogake@gmail.com'),
(11, 'Arthur', 'arthur@gmail.com'),
(12, 'Kaua', 'kaua@gmail.com'),
(13, 'Emanuelly', 'emanuelly@gmail.com'),
(14, 'Beatriz', 'beatriz@gmail.com');
