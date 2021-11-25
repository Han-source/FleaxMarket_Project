package www.dream.com.business.model;

import lombok.Data;
/**
 *  결제가 정상적으로 완료 되었을 경우 저장될 정보 VO
 * 
 * @author Fleax Market
 *
 */
@Data
public class TradeVO {
	private String tradeId; // 상품 주문번호
	private String productId; // 상품id
	private int productFinalPrice; // 상품의 최종가격
	private String sellerId; // 판매자id 
	private String buyerId; // 구매자id
	private String tradeDate; // 결제 날짜 
	private int adminPermission; // 결제현황을 나타내는 요소
	private int points; // 사용자 등급을 결정하는 point
}
