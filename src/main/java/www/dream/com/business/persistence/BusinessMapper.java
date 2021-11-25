package www.dream.com.business.persistence;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.business.model.ProductVO;
import www.dream.com.business.model.ShippingInfoVO;
import www.dream.com.business.model.TradeConditionVO;
import www.dream.com.business.model.TradeVO;
/**
 *  BusinessMapper
 * @author Fleax_Market
 *
 */
public interface BusinessMapper {

   /** --------------------------- 상품 처리 함수 정의 영역------------------------- */
   /* 일반 상품 등록 기능 */
   public int insertCommonProduct(@Param("productVO") ProductVO productVO, @Param("post") PostVO post,
         @Param("board") BoardVO board);

   /* 상품 상세 조회 기능 */
   public ProductVO findPriceById(@Param("productId") String id); // id와 childId를 통해 조회

   /* 상품 차트 보는 기능 */
   public List<TradeConditionVO> lookChartProduct(@Param("productId") String productId);

   /* 판매현황 차트화 */
   public List<TradeVO> selledChart(@Param("userId") String userId);

   /* 판매현황 차트 기간 정해서 보는 기능 */
   public List<TradeVO> mySelledDateChart(@Param("userId") String userId, @Param("firstDate") String firstDate,
         @Param("lastDate") String lastDate);

   /* 해당 상품을 내가 장바구니에 이미 담았는지를 검사 */
   public int findShoppingCartByUserIdAndProductId(@Param("userId") String userId,
         @Param("productId") String productId);

   /** --------------------------- 경매 처리 함수 정의 영역------------------------- */
   /* 경매 상품 등록 가능 */
   public int insertAuctionProduct(@Param("productVO") ProductVO productVO, @Param("post") PostVO post,
         @Param("tradeCondition") TradeConditionVO tradeCondition, @Param("board") BoardVO board);

   /* 경매 입찰자 등록 가능 */
   public int insertAuctionPrice(@Param("post") PostVO post, @Param("tradeCondition") TradeConditionVO tradeCondition,
         @Param("board") BoardVO board);

   /* 경매 상세 조회 기능 */
   public TradeConditionVO findAuctionPriceById(@Param("productId") String id);

   /* 경매 참여자 목록 조회 */
   public List<TradeConditionVO> findAuctionPartyById(@Param("productId") String id);

   /* 경매 가격의 최대값 비교 */
   public TradeConditionVO findMaxBidPrice(@Param("productId") String productId);

   /** --------------------------- 거래종류 처리 함수 정의 영역------------------------- */
   /* 안전거래에서 해당 이용자가 네고한 적이 있는지를 가져오는 함수 */
   public TradeConditionVO findNegoPriceByBuyerWithProductId(@Param("productId") String productId,
         @Param("tc") TradeConditionVO tc);

   /** --------------------------- 결제 처리 함수 정의 영역------------------------- */

   /* 상품 결제 시 shipping 정보 */
   public ShippingInfoVO findMyShippingInfo(@Param("productId") String productId);

   /* 상품 네고 기능 */
   public void insertNegoProductPrice2Buyer(@Param("tradeCondition") TradeConditionVO tradeCondition,
         @Param("postId") String postId, @Param("post") PostVO post);

   /* 장바구니 담기 기능 */
   public void insertShopphingCart(@Param("userId") String userId, @Param("productId") String productId);

   /* 결제가 완료 되면 결제 테이블에 값 담기 */
   public void purchaseProduct(@Param("shippingInfo") ShippingInfoVO shippingInfo);

   /* 결제가 완료 되면 selled에 +1 하는 기능 */
   public int selledProdut(@Param("productId") String productId);

   /** --------------------------- 관리자모드 판매현황------------------------- */
   // 기본으로 띄우는 그래프
   public List<TradeVO> findAllPurchase();

   // 일별 조회
   public List<TradeVO> find1DayPurchase(@Param("pickDate") String pickDate);

   // 원하는 날부터 다른날까지 조회
   public List<TradeVO> findBetweenDayPurchase(@Param("firstDate") String firstDate,
         @Param("lastDate") String lastDate);

   // 판매 허가 함수
   public void updateAdminPurchase(@Param("tradeId") String tradeId);

   // 판매 취소 함수
   public void updateAdminDisAgreepurchase(@Param("tradeId") String tradeId);
}