#!/bin/bash

if [ $# -lt 3 ]; then
    exit 1
fi

CLI=$1
NODE=$2
PLUGIN=$3

if [ $CLI -eq 1 ]; then
    #clusterhq-flocker-cli
    sudo apt-get -y --force-yes install  apt-transport-https software-properties-common
    sudo add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"
    sudo apt-get update
    sudo apt-get -y --force-yes install clusterhq-flocker-cli
fi

if [ $NODE -eq 1 ]; then
	#clusterhq-flocker-node
	sudo apt-get update
	sudo apt-get -y --force-yes install apt-transport-https software-properties-common
	sudo add-apt-repository -y "deb https://clusterhq-archive.s3.amazonaws.com/ubuntu/$(lsb_release --release --short)/\$(ARCH) /"
	sudo apt-get update
	sudo apt-get -y --force-yes install clusterhq-flocker-node
fi

if [ $PLUGIN -eq 1 ]; then
    #clusterhq-flocker-docker-plugin
    sudo apt-get install -y --force-yes clusterhq-flocker-docker-plugin
fi

if [ ! -e "/etc/flocker" ]; then
    mkdir -p /etc/flocker
fi
