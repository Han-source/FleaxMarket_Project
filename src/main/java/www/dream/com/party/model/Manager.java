package www.dream.com.party.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 시스템 운영자
 * @author Fleax_Market
 */
@Data
@NoArgsConstructor
public class Manager extends Party {
   public Manager(String userId) {
      super(userId);
   } 
   //권한의 종류(회원,매니저)
   private static List<AuthorityVO> listAuthority = new ArrayList<AuthorityVO>();
   static {
      listAuthority.add(new AuthorityVO("manager"));
      listAuthority.add(new AuthorityVO("user"));
   }
   @Override
   // 권한 부여
   public List<AuthorityVO> getAuthorityList() {
      return listAuthority;
   }
}