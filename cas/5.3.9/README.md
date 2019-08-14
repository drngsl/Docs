## CAS部署

官方文档： https://apereo.github.io/cas/5.3.x/index.html#

[cas-overlay-template](https://github.com/apereo/cas-overlay-template)

JDK8

Tomcat8


### Tomcat配置https

生成证书

```bash
# generate keystore
keytool -genkey -alias tomcat -keyalg RSA -validity 3650 -keystore tomcat.jks
# 导出证书
keytool -export -alias tomcat -keystore tomcat.jks -file tomcat.crt
# 将证书导入JRE cacerts. 以下keystore路径以实际路径为准
keytool -import -file tomcat.crt -alias tomcat -keystore /opt/jdk/jre/lib/security/cacerts 
```

tomcat配置证书

将上面生成的tomcat.jks复制到tomcat conf目录

```bash
cp tomcat.jks /opt/tomcat/conf
```

修改tomcat server.xml添加

```xml
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="200" SSLEnabled="true" scheme="https"
           secure="true" clientAuth="false" sslProtocol="TLS"
           keystoreFile="./conf/tomcat.jks"
           keystorePass="changeit"/>
```

测试https

![](./images/tomcat-https.JPG)


### 部署CAS

编译cas包

***编译前请准备***
```text
安装maven
```
```bash
git clone https://github.com/apereo/cas-overlay-template.git
cd cas-overlay-template
git checkout 5.3.9
mvn clean package
```

以上步骤将在target目录生成cas.war文件，将该文件解压至tomcat/webapps目录

![](./images/cas-webapps.JPG)

重启tomcat，访问cas

![](./images/cas-login.JPG)

**注：**

1. 如果CAS启动出现如下错误，在编译cas时，添加如下依赖
```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
```
2. 上图中直接访问了cas默认的域名，这种方式请现在本地hosts文件添加映射


### 配置访问Dashboard

默认情况下，访问dashboard，提示 Access Denied。 修改配置文件application.properties开启访问

配置请参考：

【1】 https://blog.csdn.net/fireofjava/article/details/79243868

【2】 https://apereo.github.io/cas/5.3.x/installation/Configuration-Properties.html#spring-boot-endpoints


## 搭建 cas-management

```bash
git clone git clone https://github.com/apereo/cas-management-overlay.git
cd cas-management-overlay
git checkout 5.3
mvn clean package
```

执行以上命令后在target目录生成cas-management

* 配置cas服务地址(application.properties)

```text
cas.server.name=https://cas.example.org:8443
cas.server.prefix=${cas.server.name}/cas
```

## [CAS 支持 Rest](https://apereo.github.io/cas/6.0.x/protocol/REST-Protocol.html)

添加依赖，重新编译，执行部署流程
```xml
<dependency>
    <groupId>org.apereo.cas</groupId>
    <artifactId>cas-server-support-rest-tokens</artifactId>
    <version>${cas.version}</version>
</dependency>
```

*注*:

编译过程中可能报错
```text
[ERROR] Failed to execute goal on project cas-overlay: Could not resolve dependencies for project org.apereo.cas:cas-overlay:war:1.0: Failure to find net.shibboleth.tool:xmlsectool:jar:2.0.0 in https://mirrors.huaweicloud.com/repository/maven/ was cached in the local repository, resolution will not be reattempted until the update interval of huaweicloud has elapsed or updates are forced -> [Help 1]
```

可以手动下载xmlsectool，并安装到本地maven仓库
```bash
wget https://build.shibboleth.net/nexus/content/repositories/releases/net/shibboleth/tool/xmlsectool/2.0.0/xmlsectool-2.0.0.jar
mvn install:install-file -Dfile=./xmlsectool-2.0.0.jar -DgroupId=net.shibboleth.tool -DartifactId=xmlsectool -Dversion=2.0.0 -Dpackaging=jar
```

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


## [CAS 集成 SAML](https://apereo.github.io/cas/6.0.x/protocol/SAML-Protocol.html)

在pom.xml中添加saml依赖，重新编译，执行部署流程

```xml
<dependency>
  <groupId>org.apereo.cas</groupId>
  <artifactId>cas-server-support-saml-idp</artifactId>
  <version>${cas.version}</version>
</dependency>
```

启动后访问： https://cas.example.org:8443/cas/idp/metadata 就能得到 SAML 接入的 metadata，以及各种 URL 地址了。在 /etc/cas/saml 下能得到这个 metadata 的 xml 定义文件，以及各证书。

为使CAS能够加载注册的各种应用(service)，请在application.properties中追加配置

```text
cas.serviceRegistry.initFromJson=true
```

否则

* SAML集成示例（CAS作为IDP，华为云服务作为SP）

1. 双方交换SAML元数据

1.1 下载华为云元数据文件 https://auth.huaweicloud.com/authui/saml/metadata.xml, 保存为*huaweicloud-metadata.xml*

1.2 将*huaweicloud-metadata.xml*上传到cas服务器/etc/cas/saml目录

1.3 添加华为云服务描述文件

![](./huaweicloud-metadata.JPG)
```json
{
  "@class" : "org.apereo.cas.support.saml.services.SamlRegisteredService",
  "serviceId" : "https://auth.huaweicloud.com/",
  "name" : "huaweicloud",
  "id" : 10000004,
  "evaluationOrder" : 10,
  "metadataLocation" : "/etc/cas/saml/huaweicloud-metadata.xml"
}
```

1.4 下载cas saml元数据文件，导入到华为云中，具体操作参考 https://support.huaweicloud.com/usermanual-iam/zh-cn_topic_0046611277.html


附： NameId-Format
| 值 | URI |  说明 |
| :-----: | :-----: | :-----: |
| urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified | 来自身份提供者的 Subject NameID 值可以是任何格式 |
| Email Address | urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress | 来自身份提供者的 Subject NameID 值使用电子邮件地址格式 |
| X.509 Subject Name | urn:oasis:names:tc:SAML:1.1:nameid-format:X509SubjectName | |
| Kerberos Principal Name | urn:oasis:names:tc:SAML:2.0:nameid-format:kerberos | |
| Entity Identifier | urn:oasis:names:tc:SAML:2.0:nameid-format:entity | |
| Transient Identifier | urn:oasis:names:tc:SAML:2.0:nameid-format:transient ||
| Persistent Identifier | urn:oasis:names:tc:SAML:2.0:nameid-format:persistent ||


## CAS 配置 SwaggerAPI

添加依赖

```xml
<dependency>
  <groupId>org.apereo.cas</groupId>
  <artifactId>cas-server-documentation-swagger</artifactId>
  <version>${cas.version}</version>
</dependency>
```

重新部署后访问：

| 描述 |  地址 |
| :-----: | :-----: |
| Swagger API规范 | http://localhost/cas/v2/api-docs |
| Swagger UI | http://localhost/cas/swagger-ui.html |

##  动态添加services

参考： https://www.jianshu.com/p/8c1fd3107b06?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation