-- Aula4 BD - 12/09/2019------

USE aula3_tarde;

SHOW TABLES;

SELECT * FROM medico;
SELECT * FROM paciente;
SELECT * FROM pessoaContato;
SELECT * FROM consulta;

--- Manipula��o de data no mySQL:

--- Obter data e hora ATUAL sistema

SELECT CURRENT_DATE;
SELECT CURRENT_TIME;

--Faz a mesma coisa:
SELECT SYSDATE();
SELECT NOW();

--- Extrair texto de uma data.
SELECT DAY('2015-09-16');
SELECT MONTH('2015-09-16');
SELECT YEAR('2015-09-16');

SELECT DAY (NOW()) AS Dia,
       MONTH (NOW()) AS Mes,
	   YEAR (NOW()) AS Ano;
	   
--- Formata��o de datas.
SELECT DATE_FORMAT('2015-09-16', '%d/%m/%Y');
-- ANO(y minusculo) apenas com 2 casa decimais.
SELECT DATE_FORMAT('2015-09-16', '%d/%m/%y') AS DataFormatada;
-- forma de escrever por extenso
SELECT DATE_FORMAT(NOW(), '%W %D %M %Y - %H %i') AS DataFormatada;

-- Aplica��o nos dados das tabelas
--Pegar apenas o ano do nascimento (SE LIGAR NAS VIRGULAS)
SELECT nome, YEAR(dataNasc) AS AnoNascimento
	FROM paciente;
	
SELECT nome,
	DATE_FORMAT(dataNasc,'%d/%m/%Y')AS Nascimento
	FROM paciente;
	
SELECT diagnostico,
	DATE_FORMAT(dataHora,'%W, %D, %M %Y - %H:%i')AS Atendimento
	FROM consulta;
 
--- CALCULAR IDADE
SELECT DATEDIFF ('2019-03-10', '2017-08-16') AS DiasDecorridos;

SELECT nome,
	DATE_FORMAT(dataNasc, '%d/%m/%Y') AS Nascimento,
	DATEDIFF(NOW(),dataNasc) AS Idade
	FROM paciente;

--Arredonda o numero na casa apontada	
	SELECT ROUND(255.6849,2);
	SELECT ROUND(255.6849,1);
--- N�o arredonda o numero na casa apontada, apenas corta-o.
	SELECT TRUNCATE(255.6849,1);
	
SELECT nome,
	DATE_FORMAT(dataNasc, '%d/%m/%Y') AS Nascimento,
	TRUNCATE(DATEDIFF (NOW(),dataNasc) / 365.25, 0) AS Idade
	FROM paciente;

-- Pesquisa em mais de dus tabelas:
SELECT medico.nome, paciente.nome, diagnostico
	FROM medico
	INNER JOIN consulta ON codMedico = cod_med
	INNER JOIN paciente ON codPaciente = cod_pac;

SELECT m.nome AS NomeMedico, espec AS Especialidade, p.nome AS NomePaciente,
	DATE_FORMAT(dataNasc,'%d/%m/%Y')AS Nascimento,
	TRUNCATE(DATEDIFF (NOW(),dataNasc) / 365.25, 0) AS IdadeAtual,
	TRUNCATE(DATEDIFF (dataHora, dataNasc) / 365.25, 0) AS IdadeConsulta,diagnostico,
	DATE_FORMAT(dataHora, '%W %D %M %Y - %H %i') AS Atendimento
	FROM medico m
	INNER JOIN consulta ON codMedico = cod_med
	INNER JOIN paciente p ON codPaciente = cod_pac;
	
	
-- VIEW - Armazenar uma instru��o de pesquisa (query)

CREATE VIEW relAtendimento AS
	SELECT m.nome AS NomeMedico, espec AS Especialidade, p.nome AS NomePaciente,
	DATE_FORMAT(dataNasc,'%d/%m/%Y')AS Nascimento,
	TRUNCATE(DATEDIFF (NOW(),dataNasc) / 365.25, 0) AS IdadeAtual,
	TRUNCATE(DATEDIFF (dataHora, dataNasc) / 365.25, 0) AS IdadeConsulta,diagnostico,
	DATE_FORMAT(dataHora, '%d/%m/%Y - %H %i') AS Atendimento
	FROM medico m
	INNER JOIN consulta ON codMedico = cod_med
	INNER JOIN paciente p ON codPaciente = cod_pac;
	
	
SELECT * FROM  relAtendimento;
DESC relAtendimento;

SELECT nomeMedico, nomePaciente, idadeConsulta, diagnostico
	FROM relAtendimento;
	
---Exportar dados  e mandar para arquivos (C:\ProgramData)

SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/Paciente.txt' FROM paciente;

SELECT * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/Paciente.csv'
	FIELDS TERMINATED BY ';'
	LINES TERMINATED BY '\n'
FROM relAtendimento;


--Criar c�pia de tabela sem os dados.
CREATE TABLE copiaPaciente (LIKE paciente);

DESC copiaPaciente;
SELECT * FROM copiaPaciente;

---Importantar dados de um arquivo.
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.6/Uploads/Paciente.txt' INTO TABLE copiaPaciente;

SELECT * FROM copiaPaciente;


/*
	Segunda Forma Normal (FN2).
	
	Todos os campos de uma tabela, que n�o fazem parte da chave prim�ria, devem ter
	a sua exist�ncia diretamente vinculada � Chave Prim�ria(PK) da tabela ao qual est�o contidos. 

	Em tabelas com Chave Prim�ria Composta n�o deve haver Depend�ncia Parcial, quando um campo 
	que n�o participa da PK depende apenas de parte dos campos que comp�e a PK.
	
	-------------------------------------------------------------------------------------------------
	
	Terceira Forma Normal (FN3).
	
	N�o deve haver Depend�ncia Transitiva, quando um campo que n�o participa da PK 
	depende de outro campo que tamb�m n�o participa da PK.
	
**/


/*
	Estudo de Caso.
	
	Uma empresa requer armazenar os dados de seus funcion�rios: nome, cpf, g�nero, 
	estado civil, cargo e sal�rio. Funcion�rios que exercem o mesmo cargo recebem o mesmo sal�rio.
	
	Caso o funcion�rio seja casado, armazenar nome e telefone do c�njuge.
	
	H� ainda a necessidade de armazenar os dados dos projetos em que os funcion�rios podem
	atuar. Destes projetos os dados s�o nome, valor, data de in�cio, tempo previsto para o 
	t�rmino e porcentagem por participa��o.

	A porcentagem � aplicada ao valor do projeto, gerando um b�nus para os funcion�rios que atuam nele.

**/

DROP DATABASE aula4_tarde;
CREATE DATABASE aula4_tarde;
USE aula4_tarde;

CREATE TABLE funcionario (
	codFuncionario 	INTEGER 	PRIMARY KEY AUTO_INCREMENT,
	nome 			VARCHAR(60)	NOT NULL,
	cpf 			CHAR(14)	NOT NULL     UNIQUE,
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
	
SHOW TABLES;

DESC cargo;
DESC funcionario;
DESC conjuge;
DESC projeto;
DESC alocado;

/*
	Exerc�cios.

	1- Inserir dados em todas as tabelas.
	
	2- Exibir funcion�rios e seus conjuges.
	
	3- Exibir funcion�rios e os projetos em que foram alocados.

**/
