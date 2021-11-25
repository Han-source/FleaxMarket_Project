package www.dream.com.bulletinBoard.model;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import lombok.Data;
import lombok.NoArgsConstructor;
import www.dream.com.business.model.ProductVO;
import www.dream.com.business.model.TradeVO;
import www.dream.com.common.attachFile.model.AttachFileVO;
import www.dream.com.framework.lengPosAnalyzer.HashTarget;
import www.dream.com.framework.printer.ClassPrintTarget;
import www.dream.com.framework.printer.PrintTarget;
import www.dream.com.framework.util.ToStringSuperHelp;
import www.dream.com.hashTag.model.IHashTagOpponent;
import www.dream.com.party.model.Party;

/**
 * 게시글 관련 VO
 * IHashTagOpponent의 기능을 상속받아 hashtag에 값을 저장할때 'Post'라는 구분자를 넘겨줌
 * @author Fleax_Market
 *
 */
@Data
@NoArgsConstructor
@ClassPrintTarget
public class PostVO extends ReplyVO implements IHashTagOpponent {
   public static final String DESCRIM4POST = "post";

   private List<PostVO> post;
   @HashTarget
   private String title;
   @HashTarget
   @PrintTarget(order = 300, caption = "조회수")
   private int readCnt;
   // 좋아요 수
   private int likeCnt; 
   // 싫어요 수
   private int dislikeCnt; 
   private BoardVO board;
   
   //거래에 관한 게시글
   private TradeVO trade;

   //첨부 파일
   private List<String> listAttachInStringFormat;
   private ProductVO product;
   @HashTarget
   private List<AttachFileVO> listAttach;

   public PostVO(String title, String content, Party writer) {
      super(content, writer);
      this.title = title;
   }

   public String getType() {
      return "Post";
   }

   @PrintTarget(order = 100, caption = "제목", withAnchor = true)
   public String getTitleWithCnt() {
      return title + " [" + super.replyCnt + "]";
   }


   /** 첨부파일에 대한 정보를 json형식으로 변경하여 화면에 출력을 하기 위한 함수*/
   public List<String> getAttachListInGson() { 
      List<String> ret = new ArrayList<>();
      ret.addAll(listAttach.stream().map(vo -> vo.getJson()).collect(Collectors.toList()));
      return ret;
   }

   
   /** 수정했을시에 파일이 삭제 되는것을 방지하기 위한 함수*/
   public void parseAttachInfo() {
      if (listAttach == null) {
         listAttach = new ArrayList<>();
      }

      if (listAttachInStringFormat != null) {
         for (String ai : listAttachInStringFormat) {
            listAttach.add(AttachFileVO.fromJson(ai));
         }
      }
   }
   
}