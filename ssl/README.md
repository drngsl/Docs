## keytool

## openSSL

> 1 生成根密钥

```bash
openssl genrsa -out rootkey.pem 2048
```

> 2 创建根证书 （用根证书来签发服务器端请求文件）

```bash
 openssl req -x509 -new -key rootkey.pem -out root.crt
```

> 3 创建服务器密钥

```bash
openssl genrsa -out serverkey.pem 2048
```

> 4 生成服务器端证书的请求文件

```bash
openssl req -new -key serverkey.pem -out server.csr
```

> 5 用根证书来签发服务器端，生成服务器端证书

```bash
openssl x509 -req -in server.csr -CA root.crt -CAkey rootkey.pem -CAcreateserial -days 3650 -out server.crt
```

> 6 将证书导出为pkcs12格式

```bash
openssl pkcs12 -export -in server.crt -inkey serverkey.pem -out server.pkcs12
```

> 7 执行keytool命令生成服务端密钥库

```bash
keytool -importkeystore -srckeystore server.pkcs12 -destkeystore mykey.keystore -srcstoretype pkcs12
```

参考

[1] https://www.cnblogs.com/ChromeT/p/11122480.html
[2] https://blog.csdn.net/joyous/article/details/80659925
[3] https://www.cnblogs.com/Sunzz/p/8862338.html