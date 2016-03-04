#! /bin/bash

FLOCKER_TMP_PATH=/tmp/flocker-crt/
FLOCKER_CONFIG_PATH=/etc/flocker/
PASSWORD=cnp200@HW
NODE_TYPE_CONTROL=control
NODE_TYPE_AGENT=agent

pre_install() {
    if [ ! -e "/usr/bin/expect" ]; then
        sudo apt-get -y --force-yes install expect
    fi
}

scp_copy() {
    node_type=$1
    host_name=$2
    if [ "${node_type}" = "$NODE_TYPE_CONTROL" ]; then
        scp_file="cluster.crt cluster.key control-service.crt control-service.key"
    elif [ "${node_type}" = "$NODE_TYPE_AGENT" ]; then
	    scp_file="cluster.crt node.crt node.key user.crt user.key plugin.crt plugin.key"
    else
	    exit 1
    fi
	
/usr/bin/expect<<-EOF
set time 30
spawn scp $scp_file root@${host_name}:${FLOCKER_CONFIG_PATH}
expect { 
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "${PASSWORD}\r" }
}
expect eof
EOF
}

if [ -d $FLOCKER_TMP_PATH ]; then
    rm -rf $FLOCKER_TMP_PATH
fi

mkdir -p $FLOCKER_TMP_PATH
cd $FLOCKER_TMP_PATH

FIRST=0
for arg in "$@"
do
    if [ "${arg}" = "${1}" ] && [ $FIRST -eq 0 ]; then
	    FIRST=1
        #generate cluster certificates
        flocker-ca initialize $1

        #generate control service certificates
        flocker-ca create-control-certificate $arg

        #rename it to control-service.crt and control-service.key
        mv control-${arg}.crt control-service.crt
        mv control-${arg}.key control-service.key

        scp_copy control $arg

        #generate docker plugin certificate first
        flocker-ca create-api-certificate plugin
    else
        #generate node authentication certificates
        node_cert_num=`flocker-ca create-node-certificate`
        node_cert_num=`echo ${node_cert_num} | cut -d ' ' -f 2 | cut -d . -f 1`
        #node_cert_num=`flocker-ca create-node-certificate | cut -d ' ' -f 2 | cut -d . -f 1`
		
		#reame it to node.crt and node.key
        mv ${node_cert_num}.crt node.crt
        mv ${node_cert_num}.key node.key

        #generate api user client certificate
        flocker-ca create-api-certificate $arg
        mv ${arg}.crt user.crt
        mv ${arg}.key user.key
	
        scp_copy agent $arg

        rm node.* user.*
    fi
done

#remove crt tmp directroy
if [ -d $FLOCKER_TMP_PATH ]; then
    rm -rf $FLOCKER_TMP_PATH
fi

