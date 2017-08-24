css 文件位置：login.css,normalize.css
cas-server-webapp-4.1.10/css
js 文件 
cas-server-webapp-4.1.10/js


添加css,js文件指向
在cas-server-webapp-4.1.10\WEB-INF\classes\cas-theme-default.properties 文件下添加
(是为了后面页面引用)

###############My CSS #######
cas.login.css.file=/css/login.css
cas.normalize.css.file=/css/normalize.css



进入cas-server-webapp-4.1.10\WEB-INF\view\jsp\default\ui 
可以看到 includes （这里包括top.jsp,bottom.jsp)
还有一系列的jsp文件（登入页面为casLogin.View.jsp)

先拷贝一份 top.jsp,bottom.jsp 重命名为 login_top.jsp login.bottom.jsp

修改login_top.jsp
引入css文件
  <spring:theme code="cas.login.css.file" var="login" />
  <spring:theme code="cas.normalize.css.file" var="normalize" />
  <!--  <link rel="stylesheet" href="<c:url value="${customCssFile}" />" /> -->
  <link rel="stylesheet"  href="<c:url value="${login}" />" />
  <link rel="stylesheet"  href="<c:url value="${normalize}" />" />

 修改 casLogin.View.jsp

 其他都可以动
 下面这些不能动


  <form:form method="post" id="fm1" commandName="${commandName}" htmlEscape="true">

        <form:errors path="*" id="msg" cssClass="errors" element="div" htmlEscape="false" />

 				<c:choose>
	                <c:when test="${not empty sessionScope.openIdLocalId}">
	                    <strong><c:out value="${sessionScope.openIdLocalId}" /></strong>
	                    <input type="hidden" id="username" name="username" value="<c:out value="${sessionScope.openIdLocalId}" />" />
	                </c:when>
	                <c:otherwise>
	                    <spring:message code="screen.welcome.label.netid.accesskey" var="userNameAccessKey" />    <!--不能删 -->
	                    <form:input cssClass="required" cssErrorClass="error" id="username"  size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="off" htmlEscape="true" placeholder="账号" />
	                     <!--写法不能变，不能删 -->
	                </c:otherwise>
	            </c:choose>
			</div>
			<div class="password-box t">
	            <spring:message code="screen.welcome.label.password.accesskey" var="passwordAccessKey" />   <!--不能删 -->
	            <form:password cssClass="required" cssErrorClass="error" class="password input-height" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" placeholder="密码"/>
	             <!--写法不能变，不能删 -->
			</div>
	        <section class="row btn-row login-box"  style="margin-top: 53px;">
	            <input type="hidden" name="lt" value="${loginTicket}" />
	            <input type="hidden" name="execution" value="${flowExecutionKey}" />
	            <input type="hidden" name="_eventId" value="submit" />
	             <!--不能删 -->
	            <input class="btn-submit btn-login btn-blue" name="submit" accesskey="l" value="登录" tabindex="6" type="submit" />
	        </section>
    	</form:form>


一个页面绑定两个username 会有问题，待解决



修改信息在 classes/messages.properties




cas 配置多数据源


1配置两个dateSource  我们系统都一个数据库所以只要配置一个dataSource1就行
<bean id="dataSource1"
          class="org.springframework.jdbc.datasource.DriverManagerDataSource">
          <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver" />
          <property name="url" value="jdbc:oracle:thin:@127.0.0.1:1521:orcl" />
          <property name="username" value="username" />
          <property name="password" value="password" />
</bean>
<bean id="dataSource2"
  class="org.springframework.jdbc.datasource.DriverManagerDataSource">
  <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver" />
  <property name="url" value="jdbc:oracle:thin:@127.0.0.1:1521:orcl" />
  <property name="username" value="username" />
  <property name="password" value="password" />
</bean>

配置两个登入权限处理
<bean id="primaryAuthenticationHandler"
           class="org.jasig.cas.adaptors.jdbc.QueryDatabaseAuthenticationHandler"
           p:dataSource-ref="dataSource1"
           p:passwordEncoder-ref="MD5PasswordEncoder"
           p:sql="select lower(LOGON_PWD) password from ams_user where LOGON_ACCT=?" />
 	<bean id="secondAuthenticationHandler"
           class="org.jasig.cas.adaptors.jdbc.QueryDatabaseAuthenticationHandler"
           p:dataSource-ref="dataSource2"
           p:passwordEncoder-ref="MD5PasswordEncoder"
           p:sql="select lower(USER_PWD) password  from OP_USER where USER_ACCT=?" />


配置  这里一定要两个
  <bean id="primaryPrincipalResolver"
          class="org.jasig.cas.authentication.principal.PersonDirectoryPrincipalResolver"
          p:principalFactory-ref="principalFactory"
          p:attributeRepository-ref="attributeRepository" /> 

 

     <bean id="secondPrincipalResolver"
          class="org.jasig.cas.authentication.principal.PersonDirectoryPrincipalResolver"
          p:principalFactory-ref="principalFactory"
          p:attributeRepository-ref="attributeRepository" /> 



 最后在头上面加上


        <constructor-arg>
            <map>
                <!--
                   | IMPORTANT
                   | Every handler requires a unique name.
                   | If more than one instance of the same handler class is configured, you must explicitly
                   | set its name to something other than its default name (typically the simple class name).
                   -->
                <entry key-ref="proxyAuthenticationHandler" value-ref="proxyPrincipalResolver" />
                <entry key-ref="primaryAuthenticationHandler" value-ref="primaryPrincipalResolver" />
                <entry key-ref="secondAuthenticationHandler" value-ref="secondPrincipalResolver" />
                <!-- 多出这里一句-->
            </map>
        </constructor-arg>



返回多个用户信息
参考blog http://blog.csdn.net/chenhai201/article/details/50623395
http://www.tuicool.com/articles/fUrERzN

AttributePrincipal principal = (AttributePrincipal)request.getUserPrincipal();
Map attributes = principal.getAttributes();
String email=attributes .get("email");

过期时间
ticketExpirationPolicies.xml

    <!-- TicketGrantingTicketExpirationPolicy: Default as of 3.5 -->
    <!-- Provides both idle and hard timeouts, for instance 2 hour sliding window with an 8 hour max lifetime -->
    <bean id="grantingTicketExpirationPolicy" class="org.jasig.cas.ticket.support.TicketGrantingTicketExpirationPolicy"
          c:maxTimeToLive="${tgt.maxTimeToLiveInSeconds:86400}" c:timeToKill="${tgt.timeToKillInSeconds:43200}" c:timeUnit-ref="SECONDS" />