-- AULA Db 05/09/2019************************************************

-- Utilizando a mesma base de dados usada na aula anterior
USE aula1_tarde;

SHOW TABLES;
DESC produto;
SELECT * FROM produto;

-- ******DICA***** dontpad.com para compartilhar dados

--Falhas de integridade

INSERT INTO produto VALUES(NULL, 'LG', 2, NULL);
INSERT INTO produto VALUES('Projetor', 'Epson', 1, 2460);

--****** NUNCA FAZER ISTO: MODO ERRADO DE ALTERAR UM ATRIBUTO
--(ERRADO POIS NĂO TEM UM ID)
UPDATE produto SET nome = 'TV'
	WHERE fabric = 'LG' AND qtd = 2;

UPDATE poduto SET preco = 2250 WHERE nome = 'TV';

--ESTES DOIS PODEM SER SUBSTITURIDOS POR:
UPDATE produto SET nome = 'TV', preco = 2250 WHERE fabric = 'LG' AND qtd = 2;


-- Excluir registro da tabela:
DELETE FROM produto WHERE nome = 'Projetor';
SELECT * FROM produto;


/*Estudo de caso: ***FEITO NO BRMODELO**** OU "er diagram tool" WORKBENCH OU
Uma empresa armazena os dados de clientes: nome, email, genero, estado civil, renda,
telefone, endereço e telefone.

Esses dados săo fornecido a outras empresas para elaboraçăo de campanhas
publicitárias.

ENDITADES

***Cliente***
nome
email
genero
estadoCivil
renda
endereco
telefone

*/

Como alterar o tamanho de um campo?
Como alterar o nome de uma coluna?

USE aula1_tarde;

---Criar nova tabela
--- PRIMARY KEY : Campo de ID de registros, năo nulo e unico
--- NOT NULL - Campo nao nulo. Preenchimento obrigatório.

CREATE TABLE cliente(
codCliente INT PRIMARY KEY,
nome VARCHAR(40) NOT NULL,
email VARCHAR(40) NOT NULL,
genero CHAR NOT NULL,
estadoCivil VARCHAR(20) NOT NULL,
renda FLOAT NOT NULL,
telefone VARCHAR(100) NOT NULL,
endereco VARCHAR(200) NOT NULL);

--Inserir dados na tabela cliente.
INSERT INTO cliente
VALUES(101, 'Bia', 'bia@uol.com', 'f', 'Solteiro', 5300, '9999-8888 / 2222-8877',
'Rua a, Bairro q, RJ');

INSERT INTO cliente
VALUES(102, 'Leo', 'bia@uol.com', 'm', 'Solteiro', 4700, '2222-8888 / 9999-5555',
'Rua s, Bairro w, SP');

INSERT INTO cliente
VALUES(103, 'Nat', 'bia@uol.com', 'f', 'Casado', 6800, '5555-7777 / 9999-6666', 'Rua
d, Bairro d, RJ');

INSERT INTO cliente
VALUES(104, 'Ana', 'bia@uol.com', 'f', 'Casado', 7100, '2222-8888 / 7777-2222', 'Rua
f, Bairro f, MG');

INSERT INTO cliente
VALUES(105, 'Edu', 'edu@uol.com', 'f', 'Solteiro', 4700, '97777-2222', 'Rua h,
Bairro u, SP');

 SELECT * FROM cliente;

--ERRO
INSERT INTO cliente
VALUES(101, NULL, 'bia@uol.com', 'f', 'Solteiro', 5300, '9999-8888 / 2222-8877',
'Rua a, Bairro q, RJ');

INSERT INTO cliente
VALUES(106, 'Edu', 'edu@uol.com', 'f', 'Casado', 4700, '2222-8888 / 7777-2222', 'Rua
f, Bairro f, MG');

DELETE FROM cliente WHERE codCliente = 106;

-- Mudar o 105
UPDATE cliente SET genero = 'm' WHERE codCliente = 105;

---*** EXERCICIOS

-- Exibir nome, gęnero e contatos dos clientes em ordem alfabética.
SELECT nome, genero, email, telefone FROM cliente ORDER BY nome ASC;

-- Exibir nome, gęnero e contatos dos clientes do sexo feminino.
SELECT nome, genero, email, telefone FROM cliente WHERE genero = "f";

-- Exibir nome, gęnero e renda dos clientes com renda inferior a 6000.
SELECT nome, genero, renda FROM cliente WHERE renda < 6000;

-- Exibir nome, gęnero e renda dos clientes do sexo feminino com renda superior a 6000
SELECT nome, genero, renda
FROM cliente WHERE genero = "f" AND renda > 6000;

 -- Exibir nome, gęnero, estado civil e renda dos clientes do sexo masculino
 -- ou dos clientes casados. Ordenados pela maior renda.
SELECT nome, genero, estadoCivil, renda FROM cliente WHERE genero = "m" OR
estadoCivil = 'Casado' ORDER BY renda DESC;

-- Exibir nome, gęnero e renda dos clientes com renda entre 5000 e 7000.
SELECT nome, genero, renda
FROM cliente
WHERE renda >= 5000 AND renda <= 7000;


-- Resultado vazio.
SELECT nome, email, endereco
FROM cliente WHERE endereco = 'RJ';


-- Erro. Campo UF năo existe.
SELECT nome, email, endereco
FROM cliente WHERE UF = 'RJ';

--Como superar esse problema?
--LIKE - Pesquisa pro trecho textual.
SELECT nome, email, endereco
FROM cliente WHERE email LIKE '%@uol%';

SELECT nome, email, endereco
FROM cliente WHERE endereco LIKE '%RJ%';

---Curiosidade
SELECT nome, email, SUBSTRING(endereco, 3, LENGTH(endereco) 20)
FROM cliente WHERE endereco LIKE '%RJ%';

SELECT nome, email, SUBSTRING(endereco, 3, 20)
FROM cliente WHERE endereco LIKE '%RJ%';

_________________Pelo professor________________________

/*
Primeira Forma Normal - FN1

Todos os campos de uma tabela devem ser atômicos(indivísivel). Os valores
armazenados nos campos devem possibilitar uma pesquisa direta.

Campo Composto e Campo Multivalorado devem ser evitados.

Campo Composto -> Endereco (Rio Branco, 185, Centro, Rio de Janeiro, RJ)
Campo Multivalorado -> Telefone (4444-6666 / 3333-1111)

--------------------------------------------------------------------------------

Segunda Forma Normal - FN2

Em uma tabela todos os campos devem ter a sua existência dependendo diretamente
da chave primária desta tabela.


**/

/*
Estudo de Caso:
Uma empresa necessita armazenar os dados dos funcionários e de seus dependentes.

Os dados são: nome do funcionário, cpf, genêro, salário, endereço, nome do
endente, grau 180 de parentesco e telefone do dependente.

ENTIDADES

Funcionario         Endereco         Dependente
nome               rua               nomeDep
cpf                bairro            grauDep
genero             cidade            telefoneDep
salario

**/




