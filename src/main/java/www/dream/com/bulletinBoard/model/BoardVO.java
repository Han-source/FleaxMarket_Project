package www.dream.com.bulletinBoard.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import www.dream.com.common.model.CommonMngVO;

/**
 * 게시판 관련 정보를 롼리하는 VO
 * 
 * @author Fleax_Market
 *
 */
@Data
@NoArgsConstructor
public class BoardVO extends CommonMngVO {
   private int id;
   private int parentId;
   private String name;
   // 게시판에 대한 설명
   private String description;

   public BoardVO(int id, int parentId) {
      this.id = id;
      this.parentId = parentId;
   }

}