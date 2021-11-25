package www.dream.com.party.model;
/**
 * @author Fleax_Market
 */
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
import lombok.NoArgsConstructor;
import www.dream.com.common.model.CommonMngVO;
import www.dream.com.framework.lengPosAnalyzer.HashTarget;
import www.dream.com.framework.printer.ClassPrintTarget;
import www.dream.com.framework.printer.PrintTarget;
import www.dream.com.hashTag.model.IHashTagOpponent;

@Data
@NoArgsConstructor
@ClassPrintTarget
public abstract class Party extends CommonMngVO implements IHashTagOpponent { 
   
   private String userId;    // 사용자 ID
   private String userPwd;  // 사용자 PW
   @HashTarget 
   @PrintTarget(order=250, caption="작성자")
   private String    name; // 게시글에서 작성자 이름 표시    
   @DateTimeFormat(pattern = "yyyy-MM-dd")   
   private Date    birthDate;  // 회원 생일 정보
   private boolean male;      // 회원 성별 정보
   private boolean   enabled;   // 회원이 현재 활동중인지 확인
   private int point; // 회원의 적립된 포인트
   private String descrim; // 회원의 권한 구분(일반User, 관리자)
   
   @HashTarget
   // 회원 ContactPoint 종류
   private List<ContactPoint> listContactPoint = new ArrayList<>();

   public Party(String userId) {
      this.userId = userId;  
   }
   
   public String getId() {
      return userId; 
   }
   
   public String getType() {
      return "Party";
   }
   
   public void addContactPoint(ContactPoint cp) {
      listContactPoint.add(cp);
   }
   
   public abstract List<AuthorityVO> getAuthorityList();
}