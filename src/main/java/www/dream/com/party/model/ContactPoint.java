package www.dream.com.party.model;

import lombok.Data;
import www.dream.com.common.model.CommonMngVO;
import www.dream.com.framework.lengPosAnalyzer.HashTarget;

/**
 * 연락처 정보
 * @author Fleax_Market
 *
 */

@Data
public class ContactPoint extends CommonMngVO {
   private String contactPointType; // 연락처 Type 
   @HashTarget
   private String info; // 연락처 Type에 대한 정보
}