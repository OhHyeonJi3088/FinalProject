package com.spring.finalProject.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.finalProject.model.BoardVO_OHJ;
import com.spring.finalProject.model.InterOHJDAO;

//==== #31. Service 선언 ====
//트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단
@Service // 원래 bean에 올려주기 위해서 @Component를 써야하는데 @Service를 쓰기 때문에 자동적으로 bean에 올라간다.
public class OHJService implements InterOHJService {
	
	// === #34. 의존객체 주입하기(DI: Dependency Injection) ===
	@Autowired
	private InterOHJDAO dao; // 다형성 // 원래는 dao가 아니라 boardDAO라고 써줘야하는데 지금은 BoardDAO가 한개밖에 없으므로 @Autowired에 의해 타입만 맞으면 되니까 dswefwf라고 써도 된다.
	// Type 에 따라 Spring 컨테이너가 알아서 bean 으로 등록된 com.spring.model.BoardDAO 의 bean 을  dao 에 주입시켜준다. 
    // 그러므로 dao 는 null 이 아니다.

	
	/////////////////////////////////////////////////////////////////////////////////
	// 기본셋팅 끝이다. 여기서부터 개발 시작이다! //
	/////////////////////////////////////////////////////////////////////////////////
		
	
	// === &55. 글쓰기(파일첨부가 없는 글쓰기) === //
	@Override
	public int boardWrite(BoardVO_OHJ boardvo) {
		int n = dao.boardWrite(boardvo);
		return n;
	}


	// === &59. 페이징 처리를 안한 검색어가 없는 전체 글목록 보여주기 === //
	@Override
	public List<BoardVO_OHJ> boardListNoSearch() {
		List<BoardVO_OHJ> boardList = dao.boardListNoSearch();
		return boardList;
	}


	// === &63. 글1개를 보여주는 페이지 요청 === //
	@Override
	public BoardVO_OHJ getView(Map<String, String> paraMap) {
		BoardVO_OHJ boardvo = dao.getView(paraMap); // 글1개 조회하기
		return boardvo;
	}
	
	
	
	
}
