-- Aula8 BD - 26/09/2019------

---Usuários, grupos e permissões

--Usuário atual.
SELECT CURRENT_USER;
--Ver todos usuários;
\du
--DROP USER ...;
DROP USER ...

CREATE USER joao WITH PASSWORD '111';
CREATE USER jose WITH PASSWORD '222';
CREATE USER maria WITH PASSWORD '333';

--Criar grupos de usuários?
CREATE GROUP dba_estagio WITH USER joao;
ALTER GROUP dba_estagio ADD USER jose;

--Conceder permissões;
\c aula6_tarde

GRANT INSERT, SELECT ON aluno TO maria;

GRANT INSERT ON relMedia TO dba_estagio;

---Trocar usuario
\c aula6_tarde joao
SELECT CURRENT_USER;

SELECT * FROM relMedia;
SELECT * FROM aluno;

\c postegres postegres


--Backup 

---No prompt de comand do SO
C:\Program Files\PostgreSQL\9.3\bin

pg_dump -U postgres -s aula6_tarde > C:\backup\aula8_tarde_BKP.txt

pg_dump -U postgres -c --inserts aula6_tarde > C:\backup\aula8_tarde_BKPCompleto.txt

--------------------------

DROP DATABASE aula6_tarde;

---No prompt de comand do SO
C:\Program Files\PostgreSQL\9.3\bin

psql -U postgres -f C:\backup\aula8_tarde_BKP.txt



----------Voltando para o MySQL



DROP DATABASE aula8;
CREATE DATABASE aula8;
USE aula8;

CREATE TABLE funcionario (
	codigo 		INT	 		PRIMARY KEY	AUTO_INCREMENT,
	nome 		VARCHAR(40)	NOT NULL,
	genero 		CHAR		NOT NULL,
	salario		FLOAT		NOT NULL);

DESC funcionario;
	
INSERT INTO funcionario(nome, genero, salario)VALUES('Beto', 'm', 4100),
													('Cadu', 'm', 4100),
													('Duda', 'f', 4100),
													('Mila', 'f', 4100),
													('Nat', 'f', 4100);
							  
SELECT * FROM funcionario;

-- Programação no MySQL.

-- Alterar o caracter de execução.
DELIMITER $$

DESC funcionario$$
SELECT * FROM funcionario$$

-- Criar função.
CREATE FUNCTION calcSalLiq(sal FLOAT, qtdFalta INT)
	RETURNS FLOAT 
	BEGIN
		DECLARE salDia, salLiq FLOAT;
	
		SET salDia = sal / 22;
		
		SET salLiq = sal - (salDia * qtdFalta);
	
		RETURN salLiq;
	
	END;
$$

SELECT calcSalLiq(2000, 3)$$


SELECT nome, salario, calcSalLiq(salario, 2) AS Liquido
	FROM funcionario WHERE codigo = 3$$

SELECT nome, salario, 
	ROUND(calcSalLiq(salario, 2), 2) AS Liquido
	FROM funcionario WHERE codigo = 3$$

-- Criar Stored Procedure.

CREATE PROCEDURE cadFuncionario(pnome VARCHAR(50), sexo CHAR, sal FLOAT, qtdDependente INT)
	BEGIN
		DECLARE valorAbono, abono FLOAT;
	
		IF sal < 5000 THEN
			SET abono = 370;
		ELSE
			SET abono = 150;
		END IF;
	
		SET valorAbono = abono * qtdDependente;
	
		INSERT INTO funcionario(nome, genero, salario) VALUES(pnome, sexo, sal + valorAbono);
	
	END;
$$

-- Executar Procedure.
CALL cadFuncionario('Beto', 'm', 5100, 2)$$
CALL cadFuncionario('Rita', 'f', 4800, 2)$$

SELECT * FROM funcionario$$

-- Criar cópia da tabela sem os dados.
CREATE TABLE funcDel(LIKE funcionario)$$

DESC funcDel$$
SELECT * FROM funcDel$$

-- Trigger(Gatilho).

CREATE TRIGGER tgMoverFuncDel
	AFTER DELETE ON funcionario
	FOR EACH ROW
	BEGIN
	
		INSERT INTO funcDel VALUES(OLD.codigo, OLD.nome, OLD.genero, OLD.salario);
	
	END;
$$

DELETE FROM funcionario WHERE codigo = 4$$

SELECT * FROM funcionario$$
SELECT * FROM funcDel$$

DELIMITER ;

-- Eventos agendados.

-- Habilitar o agendamento de eventos.
SET GLOBAL event_scheduler = 1;

-- Criar uma tabela pra teste.
CREATE TABLE teste(data_hora TIMESTAMP);

-- Criar evento para inserir na tabela a cada 10 segundos.
CREATE EVENT inserirAgendado
	ON SCHEDULE EVERY 10 SECOND
	STARTS '2019-09-26 15:11'
	ENDS '2019-09-26 15:13'
	DO
	INSERT INTO teste VALUES(NOW());

SELECT * FROM teste;

-- Controle de transação (COMMIT e ROLLBACK).

-- Desativar o autocommit.
SET SESSION autocommit = 0;

UPDATE funcionario SET genero = 'f';

DELETE FROM teste;

SELECT * FROM funcionario;
SELECT * FROM teste;

-- Confirmar Transações.
COMMIT;

-- Desfazer Transações.
ROLLBACK;

-- Ativar o autocommit.
SET SESSION autocommit = 1;

--Exportar dados para arquivos.

SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/funcionarios.txt' FROM funcionario;  

SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/funcionarios.csv' FROM funcionario;  
	FIELDS TERMINATED BY ';'
	LINES TERMINATED BY '\n'
FROM funcionario;

---Importar dados para arquivo:

DELETE FROM funcionario;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/funcionarios.txt' INTO TABLE funcionario;  

SELECT * FROM funcionario;

-- BLOB - Armazenar o código binário de um arquivo.

C:\ProgramData\MySQL\MySQL Server 5.6\Uploads\irmaodojorel.jpg

CREATE TABLE foto(
	id		INT		PRIMARY KEY,
	imagem	BLOB	NOT  NULL);
	
DESC foto;

INSERT INTO foto VALUES(1, LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/irmaodojorel.jpg'));

SELECT imagem INTO DUMPFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/irmaodojorel_CRIADO.raw' FROM foto WHERE id = 1;

-- Tipos de tabela no MySQL.

-- InnoDB - Tabela padrão do MySQL.
SHOW TABLE STATUS;

-- MyISAM - Tabela que prioriza as consultas, em detrimento às transações.

CREATE TABLE aluno(
	codigo 		INT	 		PRIMARY KEY	AUTO_INCREMENT,
	nome 		VARCHAR(40)	NOT NULL,
	genero 		CHAR		NOT NULL,
	idade		INT			NOT NULL) ENGINE = MYISAM;

DESC aluno;
	
INSERT INTO aluno(nome, genero, idade)VALUES('Beto', 'm', 17),
											('Cadu', 'm', 21),
											('Duda', 'f', 28),
											('Mila', 'f', 19),
											('Nat', 'f', 20);
							  
SELECT * FROM aluno;

SHOW TABLE STATUS;

-- Criação de usuários e permissões.

-- Usuário atual.
SELECT CURRENT_USER;

-- Todos os usuários.
SELECT user, host, password FROM mysql.user;

-- Criar usuário.
CREATE USER dudu IDENTIFIED BY '111';

-- Conceder permissões.
GRANT SELECT, INSERT ON teste TO dudu;

-- Teste de conexão com usuário no CMD.
cd C:\Program Files\MySQL\MySQL Server 5.6\bin

mysql -u dudu -p

SELECT CURRENT_USER;

USE aula8;

SELECT * FROM teste;
SELECT * FROM funcionario;

-- Backup

-- No prompt de comando.
cd C:\Program Files\MySQL\MySQL Server 5.6\bin

mysqldump -u root -p -B aula8 --routines --triggers > C:/backup/BKP_aula8.sql

-- Restaurar banco de dados (MySQL Command Line).

DROP DATABASE aula8;

SOURCE C:/backup/BKP_aula8.sql

USE aula8;








