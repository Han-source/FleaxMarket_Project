package www.dream.com.bulletinBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.persistence.BoardMapper;

/**
 * 게시판 관련 서비스 제공
 * 
 * @author Fleax_Market
 *
 */

@Service
public class BoardService {
   @Autowired
   private BoardMapper boardMapper;

   public List<BoardVO> getList() {
      return boardMapper.getList();
   }
   
   /* 보드의 종류를 가져오는것 */
   public BoardVO getBoard(int id) {
      return boardMapper.getBoard(id);
   }
   
   /* 중고거래 게시판의 하위게시판의 종류를 가져오는것 */
   public List<BoardVO> getChildBoardList(int id) {
      return boardMapper.getChildBoardList(id);
   }
   /* 중고거래 게시판의 하위게시판의 종류를 가져오는것 (더 상세한 정보)*/
   public BoardVO getChildBoard(int id, int parentId) {
      if (boardMapper.getChildBoard(id, parentId) == null) {
         return boardMapper.getChildBoard(id, 5);
      }
      return boardMapper.getChildBoard(id, parentId);
   }
}