<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>    
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">

	$(document).ready(function() {
		
		getDepartmentName();
		getPositionName();
		
		// == 검색 버튼 클릭했을 때 검색결과 나타내는 이벤트 == //
		$("#searchEmployee").click(function() {
			searchEMP();
		});

		// == 검색창 엔터를 했을 때 검색결과 나타내는 이벤트 == //
		$("input#searchEmp").keyup(function(event) {
			if(event.keyCode == 13) {
				searchEMP();
			}
		});
		
		// 검색창 초기에 안보이게 설정하기
		$("div#displayList").hide();
		
		// === 직원명 입력 시 자동글 완성하기 === //
		$("input#searchEmp").keyup(function() {
			
			// 검색어의 길이 알아오기
			var wordLength = $(this).val().trim().length;
			
			if(wordLength == 0) {
				// 검색어가 공백이거나 스페이스로 이루어질 경우 검색창 안보이게 하기
				$("div#displayList").hide();
			}
			else {
				$.ajax({
					url:"<%= ctxPath%>/employeeSearch.gw",
					type:"GET",
					data:{"searchEmployee":$("input#searchEmp").val()},
					dataType:"JSON",
					success:function(json) {
						if(json.length > 0) {
							var html = "";
							
							$.each(json, function(index, item) {
								var empName = item.empName;
								
								var index = empName.indexOf($("input#searchEmp").val());
							
								var len = $("input#searchEmp").val().length;
								
								var result = empName.substr(0, index) + "<span style='color:navy; font-weight:bold;'>" + empName.substr(index, len) + "</span>" + empName.substr(index + len);
							
								html += "<span style='cursor:pointer;' class='result'>" + result + "</span><br>";
							});
							
							// 검색창 크기 알아오기
							var input_width = $("input#searchEmp").css("width");
							
							$("div#displayList").css({"width": input_width});
							
							$("div#displayList").html(html);
							$("div#displayList").show();
						}
					},
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                }
				});
			}
			
		});// end of $("input#searchEmp").keyup(function() {}
		
		// === 자동검색 클릭시 해당하는 값을 검색어에 입력하기 === //
		$(document).on("click", ".result", function() {
			var search = $(this).text();
		
			$("input#searchEmp").val(search);
			
			$("div#displayList").hide();
			
		});
		
		
		/////////////////////////////////////////////////////
		
		sessionStorage.setItem("department","전체");
		sessionStorage.setItem("position","전체");
		
		/////////////////////////////////////////////////////
		
		
		$("td").click(function() {
			
			var empId = $(this).parent().find(".employeeid").html();
			
			var url = "<%= ctxPath%>/admin/empListEdit.gw?empId=" + empId;
			
			var pop_width = 700;
		    var pop_height = 1000;
		    var pop_left = Math.ceil( (window.screen.width - pop_width) / 2 ); 		// 정수로 형변환
		    var pop_top  = Math.ceil( (window.screen.height - pop_height) / 2 );	// 정수로 형변환
			
		    window.open(url, "empListEdit", 
		    			"left=" + pop_left + ", top=" + pop_top + ", width=" + pop_width + ", height=" + pop_height);
		}); 		
		
	});// end of $(document).ready(function() {})------------------------------------------

	
	// Function Declaration
	// === 부서목록 가져오기(Ajax) === //
	function getDepartmentName() {
		$.ajax({
			url:"<%= ctxPath%>/getDepartmentName.gw",
			type:"GET",
			dataType:"JSON",
			success:function(json) {
				if(json.length > 0) {
			<%--	var html = "<a class='dropdown-item department' href='<%= ctxPath%>/admin/empList.gw?department=전체'>전체</a>"; --%>
					
					var html = "<a class='dropdown-item department'>전체</a>";
					
					$.each(json, function(index, item) {
						var departmentname = item.depart;
						var departno = item.departno
							
						html += "<a class='dropdown-item department'>"+ departmentname +"</a>";
						
					<%--	html += "<a class='dropdown-item department' href='<%= ctxPath%>/admin/empList.gw?department=" + departmentname + "'>" + departmentname + "</a>";
					--%>
					});
					
					$("div#departmentName").html(html);
					
					$(document).on("click","a.department", function(){
						var department = $(this).text();
						sessionStorage.setItem("department",department);
						var position = sessionStorage.getItem("position");
						
						alert("부서명 : " + department + ", 직급 : " + position);
						// $.ajax
						
						departPositionSearch(department, position);
						
					});
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	}// end of function getDepartmentName() {}
	
	// === 직급 목록 가져오기(Ajax) === //
	function getPositionName() {
		$.ajax({
			url:"<%= ctxPath%>/getPositionName.gw",
			type:"GET",
			dataType:"JSON",
			success:function(json) {
				if(json.length > 0) {
					var html = "<a class='dropdown-item position'>전체</a>";
					
					$.each(json, function(index, item) {
						var positionname = item.position;
					
						html += "<a class='dropdown-item position'>" + positionname + "</a>";
					});
					
					$("div#positionName").html(html);
					
					$(document).on("click","a.position", function(){
						var position = $(this).text();
						sessionStorage.setItem("position",position);
						var department = sessionStorage.getItem("department");
						
						alert("부서명 : " + department + ", 직급 : " + position);
						// $.ajax
						departPositionSearch(department, position);
					});
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
	}// end of function getPositionName() {}
	
	
	// === 검색창에 직원명 검색하기 === //
	function searchEMP() {
		var searchemp = $("input#searchEmp").val();
		
		var department = $("a.department").val();
		
		var position = $("a.position").val();
		
		<%-- location.href = "<%= ctxPath%>/admin/empList.gw?searchEmp=" + searchemp; --%>
	}
	
	function departPositionSearch(department, position) {
	//	console.log(department);
	//	console.log(position);
	
		$.ajax({
			url:"<%= ctxPath%>/admin/empList.gw",
			type:"GET",
			data:{"department":department,
				  "position":position},
			dataType:"JSON",
			success:function(json) {
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
		
	
	}
	
</script>

<style type="text/css">
	
	div#empList {
		margin: 50px auto;
		width: 90%;
	}
	
	div.input-group {
	    width:100%;
	    text-align:center;
	    float: left;
  		display: inline-block;
	}
	
	div.search-bar {
		float: left;
  		position: relative;
  		display: inline-block;
	}
	
	div#searchButton {
		float: left;
  		position: relative;
  		display: inline-block;
	}
	
	div#empButton {
		float: right;
  		position: relative;
  		display: inline-block;
	}
	
	tr.empTr:hover {
		cursor: pointer;
		background-color: #e6e6e6;
	}
	
</style>

	<div class="container-fluid" id="empList">
	  <div class="row mb-2 ml-2">
	  	<span class="h3 font-weight-bold">직원 목록</span>
	  </div>
	  <div class="row mt-1 input-group mb-3">
	  	<div id="empButton" class="col-12 col-lg-4 mt-3 mr-2">
		  <button class="btn btn-outline-secondary float-right">관리자등록</button>
	  	</div>
	  	<div class="col-10 col-lg-4 search-bar mt-3 ml-2">
	      	<input id="searchEmp" type="text" class="form-control rounded-pill float-left" placeholder="직원 검색">
	  	</div>
	  	<div id="searchButton" class="mt-3">
		  	<i id="searchEmployee" class="fas fa-search fa-lg mt-2 pt-1" style="cursor: pointer;"></i>
	  	</div>
	  </div>
	  <div id="displayList" style="position:absolute; z-index:2; background-color: white;  border: solid 1px #bfbfbf; width: 336px; height: 150px; margin-left: 8px; margin-top: 58px; border-top:0px; padding-left: 9px; border-radius: 10px;"></div>
	  <div class="table-responsive" style="z-index: 1;">
		  <table class="table col-12" style="width: 95%;">
		    <thead class="thead-light">
		      <tr>
		        <th style="width: 10%;">이름</th>
		        <th style="width: 15%;">사번</th>
		        <th style="width: 10%;">
					<span class="dropdown-toggle" data-toggle="dropdown" style="cursor: pointer;">
					      부서
					</span>
					<div class="dropdown-menu" id="departmentName">
					</div>
				</th>
		        <th style="width: 10%;">
		        	<span class="dropdown-toggle" data-toggle="dropdown" style="cursor: pointer;">
					      직급
					</span>
					<div class="dropdown-menu" id="positionName">
					</div>
				</th>
		        <th>이메일</th>
		        <th>연락처</th>
		      </tr>
		    </thead>
		    <tbody>
		    <c:if test="${not empty requestScope.empList}">
		    	<c:forEach var="map" items="${requestScope.empList}">
		    		<tr class="empTr">
				        <td class="name">${map.name}</td>
				        <td class="employeeid">${map.employeeid}</td>
				        <td class="departmentname">${map.departmentname}</td>
				        <td class="positionname">${map.positionname}</td>
				        <td class="email">${map.email}</td>
				        <td class="mobile"><span>${map.mobile.substring(0, 3)}-${map.mobile.substring(3, 7)}-${map.mobile.substring(7)}</span></td>
				    </tr>
		    	</c:forEach>
		    </c:if>
		    </tbody>
		  </table>
	  </div>
	  
	  
	  <%-- === #122. 페이지바 보여주기 --%>
	  <div align="center" style="width: 70%; border: solid 0px gray; margin: 20px auto;">
	  	  ${requestScope.pageBar}
	  </div>
	  
	</div>
