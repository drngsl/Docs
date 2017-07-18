FROM centos:latest

WORKDIR /opt

# Install dependencies
RUN yum -y install epel-release && \
    yum install -y gcc git libxslt-devel openssl-devel libffi-devel python-devel python-pip python-virtualenv crudini && \
    yum clean all && yum -y autoremove

RUN pip install junitxml tox

# Install tempest
ARG repo="https://github.com/openstack/tempest.git"
ARG branch="master"
RUN git clone $repo -b $branch && \
    pip install tempest/ && \
    cd tempest && oslo-config-generator --config-file tempest/cmd/config-generator.tempest.conf && \
    mkdir /etc/tempest/ && cp etc/tempest.conf.sample /etc/tempest/tempest.conf && \
    cd ../ && cp tempest/.testr.conf . && rm -rf tempest

CMD ["/bin/bash"]

COPY docker-entrypoint.sh /usr/bin

ENTRYPOINT ["docker-entrypoint.sh"]