#!/bin/bash

yum -y install samba samba-client samba-common samba-winbind samba-winbind-clients krb5-workstation ntpdate

chkconfig smb on
chkconfig winbind on
service smb start
service winbind star

WORK_GROUP=SUNNIL
DOMAIN=SUNNIL.CC
DOMAIN_HOST=samba4.sunnil.cc
DOMAIN_IP=192.168.149.128
# DOMAIN_HOST_NAME=samba4

# Add AD domain host
echo "192.168.149.128 samba4.sunnil.cc samba4" >> /etc/hosts

#Set dns and ntp time
echo "nameserver ${DOMAIN_IP}" >> /etc/resolve.conf
ntpdate ${DOMAIN_HOST}

# Destroy ticket
kdestroy
klist
# Generate new ticket
kinit administrator@${DOMAIN}
klist

# Join AD
authconfig --enablewinbind  --enablewins --enablewinbindauth --smbsecurity ads \
	--smbworkgroup=${WORK_GROUP} --smbrealm ${DOMAIN} \
	--smbservers=${DOMAIN_HOST} --enablekrb5 --krb5realm=${DOMAIN} \
	--krb5kdc=${DOMAIN_HOST} --krb5adminserver=${DOMAIN_HOST} \
	--enablekrb5kdcdns --enablekrb5realmdns --enablewinbindoffline \
	--winbindtemplateshell=/bin/bash --winbindjoin=administrator \
	--update --enablelocauthorize --enablemkhomedir --enablewinbindusedefaultdomain

# Add sodu permision for domain users
echo "%${WORK_GROUP}\\\\domain\\ admins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudo

# Check AD information
net ads info

wbinfo -u

# NOTE: if selinux started, then need to install oddjobmkhomedir and start it
# NOTE: ldapsearch -h SUNNIL.CC -x LLL -D "cn=Administrator,cn=Users,dc=sunnil,dc=cc" -W -b "cn=Users,dc=sunnil,dc=cc"
