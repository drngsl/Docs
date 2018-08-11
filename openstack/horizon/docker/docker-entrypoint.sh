#!/bin/sh

settings_path="./openstack_dashboard/local/local_settings.py"
cp $settings_path.example $settings_path

if [ "$ALLOW_HOSTS" ]
then
    echo "ALLOW_HOSTS=$ALLOW_HOSTS" >> $settings_path
fi

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

httpd

exec "$@"