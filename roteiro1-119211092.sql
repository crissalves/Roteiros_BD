--Roteiro 1:

-- Pedido 1: Criação das tabelas.

-- Obs: O titular será referenciado pelo seu CPF.
-- Obs2: Os automoveis serão referenciados pela sua placa.

--Automovel: Placa, Ano, Modelo, Titular. (Feito)
CREATE TABLE AutoMovel(
    placa varchar(8) NOT NULL PRIMARY KEY,
    ano varchar(4) NOT NULL,
    modelo varchar(10),
    titular varchar(11) NOT NULL,
);

--Segurado: Nome, cpf, Telefone. (Feito)
CREATE TABLE Segurado(
    nome text,
    cpf varchar(11) PRIMARY KEY,
    telefone varchar(11),
    veiculos varchar(8)
);

--Perito: Nome, Cpf. (Feito)
CREATE TABLE Perito(
    nome text,
    cpf varchar(11) PRIMARY KEY
);

--Oficina: Local, Cnpj, Reparos, Pericias(feito)
CREATE TABLE Oficina(
    localidade text,
    cnpj varchar(14) PRIMARY KEY
);

--Seguro: Valor, Segurado, Automovel, Validade. (feito)
CREATE TABLE Seguro(
    valor money,
    segurado varchar(11),
    automovel varchar(8) PRIMARY KEY,
    validade date
);

-- Sinistro: Condição do Automovel, Valor. (feito)
CREATE TABLE Sinistro(
    automovel varchar(8) PRIMARY KEY,
    valor money,
    condicao text
);

--Pericia: Avalição do perito, Automovel (feito)
CREATE TABLE Pericia(
    avaliacao text,
    automovel varchar(8) PRIMARY KEY
);

--Reparo: Valor, Tempo de reparo, Automovel (feito)
CREATE TABLE Reparo(
    valor numeric,
    tempo date,
    automovel varchar(8) PRIMARY KEY
);
