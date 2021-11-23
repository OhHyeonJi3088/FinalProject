<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<style>
	
	.linkStyle{ /* 링크의 디자인처리 */
		color: #37f; 
		font-weight: bold;
	} 
	
	#aStyle{ /* 삭제링크에 마우스올리면 커서 모양 변경 */
		cursor: pointer;
	}
	
	.tdStyle{ /* 이전글제목,다음글제목에 효과 주기 */
		cursor: pointer;
		color: blue;
		font-size: 1.1rem; /* 기본 폰트에 1.1배 */
	}
	
	.brStyle{border-right: solid 1px #dee2e6;} /* 댓글 테이블에서 부트스트랩으로 table-bordered하면 border가 0이 안됨. 따라서 내가 원하는 디자인처리하려고 class="table"에다가 border-right 디자인처리해줌. */
	
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		// 이전글제목에 효과주기
		$(".previous").hover(
			function(){ // mouserover
				$("td#previous1").css({"cursor":"pointer"}); // i태그인 화살표에 css주기
				$("span#previous2").addClass("tdStyle");
			},
			function(){ // mouseout
				$("span#previous2").removeClass("tdStyle");
			}
		);
		
		// 다음글제목에 효과주기
		$(".next").hover(
			function(){ // mouserover
				$("td#next1").css({"cursor":"pointer"}); // i태그인 화살표에 css주기
				$("span#next2").addClass("tdStyle");
			},
			function(){ // mouseout
				$("span#next2").removeClass("tdStyle");
			}
		);
		
	});// end of $(document).ready(function(){})----------------------------
	
	// Functional Declaration
	
	// 정말로 삭제할것인지 아닌지 물어봄. (=== &77. 나는 강사님과 달리 암호확인페이지 없으니 &77 진행안함. ===)
	function delConfirm(){

		var bool = confirm("정말로 글을 삭제하시겠습니까?");
	//	console.log("확인용 bool => " + bool);
		
		if(bool){
			location.href = "<%= ctxPath%>/boardDel.gw?boardSeq=${requestScope.boardvo.boardSeq}";
		}
		// 확인을 누르면 삭제하고, 취소를 누르면 그냥 냅둠.
	}
	
	// 이전글로 이동
	function goPrevious(){
		location.href = "boardView.gw?boardSeq=${requestScope.boardvo.previousBoardSeq}";
	}
	// 다음글로 이동
	function goNext(){
		location.href = "boardView.gw?boardSeq=${requestScope.boardvo.nextBoardSeq}";
	}
	
	
	// 댓글쓰기
	function goCommentWrite(){
		
		var commentContentVal = $("input#commentContent").val().trim();
		if(commentContentVal == ""){
			alert("댓글 내용을 입력하세요!!");
			return; // 종료
		}
		
		// 첨부파일이 없는 댓글쓰기
		goCommentWrite_noAttach();
		
	}
	
	// 첨부파일이 없는 댓글쓰기
	function goCommentWrite_noAttach(){
		
		$.ajax({
			url:"<%= ctxPath%>/boardCommentWrite.gw",
			data:{"fk_boardSeq":"${requestScope.boardvo.boardSeq}",
				  "fk_employeeId":"${sessionScope.loginuser.employeeid}",
				  "content":$("input#commentContent").val()},
			type:"POST",
			dataType:"JSON",
			success:function(json){ // {"n":1} 또는 {"n":0}
				
				var n = json.n;
				
				if(n==0){
					alert("댓글쓰기 실패하였습니다.");
				}
				else{
					alert("댓글이 등록되었습니다.");
				//	goReadComment(); // 페이징처리 안한 댓글 읽어오기
				}
				
				$("input#commentContent").val("");
				
			},
			error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
		});
		
	}
	
</script>

<div class="container">


	<!-- 글1개에 대한 정보 보여주기 시작 -->
	
	<!-- 원글이 존재하지 않을 경우 -->
	<c:if test="${empty requestScope.boardvo}"> <!-- get방식이라서 유저가 존재하지 않는 글번호, 숫자타입이 아닌 글번호로 장난칠 수 있다. -->
		<div style="padding: 50px 0; font-size: 16pt; color: red; text-align: center;">장난치지마세요! 해당하는 글은 존재하지 않습니다.</div>
	</c:if>
	
	<!-- 원글이 존재하는 경우 -->
	<c:if test="${not empty requestScope.boardvo}"> 
		
		
		<div class="mb-3 d-flex" style="border: solid 0px red;">
			<!-- 링크 (답글, 수정, 삭제, 게시글종류 이동) -->
			<span class="mr-auto d-flex"> <!-- 바깥에 d-flex를 주고, 내부에 오른쪽margin을 auto로 주면 [*     **] 이런식으로 배치된다. -->
				<a href="#" class="linkStyle mr-2 my-auto">답글</a> <!-- 세로중 가운데에 정렬하기 위해서 바깥에 d-flex를 주고 내부에 y축으로 auto를 줌. -->
				<a href="<%= ctxPath%>/boardEdit.gw?boardSeq=${requestScope.boardvo.boardSeq}" class="linkStyle mr-2 my-auto">수정</a>
				<a id="aStyle" onclick="delConfirm()" class="linkStyle mr-2 my-auto">삭제</a>
				<a href="#" class="linkStyle my-auto">이동</a>
			</span>
			
			<span>
				<button type="button" class="btn" style="border: solid 1px #dee2e6;">전체목록</button>
				<button type="button" class="btn btn-secondary">검색된목록</button>
			</span>
		</div>
		
		<!-- 원글정보 테이블 -->
		<table class="table">
			<tr>
				<th rowspan="2" width="10%" style="padding: 0; text-align: center;">
					<img alt="기본프로필_kh.jpg" src="<%= ctxPath%>/resources/images/기본프로필_kh.jpg" width="90" height="100">
				</th>
				<td colspan="4"><strong style="font-size: 18px;">${requestScope.boardvo.subject}</strong></td>
			</tr>
			<tr style="border-bottom: solid 1px #dee2e6;">
				<td>작성자 : ${requestScope.boardvo.positionName} ${requestScope.boardvo.name}</td>
				<td>글종류 : ${requestScope.boardvo.bCategoryName}</td>
				<td>조회수 : <span>${requestScope.boardvo.readCount}</span></td>
				<td>작성일자 : ${requestScope.boardvo.regDate}</td>
			</tr>
		</table>
		<!-- 글내용 -->
		<div class="p-3" style="border: solid 1px #dee2e6; word-break: break-all; min-height: 300px;">${requestScope.boardvo.content}</div>
		<%-- 
		      style="word-break: break-all; 은 공백없는 긴영문일 경우 width 크기를 뚫고 나오는 것을 막는 것임. 
		             그런데 style="word-break: break-all; 나 style="word-wrap: break-word; 은
		             테이블태그의 <td>태그에는 안되고 <p> 나 <div> 태그안에서 적용되어지므로 <td>태그에서 적용하려면
		      <table>태그속에 style="word-wrap: break-word; table-layout: fixed;" 을 주면 된다.
		--%>
		
	</c:if>
	<!-- 글1개에 대한 정보 보여주기 종료 -->
	
	
	<!-- 이전글, 다음글 보기 -->
	<table class="mt-3">
		<c:if test="${not empty requestScope.boardvo.previousBoardSeq}">
			<tr>
				<th style="font-size: 1.2rem;">이전글</th>
				<td>&nbsp;</td> <!-- 여백을 주기위해 td태그 추가함 -->
				<td class="previous" id="previous1" onclick="goPrevious();"><i class="fas fa-arrow-circle-up fa-2x"></i></td>
				<td>&nbsp;</td>
				<td><span class="previous" id="previous2" onclick="goPrevious();">${requestScope.boardvo.previousSubject}</span></td>
			</tr>
		</c:if>
		<c:if test="${not empty requestScope.boardvo.nextBoardSeq}">
			<tr>
				<th style="font-size: 1.2rem;">다음글</th>
				<td>&nbsp;</td>
				<td class="next" id="next1" onclick="goNext();"><i class="fas fa-arrow-circle-down fa-2x"></i></td>
				<td>&nbsp;</td>
				<td><span class="next" id="next2" onclick="goNext();">${requestScope.boardvo.nextSubject}</span></td>
			</tr>
		</c:if>
	</table>
	
	
	
	<%-- &83. 댓글쓰기 폼 추가 --%>
	<!--
	카테고리번호가 ${requestScope.boardvo.fk_bCategorySeq}인데, <br>1이면 공지사항, 2이면 자유게시판, 3이면 건의사항임.
	공지사항은 댓글X
	건의사항은 댓글O 
	-->
	<c:if test="${requestScope.boardvo.fk_bCategorySeq eq 3}"> <%-- ${not empty sessionScope.loginuser} 를 추가안해도 글1개보기를 로그인한 사람만 볼 수 있도록 함. --%>
		<!-- 댓글쓰기 시작 -->
		<div class="mt-5" style="border-bottom: solid 1px #dee2e6; display: flex;"> <!-- span태그를 위아래로 꽉 채우기위한 flex -->
			<strong style="border-bottom: solid 2px #37f;">댓글쓰기</strong>
		</div>
		
		<div class="mt-3">
			<form name="commentWriteFrm">
				<input type="text" id="commentContent" style="width: 100%" placeholder="로그인 후 이용하실 수 있습니다."/>
				<input type="text" style="display: none;"> <!-- form태그 속의 input태그가 한 개일 경우, 엔터치면 값이 전송되는것을 방지함.  ★hidden타입은 안된다. -->
			
				<button type="button" class="btn btn-sm mt-1" style="border: solid 1px #dee2e6; color: #37f; float: right;" onclick="goCommentWrite()">등록</button>
				<button type="reset" class="btn btn-sm mt-1 mr-1" style="border: solid 1px #dee2e6; color: #37f; float: right;">취소</button>
			</form>
		</div>
		<!-- 댓글쓰기 끝 -->
		
	<%-- 
		<!-- 댓글내용 보여주기 시작 -->
		<div class="mt-5" style="border-bottom: solid 1px #dee2e6; display: flex;"> <!-- span태그를 위아래로 꽉 채우기위한 flex -->
			<strong style="border-bottom: solid 2px #37f;">댓글내용</strong>
		</div>
		
		<!-- 댓글이 존재하지 않을 경우 -->
		<div class="table-responsive mt-3">
			<table class="table table-hover">
				<tr style="text-align: center; background-color: #F7F7F7;"> <!-- 글자 가운데정렬 -->
					<th class="brStyle" width="6%">번호</th>
					<th class="brStyle">댓글내용</th>
					<th class="brStyle" width="8%">작성자</th>
					<th width="17%">작성일자</th>
				</tr>
				<tr style="border-bottom: solid 1px #dee2e6;">
					<td colspan="4">
						<div class="my-5" align="center">
							<i class="fas fa-info-circle" style="color: #37f;"></i><br>
							조회 결과, 댓글이 존재하지 않습니다.
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- 댓글이 존재하는 경우 -->
		<div class="table-responsive mt-3">
			<table class="table table-hover">
				<tr style="text-align: center; background-color: #F7F7F7;"> <!-- 글자 가운데정렬 -->
					<th class="brStyle" width="6%">번호</th>
					<th class="brStyle">댓글내용</th>
					<th class="brStyle" width="8%">작성자</th>
					<th width="17%">작성일자</th>
				</tr>
				<tr style="border-bottom: solid 1px #dee2e6;">
					<td class="brStyle" align="center">1</td>
					<td class="brStyle">네~~~알겠습니다~~~!</td>
					<td class="brStyle" align="center">서강준</td>
					<td align="center">2021-11-10 14:00:01</td>
				</tr>
			</table>
		</div>
		<!-- 댓글내용 보여주기 종료 -->
		
	--%>		
	</c:if>

	
<%--  
<!-- 가비아 그룹웨어나 네이버 같은 댓글을 하고싶을때 디자인처리 -->
	<!-- 댓글쓰기 및 댓글보여주기 시작 -->
	<div class="mt-5" style="border-bottom: solid 1px #dee2e6; display: flex;"> <!-- span태그를 위아래로 꽉 채우기위한 flex -->
		<strong style="border-bottom: solid 2px #37f;">댓글</strong>
	</div>
	
	<div style="background-color: #f4f5f7">
	
		<span>2개의 댓글</span>
		
		<div class="container">
			<div style="border: solid 1px red;">
				<img alt="기본프로필.jpg" src="<%= request.getContextPath()%>/resources/images/기본프로필.JPG" width="45" height="50">
				<span>서강준</span>
				<span>2021-11-10 14:00:01</span>
				<span>네~~~알겠습니다~~~!</span>
			</div>
		</div>
		
	</div> 
	<!-- 댓글쓰기 및 댓글보여주기 끝 -->
--%>	
	
	
</div>