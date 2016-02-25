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
          <h1 class="page-header">个人信息</h1>

<!-- 内容页面开始 -->
<%
	int StuNo = (Integer)session.getAttribute("userno");

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	int sno, dno, mno, grade;
	String name;
	String sex;
	String birthday;
	String dname;
	String mname;

	try {
		Class.forName(DBDRIVER);
		conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
		pstmt = conn.prepareStatement("select * from student where sno=?;");
		pstmt.setInt(1, StuNo);
		rs = pstmt.executeQuery();
		rs.next();
		
		sno = rs.getInt(1);
		name = rs.getString(2);
		sex = rs.getString(3);
		birthday = rs.getString(4);
		dno = rs.getInt(5);
		mno = rs.getInt(6);
		grade = rs.getInt(7);
		pstmt.close();
		rs.close();
		
		pstmt = conn.prepareStatement("select dname from department where dno=?;");
		pstmt.setInt(1, dno);
		rs = pstmt.executeQuery();
		rs.next();
		dname = rs.getString(1);
		pstmt.close();
		rs.close();
		
		pstmt = conn.prepareStatement("select mname from major where mno=? and dno=?;");
		pstmt.setInt(1, mno);
		pstmt.setInt(2, dno);
		rs = pstmt.executeQuery();
		rs.next();
		mname = rs.getString(1);
%>
<div class="table-responsive">
  <table class="table table-striped">
    <thead>
      <tr>
        <th>学号</th>
        <th>姓名</th>
        <th>性别</th>
        <th>生日</th>
        <th>院系</th>
        <th>专业</th>
        <th>年级</th>
      </tr>
    </thead>
    <tbody>
    
   		<tr>
	        <td><%=sno %></td>
	        <td><%=name %></td>
	        <td><%=sex %></td>
	        <td><%=birthday %></td>
	        <td><%=dname %></td>
	        <td><%=mname %></td>
	        <td><%=grade %></td>
	      </tr>
    
    </tbody>
  </table>
</div>
<%
	} catch (Exception e) {
		System.out.println(e);
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