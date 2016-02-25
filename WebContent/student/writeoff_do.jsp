<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%request.setCharacterEncoding("utf-8");%>
</head>

<body>
<%
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 0) {
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

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
} catch(SQLException e) {
	%>
	<script type="text/javascript">
	alert("数据库连接异常！");
	</script>
	<%
	e.printStackTrace();
}
int sno = (Integer)session.getAttribute("userno");
int dno = -1;

try {
	pstat = conn.prepareStatement("select dno from student where sno=?");
	pstat.setInt(1, sno);
	ResultSet rs = pstat.executeQuery();
	
	if (rs.next()) {
		dno = rs.getInt(1);
	}
	else {
		%>
		<script type="text/javascript">
		alert("账户异常！");
		</script>
		<%
		throw new Exception("Account Error");
	}
}
catch (Exception e) {
	e.printStackTrace();
}


		
try {
	String idx = request.getParameter("idx");
	pstat = conn.prepareStatement("insert into `write-off` (`sno`, `cno`, `semester`, `dno`) values(?, ?, ?, ?);");
	pstat.setInt(1, sno);

	pstat.setString(2, request.getParameter("cno" + idx));
	pstat.setString(3, request.getParameter("semester" + idx));
	
	pstat.setInt(4, dno);
	
	pstat.execute();
	%>
	<script type="text/javascript">
	alert("申请成功，请等待审核！");
	window.history.go(-1);
	</script>
	<%
	
} catch(SQLException e) {
	%>
	<script type="text/javascript">
	alert("操作失败！课程可能已在队列中，请勿重复申请。");
	window.history.go(-1);
	</script>
	<%
	//e.printStackTrace();
	
} finally {
	pstat.close();
	if (conn != null) conn.close();
}	
%>


</body>
</html>