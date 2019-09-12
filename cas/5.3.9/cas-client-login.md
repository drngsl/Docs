## CAS客户端集成

客户端应用使用CAS登录时，需要预先将应用注册到CAS。

CAS默认的service管理使用本地文件方式，注册的服务以json格式存在目录 WEB-INF/classes/services

![](./images/cas-service-files.png)

使用本地文件管理service需要开启配置
```bash
cas.serviceRegistry.initFromJson=true
```

开启后，将支持**所有**https协议和imaps协议客户端，修改HTTPSandIMAPS-10000001.json来支持http协议客户端
```json
{
  "@class" : "org.apereo.cas.services.RegexRegisteredService",
  "serviceId" : "^(https|http|imaps)://.*",
  "name" : "HTTPS and IMAPS",
  "id" : 10000001,
  "description" : "This service definition authorizes all application urls that support HTTPS and IMAPS protocols.",
  "evaluationOrder" : 10000
}

```

如果只希望授权特定应用登录，可修改serviceId，或者添加更多的service文件

### 搭建客户端demo

本文中使用https://github.com/cas-projects/cas-sample-java-webapp做测试

```bash
git clone https://github.com/cas-projects/cas-sample-java-webapp.git
mvn package
```

修改文件target\cas-sample-java-webapp\WEB-INF\web.xml中cas的相关地址以及serverName后，部署之。

### 访问测试

https://cas.example.org:8443/cas-sample-java-webapp