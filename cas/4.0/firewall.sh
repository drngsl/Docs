#!/bin/bash

firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --permanent --zone=public --add-service=kerberos
firewall-cmd --permanent --zone=public --add-service=ldap
firewall-cmd --permanent --zone=public --add-service=ldaps
firewall-cmd --permanent --zone=public --add-service=dns
firewall-cmd --permanent --zone=public --add-service=ntp
firewall-cmd --permanent --zone=public --add-port=135/tcp
firewall-cmd --permanent --zone=public --add-port=464/tcp
firewall-cmd --permanent --zone=public --add-port=1024/tcp
firewall-cmd --permanent --zone=public --add-port=3268/tcp
firewall-cmd --permanent --zone=public --add-port=3269/tcp
firewall-cmd --permanent --zone=public --add-port=137/udpp
firewall-cmd --permanent --zone=public --add-port=138/udp
firewall-cmd --permanent --zone=public --add-port=389/udp
firewall-cmd --reload

setsebool -P samba_domain_controller on
setsebool -P samba_export_all_ro on
setsebool -P samba_export_all_rw on
setsebool -P samba_enable_home_dirs on
