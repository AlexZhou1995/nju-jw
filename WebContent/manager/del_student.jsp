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
		var re_int = /^[1-9]+[0-9]*]*$/;
		
		var sno = document.getElementById("sno");
		if(sno.value.length == 0)
		{
			alert("学生学号不能为空!");
			sno.focus();
			return false;
		}
		else if(!re_int.test(sno.value))
		{
			alert("学生学号必须为整数!");
			sno.focus();
			return false;
		}
		
		return true;
	}
	</script>

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
          <h1 class="page-header">删除学生</h1>
          
<!-- 内容页面开始 -->
<div align="center">
<form method="post" action="del_student_do.jsp" onsubmit="JavaScript: return CheckForm();">
  <table style="border: 0px">
    <tr>
      <td width="71" height="50"><label for="sno">学生学号</label></td>
      <td width="246"><input type="text" class="form-control" name="sno" id="sno" placeholder="请输入整数，例如：102"></td>
  	  <td align="center" width="100">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
  	  </td>
  	</tr>
  </table>
</form>
</div>
<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
</body>
</html>