## CAS返回用户自定义属性

参考：https://www.twblogs.net/a/5c1f805ebd9eee16b4a71e21/zh-cn

### CAS属性返回策略

| 名称 | 说明 | 类 |
| :-----: | :-----: | :-----: |
| Return All | 返回配置的所有项 | |
| Deny All | 配置拒绝的出现则报错 | |
| Return Allowed | 返回允许的项 | |
| 自定义Filter | 自定义属性过滤策略 | |

> Return All

> Deny All

> Return Allowed

### 验证

结合文档 [CAS使用JDBC认证](./cas-auth-by-jdbc.md)以及[客户端集成](./cas-client-login.md)

在cas配置文件`application.properties`添加配置
```bash

```