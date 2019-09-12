## CAS集成JWT

### 基于JWT的ST

ST为CAS为客户端签发的ticket，由于jwt具备自验证性，故基于JWT的ST发送到客户端，不需要再到CAS服务端验证，客户端就可以解出登录用户信息

### 配置

pom.xml

```xml
<dependency>
     <groupId>org.apereo.cas</groupId>
     <artifactId>cas-server-support-token-tickets</artifactId>
     <version>${cas.version}</version>
</dependency>
```

application.properties
```text
cas.authn.token.crypto.encryptionEnabled=true
cas.authn.token.crypto.signingEnabled=true
```

### 注册客户端

```json
{
  "@class" : "org.apereo.cas.services.RegexRegisteredService",
  "serviceId" : "^https://.*",
  "name" : "Sample",
  "id" : 10,
  "properties" : {
    "@class" : "java.util.HashMap",
    "jwtAsServiceTicket" : {
      "@class" : "org.apereo.cas.services.DefaultRegisteredServiceProperty",
      "values" : [ "java.util.HashSet", [ "true" ] ]
    }
  }
}
```

### 待验证

参考：

官方文档 https://apereo.github.io/cas/5.3.x/installation/Configure-ServiceTicket-JWT.html