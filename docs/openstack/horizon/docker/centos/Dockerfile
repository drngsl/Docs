FROM centos:latest

ARG branch=mitaka

RUN yum install -y centos-release-openstack-${branch} && yum -y update && \
    yum install -y openstack-dashboard httpd mod_wsgi memcached python-memcached && \
    yum clean all && yum -y autoremove

EXPOSE 80

COPY docker-entrypoint.sh /usr/bin

ENTRYPOINT ["docker-entrypoint.sh"]
