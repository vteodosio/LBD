--1)
ALTER TABLE reserva ADD CONSTRAINT chk_sit_reserva CHECK(sit_reserva IN ('ANDAMENTO', 'VENCIDO', 'EMPRESTIMO', 'CANCELADO'));

--2)
ALTER TABLE item_reserva ADD sit_item_reserva VARCHAR2(20) NOT NULL;

ALTER TABLE item_reserva ADD CONSTRAINT chk_sit_item_reserva CHECK (sit_item_reserva IN ('CANCELADO', 'ANDAMENTO', 'VENCIDO', 'EMPRESTADO'));

--3)
--Aluno
INSERT INTO aluno VALUES(2, 3213123, '10/10/2010', '10/10/2013', 1);

--Reserva
INSERT INTO reserva VALUES(1, 001, '15:32:00', 'ALUGADO');
INSERT INTO reserva VALUES(1, 002, '15:33:00', 'ALUGADO');

--Autor
INSERT INTO autor VALUES(1, 'Monteiro Lobato', 1);
INSERT INTO autor VALUES(1, 'Elon Musk', 2);


--4)
DROP TABLE nacionalidade CASCADE CONSTRAINTS PURGE
CREATE TABLE nacionalidade (
    cod_pais SMALLINT PRIMARY KEY,
    nome_pais VARCHAR2(30) NOT NULL
);
INSERT INTO nacionalidade VALUES(1, 'BRASIL');
INSERT INTO nacionalidade VALUES(2, 'AFRICA DO SUL');
ALTER TABLE autor ADD cod_pais_autor SMALLINT;
UPDATE autor a SET a.cod_pais_autor = (
    SELECT n.cod_pais FROM nacionalidade n 
    WHERE RTRIM(UPPER(n.nome_pais)) LIKE '%'||RTRIM(UPPER(a.cod_pais_autor))||'%'
);
ALTER TABLE autor ADD FOREIGN KEY (cod_pais_autor) REFERENCES nacionalidade(cod_pais);
ALTER TABLE autor MODIFY cod_pais_autor NOT NULL;
ALTER TABLE autor DROP COLUMN nacional_autor;
