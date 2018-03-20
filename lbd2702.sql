/*Esquema de relações - Controle de Biblioteca
Usuario(Cod_usuario(PK), Nome_usuario, End_usuario, Sexo_usuario, Dt_Nascto_usuario, Fone_usuario, CPF, RG, email, Sit_usuario)
Aluno(Cod_usuario(PK)(FK), RA, Curso, Dt_Ingresso, Dt_Prev_Conclusao)
Professor(Cod_usuario(PK)(FK), Num_funcional, Dt_admissao)
Obra(ISBN(PK), Titulo, Titulo_Original, Idioma_Original, Assunto, Classificacao, Prazo_Reserva, Sit_obra)
Exemplar(ISBN(FK)(PK), Num_exemplar(PK), Ano_publicacao, Edicao, Volume, Qtde_paginas, Midia, Peso, Tamanho, Idioma, Preco, Dt_aquisicao, Origem, Prazo_Entrega, Vl_multa_diaria, Sit_exemplar, Cod_Edit(FK) NN)
Autor(Cod_autor(PK), Nome_autor, Nacional_autor)
Editora(Cod_edit(PK), Nome_edit, CNPJ, Nacional_edit, Contato, Sit_edit)
Emprestimo(Num_emprestimo(PK), Dt_hora_retirada, Vl_total_multa, Sit_Emprest, Cod_usuario(FK)NN)
Reserva(Num_reserva(PK), Dt_hora_reserva, Sit_reserva, Cod_usuario_prof(FK) NN)
Autoria(ISBN(FK)(PK), Cod_Autor(FK)(PK), Tipo_autoria)
Itens_Emprestimo(Num_emprestimo(FK)(PK), ISBN(FK)(PK), Num_exemplar(FK)(PK), Dt_Prev_Devolucao, Dt_hora_devolucao, Vl_multa_item, Sit_item)
Itens_reserva(Num_reserva(FK)(PK), ISBN(FK)(PK), Dt_validade_reserva)*/

-- tabela usuário
CREATE TABLE usuario(
    cod_usuario INTEGER PRIMARY KEY ,
    nome_usuario VARCHAR2(50) NOT NULL,
    end_usuario VARCHAR2(100) NOT NULL,
    dt_nascto_usuario DATE NOT NULL,
    sexo_usuario CHAR(1) NOT NULL,
    cpf NUMBER(11) NOT NULL,
    rg CHAR(9) NOT NULL,
    fone NUMBER(11),
    email VARCHAR2(32), 
    sit_usuario VARCHAR2(20)
);

-- tabela professor (tabela com chave estrangeira)
CREATE TABLE professor(
    cod_usuario INTEGER NOT NULL,
    num_funcional INTEGER NOT NULL,
    dt_admissao DATE,
    PRIMARY KEY (cod_usuario),
    FOREIGN KEY (cod_usuario) REFERENCES usuario (cod_usuario)
    ON DELETE CASCADE 
);

-- tabela obra
DROP TABLE obra CASCADE CONSTRAINTS ;
CREATE TABLE obra(
    isbn NUMBER(13) PRIMARY KEY,
    titulo VARCHAR2(50) NOT NULL,
    titulo_original VARCHAR2(50) NOT NULL,
    idioma_original CHAR(15) NOT NULL,
    assunto CHAR(15) NOT NULL,
    classificacao CHAR(15) NOT NULL,
    prazo_reserva SMALLINT NOT NULL,
    sit_obra CHAR(20) NOT NULL
);

-- tabela exemplar
DROP TABLE exemplar CASCADE CONSTRAINTS;
CREATE TABLE exemplar(
    isbn NUMBER(13) NOT NULL,
    num_exemplar SMALLINT NOT NULL,
    ano_publicacao SMALLINT NOT NULL,
    edicao SMALLINT NOT NULL,
    volume SMALLINT,
    qtde_paginas SMALLINT NOT NULL,
    midia CHAR(15) NOT NULL,
    peso_gr SMALLINT,
    tamanho CHAR(15),
    idioma_exemplar CHAR(15) NOT NULL,
    preco_aquisicao NUMBER(6,2),
    dt_aquisicao DATE NOT NULL,
    origem_aquisicao CHAR(15) NOT NULL CHECK( origem_aquisicao IN ('DOACAO', 'COMPRA')),
    prazo_entrega SMALLINT NOT NULL,
    vl_multa_diaria NUMBER(6,2),
    sit_exemplar VARCHAR2(15) NOT NULL,
    FOREIGN KEY (isbn) REFERENCES obra (isbn) ON DELETE CASCADE,
    PRIMARY KEY ( isbn, num_exemplar)
);

--tabela emprestimo
DROP TABLE emprestimo CASCADE CONSTRAINTS PURGE;
CREATE TABLE emprestimo(
    num_emprest INTEGER PRIMARY KEY,
    dt_hora_retirada TIMESTAMP NOT NULL,
    vl_total_multa NUMBER(6,2),
    sit_emprestimo CHAR(20) NOT NULL CHECK(sit_emprestimo IN('EM ANDAMENTO', 'ATRASO', 'CANCELADO')),
    cod_usuario INTEGER NOT NULL REFERENCES usuario
);

--tabela itens emprestimo
DROP TABLE itens_emprestimo CASCADE CONSTRAINTS PURGE;
CREATE TABLE itens_emprestimo(
    num_emprest INTEGER NOT NULL,
    isbn NUMBER(15) NOT NULL,
    num_exemplar SMALLINT NOT NULL,
    dt_prev_devolucao DATE NOT NULL,
    dt_hora_devolucao TIMESTAMP,
    vl_multa_item NUMBER(6,2),
    sit_item CHAR(15) NOT NULL,
    FOREIGN KEY (num_emprest) REFERENCES emprestimo ON DELETE CASCADE,
    FOREIGN KEY (isbn, num_exemplar) REFERENCES exemplar (isbn, num_exemplar) ON DELETE CASCADE,
    PRIMARY KEY (num_emprest, isbn, num_exemplar)
);

--tabela editora
DROP TABLE editora CASCADE CONSTRAINTS PURGE;
CREATE TABLE editora(
    cod_edit SMALLINT PRIMARY KEY,
    nome_edit VARCHAR2(50) NOT NULL,
    CNPJ_edit NUMBER(14),
    nacional_edit VARCHAR2(15) NOT NULL,
    contato VARCHAR2(32) NOT NULL,
    sit_edit CHAR(15) NOT NULL CHECK(sit_edit IN ('ATIVO', 'INATIVO'))
);


/* Atividade 1:
Exercicio 1) b)+c)*/

--Tabela Aluno
DROP TABLE aluno CASCADE CONSTRAINTS PURGE;
CREATE TABLE aluno(
    cod_usuario INTEGER NOT NULL,
    RA INTEGER NOT NULL,
    dt_ingresso DATE NOT NULL,
    dt_prevista_termino DATE NOT NULL,
    curso CHAR(15) NOT NULL,
    tipo_curso CHAR(20),
   CONSTRAINT  PK_Aluno PRIMARY KEY (cod_usuario),
CONSTRAINT UQ_aluno UNIQUE ( RA),
CONSTRAINT Fk_aluno_usuario FOREIGN KEY (cod_usuario) REFERENCES Usuario (cod_usuario) ON DELETE CASCADE );
);

--Tabela Reserva
DROP TABLE reserva CASCADE CONSTRAINTS PURGE;
CREATE TABLE reserva(
    cod_usuario_prof INTEGER NOT NULL,
    num_reserva SMALLINT PRIMARY KEY,
    dt_reserva DATE NOT NULL,
    sit_reserva CHAR(15) NOT NULL CHECK(sit_reserva in ('ALUGADO', 'DISPONIVEL')),
    FOREIGN KEY (cod_usuario) REFERENCES professor (cod_usuario) ON DELETE CASCADE
);

--Tabela Item Reserva
DROP TABLE item_reserva CASCADE CONSTRAINTS PURGE;
CREATE TABLE item_reserva(
    num_reserva INTEGER NOT NULL,
    isbn NUMBER(13) NOT NULL,
    dt_validade_reserva DATE NOT NULL,
    FOREIGN KEY (num_reserva) REFERENCES reserva ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES obra ON DELETE CASCADE,
    CONSTRAINT pk_reserva_obra PRIMARY KEY (num_reserva, isbn)
);

--Tabela Autor
DROP TABLE autor CASCADE CONSTRAINTS PURGE;
CREATE TABLE autor(
    cod_autor INTEGER PRIMARY KEY,
    nome_autor VARCHAR2(50) NOT NULL,
    nacional_autor VARCHAR2(20) NOT NULL
);

--Tabela Autoria
DROP TABLE autoria CASCADE CONSTRAINTS PURGE;
CREATE TABLE autoria(
    isbn NUMBER(13) NOT NULL,
    cod_autor INTEGER NOT NULL,
    tipo_autoria VARCHAR2(15) NOT NULL,
    FOREIGN KEY (isbn) REFERENCES obra ON DELETE CASCADE,
    FOREIGN KEY (cod_autor) REFERENCES autor ON DELETE CASCADE,
    PRIMARY KEY(isbn, cod_autor)
);

--1) a)
DROP SEQUENCE seq_reserva;
CREATE SEQUENCE seq_reserva
START WITH 800;


--Exercicio 2)
--a)
ALTER TABLE obra ADD palavra_chave VARCHAR2(30) NOT NULL;

--b)
ALTER TABLE obra ADD CONSTRAINT chk_tipo_participacao CHECK(sit_obra IN ('PRINCIPAL', 'CO-AUTOR', 'REVISOR', 'TRADUTOR'));
ALTER TABLE usuario ADD CONSTRAINT chk_tipo_curso CHECK(tipo_curso IN ('TECNOLOGIA', 'BACHARELADO', 'LICENCIATURA'));

--c)
ALTER TABLE itens_emprestimo RENAME COLUMN sit_item TO situacao_item_emprestimo;

--d)
ALTER TABLE autoria RENAME TO participantes_obra ;
ALTER TABLE participantes_obra RENAME TO autoria ;
SELECT table_name from user_tables where table_name like 'A%' ;

--e) 
ALTER TABLE aluno MODIFY tipo_curso VARCHAR2(15) ;

--f)
ALTER TABLE reserva MODIFY dt_reserva DEFAULT current_date ;
ALTER TABLE exemplar MODIFY prazo_entrega DEFAULT 7 ;

/***********************************************
        Alterando a estrutura das tabelas
***********************************************/

--adicionando nova coluna
ALTER TABLE usuario ADD tipo_usuario CHAR(10) NOT NULL;

--definindo uma restrição de verificação para tipo de usuário
ALTER TABLE usuario ADD CHECK(tipo_usuario IN ('ALUNO', 'PROFESSOR'));

--definindo check
ALTER TABLE itens_emprestimo ADD CONSTRAINT chk_situitem CHECK(sit_item IN ('AGUARDANDO', 'DEVOLVIDO', 'ATRASO', 'PERDA', 'DANIFICADO'));

--aumentar ou mudar o tipo de dado de uma coluna
ALTER TABLE obra MODIFY assunto VARCHAR2(20);

--renomeando uma coluna
ALTER TABLE exemplar RENAME COLUMN qtde_paginas TO numero_paginas;

--renomeando uma tabela
ALTER TABLE exemplar RENAME TO exemplar_obra;
ALTER TABLE exemplar_obra RENAME TO exemplar; 

--definindo valores padrão
ALTER TABLE emprestimo MODIFY dt_hora_retirada DEFAULT current_timestamp;
ALTER TABLE emprestimo MODIFY vl_total_multa DEFAULT 0.0;

--definindo chaves únicas
ALTER TABLE usuario ADD UNIQUE(cpf);
ALTER TABLE professor ADD UNIQUE(num_funcional);

--definindo uma FK do exemplar para a editora
ALTER TABLE exemplar ADD cod_edit SMALLINT NOT NULL;
ALTER TABLE exemplar ADD CONSTRAINT fk_editora FOREIGN KEY (cod_edit) REFERENCES editora (cod_edit);

--criando uma sequencia de auto_numeracao
DROP SEQUENCE seq_emprest;
CREATE SEQUENCE seq_emprest
START WITH 18000 INCREMENT BY 1
MINVALUE 18000;


-- 13/03: Populando as tabelas
INSERT INTO usuario VALUES(1, 'Jose de Arimateia', 'Rua de Baixo, 10', '10/10/1980', 'M', 123, '123X', '11987654321', 'ze_mateia@uol.com.br', 'ATIVO', 'PROFESSOR');

INSERT INTO usuario VALUES(2, 'Maria Imaculada da Conceicao', 'Rua de Cima, 20', '12/12/1995', 'F', 456, '456X', '11987651234', 'imaculada@gmail.com', 'ATIVO', 'ALUNO');

--Alterando email e cpf do usuário cujo código é o de número 2
UPDATE usuario SET email = 'maria_conceicao@gmail.com', cpf = 987654321
WHERE cod_usuario = 2;

-- professor
INSERT INTO professor VALUES(1, 223344, '01/02/2010');

-- obra
INSERT INTO obra VALUES(9788580555332, 'Engenharia de Software', 'Software Engineering', 'Ingles', 'Computacao', 'Livro Tecnico', 10, 'ATIVO', 'Desenvolvimento software');

INSERT INTO obra VALUES(9788576052371, 'Sistemas Operacionais Modernos', 'Modern Operational Systems', 'Ingles', 'Computacao', 'Livro Tecnico', 10, 'ATIVO', 'sistemas operacionais');

-- Editora
INSERT INTO editora VALUES(100, 'Prentice Hall', 8877, 'Estados Unidos', 'vendas@phall.com', 'ATIVO');

INSERT INTO editora(sit_edit, cod_edit, contato, nome_edit, nacional_edit, cnpj_edit) VALUES('ATIVO', 101, 'comercial@globo.com.br', 'Editora Globo', 'Brasil',2255);


-- Exemplar
INSERT INTO exemplar VALUES(9788580555332, 1, 2014, 8, 1, 765, 'BROCHURA', 543, '28x22x5', 'Portugues', 199.99, '15/03/2016', 'COMPRA', DEFAULT, 2.5, 'ATIVO', 100);

INSERT INTO exemplar VALUES(9788580555332, 1, 2014, 8, 1, 765, 'BROCHURA', 543, '28x22x5', 'Portugues', 0.0, '15/12/2016', 'DOACAO', DEFAULT, 2.5, 'ATIVO', 100);

INSERT INTO exemplar VALUES(9788576052371, 1, 2015, 11, 1, 890, 'BROCHURA', 750, '28x22x7', 'Portugues', 231.99, '15/03/2016', 'COMPRA', DEFAULT, 2.5, 'ATIVO', 101);

-- Emprestimo
ALTER TABLE emprestimo MODIFY dt_hora_retirada DEFAULT current_timestamp;
--ALTER TABLE emprestimo MODIFY vl_total_multa DEFAULT 0.0;
INSERT INTO emprestimo(seq_emprest.nextval, DEFAULT, DEFAULT, 'EM ANDAMENTO', 1);


--Itens emprestimo
INSERT INTO itens_emprestimo VALUES(18000, 9788580555332, 2, current_date + 7, null, 0.0, 'EM ANDAMENTO');

INSERT INTO itens_emprestimo VALUES(1800, 9788576052371, 1, current_date + 7, null, 0.0, 'AGUARDANDO');

/* CAI NA PROVA VELHO ANOTA ISSO
Tabela auxiliar para nacionalidade, transformando a entrada em textoda coluna nacionalidade em editora para uma tabela auxiliar, relacionando a partir de um único código */

--Criando a nova tabela de nacionalidade
DROP TABLE nacionalidade CASCADE CONSTRAINTS PURGE
CREATE TABLE nacionalidade (
    cod_pais SMALLINT PRIMARY KEY,
    nome_pais VARCHAR2(30) NOT NULL
);

INSERT INTO nacionalidade VALUES(1, 'BRASIL');
INSERT INTO nacionalidade VALUES(2, 'ESTADOS UNIDOS');
INSERT INTO nacionalidade VALUES(3, 'ALEMANHA');
INSERT INTO nacionalidade VALUES(4, 'INGLATERRA');

--Adicionando nova coluna em editora que vai receber o código do país
ALTER TABLE editar ADD cod_pais_edit SMALLINT;


--Atualizando a nova coluna com o código que vem da tabela nacionalidade
-- RTRIM = remover todos os espaços à direita
UPDATE editora e SET e.cod_pais edit = (
    SELECT n.cod_pais FROM nacionalidade n 
    WHERE RTRIM(UPPER(n.nome_pais)) LIKE '%'||RTRIM(UPPER(e.nacional_edit))||'%'
);

--Nova coluna em editora virando chave estrangeira
ALTER TABLE editora ADD FOREIGN KEY (cod_pais_edit) REFERENCES nacionalidade(cod_pais);

ALTER TABLE editora MODIFY cod_pais_edit NOT NULL;

--Excluindo a coluna que continha a nacionalidade como texto
ALTER TABLE editora DROP COLUMN nacional_edit;

/*********************************************************************
            Atividade 2
*********************************************************************/
