## CAS 架构

![](./images/cas_architecture.png)

## CAS Server登录流程

入口： webapp/resources/webflow/login/login-webflow.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<flow xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns="http://www.springframework.org/schema/webflow"
      xsi:schemaLocation="http://www.springframework.org/schema/webflow
                          http://www.springframework.org/schema/webflow/spring-webflow.xsd">

    <action-state id="initializeLoginForm">
        <evaluate expression="initializeLoginAction" />
        <transition on="success" to="viewLoginForm"/>
    </action-state>

    <view-state id="viewLoginForm" view="casLoginView" model="credential">
        <binder>
            <binding property="username" required="true"/>
            <binding property="password" required="true"/>
        </binder>
        <transition on="submit" bind="true" validate="true" to="realSubmit" history="invalidate"/>
    </view-state>

    <action-state id="realSubmit">
        <evaluate expression="authenticationViaFormAction"/>
        <transition on="warn" to="warn"/>
        <transition on="success" to="createTicketGrantingTicket"/>
        <transition on="successWithWarnings" to="showAuthenticationWarningMessages"/>
        <transition on="authenticationFailure" to="handleAuthenticationFailure"/>
        <transition on="error" to="initializeLoginForm"/>
    </action-state>

</flow>
```

第一步 初始化登录表单： initializeLoginAction

support/cas-server-support-actions/src/main/java/org/apereo/cas/web/config/CasSupportActionsConfiguration.java

support/cas-server-support-actions/src/main/java/org/apereo/cas/web/flow/login/InitializeLoginAction.java


第二步 显示登录页面：casLoginView

webapp/resources/templates/casLoginView.html

输入用户名、密码，点击登录，进入第三步


第三步 提交、认证：authenticationViaFormAction

support/cas-server-support-actions/src/main/java/org/apereo/cas/web/config/CasSupportActionsConfiguration.java

```java
    @ConditionalOnMissingBean(name = "authenticationViaFormAction")
    @Bean
    @RefreshScope
    public Action authenticationViaFormAction() {
        return new InitialAuthenticationAction(initialAuthenticationAttemptWebflowEventResolver,
            serviceTicketRequestWebflowEventResolver,
            adaptiveAuthenticationPolicy);
    }
```

3个参数：
initialAuthenticationAttemptWebflowEventResolver： 

serviceTicketRequestWebflowEventResolver:

adaptiveAuthenticationPolicy:

在文件中声明 core/cas-server-core-webflow/src/main/java/org/apereo/cas/web/flow/config/CasCoreWebflowConfiguration.java

第三参数在 core/cas-server-core-authentication/src/main/java/org/apereo/cas/config/CasCoreAuthenticationPolicyConfiguration.java

support/cas-server-support-actions/src/main/java/org/apereo/cas/web/flow/actions/InitialAuthenticationAction.java


```java
    @Override
    protected Event doExecute(final RequestContext requestContext) {
        final String agent = WebUtils.getHttpServletRequestUserAgentFromRequestContext();
        final GeoLocationRequest geoLocation = WebUtils.getHttpServletRequestGeoLocationFromRequestContext();

        if (geoLocation != null && StringUtils.isNotBlank(agent) && !adaptiveAuthenticationPolicy.apply(agent, geoLocation)) {
            final String msg = "Adaptive authentication policy does not allow this request for " + agent + " and " + geoLocation;
            final Map<String, Throwable> map = CollectionUtils.wrap(UnauthorizedAuthenticationException.class.getSimpleName(), new UnauthorizedAuthenticationException(msg));
            final AuthenticationException error = new AuthenticationException(msg, map, new HashMap<>(0));
            return new Event(this, CasWebflowConstants.TRANSITION_ID_AUTHENTICATION_FAILURE,
                new LocalAttributeMap(CasWebflowConstants.TRANSITION_ID_ERROR, error));
        }

        final Event serviceTicketEvent = this.serviceTicketRequestWebflowEventResolver.resolveSingle(requestContext);
        if (serviceTicketEvent != null) {
            fireEventHooks(serviceTicketEvent, requestContext);
            return serviceTicketEvent;
        }

        final Event finalEvent = this.initialAuthenticationAttemptWebflowEventResolver.resolveSingle(requestContext);
        fireEventHooks(finalEvent, requestContext);
        return finalEvent;
    }
```

adaptiveAuthenticationPolicy.apply(agent, geoLocation): 认证策略校验

检测客户端IP是否被禁用

检测UserAgent是否被禁用

![](./images/cas-login-adaptiveAuthenticationPolicy.apply.png)



