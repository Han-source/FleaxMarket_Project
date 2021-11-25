package www.dream.com.party.model;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 회원
 * @author Fleax_Market
 */
@Data
@NoArgsConstructor
public class Member extends Party {
   public Member(String userId) {
      super(userId);
   }
   // 권한의 종류(회원)
   private static List<AuthorityVO> listAuthority = new ArrayList<AuthorityVO>();
    static {
       listAuthority.add(new AuthorityVO("user"));
    }
   
   @Override
   // 권한 부여
   public List<AuthorityVO> getAuthorityList() {
      return listAuthority;
   }


}