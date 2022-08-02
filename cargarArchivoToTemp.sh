#!/bin/ksh

#CARGA ARCHIVO DE PROPIEDADES
. /desbloqueo/DEQ/SHELLS/conexion.properties

#Ejecutar PL/SQL para proceso

echo $ORACLE_HOME/bin/sqlplus

/oracle/ora11c/bin/sqlldr "$USER_RAC/$PASS_RAC@//$HOST_RAC:$PORT_RAC/RAC_IMEI", control=imeisTmp.ctl, log=imeisTmp.log, errors=10, ROWS=1000
