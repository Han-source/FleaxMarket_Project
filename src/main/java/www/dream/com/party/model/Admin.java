package www.dream.com.party.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 관리자(강제 삭제 권한 있음)
 * @author Fleax_Market
 */
@Data
@NoArgsConstructor
 
public class Admin extends Party {
   // 권한의 종류(관리자, 매니저, 회원)
   private static List<AuthorityVO> listAuthority = new ArrayList<AuthorityVO>();
   static {
      listAuthority.add(new AuthorityVO("admin"));
      listAuthority.add(new AuthorityVO("manager"));
      listAuthority.add(new AuthorityVO("user"));
   }
   
   @Override
   // 권한을 부여
   public List<AuthorityVO> getAuthorityList() {
      return listAuthority;
   } 
   
   public Admin(String userId) { 
      super(userId);
   }

   
}