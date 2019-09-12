## CAS 使用 MySQL

参考: https://www.cnblogs.com/jpeanut/p/9231201.html

添加依赖
```xml
<!-- Database Authentication Begin -->
<dependency>
    <groupId>org.apereo.cas</groupId>
    <artifactId>cas-server-support-jdbc</artifactId>
    <version>${cas.version}</version>
</dependency>
<dependency>
   <groupId>org.apereo.cas</groupId>
   <artifactId>cas-server-support-jdbc-drivers</artifactId>
   <version>${cas.version}</version>
</dependency>
<!-- Database Authentication End -->
```

添加JDBC配置项

```text
cas.authn.jdbc.query[0].sql=SELECT * FROM cas_user_base WHERE user_name=?
cas.authn.jdbc.query[0].url=jdbc:mysql://localhost:3306/test_cas?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&useSSL=false&serverTimezone=UTC
cas.authn.jdbc.query[0].driverClass=com.mysql.jdbc.Driver
cas.authn.jdbc.query[0].dialect=org.hibernate.dialect.MySQLDialect
cas.authn.jdbc.query[0].user=root
cas.authn.jdbc.query[0].password=
cas.authn.jdbc.query[0].fieldPassword=user_psd
```

附： 测试数据库

```
--创建数据库表空间
CREATE DATABASE test_cas DEFAULT CHARSET utf8 COLLATE utf8_general_ci;  
USE test_cas;  
--创建帐号信息表
DROP TABLE IF EXISTS `cas_user_base`;  
CREATE TABLE `cas_user_base` (  
  `id` INT(11) NOT NULL AUTO_INCREMENT,  
  `user_name` VARCHAR(45) DEFAULT NULL,  
  `user_psd` VARCHAR(45) DEFAULT NULL,  
  PRIMARY KEY (`id`)  
);  
--插入登录帐号数据
INSERT INTO `cas_user_base` VALUES (1,'admin','123456'),(2,'guest','123456');
```