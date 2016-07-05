===============================
fuxi
===============================

Enable Docker container to use Cinder volume and Manila share

Fuxi focuses on enabling Docker container to use Cinder volume and Manila
share, thus Docker volume can reuse the advance features and numerous vendor
drivers in Cinder and Manila. With Fuxi, Cinder and Manila can be used as
the unified persistence storage provider for virtual machine, baremetal
and Docker container.

* Free software: Apache license
* Documentation: http://docs.openstack.org/developer/fuxi
* Source: http://git.openstack.org/cgit/openstack/fuxi
* Bugs: http://bugs.launchpad.net/Fuxi

Features
--------

* TODO


Prerequisites
-------------

* Install client if needed. For example if use iSCSI client to connect iSCSI target(Cinder volume), then iSCSI client is needed.

Ubuntu

::

    sudo apt-get -y --force-yes install open-iscsi

CentOS

::

    sudo yum -y install iscsi-initiator-utils

* Install requirements.

::

    sudo pip install -r requirements.txt


If fuxi-server run with a common user, it is expected to enable fuxi to execute some Linux command without password interact.

Installing Fuxi
---------------

::

    python setup.py install

Configuring Fuxi
----------------

After install Fuxi, there will generate a configuration file `/etc/fuxi/fuxi.conf`. Edit it according to you requiremnts.

* Default section

::

    my_ip = MY_IP # The IP of host that Fuxi deployed on
    volume_provider = cinder # The enable volume provider for Fuxi

* Keystone section

::

    region = Region
    auth_url = AUTH_URL
    admin_user = ADMIN_USER
    admin_password = ADMIN_PASSWORD
    admin_tenant_name = ADMIM_TENANT_NAME

* Cinder section

::

    volume_connector = VOLUME_CONNECTOR # The way to connect to volume. For Cinder, this could chose from `[openstack, osbrick]`
    protocol = iscsi # If volume_connector = osbirck, this is needed
    fstype = ext4 # Default filesystem type to format, if not provided from request

Running Fuxi
------------
Fuxi could run with ROOT permission or general use permission. In order to make fuxi-server working normally, some extra config is inevitable.

For ROOT user

::

    ln -s /lib/udev/scsi_id /usr/local/bin

For general user

::

    echo "fuxi ALL=(root) NOPASSWD: /usr/local/bin/fuxi-rootwrap /etc/fuxi/rootwrap.conf *" > /etc/sudoers.d/fuxi-rootwrap

Here user `fuxi` could change to the user run `fuxi-server` on your host.

Start `fuxi-server`
::

    fuxi-server --config-file /etc/fuxi/fuxi.conf

Testing Fuxi
------------

::

    $ docker volume create --driver fuxi --name test_vol -o size=1 -o fstype=ext4
    test_vol
    $ docker volume ls
    DRIVER              VOLUME NAME
    fuxi                test_vol

