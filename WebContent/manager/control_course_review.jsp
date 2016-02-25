<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*" %>
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
          <h1 class="page-header">开启关闭课程评估</h1>
          
<!-- 内容页面开始 -->
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

boolean course_review_open = false;
String opened_semester = null;
ArrayList<String> sem_list = null; 

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select semno from semester where review=1;");
	rs = pstat.executeQuery();
	
	if (rs.next()) {
		// 当前有学期已经开启了课程评估
		course_review_open = true;
		opened_semester = rs.getString(1);
	}

} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
}

if (!course_review_open) {
	try {
		// 未开启课程评估
		sem_list = new ArrayList<String>();
		pstat = conn.prepareStatement("select semno from semester;");
		rs = pstat.executeQuery();
		while (rs.next()) {
			sem_list.add(rs.getString(1));
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
}


if (course_review_open) {
	// 显示：已开启
	%>
	<p>课程评估已开启。评估学期：<strong><%=opened_semester %> </strong></p>
	<a href="control_course_review_do.jsp?close=1">
	  <input type="submit" class="btn btn-lg btn-primary" name="close" id="close" value="关闭">
	</a>
	<%
}
else {
	// 显示：未开启，选择某个学期开启
	%>
	<p>课程评估当前未开启。您可以选择一个学期开启课程评估：</p>
	<form method="post" action="control_course_review_do.jsp">
      <table>
      <tbody>
      <tr>
      <td width="160px">
      <select name="sem" id="sem" class="form-control" style="width: 150px">
        <%
        for (String sem: sem_list) {
        %>
        <option value="<%=sem %>"><%=sem %></option>
        <%
        }
        %>
      </select>
      </td>
      <td>
      <input type="submit" class="btn btn-lg btn-primary" name="submit" id="submit" value="提交">
      </td>
      </tr>
      </tbody>
      </table>
    </form>
	
	<%
}


%>
<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>