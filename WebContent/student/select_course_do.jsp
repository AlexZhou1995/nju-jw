<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@include file="/config.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<title>南京大学教务系统</title>
	<script type="text/javascript">
	
	
	</script>
</head>
<body>
<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
} catch (Exception e) {
	e.printStackTrace();
	%>
	<script>
	alert("数据库连接异常!");
	location.href="select_course.jsp?dno=" + <%=request.getParameter("dno") %>;
	</script>
	<%
}
int sno = (Integer)session.getAttribute("userno");
String cno = request.getParameter("cno");
String add = request.getParameter("add");
String dno = request.getParameter("dno");
String tno = request.getParameter("tno");
if(cno == null || add == null) {
	%>
	<script>
	alert("请重新提交表单");
	location.href="select_course.jsp";
	</script>
	<%
	return;
}

Calendar cal = Calendar.getInstance();
int month = cal.get(Calendar.MONTH) + 1;
int year = cal.get(Calendar.YEAR);
String semester = null;
if(month>=9)
	semester = year+"A";
else if (month <= 3)
	semester = year-1+"A";
else
	semester = year+"B";
if(add.equals("1")) {
	try {
		pstat = conn.prepareStatement("insert into `sc` (sno, cno, type, semester, tno) values(?, ?, \'选修\', ?, ?)");
		pstat.setInt(1, sno);
		pstat.setString(2, cno);
		pstat.setString(3, semester);
		pstat.setString(4, tno);
		pstat.execute();
		%>
		<script>
		alert("选课成功!");
		location.href="select_course.jsp?dno=<%=dno%>";
		</script>
		<%
	} catch(Exception e) {
		e.printStackTrace();
		%>
		<script>
		alert("选课失败!");
		location.href="select_course.jsp?dno=<%=dno%>";
		</script>
		<%
	} finally {
		pstat.close();
	}

} else {
	try {
		pstat = conn.prepareStatement("delete from `sc` where sno=? and cno=? and semester=? and tno=?;");
		pstat.setInt(1, sno);
		pstat.setString(2, cno);
		pstat.setString(3, semester);
		pstat.setString(4, tno);
		pstat.execute();
		%>
		<script>
		alert("退选成功!");
		location.href="select_course.jsp?dno=<%=dno%>";
		</script>
		<%
	} catch(Exception e) {
		e.printStackTrace();
		%>
		<script>
		alert("退选失败!");
		location.href="select_course.jsp?dno=<%=dno%>";
		</script>
		<%
	} finally {
		pstat.close();
	}
}

if(conn != null) conn.close();
%>
</body>
</html>