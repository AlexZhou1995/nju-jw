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
<body>

<%
Connection conn = null;
PreparedStatement pstat = null;

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

// 参数格式："semno 1_s 1_c 2_s 2_c 3_s 3_c ..."
Enumeration<String> enum_para = request.getParameterNames();
if (!enum_para.hasMoreElements()) return;
String semno = request.getParameter(enum_para.nextElement());
while (enum_para.hasMoreElements()) {
	
	String cno_s = enum_para.nextElement();
	String cno_c = enum_para.nextElement();
	String cno = cno_s.split("_")[0];
	if ("".equals(request.getParameter(cno_s))) continue;
	try {
		pstat = conn.prepareStatement("update sc set `review_score`=?, `review_comment`=? where sno=? and cno=? and semester=?;");
		pstat.setString(1, request.getParameter(cno_s));
		pstat.setString(2, request.getParameter(cno_c));
		pstat.setString(3, session.getAttribute("userno").toString());
		pstat.setString(4, cno);
		pstat.setString(5, semno);
		pstat.execute();
		//System.out.println(request.getParameter(cno_s) + " "+ request.getParameter(cno_c) + " "+session.getAttribute("userno").toString() + " " + cno +" "+ semno);
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (pstat != null) pstat.close();
	}
	
}

if (conn != null) conn.close();

%>

<script type="text/javascript">
window.location.href="course_review.jsp";
</script>

</body>
</html>