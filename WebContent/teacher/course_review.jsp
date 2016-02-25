<%@page import="java.sql.*"%>
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
		var re_int_ab = /^20[0-9]{2}[AB]$/;
		var re_int = /^[1-9]+[0-9]*]*$/;
		
		var semester = document.getElementById("semester");
		if(semester.value.length == 0)
		{
			alert("学期不能为空!");
			semester.focus();
			return false;
		}
		else if(!re_int_ab.test(semester.value))
		{
			alert("学期格式不正确");
			semester.focus();
			return false;
		}
		
		var cno = document.getElementById("cno");
		if(cno.value.length == 0)
		{
			alert("课程号不能为空!");
			cno.focus();
			return false;
		}
		else if(!re_int.test(cno.value))
		{
			alert("课程号格式不正确");
			cno.focus();
			return false;
		}
		
		return true;
	}
	</script>
</head>

<body>
<%
if(session.getAttribute("usertype") == null ||
	(Integer)session.getAttribute("usertype") != 1) {
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
          <h1 class="page-header">查看课程评价</h1>
<!-- 页面内容开始 -->
<div align="center">
<form method="post" action="course_review_list.jsp" onsubmit="JavaScript: return CheckForm();">
  <table style="border: 10px">
    <tr>
      <td width="71" height="50" align="right"><label for="semester">学期：</label></td>
      <td width="246">
        <select class="form-control" name="semester" id="semester">
<%
	Connection conn = null;
	PreparedStatement pstat = null;
	ResultSet rs = null;

	try{
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

		pstat = conn.prepareStatement("select distinct(semester) from tc where tno=?;");
		pstat.setString(1, session.getAttribute("userno").toString());
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
        </td>
  	  <td width="71" height="50" align="right"><label for="cno">课编号：</label></td>
      <td width="246">
        <select class="form-control" name="semester" id="semester">
<%
	try{
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

		pstat = conn.prepareStatement("select cno, cname from `tc-full` where tno=?;");
		pstat.setString(1, session.getAttribute("userno").toString());
		rs = pstat.executeQuery();
		while(rs.next()){
			%>
			<option><%=rs.getString(1) %> - <%=rs.getString(2) %></option>
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
        </td>  	  <td align="center" width="100">
  		<input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="查看">
  	  </td>
  	</tr>
  </table>
</form>
</div>

<!-- 页面内容结束 -->
        </div>
	  </div>
  	</div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
</body>
</html>