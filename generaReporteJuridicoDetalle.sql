
-- Inicia sentencias Sell ************************
SET LINESIZE 140
SPOOL MARCA_REPORTE_JURIDICO_DETALLE.TXT;

PROMPT Comienza el proceso...
PROMPT
-- termina sentencias Sell ************************



-- Comienza el bloque pl/sql**************************************************

-- La siguiente sentencia solo cuando no hay conexivia.
-- Desde .sh ya se tiene establecida
-- CONNECT iccidr9@ "scan-imsi.telcel.com:1530/ic_r92mn"

SET SERVEROUTPUT ON;



  DECLARE

V_ACCION NUMBER;
V_IMEI VARCHAR2(15);
V_APLICACION VARCHAR2(15);
V_REGION VARCHAR2(3);
V_USUARIO VARCHAR2(15);
V_CODE_RETURN NUMBER;
V_CODE_IMEI NUMBER;
V_CODE_TELCEL NUMBER;
V_CODE_ACTIVO NUMBER;
V_MARCAMODELO VARCHAR2(40);
V_MARCA VARCHAR2(30);
V_MODELO VARCHAR2(30);
V_FZAVENTA VARCHAR2(15);
V_CVE_TRANS VARCHAR2(2);
V_FECHA_BOL DATE;
V_NOMBRE_REP VARCHAR2(45);
V_CVE_MAT VARCHAR2(10);
V_SECTOR VARCHAR2(2);
V_GPO_ART VARCHAR2(10);
V_CANAL_DIST VARCHAR2(2);
V_STATUS_SERIE VARCHAR2(9);
V_SUBFZA_VTA VARCHAR2(20);
V_CVE_CTE_ASOCIADO VARCHAR2(10);
V_DESC_CTE_ASOCIADO VARCHAR2(80);
V_CLASE_DOC VARCHAR2(5);
V_MSISDNRES VARCHAR2(15);
V_REGIONRES VARCHAR2(3);
V_TIPOLINEA VARCHAR2(2);
V_TIPOACTIVACION VARCHAR2(20);
V_ESIM NUMBER;
V_DESC_TRANS VARCHAR2(30);


  CURSOR imeis_cursor IS
      SELECT C_IMEI,C_ICCID,C_MARCA,C_MODELO,C_CVE_PROVEDOR,D_FECHA_TRANS
        FROM IMEIOWN.IMEIS_MIL_LOG; 
        --WHERE C_IMEI IN('350770412203980',
          --'350770412204004',
          --'350770412204012',
          --'350770412204038',
          --'350770412204046',
          --'350770412204061',
          --'350770412204079',
          --'350770412204087',
          --'350770412204095',
          --'350770412204111');

    IMEI_ROW IMEIOWN.IMEIS_MIL_LOG%ROWTYPE;

  BEGIN

        V_ACCION := 1;
        V_APLICACION := '1';
        V_REGION := 'R09';
        V_USUARIO := 'IMEIS';

      --OPEN iccids_cursor;
      FOR imei_row IN imeis_cursor LOOP
            BEGIN
       -- DBMS_OUTPUT.PUT_LINE('IMEI: ' || IMEI_ROW.C_IMEI);

         IMEIOWN.SP_IMEIS_CORPO_CONSULTA_V3(V_ACCION,
                                            IMEI_ROW.C_IMEI,
                                            V_APLICACION,
                                            V_REGION,
                                            V_USUARIO,
                                            V_CODE_RETURN,
                                            V_CODE_IMEI,
                                            V_CODE_TELCEL,
                                            V_CODE_ACTIVO,
                                            V_MARCAMODELO,
                                            V_MARCA,
                                            V_MODELO,
                                            V_FZAVENTA,
                                            V_CVE_TRANS,
                                            V_FECHA_BOL,
                                            V_NOMBRE_REP,
                                            V_CVE_MAT,
                                            V_SECTOR,
                                            V_GPO_ART,
                                            V_CANAL_DIST,
                                            V_STATUS_SERIE,
                                            V_SUBFZA_VTA,
                                            V_CVE_CTE_ASOCIADO,
                                            V_DESC_CTE_ASOCIADO,
                                            V_CLASE_DOC,
                                            V_MSISDNRES,
                                            V_REGIONRES,
                                            V_TIPOLINEA,
                                            V_TIPOACTIVACION,
                                            V_ESIM);         

                --CONCATENAR DESC DE CLAVE DE TRANSACCION -- CAT DE TRANS
                SELECT C_DESC_TRANSAC INTO V_DESC_TRANS FROM CAT_TRANSACCIONES WHERE C_CVE_TRANS = V_CVE_TRANS;

                 DBMS_OUTPUT.PUT(IMEI_ROW.C_IMEI||'|'||IMEI_ROW.C_ICCID||'|'||IMEI_ROW.C_MARCA||'|'||IMEI_ROW.C_CVE_PROVEDOR||'|'||IMEI_ROW.C_MODELO||'|'||V_CVE_TRANS||'|'||V_DESC_TRANS||'|'||TO_CHAR(IMEI_ROW.D_FECHA_TRANS,'YYYY-MM-DD HH24:MI:SS')||'|'||TO_CHAR(V_FECHA_BOL,'YYYY-MM-DD HH24:MI:SS'));

                EXCEPTION
                  WHEN OTHERS THEN
                 DBMS_OUTPUT.PUT(IMEI_ROW.C_IMEI||'|'||IMEI_ROW.C_ICCID||'|'||IMEI_ROW.C_MARCA||'|'||IMEI_ROW.C_CVE_PROVEDOR||'|'||IMEI_ROW.C_MODELO||'|'||TO_CHAR(IMEI_ROW.D_FECHA_TRANS,'YYYY-MM-DD HH24:MI:SS')||'|'||TO_CHAR(V_FECHA_BOL,'YYYY-MM-DD HH24:MI:SS'));
                END;

      END LOOP;

      EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR GENERAL: ' || SQLERRM);

  END;
  /
-- Finaliza el bloque pl/sql *****************************************************************



-- Inicia sentencias Sell ************************
SPOOL OFF;

PROMPT verifique el archivo para detalles...
PROMPT

EXIT;
-- termina sentencias Sell ************************
