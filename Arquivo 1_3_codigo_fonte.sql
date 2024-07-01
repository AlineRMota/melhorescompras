SET SERVEROUTPUT ON;
DECLARE
    CURSOR main_cursor IS
        SELECT
            sgv.nr_sac, 
            sgv.dt_abertura_sac, 
            sgv.hr_abertura_sac, 
            sgv.tp_sac, 
            prd.cd_produto, 
            prd.ds_produto, 
            prd.vl_unitario, 
            prd.vl_perc_lucro, 
            cli.nr_cliente, 
            cli.nm_cliente,
            (prd.vl_perc_lucro / 100) * prd.vl_unitario AS vl_unitario_lucro_produto
        FROM mc_sgv_sac sgv
        INNER JOIN mc_cliente cli ON sgv.nr_cliente = cli.nr_cliente
        INNER JOIN mc_produto prd ON sgv.cd_produto = prd.cd_produto;
        
    v_sg_estado mc_estado.sg_estado%TYPE;
    v_nm_estado mc_estado.nm_estado%TYPE;
    v_vl_unitario_lucro_produto NUMBER(10,2);
    v_vl_perc_icms_estado NUMBER;
    v_vl_icms_produto NUMBER;
    v_seq_ocorrencia NUMBER;
    v_check_value NUMBER;
    main_row main_cursor%ROWTYPE;

BEGIN
    OPEN main_cursor;
    LOOP
        FETCH main_cursor INTO main_row;
        EXIT WHEN main_cursor%NOTFOUND;

        dbms_output.put_line('Número da ocorrência do SAC: ' || main_row.nr_sac);
        dbms_output.put_line('Data de abertura do SAC: ' || main_row.dt_abertura_sac);
        dbms_output.put_line('Hora de abertura do SAC: ' || main_row.hr_abertura_sac);
        dbms_output.put_line('Tipo do SAC: ' || main_row.tp_sac);
        dbms_output.put_line('Código do produto: ' || main_row.cd_produto);
        dbms_output.put_line('Nome do produto: ' || main_row.ds_produto);
        dbms_output.put_line('Valor unitário do produto: ' || main_row.vl_unitario);
        dbms_output.put_line('Percentual do lucro unitário do produto: ' || main_row.vl_perc_lucro);
        dbms_output.put_line('Número do Cliente: ' || main_row.nr_cliente);
        dbms_output.put_line('Nome do Cliente: ' || main_row.nm_cliente);

    FOR ocorrencia_row IN (SELECT * FROM mc_sgv_ocorrencia_sac WHERE nr_ocorrencia_sac = main_row.nr_sac) LOOP
        CASE main_row.tp_sac
            WHEN 'S' THEN dbms_output.put_line('Sugestão');
            WHEN 'D' THEN dbms_output.put_line('Dúvida');
            WHEN 'E' THEN dbms_output.put_line('Elogio');
            ELSE dbms_output.put_line('Classificação Inválida');
        END CASE;

        v_vl_unitario_lucro_produto := (main_row.vl_perc_lucro / 100) * main_row.vl_unitario;
        dbms_output.put_line('Valor do lucro unitário sobre o produto ofertado ' || main_row.nr_sac || ': R$ ' || main_row.vl_unitario_lucro_produto);

        SELECT e.sg_estado, e.nm_estado
        INTO v_sg_estado, v_nm_estado
        FROM mc_end_cli ec
        INNER JOIN mc_logradouro l ON ec.cd_logradouro_cli = l.cd_logradouro
        INNER JOIN mc_bairro b ON l.cd_bairro = b.cd_bairro
        INNER JOIN mc_cidade c ON b.cd_cidade = c.cd_cidade
        INNER JOIN mc_estado e ON c.sg_estado = e.sg_estado
        WHERE ec.nr_cliente = main_row.nr_cliente;
        dbms_output.put_line('SG Estado: ' || v_sg_estado);
        dbms_output.put_line('Nome do Estado: ' || v_nm_estado);

        v_vl_perc_icms_estado := fun_mc_gera_aliquota_media_icms_estado(v_sg_estado);
        v_vl_icms_produto := (v_vl_perc_icms_estado / 100) * main_row.vl_unitario;
        dbms_output.put_line('Valor do ICMS do Produto para a Ocorrência ' || main_row.nr_sac || ': R$ ' || v_vl_icms_produto);

        UPDATE mc_sgv_ocorrencia_sac
        SET vl_icms_produto = v_vl_icms_produto
        WHERE nr_ocorrencia_sac = main_row.nr_sac;

       END LOOP;
    END LOOP;
    CLOSE main_cursor;
END;
/

--COMMIT;