package www.dream.com.business.model;

import java.util.Date;

import lombok.Data;
/**
 *  택배를 받는 고객 정보를 저장하는 VO
 * @author Fleax_Market
 *
 */

@Data
public class ShippingInfoVO extends TradeVO {

	private String address; //택배를 받을 주소	
	private int phonNum; //택배를 받는 휴대폰 번호
	private int reserveNum; //택배를 받는 예비 연락처 번호
	private String absentMsg; //택배를 받는 부재 메시지
	
}
