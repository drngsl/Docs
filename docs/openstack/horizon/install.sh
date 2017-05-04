#!/bin/bash

set -x

installComp() {
    yum install -y centos-release-openstack-mitaka && yum -y update
    yum install -y vim
    yum install -y openstack-dashboard httpd mod_wsgi memcached python-memcached
}

updateSettings() {
    # openstack-dashboard.conf
    # redirect root api
    if [ `grep 'RedirectMatch "^/$" "/dashboard/"' /etc/httpd/conf.d/openstack-dashboard.conf | wc -l` -eq 0 ]; then
        echo 'RedirectMatch "^/$" "/dashboard/"' >> /etc/httpd/conf.d/openstack-dashboard.conf
    fi

    # local-settings
    # Update alloded host
    # ALLOWED_HOSTS = ['*',]

    # Use cache
#    SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
#    CACHES = {
#        'default': {
#            'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
#            'LOCATION': '127.0.0.1:11211',
#        },
#    }

    # identity
    # OPENSTACK_HOST="127.0.0.1"

    # verify for api
    return
}

enableHttpdNetConnect() {
    setsebool -P httpd_can_network_connect on
}

startDashboard() {
    systemctl enable httpd.service memcached.service
    systemctl restart httpd.service memcached.service
}

allowAccess() {
    firewall-cmd --query-port=80/tcp
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --reload
}

installComp
updateSettings
enableHttpdNetConnect
startDashboard
allowAccess
