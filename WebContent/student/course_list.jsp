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
    (Integer)session.getAttribute("usertype") != 0) {
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
          <h1 class="page-header">查看课程</h1>

<!-- 内容页面开始 -->
<%
	int StuNo = (Integer)session.getAttribute("userno");

	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt_cno = null;
	ResultSet rs = null;
	ResultSet rs_cno = null;
	
	try {
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
		pstmt = conn.prepareStatement("select cno, type from sc where sno=? and semester=?;");
		pstmt.setInt(1, StuNo);
		pstmt.setString(2, request.getParameter("semester"));
		rs = pstmt.executeQuery();
		
%>
		
		<div class="table-responsive">
		  <table class="table table-striped">
		    <thead>
		      <tr>
		        <th>课程编号</th>
		        <th>课程名</th>
		        <th>课程类型</th>
		        <th>开课学期</th>
		        <th>时间地点</th>
		      </tr>
		    </thead>
		    <tbody>
		    	<tr>
<% 
		while(rs.next()) {
			try {
				pstmt_cno = conn.prepareStatement("select name, place_time from course where cno=?;");
				pstmt_cno.setInt(1, rs.getInt(1));
				rs_cno = pstmt_cno.executeQuery();
				rs_cno.next();
%>
		    	<td><%=rs.getInt(1) %></td>
				<td><%=rs_cno.getString(1) %></td>
		    	<td><%=rs.getString(2) %></td>
		    	<td><%=request.getParameter("semester")%></td>
		    	<td><%=rs_cno.getString(2) %></td>
		    	</tr>
<%
			} catch(Exception e) {
				System.out.println("inside" + e);
			} finally {
				rs_cno.close();
				pstmt_cno.close();
			}
		}
%>
		    </tbody>
		  </table>
		</div>
		
<%
	} catch (Exception e) {
		System.out.println("outside" + e);
	} finally {
		rs.close();
		pstmt.close();
		conn.close();
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