使用keepalived实现高可用（主备）
===============================

环境
----
```
CentOS7.2
192.168.100.141: keepalived(master) + tomcat
192.168.100.233: keepalived(backup) + tomcat
192.168.100.228: vip
```

安装
----
```
yum install -y keepalived tomcat
```

配置
----

```
vim /etc/keepalived/keepalived.conf <<
! Configuration File for keepalived
global_defs {
  router_id LVS_DEVEL_SERVER
}

vrrp_instance VI_SERVER {
  state MASTER               
  interface eth0
  virtual_router_id 51
  priority 100
  authentication {
    auth_type PASS
    auth_pass 1111
  }
  virtual_ipaddress {
    192.168.100.228/24
  }
}
```

以上为主节点配置，备节点
```
state MASTER ==> state BACKUP 
priority 100 ==> priority 90
```

启动
----
```
service keepalived start
```

访问
----
```
http://192.168.100.228:8080 (通过vip访问)
```
