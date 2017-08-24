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
	  <div class="m-box" >	
			<div class="left-area blue">
				<img src="img/logo.png">
			</div>
			<div class="right-area" >
				<div class="successful-tips" style="">
					<img style="margin-top: 130px;" src="img/hook.png">
					<p style="font-size: 24px;color: #a2c449;">退出成功</p>
					<p style="font-size: 16px;color: #999;"><span id="time">3</span>s后自动跳转</p>
				</div>
			</div>
				<div class="copyright">
					Copyright © 2013-2017 重庆聚悦健康管理有限公司
			</div>	
	</div>
	 
	</div>
<script>
//返回的是对象形式的参数  
function Request(name)
{
     new RegExp("(^|&)"+name+"=([^&]*)").exec(window.location.search.substr(1));
     return RegExp.$2
}
window.onload=function(){ 
	var url=Request("service");
	var count=2;
	if(url==""||typeof(url)=="undefined"){ 
			url="login";
	}
	setInterval(function(){
		document.getElementById("time").innerHTML=count;

		count--;
		if(count==0){ 
			window.location.href=url;
		}
	},1000);
}
</script>
<jsp:directive.include file="includes/login_bottom.jsp" />