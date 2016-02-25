<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
  <!-- 侧边栏 -->
  <div class="col-sm-3 col-md-2 sidebar">
    <p>欢迎您，<%=session.getAttribute("username") %>！</p>
    <p>当前身份：管理员 </p>
    <ul class="nav nav-sidebar" id="sidebar">
      <li><a href="welcome.jsp">欢迎页</a></li>
      <li><a href="list_course.jsp">查看课程</a></li>
      <li><a href="add_course.jsp">新建课程</a></li>
      <li><a href="del_course.jsp">删除课程</a></li>
      <li><a href="list_teacher.jsp">查看教师信息</a></li>
      <li><a href="add_teacher.jsp">添加教师账号</a></li>
      <li><a href="del_teacher.jsp">删除教师账号</a></li>
      <li><a href="list_student.jsp">查看学生信息</a></li>
      <li><a href="add_student.jsp">添加学生账号</a></li>
      <li><a href="del_student.jsp">删除学生账号</a></li>
      <li><a href="control_select_course.jsp">选课系统</a>
      <li><a href="control_course_review.jsp">课程评估系统</a>
      <li><a href="publishment.jsp">管理公告</a></li>
      <li><a href="reset_password.jsp">重置密码</a></li>
      <li><a href="change_password.jsp">修改密码</a></li>
    </ul>
  </div>
  
  <!-- 设置当前页面高亮 -->
  <script type="text/javascript">
  
	var strHref = window.location.href;
	var pageName = strHref.slice(strHref.lastIndexOf("/")+1);
	
	var sidebar = document.getElementById("sidebar");
	var lis = sidebar.getElementsByTagName("li");
	for (var i=0; i<lis.length; i++) {
		var href = lis[i].firstChild.getAttribute("href");
		if (href == pageName) {
			lis[i].setAttribute("class", "active");
			break;
		}
	}
  </script>
</body>
</html>