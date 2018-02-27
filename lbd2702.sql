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
