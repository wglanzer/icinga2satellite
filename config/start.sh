#!/bin/bash
CHECKFILE='/opt/start.done'
MASTER_PORT=${MASTER_PORT:-"5665"}

if [ ! -f '$CHECKFILE' ]; then
  echo "[start.sh] Configuring Icinga2 Satellite..."
  #chown nagios:nagios /etc/icinga2/pki -R
  #echo "[start.sh] Get new cert from $NODE_NAME"
  #icinga2 pki new-cert --cn $NODE_NAME --key /etc/icinga2/pki/$NODE_NAME.key --cert /etc/icinga2/pki/$NODE_NAME.crt
  #echo "[start.sh] Save key"
  #icinga2 pki save-cert --key /etc/icinga2/pki/$NODE_NAME.key --cert /etc/icinga2/pki/$NODE_NAME.crt --trustedcert /etc/icinga2/pki/trusted-master.crt --host $MASTER_HOST
  #echo "[start.sh] Executing pki request"
  #icinga2 pki request --host $MASTER_HOST --port $MASTER_PORT --ticket $PKI_TICKET --key /etc/icinga2/pki/$NODE_NAME.key --cert /etc/icinga2/pki/$NODE_NAME.crt --trustedcert /etc/icinga2/pki/trusted-master.crt --ca /etc/icinga2/pki/ca.key
  #echo "[start.sh] Setup node"
  #icinga2 node setup --cn $NODE_NAME --ticket $PKI_TICKET --endpoint $MASTER_HOST --zone $NODE_ZONE --master_host $MASTER_HOST --trustedcert /etc/icinga2/pki/trusted-master.crt
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
