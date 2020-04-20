-- AULA Db 03/09/2019 ************************************************
/*
w3school - site pra treinamento
my.ini (arquivo onde guardo informa��es sobre comunica��o do meu cliente servidor com o banco de dados
*/

/*
Estruturas b�sicas do Banco de Dados.
Bases de Dados (database) - Estrutura de organiza��o dos objetos de banco de dados

Tabelas (TABLE) - Estrutura composta por colunas e chaves onde os dados
				s�o efetivamente armnazenados.
*/

-- Exibir as bases de dados existentes.  At� para o c/ S
SHOW DATABASES;

-- Criar bases de dados. At� para o s/ S
CREATE DATABASE aula1_tarde;

-- Eliminar bases de dados.
DROP DATABASE aula1_tarde;

-- Selecionar base de dados.
USE aula1_tarde;
***Database changed***

CREATE TABLE produto(
	nome VARCHAR(40),    --nunca esquecer da V�RGULA
	fabric VARCHAR(20),
	qtd INT,
	preco FLOAT);
		
SHOW TABLE; -- Pede pra mostar as tabelas
DESC produto; --Faz  descri��o da tabela (exibe a tabela criada no passo anterior) 

--Inserir dados em uma tabela.
INSERT INTO produto VALUES('sMARTPHONE','Sony',2, 2300);

--Consultar dados armazenados na tabela.
SELECT nome, qtd, preco FROM produto;
	
-- UPDATE para Modificar Registros em Tabelas
/*
UPDATE tabela
SET coluna = novo_valor_armazenado
WHERE coluna = valor_filtro;
*/
UPDATE produto;
SET nome = Smartphone;
WHERE nome = sMARTPHONE;

-- Inserindo outros dados.
INSERT INTO produto VALUES('Computador','Dell',1, 1800);
INSERT INTO produto VALUES('Impressora','HP',3, 600);
INSERT INTO produto VALUES('Monitor','LG',4, 499.90);
INSERT INTO produto VALUES('Notebook','Dell',2, 2100);
INSERT INTO produto VALUES('Camera','Sony',2, 990);
INSERT INTO produto VALUES('Projetor','Epson',2, 2300);

SELECT nome, qtd, preco FROM produto;
SELECT fabric, nome, preco FROM produto;
SELECT nome, fabric, qtd, preco FROM produto;

-- O mesmo que:
SELECT * FROM produto;

-- ORDER BY - Ordena��o das linhas de resultado de uma pesquisa.
SELECT * FROM produto ORDER BY qtd;
--ou
SELECT * FROM produto ORDER BY qtd, nome;
--ou
SELECT * FROM produto ORDER BY fabric ASC;  --ASC (Nem aparece, mas ordena do maior para o menor)
SELECT * FROM produto ORDER BY fabric DESC;

--WHERE (filtro) - Condicionar a exibi��o de um registro em um resultado.
SELECT * FROM produto WHERE nome = 'Impressora';
SELECT * FROM produto WHERE fabric = 'Dell';

SELECT nome, preco, qtd, fabric
	FROM produto WHERE preco < 2000;


