## CAS集成JWT

### 基于JWT的ST

ST为CAS为客户端签发的ticket，由于jwt具备自验证性，故基于JWT的ST发送到客户端，不需要再到CAS服务端验证，客户端就可以解出登录用户信息

### 配置

```xml
<dependency>
     <groupId>org.apereo.cas</groupId>
     <artifactId>cas-server-support-token-tickets</artifactId>
     <version>${cas.version}</version>
</dependency>
```

参考：

官方文档 https://apereo.github.io/cas/development/installation/JWT-Authentication.html#jwt-authentication