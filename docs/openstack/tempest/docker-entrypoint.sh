#!/bin/bash

export PYTHON_LIB=`python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())'`
export OS_TOP_LEVEL=$PYTHON_LIB
export OS_TEST_PATH=${PYTHON_LIB}/tempest/test_discover/

CONF_FILE=/etc/tempest/tempest.conf

sed -i -e '/^#.*$/d' -e '/^$/d' $CONF_FILE

# Minial conf
crudini --set $CONF_FILE auth tempest_roles ${TEMPEST_ROLES:-Member}
crudini --set $CONF_FILE auth admin_username ${ADMIN_USERNAME:-admin}
crudini --set $CONF_FILE auth admin_tenant_name ${ADMIN_TENANT_NAME:-admin}
crudini --set $CONF_FILE auth admin_password ${ADMIN_PASSWORD:-admin}

crudini --set $CONF_FILE identity catalog_type ${CATALOG_TYPE:-identity}
crudini --set $CONF_FILE identity uri ${URI:-http://127.0.0.1:5000/v2.0}
crudini --set $CONF_FILE identity uri_v3 ${URI_V3:-http://127.0.0.1:5000/v3}
crudini --set $CONF_FILE identity auth_version ${AUTH_VERSION:-v2}
crudini --set $CONF_FILE identity region ${REGION:-RegionOne}
crudini --set $CONF_FILE identity v2_admin_endpoint_type ${V2_ADMIN_ENDPOINT_TYPE:-adminURL}
crudini --set $CONF_FILE identity v2_public_endpoint_type ${V2_PUBLIC_ENDPOINT_TYPE:-publicURL}
crudini --set $CONF_FILE identity username ${USERNAME:-demo}
crudini --set $CONF_FILE identity tenant_name ${TENANT_NAME:-demo}
crudini --set $CONF_FILE identity admin_role ${ADMIN_ROLE:-admin}
crudini --set $CONF_FILE identity password ${PASSWORD:-123456}

crudini --set $CONF_FILE identity-feature-enabled api_v2 ${API_V2:-true}
crudini --set $CONF_FILE identity-feature-enabled api_v3 ${API_V3:-false}

$@