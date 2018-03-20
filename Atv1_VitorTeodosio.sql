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