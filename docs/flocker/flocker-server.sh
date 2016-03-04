#!/bin/bash

if [ $# -lt 2 ]; then
    exit 1
fi

MASTER=$1
MINION=$2

if [ $MASTER -eq 1 ]; then
    cat <<EOF > /etc/init/flocker-control.override
    start on runlevel [2345]
    stop on runlevel [016]
    EOF
   
    echo 'flocker-control-api	4523/tcp			# Flocker Control API port' >> /etc/services
    echo 'flocker-control-agent	4524/tcp			# Flocker Control Agent port' >> /etc/services
   
    ufw allow flocker-control-api
    ufw allow flocker-control-agent
    service flocekr-control restart
fi

if [ $MINION -eq 1 ]; then
   service flocker-dataset-agent restart
   service flocker-container-agent restart
   service flocker-docker-plugin restart
fi