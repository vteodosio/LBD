/* Atividade 1:
Exercicio 1) b)+c)*/

--Tabela Aluno
DROP TABLE aluno CASCADE CONSTRAINTS PURGE;
CREATE TABLE aluno(
    cod_usuario INTEGER NOT NULL,
    RA SMALLINT NOT NULL,
    dt_ingresso DATE NOT NULL,
    dt_prevista_termino DATE NOT NULL,
    curso VARCHAR2(30) NOT NULL,
    FOREIGN KEY (cod_usuario) REFERENCES usuario ON DELETE CASCADE,
    PRIMARY KEY (cod_usuario)
);

--Tabela Reserva
DROP TABLE reserva CASCADE CONSTRAINTS PURGE;
CREATE TABLE reserva(
    cod_usuario INTEGER NOT NULL,
    num_reserva INTEGER PRIMARY KEY,
    dt_hora_reserva TIMESTAMP NOT NULL,
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
    FOREIGN KEY (isbn) REFERENCES obra ON DELETE CASCADE
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
START WITH 800 INCREMENT BY 1
MINVALUE 800;


--Exercicio 2)
--a)
ALTER TABLE obra ADD palavras_chave VARCHAR2(20) NOT NULL;

--b)
ALTER TABLE obra ADD CONSTRAINT chk_tipo_participacao CHECK(sit_obra IN ('PRINCIPAL', 'CO-AUTOR', 'REVISOR', 'TRADUTOR'));
ALTER TABLE usuario ADD CONSTRAINT chk_tipo_curso CHECK(curso IN ('TECNOLOGIA', 'BACHARELADO', 'LICENCIATURA'));

--c)
ALTER TABLE exemplar RENAME COLUMN qtde_paginas TO numero_paginas;

--d)
ALTER TABLE participacao_obra RENAME TO participantes_obra;

--e)
ALTER TABLE usuario MODIFY rg VARCHAR2(10);

--f)
ALTER TABLE exemplar MODIFY vl_multa_diaria DEFAULT 0.0;
ALTER TABLE emprestimo MODIFY vl_total_multa DEFAULT 0.0;
ALTER TABLE itens_emprestimo MODIFY vl_multa_item DEFAULT 0.0;
ALTER TABLE reserva MODIFY dt_hora_reserva DEFAULT current_timestamp;