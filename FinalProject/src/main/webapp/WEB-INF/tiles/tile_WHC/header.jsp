<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- ======= #27. tile1 중 header 페이지 만들기 (#26.번은 없다 샘이 장난침.) ======= --%>
<%
   String ctxPath = request.getContextPath();

   // === #172. (웹채팅관련3) === 
   // === 서버 IP 주소 알아오기(사용중인 IP주소가 유동IP 이라면 IP주소를 알아와야 한다.) ===
   InetAddress inet = InetAddress.getLocalHost(); 
   String serverIP = inet.getHostAddress();
   
 // System.out.println("serverIP : " + serverIP);
 // serverIP : 211.238.142.72
   
   // String serverIP = "211.238.142.72"; 만약에 사용중인 IP주소가 고정IP 이라면 IP주소를 직접입력해주면 된다.
   
   // === 서버 포트번호 알아오기   ===
   int portnumber = request.getServerPort();
 // System.out.println("portnumber : " + portnumber);
 // portnumber : 9090
   
   String serverName = "http://"+serverIP+":"+portnumber; 
 // System.out.println("serverName : " + serverName);
 // serverName : http://211.238.142.72:9090 
%>
	
<style type="text/css">
	
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		
		
	});

</script>

</head>
<body>
	<div class="container-fluid" style="max-width:1600px">
		<nav class="navbar navbar-expand-lg navbar-light pt-2" style="background-color: white;">
			<!-- Brand/logo --> <!-- Font Awesome 5 Icons -->
			<a class="navbar-brand" href="<%= ctxPath %>/index.up" style="margin-right: 10%; font-size:20pt; font-weight: bold;">그룹웨어</a>
			
			<!-- 아코디언 같은 Navigation Bar 만들기 -->
		    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
		      <span class="navbar-toggler-icon"></span>
		    </button>
			
			<div class="collapse navbar-collapse" id="collapsibleNavbar">
			  <ul class="navbar-nav mx-auto" style="font-size:14pt;">
			     <li class="nav-item active mx-2" style="text-align: center;">
			        <a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="fas fa-home fa-lg"></i><br>홈</a>
			     </li>
			     <li class="nav-item active mx-2" style="text-align: center;">
			     	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="fas fa-stopwatch fa-lg"></i><br>근태관리</a>
			     </li>
			     <li class="nav-item active mx-2" style="text-align: center;">
			     	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="far fa-file-alt fa-lg"></i><br>전자결재</a>
			     </li>
			     <li class="nav-item active mx-2" style="text-align: center;">
			     	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="fas fa-chalkboard fa-lg"></i><br>게시판</a>
			     </li>
			     <li class="nav-item active mx-2" style="text-align: center;">
			     	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="fas fa-user-friends fa-lg"></i><br>조직도</a>
			     </li>
			     <li class="nav-item active mx-2" style="text-align: center;">          
	             	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="far fa-calendar-alt fa-lg"></i><br>일정</a>
	          	 </li>
			     <li class="nav-item active mx-2" style="text-align: center;">          
	             	<a class="nav-link menufont_size" style="color:gray;" href="<%= ctxPath %>"><i class="far fa-envelope fa-lg"></i><br>메일/메신저</a>
	          	 </li>
			     <c:if test="${sessionScope.loginuser != null and sessionScope.loginuser.userid == 'admin' }"> <%-- admin 으로 로그인 했으면 --%>
					 <li class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle menufont_size text-info" href="#" id="navbarDropdown" data-toggle="dropdown"> 
				          	 관리자전용   	                           
				        </a>
				        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
				           <a class="dropdown-item text-info" href="<%= ctxPath %>">사원등록</a>
				           <a class="dropdown-item text-info" href="<%= ctxPath %>">사원관리</a>
				           <div class="dropdown-divider"></div>
				           <a class="dropdown-item text-info" href="<%= ctxPath %>">추가기능있으면 넣기</a>
				        </div>
				     </li>
		     	</c:if>
			  </ul>
			  <ul class="navbar-nav list-group-horizontal mt-sm-0 mt-2 ml-auto nav_text">
		    	<li class="nav-item ml-2" ><a class="nav-link fas fa-search fa-lg" style="color:gray" href="<%= ctxPath%>"></a></li>
		    	<li class="nav-item ml-2" ><a class="nav-link far fa-bell fa-lg" style="color:gray" href="<%= ctxPath%>"></a></li>
		    	<li class="nav-item ml-2" ><a class="nav-link far fa-user fa-lg" style="color:gray" href="<%= ctxPath%>"></a></li>
	   		  </ul>	  
			</div>
		</nav>
	</div>
	<hr style="margin:0">