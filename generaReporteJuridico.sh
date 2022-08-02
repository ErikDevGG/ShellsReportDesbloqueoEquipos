

#!/bin/ksh                                                                


#CARGA ARCHIVO DE PROPIEDADES
. /desbloqueo/DEQ/SHELLS/conexion.properties


NOMBRE_ARCHIVO=/desbloqueo/DEQ/SHELLS/UTILS/TMP/REPORTES_AMX/JURIDICO/generaReporteJuridicoDetalle.sql          export NOMBRE_ARCHIVO_BD


#Llama a ejecutar archivo .sql

echo $ORACLE_HOME/bin/sqlplus

$ORACLE_HOME/bin/sqlplus -s "$USER_RAC/$PASS_RAC@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$HOST_RAC)(Port=$PORT_RAC))(CONNECT_DATA=(SID=(SERVER = DEDICATED))(SERVICE_NAME = bdimei)))" @$NOMBRE_ARCHIVO
