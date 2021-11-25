package www.dream.com.bulletinBoard.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.IOUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.bulletinBoard.persistence.ReplyMapper;
import www.dream.com.common.attachFile.model.AttachFileVO;
import www.dream.com.common.attachFile.persistence.AttachFileVOMapper;
import www.dream.com.common.dto.Criteria;
import www.dream.com.framework.lengPosAnalyzer.PosAnalyzer;
import www.dream.com.hashTag.service.HashTagService;
import www.dream.com.party.model.Party;

/**
 * 게시글 관련 서비스 제공
 * 
 * @author Fleax_Market
 *
 */
@Service
public class PostService {
   @Autowired
   private ReplyMapper replyMapper;

   @Autowired
   private HashTagService hashTagService;

   @Autowired
   private AttachFileVOMapper attachFileVOMapper;

   /* 게시판 출력시 실행할 함수 */
   public List<PostVO> getListByHashTag(Party curUser, int boardId, int child, Criteria cri) {
      if (cri.hasSearching()) {
         String[] searchingHashtags = cri.getSearchingHashtags();
         if (curUser != null) {
            mngPersonalSearFavorite(curUser, searchingHashtags);
         }
         /* 검색어 검색 시 게시판출력 실행할 함수 */
         return replyMapper.getListByHashTag(boardId, child, cri);
      } else if (cri.getListFromLike() == 1) {
         /* 좋아요 눌렀을시 게시판출력 실행할 함수 */
         return replyMapper.getListFromLike(boardId, child, cri);
      } else {
         /* 기본 게시판출력 실행할 함수 */
         return replyMapper.getList(boardId, child, cri);
      }
   }

   /*게시글에서 현재 페이지를 출력해 주기 위한 함수 */
   public long getSearchTotalCount(int boardId, int child, Criteria cri) {
      if (cri.hasSearching()) {
         return replyMapper.getSearchTotalCount(boardId, child, cri);
      } else {
         return replyMapper.getTotalCount(boardId, child);
      }
   }
   
   /*상품게시판에서 페이지 출력 함수*/
   public long getProductSearchTotalCount(int boardId, int child, Criteria cri) {
      if (cri.hasSearching()) {
         return replyMapper.getSearchTotalCount(boardId, child, cri);
      } else {
         return replyMapper.getProductTotalCount(boardId, child);
      }
   }

   /** id 값으로 Post 객체 조회 */
   public PostVO findPostById(String id, int child) {
      return (PostVO) replyMapper.findReplyById(id, child);
   }

   public List<PostVO> findReplyByBoardId(int boardId, int child) {
      return replyMapper.findReplyByBoardId(boardId, child);
   }

   public List<PostVO> findProductList(Party curUser, int boardId, int child, Criteria cri) {
      if (cri.hasSearching()) {
         String[] searchingHashtags = cri.getSearchingHashtags();
         if (curUser != null) {
            mngPersonalSearFavorite(curUser, searchingHashtags);
         }
         return replyMapper.getProductListByHashTag(boardId, child, cri);
      } else if (cri.getFindSelledProdutList() == 1) {
         /*거래 완료만 출력할 함수*/
         return replyMapper.getfindSelledProdutList(boardId, cri); 
      } else {
         /*거래 중인 상품만 출력할 함수*/
         return replyMapper.findProductList(boardId, child, cri); 
      }
   }

   /*내가 결제한 상품 목록만 조회하기*/
   public List<PostVO> getMyPaymentList(int boardId, String buyerId, Criteria cri) {
      return replyMapper.getMyPaymentList(boardId, buyerId, cri);
   }

   /* 내 상품 현황 목록 조회하기 */
   public List<PostVO> getMyProductUploaded(int boardId, String writerId, Criteria cri) {
      if (cri.getGetMySelledList() == 1) {
         // 내가 판매 완료한 상품 목록 조회
         return replyMapper.getMySelledList(boardId, writerId, cri);
      } else {
         // 내가 판매 중인 상품들 목록 조회
         return replyMapper.getMyProductUploaded(boardId, writerId, cri);
      }

   }

   /** boardId, childBoardId, userId로 내가 장바구니에 담은 상품 조회 */
   public List<PostVO> findProductShoppingCart(String userId) {
      return replyMapper.findProductShoppingCart(userId);
   }

   /**
    * 게시글 수정 처리 첨부 파일 정보
    * 
    * @param post
    * @return
    * @throws IOException
    */
   @Transactional
   public int insert(BoardVO board, int child, PostVO post) throws IOException {
      int affectedRows = replyMapper.insert(board, child, post); // 게시글 자체를 등록
      Map<String, Integer> mapOccur = PosAnalyzer.getHashTags(post); // 06.01에 만든 PosAnalyzer FrameWork
      // 수 많은 단어가 들어왔는데, 기존의 단어와 새롭게 들어올 단어를 분리해야할것 같음
      hashTagService.CreateHashTagAndMapping(post, mapOccur);
      // 최악을 고려해야 고품질의 코드를 만들어낼 수있다.

      // 첨부 파일 정보도 관리를 해야합니다. 고성능
      List<AttachFileVO> listAttach = post.getListAttach();
      if (listAttach != null && !listAttach.isEmpty()) {
         attachFileVOMapper.insertAttachFile2PostId(post.getId(), listAttach);
      }
      return affectedRows;
   }

   public static String getFolderName() {
      SimpleDateFormat simpledf = new SimpleDateFormat("yyyy-MM-dd");
      return simpledf.format(new Date()).replace('-', File.separatorChar); // 문자의 자료형으로 replace
   }
   // 06.04 검색기능을 추가한 화면을 만들기 위해서 새로운 기능 선언

   /** 게시글 수정 처리 */
   // boolean은 if처리를 하기때문에 변경해준것
   @Transactional
   public boolean updatePost(PostVO post) {
      attachFileVOMapper.delete(post.getId());
      // 첨부파일 정보고 관리 합니다.
      List<AttachFileVO> listAttach = post.getListAttach();
      if (listAttach != null && !listAttach.isEmpty()) {
         attachFileVOMapper.insertAttachFile2PostId(post.getId(), listAttach);
      }

      hashTagService.deleteMap(post);
      Map<String, Integer> mapOccur = PosAnalyzer.getHashTags(post);
      hashTagService.CreateHashTagAndMapping(post, mapOccur);

      return replyMapper.updatePost(post) == 1;
   }

   /** id 값으로 Post 객체 삭제 */
   @Transactional
   public boolean deletePostById(String id) { // int -> boolean 변경 Redirect 하기위해서
      PostVO post = new PostVO();
      post.setId(id);
      hashTagService.deleteMap(post);
      attachFileVOMapper.delete(id);
      return replyMapper.deleteReplyById(id) == 1; // == 1 추가
   }

   /* 기존 단어와 신규 단어로 분할, 기존 단어는 활용 횟수 올리기*/
   private void mngPersonalSearFavorite(Party curUser, String[] searchingHashtags) {
      Map<String, Integer> mapOccur = new HashMap<>();

      Arrays.stream(searchingHashtags).forEach(word -> {
         mapOccur.put(word, 1);
      });

      hashTagService.mngHashTagAndMapping(curUser, mapOccur);
      hashTagService.CreateHashTagAndMapping(curUser, mapOccur);

   }

   /*장바구니 등록된것 삭제*/
   public void removeShoppingCart(String userId, String productId) {
      replyMapper.removeShoppingCart(userId, productId);
   }

   /* 게시글 조회수 증가 처리 */
   public int cntPlus(String id) {
      return replyMapper.cntPlus(id);
   }

   /** ddl 좋아요 검사 테이블에 해당하는 값 넣기 */
   public int checkLike(String id, String userId) {
      return replyMapper.checkLike(id, userId);
   }

   /* 좋아요 눌렀는지 검사*/
   public void upcheckLike(String id, String userId) {
      replyMapper.upcheckLike(id, userId);
   }

   /* 좋아요 증가 및 감소 처리 */
   public void uplike(String id) {
      replyMapper.uplike(id);
   }

   /** 좋아요 눌러 놓은것 검사*/
   public void deleteCheckLike(String id, String userId) {
      replyMapper.deleteCheckLike(id, userId);
   }
   
   /** 좋아요 감소 처리 */
   public void downlike(String id) {
      replyMapper.downlike(id);
   }

   /** 게시글 실시간 좋아요 처리 */
   public int getLike(String id, String userId) {
      return replyMapper.getLike(id, userId);
   }

   /* Manager Mode Delete*/
   public void batchDeletePost(ArrayList<String> postIds) {
      replyMapper.batchDeletePost(postIds);
   }

   
}