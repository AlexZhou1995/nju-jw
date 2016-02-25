<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Calendar" %>
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
if (session.getAttribute("usertype") == null 
    || (Integer)session.getAttribute("usertype") != 2) {
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
PreparedStatement ins_pstat = null;
ResultSet rs = null;

Calendar cal = Calendar.getInstance();
int month = cal.get(Calendar.MONTH) + 1;
int year = cal.get(Calendar.YEAR);

try {
	conn = DriverManager.getConnection(DBURL, DBUSER, DBPASS);
} catch(SQLException e) {
	%>
	<script type="text/javascript">
	alert("数据连接异常");
	</script>
	e.printStackTrace();
	<% 
}

try {
	Class.forName(DBDRIVER);
	String type = request.getParameter("type");
	String dno = request.getParameter("dno");
	String cno = request.getParameter("cno");
	String tno = request.getParameter("tno");
	String semester = request.getParameter("semester");
	int exExist = 0;
	
	if(type.equals("0")) {
		pstat = conn.prepareStatement("select name from course where cno=?;");
		pstat.setString(1, cno);
		rs = pstat.executeQuery();
		if(!rs.next()) {
			%>
			<script type="text/javascript">
			alert("课程不存在!");
			window.history.go(-1);
			</script>
			<%
			return;
		}
		pstat.close();
		rs.close();
		
		String grade = request.getParameter("grade");
		pstat = conn.prepareStatement("select sno from student where dno=? and grade=?;");
		pstat.setString(1, dno);
		pstat.setString(2, grade);
		rs = pstat.executeQuery();
		
		ArrayList<Integer> stu_no = new ArrayList<Integer>();
		while(rs.next()) {
			stu_no.add(rs.getInt(1));
		}
		
		for(int i = 0; i < stu_no.size(); i ++) {
			try {
				ins_pstat = conn.prepareStatement("insert into sc  (`sno`, `cno`, `type`, `semester`, `tno`) values(?, ?, '必修', ?, ?);");
				ins_pstat.setInt(1, stu_no.get(i));
				ins_pstat.setString(2, cno);
				ins_pstat.setString(3, semester);
				ins_pstat.setString(4, tno);
				ins_pstat.execute();
			} catch(Exception e) {
				e.printStackTrace();
				exExist = 1;
			} finally {
				ins_pstat.close();
			}
		}	
	} else if(type.equals("1")) {
		String grade = request.getParameter("grade");
		String major = request.getParameter("major");
		pstat = conn.prepareStatement("select sno from student where dno=? and grade=? and mno=?;");
		pstat.setString(1, dno);
		pstat.setString(2, grade);
		pstat.setString(3, major);
		rs = pstat.executeQuery();
		
		ArrayList<Integer> stu_no = new ArrayList<Integer>();
		while(rs.next()) {
			stu_no.add(rs.getInt(1));
		}
		
		for(int i = 0; i < stu_no.size(); i ++) {
			try {
				ins_pstat = conn.prepareStatement("insert into sc  (`sno`, `cno`, `type`, `semester`, `tno`) values(?, ?, '必修', ?, ?);");
				ins_pstat.setInt(1, stu_no.get(i));
				ins_pstat.setString(2, cno);
				ins_pstat.setString(3, semester);
				ins_pstat.setString(4, tno);
				ins_pstat.execute();
			} catch(Exception e) {
				e.printStackTrace();
				exExist = 1;
			} finally {
				ins_pstat.close();
			}
		}	
	} else if(type.equals("2")) {
		String sno = request.getParameter("sno");
		try {
			ins_pstat = conn.prepareStatement("insert into sc  (`sno`, `cno`, `type`, `semester`, `tno`) values(?, ?, \'必修\', ?, ?);");
			ins_pstat.setString(1, sno);
			ins_pstat.setString(2, cno);
			ins_pstat.setString(3, semester);
			ins_pstat.setString(4, tno);
			ins_pstat.execute();
		} catch(Exception e) {
			%>
			<script type="text/javascript">
			alert("添加失败");
			window.history.go(-1);
			</script>
			<%
			e.printStackTrace();
			exExist = 1;
		} finally {
			ins_pstat.close();
		}
	}
	%>
	<script type="text/javascript">
	if(<%=exExist%> == "1") alert("存在课程重复!");
	alert("添加成功");
	window.history.go(-1);
	</script>
	<%
} catch (Exception e) {
	e.printStackTrace();
} finally {
	if(pstat != null) pstat.close();
	if(rs != null) rs.close();
	conn.close();
}

%>
</body>
</html>