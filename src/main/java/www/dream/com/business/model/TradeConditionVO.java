package www.dream.com.business.model;

import java.time.LocalDateTime;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;
/**
 *   
 *  상품 거래 방식에 따른 VO 
 * @author Fleax Market
 *
 */
@Data
public class TradeConditionVO {
	
	private String sellerId; // 판매자id
    private String buyerId; // 구매자id
    private String tradeId; // 상품 주문 번호
    private String productId; // 상품id
    private int discountPrice; // 할인 가격
    private int auctionCurrentPrice; // 경매 현재 가격
    private Date auctionStartDate; // 경매 시작 가격
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    private LocalDateTime auctionEndDate; // 경매 종료 날짜 및 시간
}
