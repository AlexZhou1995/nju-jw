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
<%
	int ano = (Integer)session.getAttribute("userno");

	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	PreparedStatement pstmt3 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet rs3 = null;
	String dno = null;
	
	try {
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
		
		pstmt3 = conn.prepareStatement("select dno from admin where ano=?;");
		pstmt3.setInt(1, ano);
		rs3 = pstmt3.executeQuery();
		while(rs3.next()) {
			dno = rs3.getString(1);
		};
		System.out.println(dno);
		pstmt3.close();
		rs3.close();
		
		
		pstmt = conn.prepareStatement("select sno, name, sex, birthday, mno, grade from student where dno=? and grade=? order by mno, sno;");
		pstmt.setString(1, dno);
		pstmt.setString(2, request.getParameter("grade"));
		rs = pstmt.executeQuery();
		
		pstmt2 = conn.prepareStatement("select dname from department where dno=?;");
		pstmt2.setString(1, dno);
		rs2 = pstmt2.executeQuery();
		String dName = null;
		while(rs2.next()) {
		dName = rs2.getString(1);
		};
		System.out.println(dName);
		pstmt2.close();
		rs2.close();
		
		String mName =null;
%>
		
		<div class="table-responsive">
		  <table class="table table-striped">
		    <thead>
		      <tr>
		        <th>学号</th>
		        <th>姓名</th>
		        <th>性别</th>
		        <th>出生日期</th>
		        <th>院系</th>
		        <th>专业</th>
		        <th>入学年份</th>
		      </tr>
		    </thead>
		    <tbody>
		    	<tr>
<% 
		while(rs.next()) {
				pstmt2 = conn.prepareStatement("select mname from major where mno=?;");
				pstmt2.setString(1, rs.getString(5));
				rs2 = pstmt2.executeQuery();
				while(rs2.next()) {
					mName = rs2.getString(1);
				};
				pstmt2.close();
				rs2.close();
%>
		    	<td><%=rs.getString(1) %></td>
				<td><%=rs.getString(2) %></td>
		    	<td><%=rs.getString(3) %></td>
		    	<td><%=rs.getString(4) %></td>
		    	<td><%=dName %></td>
		    	<td><%=mName %></td>
		    	<td><%=rs.getString(6) %></td>
		    	</tr>
<%
		}
%>
		    </tbody>
		  </table>
		  
		</div>
		
<%
	} catch (Exception e) {
		System.out.println("outside" + e);
	}finally {
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