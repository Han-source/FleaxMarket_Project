package www.dream.com.party.model;

import org.springframework.security.core.GrantedAuthority;
/**
 * @author Fleax_Market
 */

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuthorityVO implements GrantedAuthority {
   // 권한 부여
   private String authority;
}