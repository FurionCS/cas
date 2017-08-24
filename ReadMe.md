### cas 服务端配置

### 1 .支持Http

1. 修改 WEB-INF\deployerConfigContext.xml

		增加参数 p:requireSecure="false" ，是否需要安全验证，即 HTTPS ， false 为不采用

		<bean id="proxyAuthenticationHandler"
          class="org.jasig.cas.authentication.handler.support.HttpBasedServiceCredentialsAuthenticationHandler"
          p:httpClient-ref="supportsTrustStoreSslSocketFactoryHttpClient" p:requireSecure="false" />

2. 修改 WEB-INF\spring-configuration/ticketGrantingTicketCookieGenerator.xml 

		修改 p:cookieSecure="true" 为 p:cookieSecure=" false " ， 即不需要安全 cookie

		<bean id="ticketGrantingTicketCookieGenerator" class="org.jasig.cas.web.support.CookieRetrievingCookieGenerator"
          c:casCookieValueManager-ref="cookieValueManager"
          p:cookieSecure="false"
          p:cookieMaxAge="-1"
          p:cookieName="TGC"
          p:cookiePath=""/>

3. 修改 WEB-INF\spring-configuration\warnCookieGenerator.xml

		修改 p:cookieSecure="true" 为 p:cookieSecure=" false " ， 即不需要安全 cookie

		 <bean id="warnCookieGenerator" class="org.jasig.cas.web.support.CookieRetrievingCookieGenerator"
          p:cookieHttpOnly="true"
          p:cookieSecure="false"
          p:cookieMaxAge="-1"
          p:cookieName="CASPRIVACY"
          p:cookiePath=""/>

4. 修改注册服务WEB-INF/classes/services/HTTPSandIMAPS-10000001.json

		将"serviceId" : "^(https|imaps)://.*"修改为"serviceId" : "^(https|http|imaps)://.*"

### 2.支持数据库认证

1.注释掉默认的用户认证

		<!--<bean id="primaryAuthenticationHandler"
          		class="org.jasig.cas.authentication.AcceptUsersAuthenticationHandler">
        		<property name="users">
            		<map>
                		<entry key="casuser" value="Mellon"/>
            		</map>
       			 </property>
    		</bean>-->

2.添加JDBC验证方式
		
		
		<bean id="dataSource"
	          class="org.springframework.jdbc.datasource.DriverManagerDataSource">
	          <property name="driverClassName" value="oracle.jdbc.driver.OracleDriver" />
	          <property name="url" value="jdbc:oracle:thin:@123.56.74.172:1521:orcl" />
	          <property name="username" value="zjk" />
	          <property name="password" value="zjk" />
    	</bean>
	
		<bean id="primaryAuthenticationHandler"
	           class="org.jasig.cas.adaptors.jdbc.QueryDatabaseAuthenticationHandler"
	           p:dataSource-ref="dataSource"
	           p:passwordEncoder-ref="MD5PasswordEncoder"
	           p:sql="select lower(LOGON_PWD) password from ams_user where LOGON_ACCT=?" />
		   
		<bean id="MD5PasswordEncoder" class="org.jasig.cas.authentication.handler.DefaultPasswordEncoder">
	         <constructor-arg index="0">
	             <value>MD5</value>
	         </constructor-arg>
    	</bean>

3.添加jar包

	将cas-server-support-jdbc-4.1.10.jar,commons-dbcp2-2.1.1.jar,ojdbc6.jar三个包拷贝到WEB-INF/lib上

### 3.支持REST API
	
1.添加jar包
	
	将cas-server-support-rest-4.1.10.jar包拷贝到WEB-INF/lib上


### 4.支持OAuth 2.0


1. 修改 WEB-INF\web.xml

		添加路由映射

		<servlet-mapping>
		  <servlet-name>cas</servlet-name>
		  <url-pattern>/oauth2.0/*</url-pattern>
		</servlet-mapping>

2. 修改 WEB-INF\cas-servlet.xml
		
		在文件中添加bean

		<bean
			  id="oauth20WrapperController"
			  class="org.jasig.cas.support.oauth.web.OAuth20WrapperController"
			  p:loginUrl="http://127.0.0.1:8080/cas/login"
			  p:servicesManager-ref="servicesManager"
			  p:ticketRegistry-ref="ticketRegistry"
			  p:timeout="7200" />

		在handlerMappingC的bean中添加属性

		<prop key="/oauth2.0/*">oauth20WrapperController</prop>

		
3. 添加OAuth2客户端(在WEB-INF/classes/services/文件夹下添加服务定义的json)

		{
  			"@class" : "org.jasig.cas.support.oauth.services.OAuthRegisteredService",
  			"serviceId" : "oauth client service url",
  			"name" : "serviceName",
  			"id" : 1,
  			"description" : "Service Description",
  			"clientId":"client id goes here",
  			"clientSecret":"client secret goes here"
		}
		

### 5：修改cas来源登录退出页面
- cas
	- css (样式)
	- img (图片)
	- js  (js)
	
####登录页面和退出页面
路径 cas\WEB-INF\view\jsp\default\ui  下
登入页面casLoginView.jsp , /includes/login_top.jsp , /includes/bottom.jsp
退出页面casLogoutView.jsp, /includes/logout_top.jsp,/includes/bottom.jsp

> 建议修改页面时先备份下原来的

在login_top.jsp中引入自己的样式
```vbscript-html
  <link rel="stylesheet"  href="css/normalize.css" />
  <link rel="stylesheet"  href="css/login.css" />
```

在casLoginView.jsp中修改自己的html

> cas 默认只提供username 和password 两个变量，如果需要新增请看后面

下面的修改时请谨慎
```html

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
	                   
	                </c:otherwise>
	            </c:choose>
			</div>
			<div class="password-box t">
	            <spring:message code="screen.welcome.label.password.accesskey" var="passwordAccessKey" />   <!--不能删 -->
	            <form:password cssClass="required" cssErrorClass="error" class="password input-height" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" placeholder="密码"/>
	             
			</div>
	        <section class="row btn-row login-box"  style="margin-top: 53px;">
	            <input type="hidden" name="lt" value="${loginTicket}" />
	            <input type="hidden" name="execution" value="${flowExecutionKey}" />
	            <input type="hidden" name="_eventId" value="submit" />
	             <!--不能删 -->
	            <input class="btn-submit btn-login btn-blue" name="submit" accesskey="l" value="登录" tabindex="6" type="submit" />
	        </section>
    	</form:form>
```

##### 修改信息在classes/messages.properties


如：
```java
authenticationFailure.AccountNotFoundException=用户名或密码错误
authenticationFailure.FailedLoginException=用户名或密码错误
```

### 6.cas配置多数据源
**deployerConfigContext.xml**
####  配置两个dateSource 
``` xml
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
```

#### 配置两个登入权限处理
**deployerConfigContext.xml**
```xml
<bean id="primaryAuthenticationHandler"
           class="org.jasig.cas.adaptors.jdbc.QueryDatabaseAuthenticationHandler"
           p:dataSource-ref="dataSource1"
           p:passwordEncoder-ref="MD5PasswordEncoder"
           p:sql="select lower(LOGON_PWD) password from t_user where LOGON_ACCT=?" />
 	<bean id="secondAuthenticationHandler"
           class="org.jasig.cas.adaptors.jdbc.QueryDatabaseAuthenticationHandler"
           p:dataSource-ref="dataSource2"
           p:passwordEncoder-ref="MD5PasswordEncoder"
           p:sql="select lower(USER_PWD) password  from t_user2 where USER_ACCT=?" />
```

#### 配置 PrincipalResolver
**deployerConfigContext.xml**
```xml
  <bean id="primaryPrincipalResolver"
          class="org.jasig.cas.authentication.principal.PersonDirectoryPrincipalResolver"
          p:principalFactory-ref="principalFactory"
          p:attributeRepository-ref="attributeRepository" /> 
     <bean id="secondPrincipalResolver"
          class="org.jasig.cas.authentication.principal.PersonDirectoryPrincipalResolver"
          p:principalFactory-ref="principalFactory"
          p:attributeRepository-ref="attributeRepository" /> 

```
####  最后配置secondPrincipalResolver
**deployerConfigContext.xml**
```xml
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
```


### 7. 返回多个用户信息

cas默认返回用户名，但是在实际生产中往往不止则一个数据，那么就需要我们在查询一遍数据库获得数据

参考链接  [bolg1](http://blog.csdn.net/chenhai201/article/details/50623395) ,[blog2](http://www.tuicool.com/articles/fUrERzN)

**deployerConfigContext.xml**
``` xml
<bean id="primaryAttributeRepository" class="org.jasig.services.persondir.support.jdbc.SingleRowJdbcPersonAttributeDao">
		<constructor-arg index="0" ref="dataSource" />
		<constructor-arg index="1" value="select user_id,'ams' source from t_user where {0}" />
			<property name="queryAttributeMapping">
				<map>
					<entry key="username" value="LOGON_ACCT" />
				</map>
			</property>
			<property name="resultAttributeMapping">
				<map>
					<!-- key是数据库的字段  赋值给 userId变量 -->
					<entry key="user_id" value="userId" />
					<entry key="source" value="source"/>
				</map>
			</property>
	</bean>
```



### 8.设置过期时间
在ticketExpirationPolicies.xml中
```xml 
    <!-- TicketGrantingTicketExpirationPolicy: Default as of 3.5 -->
    <!-- Provides both idle and hard timeouts, for instance 2 hour sliding window with an 8 hour max lifetime -->
    <bean id="grantingTicketExpirationPolicy" class="org.jasig.cas.ticket.support.TicketGrantingTicketExpirationPolicy"
          c:maxTimeToLive="${tgt.maxTimeToLiveInSeconds:86400}" c:timeToKill="${tgt.timeToKillInSeconds:43200}" c:timeUnit-ref="SECONDS" />
```


### 9.区别登录

区别登录已经脱离cas，但是我之前坑爹的需求就要这么做，没办法只能修改原代码，这里放出来，是因为其中是有用的一些信息，包括自定义参数上传等。


> 需要修改源代码，下载源代码

cas sql 默认只支持传username 

```java
	 final String dbPassword = getJdbcTemplate().queryForObject(this.sql, String.class, username);
     if (!dbPassword.equals(encryptedPassword)) {
          hrow new FailedLoginException("Password does not match value on record.");
     }
```

解决方法：
 **  多传一个来源，根据来源和sql匹配看看是不是有存在相同字符，如果存在就执行该sql，不存在就是直接报密码错误   **

1：修改源代码：cas-server-core  jar包
org.jasig.cas.authentication 包下
新增类 

```java
package org.jasig.cas.authentication;

/**
 * @author ErnestCheng
 * @since 1.0
 * 2017-08-17
 */
public class MyCredential extends  UsernamePasswordCredential {


    private String usertype; //用户类型

    public final String getUsertype() {
        return usertype;
    }
    public final void setUsertype(String usertype) {
        this.usertype = usertype;
    }

}
```

2: 修改源代码 ：cas-server-support-jdbc jar包
org.jasig.cas.adaptors.jdbc 包下
新增类

```java
package org.jasig.cas.adaptors.jdbc;

import javax.security.auth.login.AccountNotFoundException;
import javax.security.auth.login.FailedLoginException;
import javax.validation.constraints.NotNull;


import org.jasig.cas.authentication.HandlerResult;
import org.jasig.cas.authentication.MyCredential;
import org.jasig.cas.authentication.PreventedException;
import org.jasig.cas.authentication.UsernamePasswordCredential;

import org.springframework.dao.DataAccessException;
import org.springframework.dao.IncorrectResultSizeDataAccessException;


import java.security.GeneralSecurityException;

/**
 * @author ErnestCheng
 * @since 1.0
 * 2017-08-17
 */
public class MyAuthenticationHandler extends AbstractJdbcUsernamePasswordAuthenticationHandler{

    @NotNull
    private String sql;
    @Override
    protected HandlerResult authenticateUsernamePasswordInternal(UsernamePasswordCredential credential) throws GeneralSecurityException, PreventedException {

        MyCredential myCredential=null;
        if(MyCredential.class.isInstance(credential)){
            myCredential=(MyCredential)credential;
        }else{
            throw new IllegalAccessError("验证参数不匹配");
        }
        final String username = myCredential.getUsername();
        final String password=myCredential.getPassword();
        final String encryptedPassword = this.getPasswordEncoder().encode(password);
        final String userType=myCredential.getUsertype();
        try {
            if(this.sql.contains(userType) || this.sql.contains(userType.toUpperCase())) {
                final String dbPassword = getJdbcTemplate().queryForObject(this.sql, String.class, username);
                if (!dbPassword.equals(encryptedPassword)) {
                    throw new FailedLoginException("Password does not match value on record.");
                }
            }else{
                throw new FailedLoginException("Password does not match value on record.");
            }
        } catch (final IncorrectResultSizeDataAccessException e) {
            if (e.getActualSize() == 0) {
                throw new AccountNotFoundException(username + " not found with SQL query");
            } else {
                throw new FailedLoginException("Multiple records   " + username);
            }
        } catch (final DataAccessException e) {
            throw new PreventedException("SQL exception while executing query for " + username, e);
        }
        return createHandlerResult(myCredential, this.principalFactory.createPrincipal(username), null);
    }


    /**
     * @param sql The sql to set.
     */
    public void setSql(final String sql) {
        this.sql = sql;
    }

}

```

3: 新增自定义参数
在 Web-inf\webflow\login\login-webflow.xml 下


```java
 <view-state id="viewLoginForm" view="casLoginView" model="credential">
        <binder>
            <binding property="username" required="true"/>
            <binding property="password" required="true"/>
            <binding property="usertype" required="false"/>
            <!-- 这里可以新增自定义参数 -->
        </binder>
        <on-entry>
            <set name="viewScope.commandName" value="'credential'"/>

            <!--
            <evaluate expression="samlMetadataUIParserAction" />
            -->
        </on-entry>
        <transition on="submit" bind="true" validate="true" to="realSubmit"/>
    </view-state>
```


4:修改参数接受类

在 Web-inf\webflow\login\login-webflow.xml 下
UsernamePasswordCredential 改成 MyCredential
```java
<var name="credential" class="org.jasig.cas.authentication.MyCredential"/>
```

5：修改处理类

在 web-inf\deployerConfigContext.xml
QueryDatabaseAuthenticationHandler 改成MyAuthenticationHandler
```java
 <bean id="primaryAuthenticationHandler"
          class="org.jasig.cas.adaptors.jdbc.MyAuthenticationHandler"
		  p:dataSource-ref="dataSource"
		  p:passwordEncoder-ref="MD5PasswordEncoder"
		  p:sql="select lower(LOGON_PWD) password from ams_user where LOGON_ACCT=? and USER_TYPE_ID='2'" />
```

6:新增页面自定义参数
在 web-inf\view\jsp\default\ui\casLoginView.jsp
```java
<div class="password-box t" style="display:none">
	            <form:input cssClass="required password input-height" cssErrorClass="error " class="password input-height" id="usertype" size="25" tabindex="2" path="usertype"   htmlEscape="true" autocomplete="off" placeholder="来源"/> 
			</div>
```

```javascript
<script type="text/javascript">
	var url=document.location.href;
	function isContains(url, source) {
    	return url.indexOf(source) >= 0;
	}
	if(isContains(url,'ts')){ 
		document.getElementById("usertype").value='ams_user';
	}else if(isContains(url,'op')){ 
		document.getElementById("usertype").value='op_user';
	}
</script>
```

