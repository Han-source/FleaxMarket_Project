package www.dream.com.party.model;

import lombok.Data;
/**
 * 
 * @author Fleax_Market
 *
 */

@Data
public class partyOfAuthVO {
   private String partyType; //partyType : user, manager, Admin
   private String description; // partyType에 대한 상세 설명
}		