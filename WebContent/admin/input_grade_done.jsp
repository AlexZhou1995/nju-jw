<%@page import="java.util.Enumeration"%>
<%@page import="njujw.StringMD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@include file="../config.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%request.setCharacterEncoding("utf-8");%>
</head>

<body>

<%
Connection conn = null;
PreparedStatement pstat = null;
ResultSet rs = null;
PreparedStatement pstat2 = null;

String cno = (String)request.getParameter("cno");
String semno = (String)request.getParameter("semno");

try {
	Class.forName(DBDRIVER);
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
}
catch (SQLException e) {
	%>
	<script type="text/javascript">
	alert("数据库连接异常！");
	</script>
	<%
	e.printStackTrace();
}

pstat = conn.prepareStatement("select sno from sc where cno=? and semester=? order by sno;");
pstat.setString(1, cno);
pstat.setString(2, semno);
rs = pstat.executeQuery();
while(rs.next()) {
	pstat2 = conn.prepareStatement("update sc set `score`=? where sno=? and cno=? and semester=?;");
	pstat2.setString(1, request.getParameter(rs.getString(1)));
	pstat2.setString(2, rs.getString(1));
	pstat2.setString(3, cno);
	pstat2.setString(4, semno);
	pstat2.execute();
	pstat2.close();
};
if (rs != null) rs.close();
if (pstat != null) pstat.close();
if (conn != null) conn.close();

%>


<script type="text/javascript">
	alert("成绩输入成功！");
	window.location.href="input_grade.jsp"
</script>

</body>
</html>