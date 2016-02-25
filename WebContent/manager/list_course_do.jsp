<%@page import="java.util.HashMap"%>
<%@page import="org.apache.tomcat.jni.Directory"%>
<%@page import="java.util.Map"%>
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
request.setCharacterEncoding("utf-8");

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

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
Map<Integer, String> department = new HashMap<Integer, String>();

boolean search;

if(request.getParameter("keyword") == null){
	search = true;
}

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
	pstat = conn.prepareStatement("select dno, dname from department order by dno;");
	rs = pstat.executeQuery();
	
	while (rs.next()) {
		department.put(rs.getInt(1), rs.getString(2));
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
<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>编号</th>
        <th>开设院系</th>
        <th>课程名</th>
        <th>学分数</th>
        <th>时间地点</th>
      </tr>
    </thead>
    <tbody>
    <%
	try {
		pstat = conn.prepareStatement("select * from course order by dno, cno;");
		rs = pstat.executeQuery();
		while (rs.next()) {
			if(request.getParameter("keyword")!=null){
				if(rs.getString(3).contains(request.getParameter("keyword"))==false)
					continue;
			}
		%>
	      <tr>
	        <td><%=rs.getString(1) %></td>
	        <td><%=department.get(rs.getInt(2)) %></td>
	        <td><%=rs.getString(3) %></td>
	        <td><%=rs.getString(4) %></td>
	        <td><%=rs.getString(5) %></td>
	      </tr>
	    <%
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (rs != null) rs.close();
		if (pstat != null) pstat.close();
	}
    if (conn != null) conn.close();
	%>
	</tbody>
  </table>
</div>
<!-- 内容页面结束 -->

        </div>
      </div>
    </div>
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
  </body>
</html>