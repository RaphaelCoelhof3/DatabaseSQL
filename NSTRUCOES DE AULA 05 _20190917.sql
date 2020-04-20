-- Aula5 BD - 17/09/2019------

-- Utilizando a mesma base de dados usada na aula anterior
DROP DATABASE aula4_tarde;
CREATE DATABASE aula4_tarde;
USE aula4_tarde;

CREATE TABLE funcionario (
	codFuncionario 	INTEGER 	PRIMARY KEY AUTO_INCREMENT,
	nome 			VARCHAR(60)	NOT NULL,
	cpf 			CHAR(14)	NOT NULL	UNIQUE,
	genero 			CHAR		NOT NULL,
	estadoCivil 	VARCHAR(10)	NOT NULL);
	
CREATE TABLE cargo (
	codCargo 	INTEGER 	PRIMARY KEY AUTO_INCREMENT,
	titulo 		VARCHAR(80)	NOT NULL,
	salario 	FLOAT		NOT NULL);
	
CREATE TABLE conjuge (
	codConjuge 	INTEGER 	PRIMARY KEY AUTO_INCREMENT,
	nome 		VARCHAR(60)	NOT NULL,
	telefone 	VARCHAR(10)	NOT NULL,
	cod_func 	INTEGER		NOT NULL	UNIQUE,
	FOREIGN KEY(cod_func) REFERENCES funcionario (codFuncionario));
	
CREATE TABLE projeto (
	codProjeto 		INTEGER 	AUTO_INCREMENT,
	nome 			VARCHAR(60)	NOT NULL,
	valor 			FLOAT		NOT NULL,
	dataInicio 		DATE		NOT NULL,
	tempPrev 		INTEGER		NOT NULL,
	porcentBonus 	FLOAT		NOT NULL,
	PRIMARY KEY(codProjeto));

CREATE TABLE alocado (
	cod_func 	INTEGER		NOT NULL,
	cod_proj 	INTEGER		NOT NULL,
	PRIMARY KEY(cod_func, cod_proj),
	FOREIGN KEY(cod_func) REFERENCES funcionario (codFuncionario),
	FOREIGN KEY(cod_proj) REFERENCES projeto (codProjeto));

SELECT * FROM cargo;	
SELECT * FROM projeto;
SELECT * FROM alocado;
SELECT * FROM funcionario;
SELECT * FROM conjuge;

--Alterar estrutura das tabelas:

--Adc um campo.
ALTER TABLE funcionario ADD COLUMN cod_cargo INT NOT NULL;

--Adc restrição (CONSTRAINT) de chave estrangeira.
ALTER TABLE funcionario ADD CONSTRAINT FK_cargo
FOREIGN KEY(cod_cargo) REFERENCES cargo (codCargo);

--ADC restrição (CONSTRAINT) de campo único.
ALTER TABLE conjuge ADD CONSTRAINT UNQ_codFunc UNIQUE(cod_func);

---Consultar uma constraint
SELECT * FROM information_schema.referential_constraints WHERE constraint_schema = 'aula4_tarde';

DESC cargo;	
DESC projeto;
DESC alocado;
DESC funcionario;
DESC conjuge;

-- Inserir dados nas tabelas.

INSERT INTO cargo(titulo, salario) VALUES('Estagio', 1400),
										 ('Junior', 3350),
										 ('Pleno', 6100),
										 ('Senior', 9800),
										 ('Gerente', 13000);
										 
SELECT * FROM cargo;

INSERT INTO funcionario VALUES(NULL, 'Bia', '123.312.312-21', 'f', 'Solteiro', 4),
							  (NULL, 'Leo', '132.312.312-17', 'm', 'Casado', 3),
							  (NULL, 'Ana', '045.312.312-05', 'f', 'Casado', 1),
							  (NULL, 'Mel', '221.312.312-15', 'f', 'Solteiro', 1),
							  (NULL, 'Edu', '034.312.312-38', 'm', 'Solteiro', 2),
							  (NULL, 'Rui', '441.312.312-06', 'm', 'Solteiro', 1),
							  (NULL, 'Nat', '934.312.312-17', 'f', 'Solteiro', 2);

SELECT * FROM funcionario;
							  
INSERT INTO conjuge VALUES(NULL, 'Beto', '2333-4222', 3),
						  (NULL, 'Duda', '5333-4221', 2);
						  
SELECT * FROM conjuge;

INSERT INTO projeto
	VALUES(NULL, 'E-Commerce', 230000, '2019-05-14', 170, 1),
		  (NULL, 'Gestão Hospitalar', 420000, '2019-07-10', 225, 0.5);

SELECT * FROM projeto;

INSERT INTO alocado(cod_proj, cod_func) VALUES(2, 5), (1, 3), (1, 2), (2, 6), (2, 7), (1, 1), (2, 4);

SELECT * FROM alocado;

--Exibir nome de todos os funcionarios. Caso possuirem conjuges declarados, exibir o nome e telefone do conjuge.
SELECT f.nome AS NomeFunc,
	c.nome AS NomeConj, telefone
	FROM funcionario f LEFT JOIN conjuge c
	ON codFuncionario = cod_func;
	
-- OU 
SELECT f.nome AS NomeFunc,
	IFNULL(c.nome, '---') AS NomeConj,
	IFNULL(telefone, '---') AS TelefoneConj
	FROM funcionario f LEFT JOIN conjuge c
	ON codFuncionario = cod_func;

-- Exibir o nome do funcionario, o nome e o valor do projeto em que foram alocados.
SELECT f.nome AS Funcionario,
	p.nome AS Projeto, valor
	FROM funcionario f
	INNER JOIN alocado
	ON codFuncionario = cod_func
	INNER JOIN projeto p
	ON codProjeto = cod_proj;
	
	
--Exibir o nome e o cargo do funcionario, o nome e o valor do projeto em que foram alocados.
SELECT f.nome AS Funcionario, titulo,
	p.nome AS Projeto, valor
	FROM funcionario f
	INNER JOIN alocado ON codFuncionario = cod_func
	INNER JOIN projeto p ON codProjeto = cod_proj
	INNER JOIN cargo ON codCargo = cod_cargo;
	
--Funções de AGREGAÇÃO- Valores agregados de coluna
SELECT COUNT(nome) FROM funcionario;	
SELECT SUM(valor) FROM projeto;
SELECT AVG(valor) FROM projeto;	
SELECT MIN(salario) FROM cargo;
SELECT MAX(salario) FROM cargo;	

SELECT COUNT (nome) AS QTD_Func,
	SUM(salario) AS Soma,
	ROUND(AVG(salario),2) AS Media
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo;
	
--GROUP BY - Diluir o valor da função de agregação pelos valores distintos de uma coluna.

SELECT DISTINCT genero FROM funcionario;

SELECT estadoCivil, COUNT(nome) AS QTD
FROM funcionario
GROUP BY estadoCivil;

SELECT titulo AS Cargo, COUNT(nome) AS QTD_Func
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	GROUP BY titulo;

SELECT genero, COUNT(nome) AS QTD_Func,
	SUM(salario) AS Soma,
	ROUND(AVG(salario),2) AS Media
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	GROUP BY genero;
	
SELECT estadoCivil, genero, COUNT(nome) AS QTD
	FROM funcionario
	GROUP BY estadoCivil, genero;

SELECT estadoCivil, genero, COUNT(nome) AS QTD
	FROM funcionario
	GROUP BY estadoCivil, genero
	ORDER BY estadoCivil DESC;
	
--WHERE e HAVING

SELECT titulo AS Cargo, COUNT(nome) AS QTD_Func
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	WHERE titulo IN('Junior','Pleno') 
	GROUP BY titulo;
	
SELECT titulo AS Cargo, COUNT(nome) AS QTD_Func
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	GROUP BY titulo HAVING COUNT(nome)>1;
	
SELECT titulo AS Cargo, COUNT(nome) AS QTD_Func,
	SUM(salario) AS Soma
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	WHERE titulo IN ('Estagio', 'Junior', 'Pleno')
	GROUP BY titulo HAVING SUM(salario) > 600;
	
---SubQuery.

-- Exibir funcionarios com salário acima da média.

SELECT nome, salario
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo
	WHERE salario > (SELECT AVG(salario)
	FROM cargo INNER JOIN funcionario
	ON codCargo = cod_cargo);
	
---Calculo com datas.

SELECT DATE_ADD(NOW(), INTERVAL 220 DAY);
SELECT DATE_ADD(NOW(), INTERVAL -220 DAY);

SELECT nome, dataInicio, tempPrev,
	DATE_ADD(dataInicio, INTERVAL tempPrev DAY) AS DataFim
	FROM projeto;
	
SELECT nome,
	DATE_FORMAT(dataInicio, '%d/%m/%Y') AS Inicio, tempPrev,
	DATE_FORMAT(DATE_ADD(dataInicio, INTERVAL tempPrev DAY), '%d/%m/%Y') AS DataFim
	FROM projeto;
	


/*
	Estudo de Caso
	
	Uma empresa requer controlar os dados de seus clientes.	Existem dois tipos de 
	clientes, pessoa física e pessoa jurídica.
	
	Os dados dos clientes pessoa física são: nome, email, renda, endereço, cpf e gênero.
	
	Os dados dos clientes pessoa jurídica são: nome, email, renda, endereço, cnpj e ramo. 
	
**/
	
_______________________________POSTGRESQL__________________________________	
	
	-- Geração de Modelo físico
-- Sql ANSI 2003 - brModelo.

DROP DATABASE aula5_tarde;
CREATE DATABASE aula5_tarde;

---Exibir bases de dados:
\l
---Conectar a uma base de dados
\c aula5_tarde
-- Para listar todas as tabelas: ( \d = ).
\d

CREATE TABLE cliente (
	codCliente 	INTEGER 	PRIMARY KEY,
	nome		VARCHAR(60)	NOT NULL,
	email 		VARCHAR(60)	NOT NULL,
	renda 		FLOAT		NOT NULL);

-- ON DELETE CASCADE (Deleção em cascata) - O registro é excluido quando o registro de referência for excluido. SOMENTE USAR NOS CASOS DE ESPECIALIZAÇÃO.

CREATE TABLE pessoaFisica (
	codCliente 	INTEGER 	PRIMARY KEY,
	cpf 		VARCHAR(14)	NOT NULL,
	genero 		CHAR		NOT NULL,
	FOREIGN KEY(codCliente) REFERENCES cliente (codCliente) ON DELETE CASCADE);

CREATE TABLE pessoaJuridica (
	codCliente 	INTEGER 	PRIMARY KEY,
	cnpj 		CHAR(18)	NOT NULL,
	ramo 		VARCHAR(20)	NOT NULL,
	FOREIGN KEY(codCliente) REFERENCES cliente (codCliente) ON DELETE CASCADE);

CREATE TABLE endereco (
	codEndereco INTEGER 	PRIMARY KEY,
	rua 		VARCHAR(60) NOT NULL,
	bairro 		VARCHAR(60)	NOT NULL,
	cidade 		VARCHAR(60)	NOT NULL,
	cod_Cliente INTEGER		NOT NULL	UNIQUE,
	FOREIGN KEY(cod_Cliente) REFERENCES cliente (codCliente));

-- Exibir tabela.
\d

-- Exibir estrutura das tabelas
\d cliente
\d pessoaFisica
\d pessoaJuridica
\d endereco