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
          <h1 class="page-header">成绩录入</h1>

<!-- 内容页面开始 -->
<%
	int ano = (Integer)session.getAttribute("userno");

	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	String dname = null;
	String cno = request.getParameter("cno");
	String year= request.getParameter("year");
	
	
	try {
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
		
		pstmt = conn.prepareStatement("select sc.sno as sno, name, dno, grade, score from (sc join student on (sc.sno = student.sno)) where cno=? and semester=? order by sno;");
		pstmt.setString(1, request.getParameter("cno"));
		pstmt.setString(2, request.getParameter("year"));
		rs = pstmt.executeQuery();
		
	//	request.setAttribute("cno",cno);
	//	request.setAttribute("semno",year);
%>
		
		<div class="table-responsive">
		<form method="post" action="input_grade_done.jsp">
		  <table class="table table-striped">
		    <thead>
		      <tr>
		        <th>学号</th>
		        <th>姓名</th>
		        <th>院系</th>
		        <th>年级</th>
		        <th>成绩</th>
		      </tr>
		    </thead>
		    <tbody>
		    	<tr>
<% 
		while(rs.next()) {
				pstmt2 = conn.prepareStatement("select dname from department where dno=?;");
				pstmt2.setString(1, rs.getString(3));
				rs2 = pstmt2.executeQuery();
				while(rs2.next()) {
					dname = rs2.getString(1);
				};
				pstmt2.close();
				rs2.close();
%>
		    	<td><%=rs.getString(1) %></td>
				<td><%=rs.getString(2) %></td>
		    	<td><%=dname %></td>
		    	<td><%=rs.getString(4) %></td>
		    	<td width="30px">
<%
				if (rs.getString(5) == null) { 
					%>
			    	<input type="text" name="<%=rs.getString(1)%>" class="form-control" placeholder="成绩">
					<%
				} else {
					%>
					<input type="text" name="<%=rs.getString(1)%>" class="form-control" placeholder="成绩" value="<%=rs.getString(5) %>">
					<%
				}
%>
			  	</td>
		    	</tr>
<%
		}
%>
		    </tbody>
		  </table>
		  <input type="hidden" name="cno" value=<%=cno %>>
		  <input type="hidden" name="semno" value=<%=year %>>
		  <input type="submit" class="btn btn-lg btn-primary" value="提交">
		  </form>
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