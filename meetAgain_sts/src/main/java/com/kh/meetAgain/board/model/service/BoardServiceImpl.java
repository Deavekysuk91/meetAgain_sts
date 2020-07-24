package com.kh.meetAgain.board.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.meetAgain.board.model.dao.BoardDAO;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO boardDAO;

	@Override
	public List<Map<String, String>> selectBoardList(int cPage, int numPerPage) {
		return boardDAO.selectBoardList(cPage, numPerPage);
	}

	@Override
	public int selectBoardTotalContents() {
		return boardDAO.selectBoardTotalContents();
	}

}