<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="ssi.jsp" %>
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>memberProc.jsp</title>
</head>
<body>
	
<%
	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");
	String mname = request.getParameter("mname");
	String email = request.getParameter("email");
	String tel = request.getParameter("tel");
	String zipcode = request.getParameter("zipcode");
	String address1 = request.getParameter("address1");
	String address2 = request.getParameter("address2");
	String job = request.getParameter("job");
	
	dto.setId(id);
	dto.setPasswd(passwd);
	dto.setMname(mname);
	dto.setEmail(email);
	dto.setTel(tel);
	dto.setZipcode(zipcode);
	dto.setAddress1(address1);
	dto.setAddress2(address2);
	dto.setJob(job);
	
	int cnt=dao.create(dto);
	
	if(cnt==0){
		out.println("<p>글추가 실패했습니다</p>");
		out.println("<p><a href='javascript:history.back()'>[다시시도]</a></p>");
	}else{
		out.println("<script>");
		out.println("	alert('회원가입이 완료되었습니다.');");
		out.println("	location.href='loginForm.jsp';");//목록페이지 이동		
		out.println("</script>");
	
	}//if end
%>
</body>
</html>