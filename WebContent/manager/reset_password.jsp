<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
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
	
</head>
<body>
<%
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 3) {
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
        <ul class="nav navbar-nav navbar-right">
        <li><a href="../about.html">关于</a></li>
        <li><a href="../logoff.jsp">退出</a></li>
      </ul>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="_sidebar.jsp"></jsp:include>
        
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">重置密码</h1>
          
<!-- 内容页面开始 -->
	<div align="center">
          <form method="post" action="reset_password_do.jsp">
          
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="Name">用户名</label></td>
      <td width="246"><input type="text" class="form-control" name="Name" id="Name" placeholder="例如：student"></td>
    </tr>	
  	<tr>
  	<td colspan="2" align="center" height="60">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交" onclick="return window.confirm('确定要提交吗？')">
  	</td>
  	</tr>
  	
  </table>
</form>
</div>

          
<!-- 内容页面开始 -->

        </div>
      </div>
    </div>
          



</body>
</html>