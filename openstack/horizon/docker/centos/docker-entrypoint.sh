#!/bin/bash

settings_path="/etc/openstack-dashboard/local_settings"

if [ "$OPENSTACK_API_VERSIONS" ]
then
    echo "OPENSTACK_API_VERSIONS="$OPENSTACK_API_VERSIONS >> $settings_path
fi

if [ "$OPENSTACK_HOST" ]
then
    echo "OPENSTACK_HOST="$OPENSTACK_HOST >> $settings_path
fi

if [ "$OPENSTACK_KEYSTONE_DEFAULT_ROLE" ]
then
    echo "OPENSTACK_KEYSTONE_DEFAULT_ROLE=$OPENSTACK_KEYSTONE_DEFAULT_ROLE" >> $settings_path
fi

if [ "$OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT" ]
then
    echo "OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT=$OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT" >> $settings_path
fi

if [ "$OPENSTACK_KEYSTONE_URL" ]
then
    echo "OPENSTACK_KEYSTONE_URL=$OPENSTACK_KEYSTONE_URL" >> $settings_path
fi

service httpd memcached start

/bin/bash "$@"