## Spring 注解

@Qualifier： 当一个接口有多个实现的时候，为了指名具体调用哪个类的实现

如 `@Qualifier("serviceTicketRequestWebflowEventResolver")`


@Configuration("xxx")
@ConfigurationProperties
@EnableConfigurationProperties(XXX.class)
@ConditionalOnProperty
@ImportAutoConfiguration