-- Aula6 BD - 19/09/2019------

---Exibir bases de dados ( \l = listem):
\l
---Conectar a uma base de dados ( \c = conect):
\c aula5_tarde
-- Para listar todas as tabelas: ( \d = ).
\d
-- Para listar, somente, as tables do banco/schema atual:
\dt
-- Exibir estrutura das tabelas
\d cliente
\d pessoaFisica
\d pessoaJuridica
\d endereco

--AUTOINCREMENTE não existe aqui. 
-- SEQUENCE (sequência) - Objeto independente utilizado para geração de valores sequenciais.

CREATE SEQUENCE seqcliente;

CREATE SEQUENCE seqendereco START WITH 101;

--Ou assim (não mostrado em aula)
DROP SEQUENCE public.seqendereco;

CREATE SEQUENCE public.seqendereco
    INCREMENT 1
    START 101
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.seqendereco
    OWNER TO postgres;

/*
	As sequências são manipuladas pelas funções NEXTVAL() e CURRVAL().
	
	NEXTVAL() -> Iteração da sequência e retorno do próximo valor.
	CURRVAL() -> Retorno do valor atual.
	
**/

INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Bia', 'bia@uol.com', 5300);
INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Leo', 'leo@uol.com', 6100);
INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Nat', 'nat@uol.com', 7200);
INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Mel', 'mel@uol.com', 4700);
INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Coti', 'coti@uol.com', 12000);
INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), 'Xpto', 'xpto@uol.com', 9000);

SELECT * FROM cliente;

INSERT INTO pessoaFisica VALUES(1, '234.423.423-26', 'f');
INSERT INTO pessoaFisica VALUES(2, '333.423.423-07', 'f');
INSERT INTO pessoaFisica VALUES(3, '444.423.423-65', 'f');
INSERT INTO pessoaFisica VALUES(4, '555.423.423-12', 'f');

SELECT * FROM pessoaFisica;

INSERT INTO pessoaJuridica VALUES(5, '16.423.423/0001-17', 'EDU');
INSERT INTO pessoaJuridica VALUES(6, '31.234.423/0001-06', 'COM');

SELECT * FROM pessoaJuridica;

INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua a', '123', 'Cidade q', 5);
INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua s', '312', 'Cidade w', 2);
INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua d', '432', 'Cidade e', 3);
INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua f', '321', 'Cidade r', 4);
INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua g', '732', 'Cidade t', 6);
INSERT INTO endereco VALUES(NEXTVAL('seqendereco'), 'Rua h', '580', 'Cidade y', 1);

SELECT * FROM endereco;

--Pesquisas:

SELECT nome, email, cpf, genero, renda
FROM cliente c INNER JOIN pessoaFisica pf
ON c.codCliente = pf.codCliente;

SELECT nome, email, cnpj, ramo, renda
FROM cliente c INNER JOIN pessoaJuridica pj
ON c.codCliente = pj.codCliente;

SELECT nome, cpf, rua, cidade, bairro
FROM cliente c INNER JOIN pessoaFisica pf
ON c.codCliente = pf.codCliente
INNER JOIN endereco
ON c.codCliente = cod_cliente;

SELECT nome, cpf, rua, cidade, bairro
FROM cliente c
INNER JOIN pessoaFisica pf ON c.codCliente = pf.codCliente
INNER JOIN endereco ON c.codCliente = cod_cliente
WHERE genero = 'f'
ORDER BY nome;

--Programação no PostgreSQL.

--Função com retorno SQL;

CREATE FUNCTION obterDadosCliente(cod INT)
	RETURNS VARCHAR(200) AS $$
	
		SELECT 'nome: ' || nome || ' / e-mail: ' || email || ' / Renda: ' || renda
		FROM cliente
		WHERE codCliente = cod;	
	
$$
LANGUAGE SQL;

SELECT obterDadosCliente (3);
SELECT obterDadosCliente (5);
SELECT obterDadosCliente (2);

CREATE FUNCTION ondeMora (cod_onde_mora INT)
	RETURNS VARCHAR(100) AS $$
	
		SELECT 'nome: ' || nome || ', Renda: ' || renda || ', Bairro: ' || bairro
		FROM endereco INNER JOIN cliente
		ON cod_cliente = codcliente
		WHERE codendereco = cod_onde_mora
	
$$
LANGUAGE SQL;

SELECT ondeMora(104);

CREATE FUNCTION clienteMaisRicosQue(limite INT)
	RETURNS VARCHAR(200) AS $$
	
		SELECT 'Quem é: ' || nome || ' / Quanto ganha: R$ ' || renda || ' / Onde mora: ' || rua || ' '	|| cidade
		FROM cliente INNER JOIN endereco
		ON codCliente = cod_Cliente
		WHERE renda > limite;
		
$$
LANGUAGE SQL;

SELECT clienteMaisRicosQue (8000);

-- Como excluir uma função: DROP FUNCTION public.ondeMora(cod_onde_mora INT);

--Função PLPSQL;
CREATE OR REPLACE FUNCTION calcDesconto(valor FLOAT, porcent FLOAT)
	RETURNS FLOAT AS $$
	DECLARE
		resultado FLOAT;
	BEGIN
	
		resultado = valor - (valor * (porcent/100));

		RETURN resultado;

	END
$$
LANGUAGE PLPGSQL;

SELECT calcDesconto(5600, 30);

SELECT nome, renda,
	calcDesconto (renda, 1.15) AS RendaDesconto
	FROM cliente;


UPDATE cliente SET renda = calcDesconto (renda, 0.75)
	WHERE codCliente = 2;
	
SELECT nome, renda,
	TO_CHAR(calcDesconto (renda, 1.15), '999999d99' AS RendaDesconto
	FROM cliente;

-- Função para executar transação.	
	
CREATE OR REPLACE FUNCTION cadastrarPF(P_nome VARCHAR(40), p_email VARCHAR(40), p_renda FLOAT, p_cpf CHAR(14), sexo CHAR)
	RETURNS VOID AS $$
	DECLARE
		FK_cliente INT;
	BEGIN
	
		INSERT INTO cliente VALUES (NEXTVAL('seqcliente'), p_nome, p_email, p_renda);
		
		FK_cliente = CURRVAL('seqcliente');
		
		INSERT INTO pessoaFisica VALUES(FK_cliente, p_cpf, sexo);

		RETURN;
		
	END;
$$
LANGUAGE PLPGSQL;

SELECT cadastrarPF ('Beto', 'beto@uol.com', 39000, '111.222.333-44', 'm')

SELECT * FROM cliente;
SELECT * from pessoaFisica;


-- Aula6 BD - 19/09/2019

/*
	Estudo de caso:
	
	Uma instituição de ensino requer controlar as avaliações(Aprovações e Reprovações) de seus 
	alunos nas disciplinas por eles cursadas. 

	Cada aluno possui as seguintes informações: nome, email, gênero e data de nascimento. Para alguns
	alunos é necessário armazenar nome e cpf de um responsável.
	
	Das disciplinas que os alunos podem cursar os dados são: nome, carga horária, nome do professor
	e sua titulação máxima. Cada professor pode lecionar várias disciplinas, mas uma disciplina é lecionada
	por apenas um professor. É possível que haja professor sem disciplina, assim como disciplina
	sem professor.

	No ano letivo em que um aluno cursa uma disciplina ele obtém 3 notas para cada disciplina.
	Essas notas são utilizadas para gerar a média e verificar a condição de aprovação do aluno.
	
**/

DROP DATABASE aula6_tarde;
CREATE DATABASE aula6_tarde;

\c aula6_tarde

CREATE TABLE aluno (
	matricula 	INTEGER 	PRIMARY KEY,
	nome 		VARCHAR(50)	NOT NULL,
	email 		VARCHAR(40)	NOT NULL,
	genero 		CHAR		CHECK(genero = 'f' OR genero = 'm') NOT NULL,
	dataNasc 	VARCHAR(10)	NOT NULL);

CREATE TABLE responsavel (
	codResponsavel 	INTEGER 	PRIMARY KEY,
	nome 			VARCHAR(50)	NOT NULL,
	cpf 			CHAR(14)	NOT NULL	UNIQUE,
	mat_aluno 		INTEGER		NOT NULL	UNIQUE,
	FOREIGN KEY(mat_aluno) REFERENCES aluno(matricula));

CREATE TABLE professor (
	codProfessor 	INTEGER 	PRIMARY KEY,
	nome 			VARCHAR(50)	NOT NULL,
	titulacao 		VARCHAR(30)	NOT NULL);

CREATE TABLE disciplina (
	codDisciplina 	INTEGER 	PRIMARY KEY,
	nome 			VARCHAR(50)	NOT NULL,
	cargaHr 		INTEGER		NOT NULL,
	cod_prof	 	INTEGER,
	FOREIGN KEY(cod_prof) REFERENCES professor (codProfessor));

CREATE TABLE notas (
	anoLetivo 		INTEGER,
	cod_disc	 	INTEGER,
	mat_aluno 		INTEGER,
	nota3 			FLOAT,
	nota1 			FLOAT,
	nota2 			FLOAT,
	PRIMARY KEY(anoLetivo, cod_disc, mat_aluno),
	FOREIGN KEY(cod_disc) REFERENCES disciplina (codDisciplina),
	FOREIGN KEY(mat_aluno) REFERENCES aluno (matricula));

-- Criar Sequências.
CREATE SEQUENCE seqaluno;
CREATE SEQUENCE seqresp START WITH 101;
CREATE SEQUENCE seqprof START WITH 110 INCREMENT BY 10;
CREATE SEQUENCE seqdisc;

	
-- Metadados (METADADOS).
\d

SELECT * FROM pg_tables
	WHERE schemaname = 'public';

SELECT * FROM INFORMATION_SCHEMA.tables 
	WHERE table_schema = 'public';

\d aluno
\d responsavel
\d professor
\d disciplina
\d notas





