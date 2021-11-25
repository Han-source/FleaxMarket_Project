package www.dream.com.bulletinBoard.persistence;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.bulletinBoard.model.ReplyVO;
import www.dream.com.common.dto.Criteria;
import www.dream.com.party.model.Party;
/**
 * 게시글 및 댓글 관련 Mapper(Interface)
 * 
 * @author Fleax_Market
 *
 */
public interface ReplyMapper { 
   /** --------------------------- 자유 게시글 처리 함수 정의 영역------------------------- */
   /* 자유게시판 글 목록 */
   public List<PostVO> getList(@Param("boardId") int boardId, @Param("child") int child, @Param("cri") Criteria cri); 
   
   /* id 값으로 게시글 및 댓글 조회*/
   public PostVO findReplyById(@Param("id") String id, @Param("child") int child); // 조회
   
   /* boardId 값으로 Post및 Reply, Reply of Reply 객체 조회*/
   public List<PostVO> findReplyByBoardId(@Param("boardId") int boardId, @Param("child") int child); // 조회

   /* 좋아요 순에 따른 개념글 만들기*/
   public List<PostVO> getListFromLike(@Param("boardId") int boardId, @Param("child") int child,
         @Param("cri") Criteria cri);

   /* 조회수 증가 처리*/
   public int cntPlus(String id);

   /* 자유게시판 페이징 처리*/
   public long getTotalCount(@Param("boardId") int boardId, @Param("child") int child);

   /** --------------------------- 거래 게시글 처리 함수 정의 영역------------------------- */
   /* id 값으로 구매하려고 하는 상품 조회*/
   public PostVO findProductPurchaseRepresentById(@Param("productId") String id, @Param("child") int child);

   /* 상품 조회*/
   public List<PostVO> findProductList(@Param("boardId") int boardId, @Param("child") int child,
         @Param("cri") Criteria cri); // 조회
   
   /* id 값으로 상품 조회*/
   public PostVO findProductById(@Param("productId") String id, @Param("child") int child);

   /* boardId, childBoardId, userId로 내가 장바구니에 담은 상품 조회*/
   public List<PostVO> findProductShoppingCart(@Param("userId") String userId);

   /* 상품 게시판에서 검색하는 것*/
   public List<PostVO> getProductListByHashTag(@Param("boardId") int boardId, @Param("child") int child,
         @Param("cri") Criteria cri);

   /* 내가 판매 완료한 상품 게시글 조회하기.*/
   public List<PostVO> getMySelledList(@Param("boardId") int boardId, @Param("writerId") String writerId, @Param("cri") Criteria cri);

   /* 거래완료된 상품 조회*/
   public List<PostVO> getfindSelledProdutList(@Param("boardId") int boardId, @Param("cri") Criteria cri);

   /* 상품 페이지 처리*/
   public long getProductTotalCount(@Param("boardId") int boardId, @Param("child") int child);

   /* 내가 결제한 상품 목록만 조회하기.*/
   public List<PostVO> getMyPaymentList(@Param("boardId") int boardId, @Param("buyerId") String buyerId,
         @Param("cri") Criteria cri);

   /* 내가 등록한 상품 목록 조회하기.*/
   public List<PostVO> getMyProductUploaded(@Param("boardId") int boardId, @Param("writerId") String writerId,
         @Param("cri") Criteria cri);
   
   /* 장바구니 등록된것 삭제*/
   public void removeShoppingCart(@Param("userId") String userId, @Param("productId") String productId);
   
   /** --------------------------- 검색 처리 관련 함수 정의 영역-------------------------- */
   /* 초기 화면 띄울때 활용*/
   public List<PostVO> getListByHashTag(@Param("boardId") int boardId, @Param("child") int child,
         @Param("cri") Criteria cri);

   /** --------------------------- 좋아요 처리 관련 함수 정의 영역------------------------- */
   /* db에 insert하여 형식 저장*/
   public void upcheckLike(@Param("id") String id, @Param("userId") String userId);

   /* 게시글의 좋아요 겟수*/
   public int getLike(@Param("id") String id, @Param("userId") String userId);

   /* ddl 좋아요 검사 테이블에 해당하는 값 넣기*/
   public int checkLike(@Param("id") String id, @Param("userId") String userId);

   /* 좋아요 증가 처리*/
   public void uplike(String id);

   /* 좋아요 감소 처리*/
   public void downlike(@Param("id") String id);

   /* 좋아요 감소시 db에 기록 삭제*/
   public int deleteCheckLike(@Param("id") String id, @Param("userId") String userId);

   /**
    * --------------------------- 댓글 처리 함수 정의 영역 -------------------------------
    */
   /* 댓글 수 처리하기*/
   public int getAllReplyCount(@Param("replyId") String replyId, @Param("idLength") int idLength);

   /* Id값으로 댓글 조회*/
   public int insertReply(@Param("originalId") String originalId, @Param("reply") ReplyVO reply); // js에서 original이였음
   /* 특정 댓글의 모든 후손 대댓글을 작성 순서에 따라 조회 해줍니다.*/

   public List<ReplyVO> getReplyListOfReply(@Param("originalId") String originalId, @Param("idLength") int idLength);

   /* 댓글 수정 처리*/
   public int updateReply(ReplyVO reply);

   /* 댓글 수 파악해서 페이징처리를 위한 단계*/
   public int getReplyCount(@Param("originalId") String originalId, @Param("idLength") int idLength);

   /* 댓글 페이징처리*/
   public List<ReplyVO> getReplyListWithPaging(@Param("originalId") String originalId, @Param("idLength") int idLength,
         @Param("cri") Criteria cri);

   /**
    * --------------------------------- 공통 처리-------------------------------------
    */
   /* 검색한 게시글 페이징처리(거래 게시글 포함)*/
   public long getSearchTotalCount(@Param("boardId") int boardId, @Param("child") int child,
         @Param("cri") Criteria cri);

   /* 게시글 등록시 db에 들어가는 형식*/
   public int insert(@Param("board") BoardVO board, @Param("child") int child, @Param("post") PostVO post);

   /* 게시글 수정 처리 (거래 게시글에서도 수정처리 해야함 만들 것.)*/
   public int updatePost(PostVO post);

   /* id 값으로 Post 객체 삭제*/
   public int deleteReplyById(String id);

   /* Manager Mode 일괄 삭제*/
   public void batchDeletePost(@Param("postIds") ArrayList<String> postIds);

   public List<PostVO> adminManage(@Param("userId") String userId);

   /* 관리자 거래 확인 함수*/
   public List<PostVO> findPurchasePermission();
}