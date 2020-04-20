-- Aula3 BD - 10/09/2019------

***Status apresenta o CURRENT DATABASE:

-- UNIQUE - campo unico, nao permite ducplicidade.

CREATE TABLE funcionario (
codFuncionario                INTEGER       PRIMARY KEY,
nome                          VARCHAR(40)   NOT NULL,
cpf                           CHAR(14)      NOT NULL        UNIQUE,
genero                        CHAR          NOT NULL,
salario                       FLOAT         NOT NULL);
     

/* Como declarar uma chave estrangeira:
FOREING KEY (cod_func) - Declarar o campo cod_func como uma chave estrangeira.
REFERENCES funcionario (codFuncionario) - Determinar a referencia da chave estrangeria ao campo do funcionario da tabela funcionario.
*/
CREATE TABLE dependente (
codDependente                 INTEGER      PRIMARY KEY,
nome                          VARCHAR(40)  NOT NULL,
telefone                      VARCHAR(10)  NOT NULL,
grauParent                    VARCHAR(10)  NOT NULL,
cod_Func                      INTEGER      NOT NULL,
FOREIGN KEY(cod_Func) REFERENCES funcionario (codFuncionario));

    
CREATE TABLE endereco (
codEndereco                   INTEGER      PRIMARY KEY,
rua                           VARCHAR(60)  NOT NULL,
numero                        VARCHAR(10)  NOT NULL,
bairro                        VARCHAR(60)  NOT NULL,
cidade                        VARCHAR(60)  NOT NULL,
uf                            CHAR(2)      NOT NULL,
codFunc                       INTEGER      NOT NULL         UNIQUE,
FOREIGN KEY(codFunc) REFERENCES funcionario (codFuncionario));

---Exibir tabelas;
SHOW TABLES;

--- Exibir estrutura das tabelas:
DESC funcionario;
DESC endereco;
DESC dependente;

--Inserir dados nas tabelas.
INSERT INTO funcionario VALUE (101,'Bia','123.312.312-16','f',5200);
INSERT INTO funcionario VALUE (102,'Leo','222.312.312-31','m',4700);
INSERT INTO funcionario VALUE (103,'Ana','333.312.312-03','f',6100);
INSERT INTO funcionario VALUE (104,'Nat','444.312.312-14','f',7400);
INSERT INTO funcionario VALUE (105,'Edu','555.312.312-28','m',3500);

SELECT * FROM funcionario;

INSERT INTO endereco VALUE (1,'Rua a','132','Bairro q','Cidade z','RJ', 101);
INSERT INTO endereco VALUE (2,'Rua s','312','Bairro w','Cidade x','SP', 102);
INSERT INTO endereco VALUE (3,'Rua d','553','Bairro e','Cidade c','RJ', 103);
INSERT INTO endereco VALUE (4,'Rua f','423','Bairro r','Cidade v','MG', 104);
INSERT INTO endereco VALUE (5,'Rua g','546','Bairro t','Cidade b','ES', 105);

SELECT * FROM endereco;

INSERT INTO dependente VALUE (1, 'Beto', '4444-6666', 'Filho', 103);
INSERT INTO dependente VALUE (2, 'Rafa', '5544-6666', 'Filha', 104);
INSERT INTO dependente VALUE (3, 'Mila', '6644-6666', 'Filha', 102);
INSERT INTO dependente VALUE (4, 'Duda', '7744-6666', 'Filha', 101);
INSERT INTO dependente VALUE (5, 'Hugo', '8844-6666', 'Filho', 105);
INSERT INTO dependente VALUE (6, 'Cadu', '9944-6666', 'Conjugue', 104);
INSERT INTO dependente VALUE (7, 'Rita', '2244-6666', 'Conjugue', 102);

SELECT * FROM dependente;

---- EXERCICIOS----

-- Exibir funcionarios do sexo feminino com salario inferior a 6000.
SELECT * FROM funcionario WHERE genero = 'f' AND salario < 6000;


-- Exibir os endereços do Rio e de Minas Gerais.
SELECT * FROM endereco WHERE uf = 'RJ' OR uf = 'MG';
--pode parecer a mesma coisa, mas isso nao funciona:
SELECT * FROM endereco WHERE uf = 'RJ' OR 'MG'; 
--o outro jeito certo é esse (Deixa mais organizado e menos repetitivo)
SELECT * FROM endereco WHERE uf IN('RJ', 'MG');

	
-- Exibir nome, grau de parentesco e telefone dos dependentes.
-- somente filhos e filhas em ordem alfabética.
--- +1X ESSE COMANDO (ABAIXO) ESTA ERRADO
SELECT nome, grauParent, telefone
	FROM dependente
	WHERE grauParent = 'Filho' OR 'Filha' #o erro tá aqui#
	ORDER BY nome;
--Agora certo:	
SELECT nome, grauParent, telefone FROM dependente WHERE grauParent = 'Filho' OR grauParent = 'Filha' ORDER BY nome;
--Agora outro jeito certo:
SELECT nome, grauParent, telefone
	FROM dependente
	WHERE grauParent IN('Filho', 'Filha')
	ORDER BY nome;
	
-- Exibir os endereços que não são do Rio e de Minas Gerais.
SELECT * FROM endereco WHERE uf <> 'RJ' OR 'MG'; #o erro tá aqui#
--certo...
SELECT * FROM endereco WHERE uf NOT IN ('RJ', 'MG');


---PESQUISA EM DUAS TABELAS (ATENÇÃO! SINTAXE DEFASADA pois só apresenta a intercessão.
--- Há outro jeito que é através do JOIN.

SELECT nome, rua, bairro, uf
	FROM funcionario, endereco
	WHERE codFuncionario = codFunc;
	---Observe que fazer referencia FOREST KEY
	--- CAMPO =codFuncionario DA TABLE funcionario E CAMPO =codFunc DA TABLE endereco;
	
SELECT codFuncionario, nome, rua,
	codEndereco, bairro, uf, codFunc
	FROM funcionario, endereco
	WHERE codFuncionario = codFunc;
	
SELECT nome, rua, bairro, uf
	FROM funcionario, endereco
	WHERE codFuncionario = codFunc;
	AND uf = "RJ";

---Como relacionar um determiando campo que se repete entre as tabelas.
SELECT codFuncionario, funcionario.nome, cpf, genero, salario, codDependente, dependente.nome, telefone, grauParent, cod_Func
	FROM funcionario, dependente
	WHERE codFuncionario = cod_Func;
	
--- Se as tabelas possuirem nomes de campos semelhantes, é preciso identificar qual campo pertence a qual tabela.
	SELECT funcionario.nome, dependente.nome, grauParent
	FROM funcionario, dependente
	WHERE codFuncionario = cod_func;
	
--	ou outra maneira (com uma alinea para o nome dos campos)
SELECT f.nome AS NomeFunc, d.nome AS NomeDependente, grauParent
	FROM funcionario f, dependente d
	WHERE codFuncionario = cod_func;
	
	
------- PESQUISA EM DUAS TABELAS USANDO O JOIN
--- INNER JOIN
SELECT nome, rua, bairro, uf
	FROM funcionario INNER JOIN endereco
	ON codFuncionario = codFunc;
	
SELECT nome, rua, bairro, uf
	FROM funcionario INNER JOIN endereco
	ON codFuncionario = codFunc
	WHERE uf = 'RJ';
	
SELECT f.nome AS NomeFunc, d.nome AS NomeDependente, grauParent
	FROM funcionario f INNER JOIN dependente d
	ON codFuncionario = cod_func;

------- PESQUISA EM DUAS TABELAS USANDO O JOIN
------ LEFT / RIGHT JOIN

INSERT INTO funcionario VALUE (106, 'Val', '888.312.312-28', 'f',5700);

SELECT funcionario.nome, dependente.nome, grauParent
	FROM funcionario LEFT JOIN dependente
	ON codFuncionario = cod_func;
	
SELECT funcionario.nome, dependente.nome, grauParent
	FROM dependente RIGHT JOIN funcionario
	ON codFuncionario = cod_func;

________________TAREFA NO BR MODELO________________	
	
/*
	Estudo de Caso
	
	Um hospital requer armazenar os dados de suas consultas. Cada consulta realizada deve armazenar o nome do médico e sua especialidade; o nome, gênero e data de nascimento 
	do paciente; o diagnóstico e a data e hora do atendimento.

	Os médicos podem atender qualquer paciente várias vezes, assim como os pacientes podem 
	ser atendidos por qualquer médico várias vezes.
	
	Os pacientes podem informar o nome e o telefone de uma pessoa para contato, 
	mas isso não é obrigatório.

**/

-- AUTO INCRMENTE - Geração automatica de valores sequenciais.

CREATE TABLE medico (
	codMedico 	   INTEGER       PRIMARY KEY      AUTO_INCREMENT,
	nome 		   VARCHAR(50)   NOT NULL,
	espec 		   VARCHAR(40)   NOT NULL);

--ENUM('f', 'm') - Limitar a entrada de dados para o campo.
---Data - Armazenamento datas no formato yyyy-mmm-ddd.

CREATE TABLE paciente (
	codPaciente   INTEGER            PRIMARY KEY  AUTO_INCREMENT,
	nome          VARCHAR(50)        NOT NULL,
	genero        ENUM('f', 'm')     NOT NULL,
	dataNasc      DATE               NOT NULL);

CREATE TABLE pessoaContato (
	codContato        INTEGER       PRIMARY KEY   AUTO_INCREMENT,
	nome              VARCHAR(50)   NOT NULL,
	telefone          VARCHAR(10)   NOT NULL,
	cod_pac           INTEGER       NOT NULL      UNIQUE,
	FOREIGN KEY(cod_pac) REFERENCES paciente (codPaciente));

---TIMESTAMP - Armazena data e hora no formato yyyy-mmm-ddd    hh:mm:ss.

CREATE TABLE consulta (
	codConsulta       INTEGER       PRIMARY KEY   AUTO_INCREMENT,
	cod_med           INTEGER       NOT NULL,
	cod_pac           INTEGER       NOT NULL,
	diagnostico       VARCHAR(200)  NOT NULL,
	dataHora          TIMESTAMP,
	FOREIGN KEY(cod_med) REFERENCES medico (codMedico),
	FOREIGN KEY(cod_pac) REFERENCES Paciente (codPaciente));
	
DESC medico;	
DESC paciente;
DESC pessoaContato;	
DESC consulta;
	
/* MEU COMENTARIO
DATETIME e TIMESTAMP:
Ambos os tipos suportam o seguinte formato, 'YYYY-MM-DD HH:MM:SS' mas a diferença está no intervalo de tempo aceito. O intervalo de tempo (DATA e HORA) aceito pelo tipo DATETIME é de '1000-01-01 00:00:00' até '9999-12-31 23:59:59'. Já  o intervalo para o tipo TIMESTAMP é de '1970-01-01 00:00:01' até '2038-01-19 03:14:07'.
 
Podemos observar que o tipo DATETIME possui um intervalo maior que o tipo TIMESTAMP, tecnicamente essa diferença pode influenciar em uma data de nascimento onde a pessoa nasceu antes de 1970. É uma prática normal usar um campo com o tipo TIMESTAMP com default DATA e HORA do servidor gravando quando o registro foi incluído ou alterado
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;
*/

---ENTRANDO COM OS DADOS

INSERT INTO medico VALUES(NULL, 'Mel', 'Ortopedia');
INSERT INTO medico VALUES(NULL, 'Edu', 'Cardiologia');
INSERT INTO medico VALUES(NULL, 'Nat', 'Pediatria');
INSERT INTO medico VALUES(NULL, 'Bia', 'Clinica Medica');

SELECT * FROM medico;

INSERT INTO paciente VALUES(NULL, 'Rafa', 'f', '1989-04-16'),
						   (NULL, 'Duda', 'f', '1976-05-20'),
						   (NULL, 'Cadu', 'm', '1983-01-03'),
						   (NULL, 'Beto', 'm', '1954-02-12'),
						   (NULL, 'Juca', 'm', '2011-10-29'),
						   (NULL, 'Mila', 'f', '1971-11-08'),
						   (NULL, 'Hugo', 'm', '1965-07-11');

SELECT * FROM paciente;

/*Especifico os campos que quero acrescentar informação;
Repare que a TABLE pessoaContato possui 4 campos. Mas no momento
não queremos entrar  com informação do campo codContato, pois ele
é AUTO INCREMENT. */
INSERT INTO pessoaContato(nome, telefone, cod_pac) 
		VALUES('Maria', '3333-5555', 2),
			  ('Pedro', '7777-5555', 4),
			  ('Paulo', '4444-5555', 5);

SELECT * FROM pessoaContato;

INSERT INTO consulta(codConsulta, cod_med, cod_pac, diagnostico, dataHora)
					 VALUES(NULL, 4, 7, 'Dengue', '2018-12-22 10:00'),
						   (NULL, 1, 2, 'Fratura', '2018-12-26 08:30'),
						   (NULL, 3, 5, 'Catapora',	'2018-12-29 17:00'),
						   (NULL, 4, 6, 'Virose', '2019-01-03 14:00'),
						   (NULL, 4, 3, 'Infeccao',	'2019-01-11 16:00'),
						   (NULL, 1, 3, 'Entorse', '2019-01-24 13:00'),
						   (NULL, 2, 1, 'Hipertensao', '2019-01-30 11:20'),
						   (NULL, 4, 2, 'Zika', '2019-02-04 17:20'),
						   (NULL, 1, 1, 'Fratura', '2019-02-09 09:00'),
						   (NULL, 4, 3, 'Gripe', '2019-02-15 15:30'),
						   (NULL, 2, 7, 'Arritmia', '2019-03-01 16:30'),
						   (NULL, 1, 2, 'Luxacao', '2019-03-08 13:00'),
						   (NULL, 4, 1, 'Pneumonia', '2019-03-14 12:00'),
						   (NULL, 3, 5, 'Gripe', '2019-03-22 16:00'),
						   (NULL, 2, 6, 'Arritmia', '2019-03-29 13:00');
						   
SELECT * FROM consulta;

________________ PARA PRÓXIMA AULA__________________________
-- Exercícios (JOINs quando necessário).

-- Exibir o nome e a data de nascimento dos pacientes nascidos antes de 1980. Ordenar do mais novo pro mais velho.
SELECT nome, dataNasc
	FROM paciente
	WHERE dataNasc < '1979-12-31'
	ORDER BY dataNasc DESC;
-- OU (Se o 'Y' estiver em minúsculo, aparecerá apenas dois dígitos em year.)
SELECT nome,
	DATE_FORMAT(dataNasc, '%d/%m/%Y') AS Nascimento
	FROM paciente
	WHERE dataNasc < '1979-12-31';
-- OU
	SELECT nome,
	DATE_FORMAT(dataNasc, '%d/%m/%Y') AS Nascimento
	FROM paciente
	WHERE YEAR (dataNasc) < 1980
	ORDER BY dataNasc DESC;	


-- Exibir o nome, a data de nascimento e a idade dos pacientes que fazem aniversário no mes atual.
SELECT nome,
	DATE_FORMAT (dataNasc, '%d/%m/%Y') AS Aniversario
	FROM paciente
	WHERE MONTH (dataNasc) = '10'
	ORDER BY dataNasc DESC;
	
SELECT nome,
	DATE_FORMAT (dataNasc, '%d/%m/%Y') AS Aniversario
	FROM paciente
	WHERE DAY (dataNasc) = '03'
	ORDER BY dataNasc DESC;	
	
-- Exibir o nome e a especialidade dos médicos e as datas em que atenderam.
SELECT medico.nome AS nome_medico, espec, dataHora
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med;
---Sendo mais especifico...
SELECT medico.nome AS nome_medico, espec,
	DATE_FORMAT (dataHora, '%d/%m/%Y') AS DataAtendimento
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med
	ORDER BY dataHora;

/* Exibir o nome e a especialidade dos médicos e as datas em que atenderam.
Somente atendimentos da ortopedia e clinica médica.*/
SELECT medico.nome AS nome_medico, espec, dataHora
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med
	WHERE espec = 'Ortopedia' OR espec = 'Clinica Medica';
--oU
SELECT medico.nome AS nome_medico, espec, dataHora
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med
	WHERE espec IN ('Ortopedia','Clinica Medica');
--OU
SELECT medico.nome AS nome_medico, espec,
	DATE_FORMAT(dataHora,'%d/%m/%Y - %H:%i') AS Atendimento
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med
	WHERE espec = 'Ortopedia' OR espec = 'Clinica Medica';
	--ou (entre DATE_FORMAT deve haver virgula (antes também))
SELECT medico.nome AS nome_medico, espec,
	DATE_FORMAT(dataHora,'%d/%m/%Y') AS Atendimento,
	DATE_FORMAT(dataHora,'%H:%i') AS HoraAtendimento
	FROM medico INNER JOIN consulta
	ON codMedico = cod_med
	WHERE espec = 'Ortopedia' OR espec = 'Clinica Medica';
	
-- Exibir nome, genero e diagnóstico dos pacientes.
SELECT nome, genero, diagnostico
	FROM paciente INNER JOIN consulta
	ON codPaciente = cod_pac;
	
-- Exibir nome, genero e diagnóstico dos pacientes. Somente consultas realizadas em janeiro e fevereiro de 2019.
SELECT nome, genero, diagnostico,
	DATE_FORMAT(dataHora,'%d/%m/%Y - %H:%i') AS Atendimento
	FROM paciente INNER JOIN consulta
	ON codPaciente = cod_pac
	WHERE dataHora >= '2019-01-01' AND dataHora < '2019-03-01';
	
SELECT nome, genero, diagnostico,
	DATE_FORMAT(dataHora,'%d/%m/%Y - %H:%i') AS Atendimento
	FROM paciente INNER JOIN consulta
	ON codPaciente = cod_pac
	WHERE dataHora  BETWEEN '2019-01-01' AND '2019-03-01';

-- Exibir o nome e o genero de todos os pacientes. Caso tenha informado contato, exibir o nome e o telefone do contato.
SELECT paciente.nome AS nomePaciente, genero, pessoaContato.nome AS nomePessoaContato, telefone
	FROM paciente LEFT JOIN pessoaContato
	ON codPaciente = cod_pac;

--OU  posso buscar apenas por aqueles que não informaram os contatos
SELECT paciente.nome AS nomePaciente, genero, pessoaContato.nome AS nomePessoaContato, telefone
	FROM paciente LEFT JOIN pessoaContato
	ON codPaciente = cod_pac
	WHERE cod_pac IS NULL;


