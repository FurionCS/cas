<%--

    Licensed to Apereo under one or more contributor license
    agreements. See the NOTICE file distributed with this work
    for additional information regarding copyright ownership.
    Apereo licenses this file to you under the Apache License,
    Version 2.0 (the "License"); you may not use this file
    except in compliance with the License.  You may obtain a
    copy of the License at the following location:

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

--%>
<jsp:directive.include file="includes/login_top.jsp" />

<div class="g-bg">
	<div class="m-box clear" >	
		<div class="left-area blue">
			<img src="img/logo.png">
		</div>
		<div class="right-area" >
			 <form:form method="post" id="fm1" commandName="${commandName}" htmlEscape="true">

        <form:errors path="*" id="msg" cssClass="errors" element="div" htmlEscape="false" />

       <div class="title"><span class="EN">LOGIN</span><span class="CH">/ 登录</span></div>
			<div class="platform-selection-box" style="display:none">
				<select class="platform-selection input-height" disabled>
					<option>健康管理平台</option>
				</select>
				<img style="display: none;" class="arrow" src="img/arrow.png">
			</div>
			<div class="account-box" style="margin-top: 55px;">
	            <c:choose>
	                <c:when test="${not empty sessionScope.openIdLocalId}">
	                    <strong><c:out value="${sessionScope.openIdLocalId}" /></strong>
	                    <input type="hidden" id="username" name="username" value="<c:out value="${sessionScope.openIdLocalId}" />" />
	                </c:when>
	                <c:otherwise>
	                    <spring:message code="screen.welcome.label.netid.accesskey" var="userNameAccessKey" />
	                    <form:input cssClass="required account input-height" cssErrorClass="error" id="username"  size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="off" htmlEscape="true" placeholder="账号" />
	                </c:otherwise>
	            </c:choose>
			</div>
			<div class="password-box t">
	            <spring:message code="screen.welcome.label.password.accesskey" var="passwordAccessKey" />
	            <form:password cssClass="required password input-height" cssErrorClass="error " class="password input-height" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" placeholder="密码"/>
			</div>
			<div class="password-box t" style="display:none">
	            <form:input cssClass="required password input-height" cssErrorClass="error " class="password input-height" id="usertype" size="25" tabindex="2" path="usertype"   htmlEscape="true" autocomplete="off" placeholder="来源"/> 
			</div>
	        <section class="row btn-row login-box"  style="margin-top: 53px;">
	            <input type="hidden" name="lt" value="${loginTicket}" />
	            <input type="hidden" name="execution" value="${flowExecutionKey}" />
	            <input type="hidden" name="_eventId" value="submit" />
	            <input class="btn-submit btn-login btn-blue" name="submit" accesskey="l" value="登录" tabindex="6" type="submit" />
	        </section>
    	</form:form>
		</div>
		<div class="copyright">
				Copyright © 2013-2017 重庆聚悦健康管理有限公司
		</div>	
	</div>
	<div class="m-box" style="display: none;">	
		<div class="left-area gray">
			<img src="img/logo.png">
		</div>
		<div class="right-area">
		<form id="fm1" action="/cas/login" method="post">
		<form:form method="post" id="fm1" commandName="${commandName}" htmlEscape="true">
	        <form:errors path="*" id="msg" cssClass="errors" element="div" htmlEscape="false" />
				<div class="title"><span class="platform">运营管理平台</span><span class="CH">/ 登录</span></div>
				<div class="account-box " style="margin-top: 80px;">
					<!-- <input class="account input-height-small" type="text" placeholder="用户名"> -->
					 <input id="username" name="username" class="required" style="padding: 22px 0;" tabindex="1" placeholder="用户名" accesskey="u" type="text" value="" size="25" autocomplete="off">
				</div>
				<div class="password-box ">
					<!-- <input class="password input-height-small" type="password" placeholder="密码" > -->
					<input id="password" name="password" class="required" style="padding: 22px 0;" tabindex="2" placeholder="密码" accesskey="p" type="password" value="" size="25" autocomplete="off">
				</div>
				<div class="password-box ">
					<!--<input class="password input-height-small" type="password" placeholder="密码2" > -->
					<input id="password" name="password2" class="required" style="padding: 22px 0;" tabindex="2" placeholder="密码2" accesskey="p" type="password" value="" size="25" autocomplete="off">
				</div>
				<section class="row btn-row login-box"  style="margin-top: 35px;">
					<input type="hidden" name="lt" value="${loginTicket}" />
		            <input type="hidden" name="execution" value="${flowExecutionKey}" />
		            <input type="hidden" name="_eventId" value="submit" />
		            <input class="btn-submit btn-login btn-green" name="submit" accesskey="l" value="登录" tabindex="6" type="submit" />
				 </section>
				 </form:form>
		</div>
		<div class="copyright">
				Copyright © 2013-2017 重庆聚悦健康管理有限公司
		</div>	
	</div>
</div>
<script type="text/javascript">
	var url=document.location.href;
	function isContains(url, source) {
    	return url.indexOf(source) >= 0;
	}
	if(isContains(url,'ts')){ 
		document.getElementById("usertype").value='ams_user';
	}else if(isContains(url,'op')){ 
		document.getElementById("usertype").value='op_user';
	}else if(isContains(url,'client')){ 
		document.getElementById("usertype").value='op_user';
	}
</script>

<jsp:directive.include file="includes/login_bottom.jsp" />
