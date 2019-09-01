## CAS启用Rest API

添加依赖，重新编译，执行部署流程

```xml
<dependency>
    <groupId>org.apereo.cas</groupId>
    <artifactId>cas-server-support-rest</artifactId>
    <version>${cas.version}</version>
</dependency>
```

*注*:

编译过程中可能报错
```text
[ERROR] Failed to execute goal on project cas-overlay: Could not resolve dependencies for project org.apereo.cas:cas-overlay:war:1.0: Failure to find net.shibboleth.tool:xmlsectool:jar:2.0.0 in https://mirrors.huaweicloud.com/repository/maven/ was cached in the local repository, resolution will not be reattempted until the update interval of huaweicloud has elapsed or updates are forced -> [Help 1]
```

### Rest API

1. 获取TGT

URL: `https://cas.example.com:8443/cas/v1/tickets`

```bash
curl -XPOST https://cas.example.org:8443/cas/v1/tickets -k -H "Content-type: application/x-www-form-urlencoded" -d "username=casuser&password=Mellon" --verbose
```

返回值

Header:

`Location: https://cas.example.org:8443/cas/v1/tickets/TGT-4-35qNotb7SX4bH1xkve3AJ5XKRLZ-N1Sl0o5OfBRHo2On9c10JpvucQFG5Nr2CQe5oa4LAPTOP-15OQ5UH7`

Body:

```html
<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">
<html>
<head><title>201 Created</title></head>
<body><h1>TGT Created</h1>
<form action="https://cas.example.org:8443/cas/v1/tickets/TGT-4-35qNotb7SX4bH1xkve3AJ5XKRLZ-N1Sl0o5OfBRHo2On9c10JpvucQFG5Nr2CQe5oa4LAPTOP-15OQ5UH7"
      method="POST">Service:<input type="text" name="service" value=""><br><input type="submit" value="Submit"></form>
</body>
</html>
```

2. 获取ST：为service颁发ticket

URL: https://cas.example.org:8443/cas/v1/tickets/<tgt>?service=<service-url>

注：
```text
tgt为上一步得到的tgt
```

```bash
curl -XPOST https://cas.example.org:8443/cas/v1/tickets/TGT-4-35qNotb7SX4bH1xkve3AJ5XKRLZ-N1Sl0o5OfBRHo2On9c10JpvucQFG5Nr2CQe5oa4LAPTOP-15OQ5UH7 -k -H "Content-type: application/x-www-form-urlencoded" -d "service=https://app1.example.org" --verbose
```

返回值：

Body:

```text
448ST-1-KK8s-8qvT6EF8UNt29ova6ByF2gLAPTOP-15OQ5UH7
```
