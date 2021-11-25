package www.dream.com.business.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.framework.printer.ClassPrintTarget;
/**
 * 상품에 관한 정보를 저장할 VO
 * 
 * @author Fleax Market
 *
 */

@Data
@NoArgsConstructor // 여기서도 생성자를 강제로 만들거기 때문에
@ClassPrintTarget
public class ProductVO extends BoardVO{
	public static final String DESCRIM4POST = "product"; // descrim 구분자를 설정하여 상품이라는 것을 나타내는 역할
	private String productId; // 상품ID	
	private String userId; // 유저ID	
	private int productPrice; // 상품가격	
	private String discrim; // 물품 구분자 역할
	
	
}
