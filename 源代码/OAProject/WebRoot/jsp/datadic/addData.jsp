<%@page import="pojo.TUser"%>
<%@page import="tools.GetTime"%>
<%@page import="pojo.TDatadic"%>
<%@page import="datadic.dao.TDatadicDAO"%>
<%@page
	import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
	<%-- errorPage="../error.jsp"%> --%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
	+ request.getServerName() + ":" + request.getServerPort()
	+ path + "/";
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>数据类别</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

<!-- <link rel="stylesheet" type="text/css" href="/EEpro/css/left_css.css"> -->
<link rel="stylesheet" type="text/css" href="<%=path%>/css/reg.css">
<script type="text/javascript">
	function add() {

		//var form = document.getElementById("addTypeForm");
		//var form="form"+id;
		//alert(form);
		var typeName = document.getElementById("typeName");
		//var regex = /^a{3,15}$/;
		//alert(count.value);
		if (typeName.value.length > 15 || typeName.value.length < 3) {//alert(count);
			alert("类别名称长度3-15！");
			return false;
		} else {

			return true;

		}
	}
</script>

</head>

<body>
<form action="<%=path%>/jsp/datadic/addData.jsp" name="form" id="form"
		method="post">
		<table width="500px" align="center" style="margin-top: 100px;margin-left: 100px;">
			

	<%
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		TDatadicDAO dao = (TDatadicDAO) context.getBean("TDatadicDAO");
		List<TDatadic> tDatadics = dao.findAll();
		if (request.getParameter("submit") != null) {
			String npid = request.getParameter("nmaxid");
			String sname = request.getParameter("typeName");
			String suser = ((TUser)session.getAttribute("user")).getUsername();
			//String suser = "new";
			Date date = GetTime.time();
			//System.out.println(date);
			/* List<TDatadic> list = dao.findByDpid(npid); */
			if(sname!=null && !sname.equals("") && sname.length()>1 && sname.length()<20){
			List<TDatadic> list = dao.findByDpid(npid); 
			
			boolean eq=true;
			if(list!=null){
				for(TDatadic datadic:list){
					if(sname.equals(datadic.getDname())&&datadic.getDisdel()!=1){
						eq=false;
					}
				}
			}
			if (eq) {
				TDatadic instance = new TDatadic(sname,Integer.valueOf(npid), date, suser, date, 0);
				dao.save(instance);
	%>
		<jsp:forward page="showData.jsp"></jsp:forward>
	<%
			}else{
	%>
	<tr>
		<td>
			<font color="red">该类别中已有此项</font>
		</td>
	</tr>
	<%
			}
		}else{
		%>
		<tr>
			<td>
				<font color="red">名称格式不正确（应输入长度为2-19的名称）</font>
			</td>
		</tr>
	<%
		}
		}
	%>
			<tr>
				<td width="" style="padding-left: 0">请选择大类：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select
					class="index_select" name="nmaxid" id="nmaxid">
						<option value="0">无</option>
						<%
							for (TDatadic datadic : tDatadics) {
								if (datadic.getDpid() == 0 && datadic.getDisdel()==0) {
						%>

						<option value="<%=datadic.getDid()%>"><%=datadic.getDname()%></option>
						<%
							}
						%>
						<%
							}
						%>
				</select> <font style="font-style: italic;font-size: 15px">(若要创建大类请选“无”)</font>
				</td>
			</tr>
			<tr>

				<td>请输入类别名： <input type="text" name="typeName" id="typeName">

				</td>
			</tr>
			<tr>
				<td align="center"><input type="submit" name="submit" value="保存" />
				</td>
			</tr>
		</table>
	</form>

</body>
</html>
