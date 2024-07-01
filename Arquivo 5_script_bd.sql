-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-03-15 13:53:27 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



DROP TABLE t_mc_categoria CASCADE CONSTRAINTS;

DROP TABLE t_mc_classificação CASCADE CONSTRAINTS;

DROP TABLE t_mc_cliente CASCADE CONSTRAINTS;

DROP TABLE t_mc_departamento CASCADE CONSTRAINTS;

DROP TABLE t_mc_funcionario CASCADE CONSTRAINTS;

DROP TABLE t_mc_pes_fisica CASCADE CONSTRAINTS;

DROP TABLE t_mc_pes_juridica CASCADE CONSTRAINTS;

DROP TABLE t_mc_produto CASCADE CONSTRAINTS;

DROP TABLE t_mc_sac CASCADE CONSTRAINTS;

DROP TABLE t_mc_video_produto CASCADE CONSTRAINTS;

DROP TABLE t_mc_visualização CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE t_mc_categoria (
    cd_cateogoria  NUMBER(7) NOT NULL,
    cd_produto     NUMBER(7) NOT NULL,
    desc_categoria VARCHAR2(200) NOT NULL,
    status         VARCHAR2(1) NOT NULL,
    dt_inicio      DATE NOT NULL,
    dt_termino     DATE
);

ALTER TABLE t_mc_categoria ADD CONSTRAINT pk_t_mc_categoria PRIMARY KEY ( cd_cateogoria );

ALTER TABLE t_mc_categoria ADD CONSTRAINT un_t_mc_categoria_ UNIQUE ( desc_categoria );

CREATE TABLE t_mc_classificação (
    inst_produto        CHAR(1) NOT NULL,
    cd_video            NUMBER(7) NOT NULL,
    video_cotidiano     CHAR(1),
    video_comercial     CHAR(1),
    video_institucional CHAR(1)
);

ALTER TABLE t_mc_classificação ADD CONSTRAINT pk_t_mc_classificação PRIMARY KEY ( inst_produto );

CREATE TABLE t_mc_cliente (
    cd_cliente  NUMBER(7) NOT NULL,
    cd_pf       NUMBER(7),
    cd_pj       NUMBER(7),
    nm_cliente  VARCHAR2(20),
    ds_email    VARCHAR2(20),
    nr_telefone NUMBER(12)
);

ALTER TABLE t_mc_cliente
    ADD CONSTRAINT arc_2 CHECK ( ( ( cd_pj IS NOT NULL )
                                   AND ( cd_pf IS NULL ) )
                                 OR ( ( cd_pf IS NOT NULL )
                                      AND ( cd_pj IS NULL ) ) );

CREATE UNIQUE INDEX t_mc_cliente__idx ON
    t_mc_cliente (
        cd_pj
    ASC );

CREATE UNIQUE INDEX t_mc_cliente__idxv1 ON
    t_mc_cliente (
        cd_pf
    ASC );

ALTER TABLE t_mc_cliente ADD CONSTRAINT pk_t_mc_cliente PRIMARY KEY ( cd_cliente );

CREATE TABLE t_mc_departamento (
    cd_depto NUMBER(7) NOT NULL,
    nm_depto VARCHAR2(20) NOT NULL,
    sg_depto CHAR(1) NOT NULL,
    tp_depto CHAR(1) NOT NULL
);

COMMENT ON COLUMN t_mc_departamento.cd_depto IS
    'Identificador unico da entidade departamento.';

ALTER TABLE t_mc_departamento ADD CONSTRAINT pk_t_mc_departamento PRIMARY KEY ( cd_depto );

CREATE TABLE t_mc_funcionario (
    cd_depto   NUMBER(7) NOT NULL,
    cd_func    NUMBER(7) NOT NULL,
    nr_cpf     NUMBER(11) NOT NULL,
    nm_func    VARCHAR2(20) NOT NULL,
    dt_nasc    DATE NOT NULL,
    tel_ddd    NUMBER(12) NOT NULL,
    email_func VARCHAR2(20) NOT NULL,
    cg_func    VARCHAR2(7) NOT NULL,
    nm_depto   VARCHAR2(20) NOT NULL
);

ALTER TABLE t_mc_funcionario ADD CONSTRAINT pk_t_mc_funcionario PRIMARY KEY ( cd_depto,
                                                                              cd_func );

ALTER TABLE t_mc_funcionario ADD CONSTRAINT un_t_mc_funcionario_ UNIQUE ( nr_cpf );

CREATE TABLE t_mc_pes_fisica (
    cd_pf          NUMBER(7) NOT NULL,
    dt_nasc        DATE NOT NULL,
    log_sen        VARCHAR2(20) NOT NULL,
    nm_cliente     VARCHAR2(30) NOT NULL,
    nr_cpf         NUMBER(11) NOT NULL,
    sex_biol       CHAR(1) NOT NULL,
    status_cliente CHAR(1) NOT NULL,
    nr_telefone    NUMBER(12),
    qtde_estrelas  CHAR(1),
    gen_nasc       CHAR(1)
);

ALTER TABLE t_mc_pes_fisica ADD CONSTRAINT pk_t_mc_pes_fisica PRIMARY KEY ( cd_pf );

CREATE TABLE t_mc_pes_juridica (
    cd_pj            NUMBER(7) NOT NULL,
    log_sen          VARCHAR2(20) NOT NULL,
    nm_cliente       VARCHAR2(30) NOT NULL,
    status           VARCHAR2(1) NOT NULL,
    nr_telefone      NUMBER(12),
    dt_fund          DATE,
    nr_cnpj          NUMBER(14),
    nr_insc_estadual NUMBER(9),
    qtde_estrelas    CHAR(1)
);

ALTER TABLE t_mc_pes_juridica ADD CONSTRAINT pk_t_mc_pes_juridica PRIMARY KEY ( cd_pj );

CREATE TABLE t_mc_produto (
    cd_produto      NUMBER(7) NOT NULL,
    desc_completa   VARCHAR2(200) NOT NULL,
    vl_unit_produto NUMBER(5, 2) NOT NULL,
    desc_normal     VARCHAR2(200) NOT NULL,
    cd_barras       NUMBER(15),
    status          VARCHAR2(1)
);

ALTER TABLE t_mc_produto ADD CONSTRAINT pk_t_mc_produto PRIMARY KEY ( cd_produto );

ALTER TABLE t_mc_produto ADD CONSTRAINT un_t_mc_produto_ UNIQUE ( desc_completa );

CREATE TABLE t_mc_sac (
    cd_depto       NUMBER(7) NOT NULL,
    cd_func        NUMBER(7) NOT NULL,
    cd_produto     NUMBER(7) NOT NULL,
    duvida         NUMBER(10) NOT NULL,
    cd_cliente     NUMBER(7) NOT NULL,
    dt_abertura    DATE NOT NULL,
    hr_abertura    DATE NOT NULL,
    sugestão       CHAR(1) NOT NULL,
    reclamaçao     CHAR(1) NOT NULL,
    status         VARCHAR2(1) NOT NULL,
    hr_tempo_total TIMESTAMP NOT NULL,
    txt_cliente    VARCHAR2(200) NOT NULL,
    dt_atendimento DATE,
    hr_atendimento DATE,
    indice_satisf  CHAR(1)
);

CREATE UNIQUE INDEX t_mc_sac__idx ON
    t_mc_sac (
        cd_cliente
    ASC );

ALTER TABLE t_mc_sac
    ADD CONSTRAINT pk_t_mc_sac PRIMARY KEY ( duvida,
                                             cd_produto,
                                             cd_depto,
                                             cd_func );

CREATE TABLE t_mc_video_produto (
    cd_video   NUMBER(7) NOT NULL,
    cd_produto NUMBER(7) NOT NULL,
    dt_video   DATE NOT NULL,
    status     VARCHAR2(1) NOT NULL,
    usuario    VARCHAR2(10)
);

ALTER TABLE t_mc_video_produto ADD CONSTRAINT pk_t_mc_video_produto PRIMARY KEY ( cd_video );

CREATE TABLE t_mc_visualização (
    cd_video         NUMBER(7) NOT NULL,
    hr_visualizacao  DATE NOT NULL,
    dt_visualizacao  DATE NOT NULL,
    min_visualizacao DATE,
    seg_visualizacao TIMESTAMP
);

ALTER TABLE t_mc_visualização ADD CONSTRAINT pk_t_mc_visualização PRIMARY KEY ( cd_video );

ALTER TABLE t_mc_categoria
    ADD CONSTRAINT fk_mc_categoria_produto FOREIGN KEY ( cd_produto )
        REFERENCES t_mc_produto ( cd_produto );

ALTER TABLE t_mc_cliente
    ADD CONSTRAINT fk_mc_cliente_pes_fisica FOREIGN KEY ( cd_pf )
        REFERENCES t_mc_pes_fisica ( cd_pf );

ALTER TABLE t_mc_cliente
    ADD CONSTRAINT fk_mc_cliente_pes_juridica FOREIGN KEY ( cd_pj )
        REFERENCES t_mc_pes_juridica ( cd_pj );

ALTER TABLE t_mc_funcionario
    ADD CONSTRAINT fk_mc_func_depto FOREIGN KEY ( cd_depto )
        REFERENCES t_mc_departamento ( cd_depto );

ALTER TABLE t_mc_sac
    ADD CONSTRAINT fk_mc_sac_cliente FOREIGN KEY ( cd_cliente )
        REFERENCES t_mc_cliente ( cd_cliente );

ALTER TABLE t_mc_sac
    ADD CONSTRAINT fk_mc_sac_funcionario FOREIGN KEY ( cd_depto,
                                                       cd_func )
        REFERENCES t_mc_funcionario ( cd_depto,
                                      cd_func );

ALTER TABLE t_mc_sac
    ADD CONSTRAINT fk_mc_sac_produto FOREIGN KEY ( cd_produto )
        REFERENCES t_mc_produto ( cd_produto );

ALTER TABLE t_mc_video_produto
    ADD CONSTRAINT fk_mc_video_produto_produto FOREIGN KEY ( cd_produto )
        REFERENCES t_mc_produto ( cd_produto );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE t_mc_classificação
    ADD CONSTRAINT fk_t_mc_classificação_t_mc_video_produto FOREIGN KEY ( cd_video )
        REFERENCES t_mc_video_produto ( cd_video );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE t_mc_visualização
    ADD CONSTRAINT fk_t_mc_visualização_t_mc_video_produto FOREIGN KEY ( cd_video )
        REFERENCES t_mc_video_produto ( cd_video );



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             3
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   2
-- WARNINGS                                 0
