--Roteiro 1:

-- Pedido 1: Criação das tabelas.

-- Obs: O titular será referenciado pelo seu CPF.
-- Obs2: Os automoveis serão referenciados pela sua placa.

--Automovel: Placa, Ano, Modelo, Titular. (Feito)
CREATE TABLE AutoMovel(
    placa varchar(8) NOT NULL PRIMARY KEY,
    ano varchar(4) NOT NULL,
    modelo varchar(10),
    titular varchar(11) NOT NULL
);

--Segurado: Nome, cpf, Telefone. (Feito)
CREATE TABLE Segurado(
    nome text NOT NULL,
    cpf varchar(11) NOT NULL PRIMARY KEY,
    telefone varchar(11),
    veiculos varchar(8) NOT NULL 
);

--Perito: Nome, Cpf. (Feito)
CREATE TABLE Perito(
    nome text,
    cpf varchar(11) NOT NULL PRIMARY KEY
);

--Oficina: Local, Cnpj (feito)
CREATE TABLE Oficina(
    localidade text NOT NULL,
    cnpj varchar(14) NOT NULL PRIMARY KEY
);

--Seguro: Valor, Segurado, Automovel, Validade. (feito)
CREATE TABLE Seguro(
    valor money,
    segurado varchar(11) NOT NULL,
    automovel varchar(8) NOT NULL PRIMARY KEY,
    validade date NOT NULL
);

-- Sinistro: Condição do Automovel, Valor. (feito)
CREATE TABLE Sinistro(
    automovel varchar(8) NOT NULL PRIMARY KEY,
    valor money,
    condicao text
);

--Pericia: Avalição do perito, Automovel (feito)
CREATE TABLE Pericia(
    avaliacao text,
    automovel varchar(8) NOT NULL PRIMARY KEY
);

--Reparo: Valor, Tempo de reparo, Automovel (feito)
CREATE TABLE Reparo(
    valor numeric NOT NULL,
    tempo date,
    automovel varchar(8) NOT NULL PRIMARY KEY
); 

--Ponto 3:
-- Adicionar telefone para Oficina e para o Perito.
ALTER TABLE Oficina ADD COLUMN telefone varchar(11);
ALTER TABLE Perito ADD COLUMN telefone varchar(11);

--Ponto 4:
-- Adiciona a placa de um Automovel como chave estrangeira dos Veiculos do Segurado.
ALTER TABLE Segurado ADD CONSTRAINT placa FOREIGN KEY (veiculos) REFERENCES AutoMovel (placa);


--Ponto 5:
--Adicionei os NOT NULL nas Create Table.

--Ponto 6:
--Deu errado pois gerou uma dependência em Veiculos do segurado.
DROP TABLE automovel;

--Deletendo as outras:
DROP TABLE segurado;
DROP TABLE seguro;
DROP TABLE Sinistro;
DROP TABLE reparo;
DROP TABLE perito;
DROP TABLE pericia;
DROP TABLE oficina;
DROP TABLE automovel;

--Ponto 7 Reescrevi todos os comandos de criação para incluindo os dados NOT NULL, chaves primárias e estrangeiras.

--Ponto 8 Adicionei todas as tabelas já com as intruções corretas.
--Ponto 8 Usei alter table para usar mais chaves Estrangeiras relacionadas as placas dos veiculos e do cpf do segurado.

ALTER TABLE Seguro ADD CONSTRAINT Segurado FOREIGN KEY (segurado) REFERENCES Segurado (cpf);
ALTER TABLE Seguro ADD CONSTRAINT Placa_Veiculo FOREIGN KEY (automovel) REFERENCES Automovel (placa);
ALTER TABLE Sinistro ADD CONSTRAINT Placa_Veiculo FOREIGN KEY (automovel) REFERENCES Automovel (placa);
ALTER TABLE Pericia ADD CONSTRAINT Placa_Veiculo FOREIGN KEY (automovel) REFERENCES Automovel (placa);
ALTER TABLE Reparo ADD CONSTRAINT Placa_Veiculo FOREIGN KEY (automovel) REFERENCES Automovel (placa);
--Tudo Perfeito nas alterações.

--Ponto 9 Deletei novamento tudo usando o DROP TABLE.

DROP TABLE segurado;
DROP TABLE seguro;
DROP TABLE Sinistro;
DROP TABLE reparo;
DROP TABLE perito;
DROP TABLE pericia;
DROP TABLE oficina;
DROP TABLE automovel;

--Ponto 10 Deixei Como estava as tabelas antes do Ponto 9, para testar adicionar novas colunas e altera-las.