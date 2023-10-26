<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>uploadTest.jsp</title>
</head>
<body>

	<h3>* 파일 첨부 테스트 *</h3>
	<form method="post" action="uploadTestProc.jsp" enctype="multipart/form-data">
		이름: <input type="text" name="uname"> <br>
		제목: <input type="text" name="subject"> <br>
		내용: <textarea rows="5" cols="20" name="content"></textarea> <br>
		첨부: <input type="file" name="filenm"> <br><!-- type이 file이면 파일선택 버튼 나옴 -->
		<input type="submit" value="전송">	
	</form>
	
	<!-- method="get"은 ?에 원하는 데이터를 문자열 형태로 보내는 것 -->
	<!-- get 방식으로 하면 파일이 안가요 -->
	<!-- 폼에 있는 정보를 서버에 있는게 request로 담긴다 -->
	<!-- 완성 전 영상에서 enctype를 붙이니까 더 null값이 뜬다 -->
	
	
	
</body>
</html>