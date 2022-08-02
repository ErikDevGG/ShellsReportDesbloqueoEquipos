

#!/bin/ksh

#CARGA ARCHIVO DE PROPIEDADES
. /desbloqueo/DEQ/SHELLS/conexion.properties

cd /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO
#REMOVER ARCHIVOS TMP
## rm /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/

##cd /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES29072016

for varMarca in `cat marcas.list`
do

    echo -e "PROCESANDO: " $varMarca

    echo -e "PROCESANDO DETALLE DE LA MARCA"

time $ORACLE_HOME/bin/sqlplus -s "$USER_RAC/$PASS_RAC@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$HOST_RAC)(Port=$PORT_RAC))(CONNECT_DATA=(SID=(SERVER = DEDICATED))(SERVICE_NAME = bdimei)))" <<  EOF > /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_`date +%d%m%Y`.out
set pagesize 0 linesize 100 feedback off verify off heading off echo off
SELECT T1.C_IMEI||'|'||T1.C_CVE_MATERIAL||'|'||T1.C_DESC_MATERIAL||'|'||T2.C_MARCA||'|'||T2.C_MODELO||'|'||T1.D_FECHA_HORA
from IMEIS_SAP T1, cat_marca_modelo_sap T2
WHERE T1.c_cve_material = T2.c_cve_material
AND T1.D_FECHA_HORA>=TO_DATE('01-01-2012','DD-MM-YYYY')
and T1.C_DESC_MATERIAL like '$varMarca%'
and T1.C_SECTOR in ('11','02','14');
exit;
EOF
    echo -e "PROCESANDO DESBLOQUEADOS DE LA MARCA: "


time $ORACLE_HOME/bin/sqlplus -s "$USER_DESB/$PASS_DESB@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$HOST_DESB)(Port=$PORT_DESB))(CONNECT_DATA=(SID=$SID_DESB)))" <<  EOF > /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_DESB_`date +%d%m%Y`.out
set pagesize 0 linesize 100 feedback off verify off heading off echo off
select C_IMEI
from TDE_DESBLOQUEO
where C_MARCA like '%$varMarca%';
exit;
EOF



if [ -s /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_`date +%d%m%Y`.out ] && [ -s /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_DESB_`date +%d%m%Y`.out ]; then

  echo -e "DEPOSITANDO DATA DE LA MARCA EN ARCHIVOS GENERALES"


        time sort -n  /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_`date +%d%m%Y`.out >>  /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/DETALLE_`date +%d%m%Y`.SORT
        time sort -n  /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_DESB_`date +%d%m%Y`.out >>  /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/DESB_`date +%d%m%Y`.SORT

        rm /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_`date +%d%m%Y`.out
        rm /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/LISTADO_DESB_`date +%d%m%Y`.out
fi



done

  echo -e "SE TERMINA DE CONSULTAR TODA LA DATA DE LAS MARCAS E INICIA FILTRO DE FALTANTES ENTRE DESBLOQUEADOS Y TARIFARIOS SAP"

                ksh -c "time awk -F'|' 'FNR==NR {a[\$1];next} (\$1 in a)' /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/DESB_`date +%d%m%Y`.SORT /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/DETALLE_`date +%d%m%Y`.SORT > /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/ENCONTRADOS_DESB_SAP_`date +%d%m%Y`.T"
                sleep 3
  echo -e "SE FILTRA ENTRE TODOS LOS TARIFARIOS Y LOS CARGADOS EN LA UNION DESBLOQUEO | TARIFARIOS =  FALTANTES  "

                ksh -c "time awk -F'|' 'FNR==NR {a[\$1];next} !(\$1 in a)' /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/ENCONTRADOS_DESB_SAP_`date +%d%m%Y`.T /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/DETALLE_`date +%d%m%Y`.SORT  > /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/MARCA_REPORTE_JURIDICO_DETALLE_`date +%d%m%Y`.TXT"
                sleep 3

  echo -e "INICIA PROCESO GENERACION DE DATOS EN TABLA TEMPORAL"

            sh /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/cargaArchivoToTemp.sh


  echo -e "INICIA PROCESO DE CREACION DE ARCHIVO REPORTE CON CONSULTA DE SP_IMEIS"


            sh /desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/generaReporteJuridico.sh

  echo -e "PROCESO COMPLETADO"


  