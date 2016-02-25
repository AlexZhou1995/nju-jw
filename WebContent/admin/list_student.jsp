<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.*" %>
<%@include file="/config.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>南京大学教务系统</title>

    <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="../css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
	<link href="../css/dashboard.css" rel="stylesheet">
	
	
	<script type="text/javascript">
	function CheckForm()
	{
		var re_int = /^[1-9]+[0-9]*]*$/;
		
		var grade = document.getElementById("grade");
		if(grade.value.length == 0)
		{
			alert("入学年份不能为空!");
			grade.focus();
			return false;
		}
		else if(!re_int.test(grade.value))
		{
			alert("入学年份必须为整数!");
			grade.focus();
			return false;
		}
		return true;
	}
	</script>
</head>
<body>
<% 
if(session.getAttribute("usertype") == null ||
    (Integer)session.getAttribute("usertype") != 2) {
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
          <h1 class="page-header">查看学生信息</h1>

<!-- 内容页面开始 -->
<div align="center">
<form method="post" action="list_student_do.jsp" >
  <table style="border: 0px">
	 <tr>
	 <td align="center" width="70" height="50"><label for="grade">年级</label>
	 <td  width="180">
	 <select name="grade" id="grade" class="form-control">
<%
	Connection conn = null;
	PreparedStatement pstat = null;
	ResultSet rs = null;

	try{
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

		pstat = conn.prepareStatement("select distinct(grade) from student;");
		rs = pstat.executeQuery();
		while(rs.next()){
			%>
			<option><%=rs.getString(1) %></option>
			<%
		}
	}catch (SQLException e) {
		e.printStackTrace();
	}
	finally {
		rs.close();
		pstat.close();
		conn.close();
	}
%>
	 </select>
	 <td width="100" align="center">
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
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>