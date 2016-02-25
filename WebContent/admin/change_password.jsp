<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../config.jsp" %>

<!DOCTYPE html>
<html>
  <head>
	<meta charset="utf-8">
	<title>南京大学教务系统</title>

	<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="../css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="../css/dashboard.css" rel="stylesheet">
	
	<script type="text/javascript">
	function CheckForm()
	{
		var old = document.getElementById("old_password");
		if(old.value.length == 0)
		{
			alert("旧密码不能为空!");
			old.focus();
			return false;
		}
		
		var new1 = document.getElementById("new_password");
		if(new1.value.length == 0)
		{
			alert("新密码不能为空!");
			new1.focus();
			return false;
		}
		
		var new2 = document.getElementById("new_password_again");
		if(new2.value != new1.value)
		{
			alert("两次输入不一致!");
			new2.focus();
			return false;
		}
	}
	</script>
  </head>
<body>

<%
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 2) {
	%>
	<script type="text/javascript">
	alert("请重新登录！");
	window.location.href="../index.html";
	</script>
	<%
	return;
}
%>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="welcome.jsp" class="navbar-brand">南京大学教务系统</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="../about.html">关于</a></li>
            <li><a href="../logoff.jsp">退出</a></li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="_sidebar.jsp"></jsp:include>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">修改密码</h1>
          
<!-- 内容页面开始 -->

<div align="center">
<form method="post" action="change_password_do.jsp" onsubmit="JavaScript: return CheckForm();">
  <table style="border: 0px">
    <tbody>
    <tr>
      <td width="80" height="50"><label for="old_password">旧密码</label></td>
      <td width="246"><input type="password" class="form-control" name="old_password" id="old_password"></td>
    </tr>
    <tr>
      <td width="80" height="50"><label for="new_password">新密码</label></td>
      <td width="246"><input type="password" class="form-control" name="new_password" id="new_password"></td>
    </tr>
    <tr>
      <td width="80" height="50"><label for="new_password_again">重复新密码</label></td>
      <td width="246"><input type="password" class="form-control" id="new_password_again"></td>
    </tr>
    
    <tr>
  	  <td colspan="2" align="center" height="60">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
    	<input type="reset" class="btn btn-lg btn-danger" name="reset" id="reset" value="重置">
  	  </td>
  	</tr>
    </tbody>
  </table>
</form>
</div>

<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>