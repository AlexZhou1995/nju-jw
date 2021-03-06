<%@page import="java.util.ArrayList"%>
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

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
ArrayList<Integer> dpt_no = new ArrayList<Integer>();
ArrayList<String> dpt_list = new ArrayList<String>();

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select dno, dname from department order by dno;");
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		dpt_no.add(rs.getInt(1));
		dpt_list.add(rs.getString(2));
	}
} catch (SQLException e) {
	e.printStackTrace();
} finally {
	if (rs != null) rs.close();
	if (pstat != null) pstat.close();
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
          <h1 class="page-header">查看课程</h1>

<!-- 内容页面开始 -->
<div align="center">
<form method="post" action="list_course_do.jsp">
  <table style="border: 0px">
    <tr>
      <td width="111" height="50"><label for="keyword">课程名关键字</label></td>
      <td width="286"><input type="text" class="form-control" name="keyword" id="keyword" placeholder="不超过10个字，查看所有课程请留空"></td>
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
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>