#!/bin/bash
CHECKFILE='/opt/start.done'
MASTER_PORT=${MASTER_PORT:-"5665"}
NODE_ZONE=${NODE_ZONE:-"$NODE_NAME"}

if [ ! -f '$CHECKFILE' ]; then
  echo "[start.sh] Configuring Icinga2 Satellite..."
  (echo "Y"             #is satellite setup
   echo $NODE_NAME      #specify node CN
   echo $NODE_ZONE      #specify node zone
   echo $MASTER_HOST    #master common name
   echo "Y"             #establish a connection?
   echo $MASTER_HOST    #master fqdn
   echo $MASTER_PORT    #master port
   echo "N"             #Add more endpoints
   echo                 #CSR-Host
   echo                 #CSR-Port
   echo "y"             #is this information correct?
   echo $PKI_TICKET     #ticket
   echo                 #API-bind host
   echo                 #API-bind port
   echo "y"             #Accept config from master
   echo "y"             #Accept commands from master
   ) | icinga2 node wizard

  if [ $? -eq 0 ]; then
    echo "[start.sh] Configuration finished!"
    touch '$CHECKFILE';
  else
    echo "[start.sh] Configuration failed!"
    exit $?
  fi
fi

# Start supervisor
/usr/bin/supervisord
