-- Aula7 BD - 24/09/2019------

DROP DATABASE aula6_tarde;
CREATE DATABASE aula6_tarde;
 --"O mesmo que USE aula6_tarde;"
\c aula6_tarde
--ou (listar tabelas)
\d 

CREATE TABLE aluno (
	matricula 	INTEGER 	PRIMARY KEY,
	nome 		VARCHAR(50)	NOT NULL,
	email 		VARCHAR(40)	NOT NULL,
	genero 		CHAR		CHECK(genero = 'f' OR genero = 'm') NOT NULL,
	dataNasc 	VARCHAR(10)	NOT NULL);

ALTER TABLE aluno ALTER COLUMN dataNasc TYPE DATE USING datanasc::date;

CREATE TABLE responsavel (
	codResponsavel 	INTEGER 	PRIMARY KEY,
	nome 			VARCHAR(50)	NOT NULL,
	cpf 			CHAR(14)	NOT NULL	UNIQUE,
	mat_aluno 		INTEGER		NOT NULL	UNIQUE,
	FOREIGN KEY(mat_aluno) REFERENCES aluno (matricula));

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




-- Inserir dados

INSERT INTO aluno VALUES(NEXTVAL('seqaluno'), 'Leo', 'leo@uol.com', 'm', '1994-06-17'),
						(NEXTVAL('seqaluno'), 'Ana', 'ana@uol.com', 'f', '1998-03-29'),
						(NEXTVAL('seqaluno'), 'Bia', 'bia@aol.com', 'f', '1995-10-06'),
						(NEXTVAL('seqaluno'), 'Edu', 'edu@uol.com', 'm', '1990-08-21'),
						(NEXTVAL('seqaluno'), 'Nat', 'nat@uol.com', 'f', '1989-11-05'),
						(NEXTVAL('seqaluno'), 'Mel', 'mel@aol.com', 'f', '1985-04-30'),
						(NEXTVAL('seqaluno'), 'Rui', 'rui@uol.com', 'm', '1991-10-09');
						
SELECT * FROM aluno;

INSERT INTO responsavel VALUES(NEXTVAL('seqresp'), 'Pedro', '233.123.321-05', 5);
INSERT INTO responsavel VALUES(NEXTVAL('seqresp'), 'Maria', '444.123.321-16', 2);
INSERT INTO responsavel VALUES(NEXTVAL('seqresp'), 'Paulo', '064.123.321-41', 1);
INSERT INTO responsavel VALUES(NEXTVAL('seqresp'), 'Bruna', '124.123.321-27', 4);

SELECT * FROM responsavel;

INSERT INTO professor(codProfessor, nome, titulacao)
					  VALUES(NEXTVAL('seqprof'), 'Beto', 'Doutorado'),
							(NEXTVAL('seqprof'), 'Rafa', 'Pos Graduacao'),
							(NEXTVAL('seqprof'), 'Duda', 'Mestrado'),
							(NEXTVAL('seqprof'), 'Cadu', 'Graduacao');
							
SELECT * FROM professor;

INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'Logica', 32, 140);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'BD', 32, 110);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'PHP', 60, 120);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'SQL Server', 32, 120);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'BI', 40, 110);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'UML', 20, NULL);
INSERT INTO disciplina VALUES (NEXTVAL('seqdisc'), 'Oracle', 32, 110);

SELECT * FROM disciplina;

INSERT INTO notas VALUES (2018, 3, 2);

SELECT * FROM notas;

UPDATE notas SET nota1 = 6.5
	WHERE anoLetivo = 2018 AND cod_disc = 3
	AND mat_aluno = 2;
	
UPDATE notas SET nota2 = 4
	WHERE anoLetivo = 2018 AND cod_disc = 3
	AND mat_aluno = 2;
	
UPDATE notas SET nota3 = 5
	WHERE anoLetivo = 2018 AND cod_disc = 3
	AND mat_aluno = 2;
	
SELECT * FROM notas;

INSERT INTO notas VALUES (2018, 6, 4, 8, 7.5, 5);
INSERT INTO notas VALUES (2018, 2, 3, 4, 9.5, 7);
INSERT INTO notas VALUES (2018, 7, 1, 5, 7, 6);
INSERT INTO notas VALUES (2018, 3, 6, 4, 9, 6);
INSERT INTO notas VALUES (2018, 1, 3, 7, 6, 6);
INSERT INTO notas VALUES (2018, 2, 2, 3, 5, 7);
INSERT INTO notas VALUES (2019, 5, 4, 8, 7, 4);
INSERT INTO notas VALUES (2019, 3, 1, 6, 6, 8);
INSERT INTO notas VALUES (2019, 5, 2, 7, 4, 6);
INSERT INTO notas VALUES (2019, 7, 6, 8, 7, 5);
INSERT INTO notas VALUES (2019, 1, 3, 6, 5, 5);
INSERT INTO notas VALUES (2019, 2, 2, 5, 8, 7);
INSERT INTO notas VALUES (2019, 3, 5, 5, 5.5, 5);
INSERT INTO notas VALUES (2019, 4, 1, 7, 8.5, 6);
INSERT INTO notas VALUES (2019, 6, 2, 6.5, 8.5, 8);
INSERT INTO notas VALUES (2019, 5, 3, 5.5, 5, 8);

SELECT * FROM notas;
	
SELECT nome, 
	TO_CHAR(dataNasc, 'dd/mm/yyyy') AS Nascimento
	FROM aluno;

SELECT nome, 
	DATE_PART('MONTH', dataNasc) AS AnoNascimento
	FROM aluno;

SELECT nome, 
	DATE_PART('YEAR', dataNasc) AS AnoNascimento
	FROM aluno;

SELECT nome, 
	TO_CHAR(dataNasc, 'dd/mm/yyyy') AS Nascimento,
	AGE(dataNasc) AS Idade
	FROM aluno;


SELECT nome, 
	TO_CHAR(dataNasc, 'dd/mm/yyyy') AS Nascimento,
	DATE_PART('YEAR', AGE(dataNasc)) AS Idade
	FROM aluno;

SELECT p.nome AS NomeProf, d.nome AS NomeDisc, cargaHr
	FROM professor p INNER JOIN disciplina d
	ON codProfessor = cod_prof;
	
SELECT p.nome AS NomeProf, d.nome AS NomeDisc, cargaHr
	FROM professor p LEFT JOIN disciplina d
	ON codProfessor = cod_prof;
	
SELECT p.nome AS NomeProf, d.nome AS NomeDisc, cargaHr
	FROM professor p RIGHT JOIN disciplina d
	ON codProfessor = cod_prof;
	
SELECT p.nome AS NomeProf, d.nome AS NomeDisc, cargaHr
	FROM professor p FULL JOIN disciplina d
	ON codProfessor = cod_prof
	
---Busca em mais de uma tabela
SELECT anoLetivo, d.nome AS disciplina, a.nome AS Aluno, nota1, nota2, nota3
	FROM aluno a
	INNER JOIN notas ON matricula = mat_aluno
	INNER JOIN disciplina d ON codDisciplina = cod_disc;

SELECT AVG(nota1) AS "Media Nota1"
	FROM notas;
	
SELECT genero, ROUND(AVG(nota1)) AS "Media Nota1"
	FROM aluno
	INNER JOIN notas ON matricula = mat_aluno
	GROUP BY genero;
	
SELECT anoLetivo, p.nome AS Professor, d.nome AS disciplina,
	a.nome AS aluno, nota1, nota2, nota3,
	(nota1 + nota2 + nota3)/3 AS media
	FROM aluno a
	INNER JOIN notas ON matricula = mat_aluno
	INNER JOIN disciplina d ON codDisciplina = cod_disc
	LEFT JOIN professor p ON codProfessor = cod_prof;
	
SELECT * FROM relMedia;

CREATE VIEW relMedia2 AS
	SELECT anoLetivo, p.nome AS Professor, d.nome AS disciplina,
	a.nome AS aluno, nota1, nota2, nota3,
	ROUND((nota1 + nota2 + nota3)/3) AS media
	FROM aluno a
	INNER JOIN notas ON matricula = mat_aluno
	INNER JOIN disciplina d ON codDisciplina = cod_disc
	LEFT JOIN professor p ON codProfessor = cod_prof;
	
SELECT * FROM relMedia2;

SELECT anoLetivo, aluno, disciplina,
	TO_CHAR(media, '99d99') AS Media
	FROM relMedia
	ORDER BY anoLetivo, aluno;
------	
SELECT anoLetivo, aluno, disciplina,
	TO_CHAR(media, '99d99') AS Media,
	CASE
	
		WHEN media >= 7 THEN 'Aprovado'
		WHEN media >= 6 AND media <= 6.99 THEN 'Recuperacao'
		ELSE 'Reprovado'
	END AS Situacao
FROM relMedia
	ORDER BY anoLetivo, aluno;

--Exportar daddos para arquivos;
\copy aluno TO C:/bancodedados/alunos.txt

\copy aluno TO C:/bancodedados/alunos.csc DELIMITER ';'

CREATE VIEW realSituacao AS
SELECT anoLetivo, aluno, disciplina,
	TO_CHAR(media, '99d99') AS Media,
	CASE
	
		WHEN media >= 7 THEN 'Aprovado'
		WHEN media >= 6 AND media <= 6.99 THEN 'Recuperacao'
		ELSE 'Reprovado'
	END AS Situacao
FROM relMedia;

\copy (SELECT * FROM realSituacao) TO C:/bancodedados/situacaoAluno.csv  DELIMITER ';' CSV HEADER

--IMPORTAR  daddos para arquivos;

CREATE TABLE copiaAluno(LIKE aluno);
\d copiaAluno
SELECT * FROM copiaAluno;

\copy copiaAluno FROM C:/bancodedados/alunos.txt
SELECT * FROM copiaAluno;

DELETE FROM copiaAluno;
	
--SCHEMA - DIvisão de uma base de dados
CREATE SCHEMA rh; 
	
---SCHEMA atual
SHOW SEARCH_PATH;

---criar tabela no esquema rh
--SERIAL : Criação implicita de SEQUENC
CREATE TABLE rh.funcionario (
	matricula 	SERIAL				PRIMARY KEY,
	nome 		VARCHAR(50)			NOT NULL,
	genero 		CHAR				NOT NULL,
	salario 	DEC(10,2)		NOT NULL);
	
	
SET SEARCH_PATH TO rh;

DROP TABLE funcionario;

CREATE TABLE rh.funcionario (
	codigo 	SERIAL				PRIMARY KEY,
	nome 		VARCHAR(50)			NOT NULL,
	genero 		CHAR				NOT NULL,
	salario 	DEC(10,2)		NOT NULL);
	
\d
\d funcionario


INSERT INTO funcionario(nome,genero, salario) VALUES('Hugo', 'm',4500),
													('Mila', 'f',4500),
													('Rafa', 'f',4500),
													('Dudu', 'm',4500),
													('Nat', 'f',4500);
						
SELECT * FROM funcionario;
SELECT * FROM public.aluno;

--UNION e UNION ALL.						
						
SELECT nome, genero FROM funcionario
UNION
SELECT nome, genero FROM public.aluno;

SELECT codigo, nome, genero FROM funcionario
UNION
SELECT matricula, nome, genero FROM public.aluno;

SELECT nome, genero, TO_CHAR(salario, '9999d99') AS "Salario/email" FROM funcionario
UNION
SELECT nome, genero, email FROM public.aluno;

SELECT nome, genero FROM funcionario
UNION ALL
SELECT nome, genero FROM public.aluno;

SELECT nome, genero, '----' AS email, 'Funcionario' AS Tipo
FROM funcionario
UNION
SELECT nome, genero, email, 'Aluno' FROM public.aluno;

SELECT 'F_' || codigo AS ID, nome, genero FROM funcionario
UNION
SELECT 'A_' || matricula, nome, genero FROM public.aluno;
						
--- TRIGGER (GATILHO) - Bloco de programação executado a partir de um evento 						
						
-- 1º Criar a função qie será executada.

CREATE FUNCTION fnVerifReducSal()
	RETURNS TRIGGER AS $$
	BEGIN
	
		IF NEW.salario < OLD.salario THEN
			RAISE NOTICE 'Salario Atual: %', OLD.salario;
			RAISE EXCEPTION 'Salario nao pode ser reduzido';
		END IF;
	
		RETURN NEW;
	END;
$$
LANGUAGE PLPGSQL;

--2º Criar TRIGGER que determina quando a funcao e executada.

CREATE TRIGGER tgVerifReducSal
	BEFORE UPDATE ON funcionario
	FOR EACH ROW
	EXECUTE PROCEDURE fnVerifReducSal();
	
UPDATE funcionario SET salario = 3000 WHERE codigo = 3;
SELECT * FROM funcionario;

UPDATE funcionario SET salario = 5000 WHERE codigo = 3;
SELECT * FROM funcionario;

SET SEARCH_PATH TO public;

---(AICD) = atomicidade, Consistência, Isolamento e Durabilidade

--Controle de transacao (COMMIT E ROOLLBACK)

--Incicie um bloco de trnsacao
BEGIN;

UPDATE aluno SET genero = 'f';

SELECT * FROM aluno;

DELETE FROM responsavel;
SELECT * FROM responsavel;

--confirmar transacao:
COMMIT;

-- DESFAZER TRANSACAO:
ROLLBACK;

SELECT * FROM aluno;
SELECT * FROM responsavel;















1


