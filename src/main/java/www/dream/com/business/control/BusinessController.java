package www.dream.com.business.control;

import java.io.IOException;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.bulletinBoard.service.BoardService;
import www.dream.com.bulletinBoard.service.PostService;
import www.dream.com.bulletinBoard.service.ReplyService;
import www.dream.com.business.model.ProductVO;
import www.dream.com.business.model.ShippingInfoVO;
import www.dream.com.business.model.TradeConditionVO;
import www.dream.com.business.model.TradeVO;
import www.dream.com.business.service.BusinessService;
import www.dream.com.common.dto.Criteria;
import www.dream.com.framework.springSecurityAdapter.CustomUser;
import www.dream.com.party.model.ContactPoint;
import www.dream.com.party.model.Party;
import www.dream.com.party.service.PartyService;
/**
 * 중고 상품에관한 처리를 진행하는 Controller 
 * @author Fleax_Market
 *
 */
@Controller
@RequestMapping("/business/*")
public class BusinessController {

	@Autowired
	private BusinessService businessService;
	@Autowired
	private ReplyService replyService;
	@Autowired
	private BoardService boardService;
	@Autowired
	private PostService postService;
	@Autowired
	private PartyService partyService;
	
	// 등록한 상품 목록 페이지 출력
	@GetMapping(value = "productList")
	public void listBySearch(@RequestParam("boardId") int boardId, @RequestParam("child") int child,
			@ModelAttribute("pagination") Criteria userCriteria, @AuthenticationPrincipal Principal principal,
			Model model) {
		Party curUser = getPricipalUser(principal);
		if (curUser != null) {
			model.addAttribute("userId", curUser.getUserId());
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardId", boardId);
		model.addAttribute("child", child);
		model.addAttribute("boardName", boardService.getBoard(boardId).getName());
		model.addAttribute("childBoardList", boardService.getChildBoardList(4));
		model.addAttribute("childBoardName", boardService.getChildBoard(boardId, child).getName());
		model.addAttribute("productList", postService.findProductList(curUser, boardId, child, userCriteria));
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("page", userCriteria);
		userCriteria.setTotal(postService.getProductSearchTotalCount(boardId, child, userCriteria));
	}
	
	// 내가 결제한 상품 내역 목록 페이지 출력
	@GetMapping(value = "paymentHistory") 
	public void paymentList(@ModelAttribute("pagination") Criteria userCriteria,
			@AuthenticationPrincipal Principal principal, Model model) {
		Party curUser = getPricipalUser(principal);
		if (curUser != null) {
			model.addAttribute("userId", curUser.getUserId());
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardId", 4);
		model.addAttribute("boardName", boardService.getBoard(4).getName());
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("childBoardList", boardService.getChildBoardList(4));
		model.addAttribute("page", userCriteria);
		model.addAttribute("paymentList", postService.getMyPaymentList(4, curUser.getUserId(), userCriteria));
	}
	
	// 내가 결제한 상품 중 특정 상품에 정보 페이지 출력
	@GetMapping(value = "paymentReadHistory") 
	public void paymentReadHistory(@ModelAttribute("pagination") Criteria userCriteria,
			@AuthenticationPrincipal Principal principal, Model model, String productId, int child, String tradeId,
			String tradeDate, int productPrice) {
		Party curUser = getPricipalUser(principal);
		if (curUser != null) {
			TradeConditionVO newProductCondition = new TradeConditionVO();
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			newProductCondition.setBuyerId(curUser.getUserId());
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("userId", curUser.getUserId());
			model.addAttribute("negoBuyer",businessService.findNegoPriceByBuyerWithProductId(productId, newProductCondition));
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardId", 4);
		model.addAttribute("boardName", boardService.getBoard(4).getName());
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("product", businessService.findPriceById(productId));
		model.addAttribute("post", replyService.findProductById(productId, child));
		model.addAttribute("page", userCriteria);
		model.addAttribute("tradeId", tradeId);
		model.addAttribute("tradeDate", tradeDate);
		model.addAttribute("productPrice", productPrice);
		model.addAttribute("info", businessService.findMyShippingInfo(productId));
	}

	 // 내 상품 목록 중 판매중인 상품과 판매가 완료된 상품 페이지 출력
	   @GetMapping(value = { "myProductUploaded", "myProductSelled" }) 
	   public void myProductUploaded(@ModelAttribute("pagination") Criteria userCriteria,
	         @AuthenticationPrincipal Principal principal, Model model, String firstDate, String lastDate) {
	      Party curUser = getPricipalUser(principal);
	      if (curUser != null) {
	         model.addAttribute("userId", curUser.getUserId());
	         model.addAttribute("descrim", curUser.getDescrim());
	         model.addAttribute("party", partyService.getList(curUser));
	      }
	      model.addAttribute("boardId", 4);
	      model.addAttribute("boardName", boardService.getBoard(4).getName());
	      model.addAttribute("boardList", boardService.getList());
	      model.addAttribute("page", userCriteria);
	      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
	      List<PostVO> a = postService.getMyProductUploaded(4, curUser.getUserId(), userCriteria);
	      model.addAttribute("productUploaded", postService.getMyProductUploaded(4, curUser.getUserId(), userCriteria));
	      model.addAttribute("sellChart", businessService.selledChart(curUser.getUserId()));
	      if (firstDate != null && lastDate != null) {
	         model.addAttribute("mySelledDateChart",
	               businessService.mySelledDateChart(curUser.getUserId(), firstDate, lastDate));
	      }
	   }

	private Party getPricipalUser(Principal principal) {
		Party curUser = null;
		if (principal != null) {
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
		}
		return curUser;
	}
	// 상품에 관한 읽기, 수정 화면 출력
	@GetMapping(value = { "readProduct", "modifyProduct" })
	public void findProductById(@RequestParam("boardId") int boardId, String productId,
			@RequestParam("child") int child, Model model, @AuthenticationPrincipal Principal principal) {
		Party curUser = null;
		if (principal != null) {
			TradeConditionVO newProductCondition = new TradeConditionVO();
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			newProductCondition.setBuyerId(curUser.getUserId());
			model.addAttribute("userId", curUser.getUserId());
			TradeConditionVO  a = businessService.findNegoPriceByBuyerWithProductId(productId, newProductCondition);
			model.addAttribute("negoBuyer", businessService.findNegoPriceByBuyerWithProductId(productId, newProductCondition));
			model.addAttribute("checkShoppingCart", businessService.findShoppingCartByUserIdAndProductId(curUser.getUserId(), productId));
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("childBoardList", boardService.getChildBoardList(4));
		model.addAttribute("post", replyService.findProductById(productId, child));
		model.addAttribute("product", businessService.findPriceById(productId));
		model.addAttribute("condition", businessService.findAuctionPriceById(productId));
		model.addAttribute("auctionParty", businessService.findAuctionPartyById(productId));
		model.addAttribute("boardId", boardId);
		model.addAttribute("child", child);
		model.addAttribute("tc", businessService.lookChartProduct(productId));
		model.addAttribute("maxBidPrice", businessService.findMaxBidPrice(productId));
	}
	
	// 경매 참여 시 처리가 이루어지는 곳
	@PostMapping(value = "readProduct")
	@PreAuthorize("isAuthenticated()")
	public String findProductById(@RequestParam("boardId") int boardId, @RequestParam("child") int child,
			TradeConditionVO tradeCondition, PostVO newPost, @RequestParam("postId") String postId,
			RedirectAttributes rttr) {
		BoardVO board = new BoardVO(boardId, child);

		newPost.setId(postId);
		businessService.insertAuctionPrice(newPost, tradeCondition, board);
		return "redirect:/business/readProduct?boardId=" + boardId + "&child=" + child + "&productId=" + postId;
	}
	
	// 상품 게시판에 관해 수정 처리가 이루어지는 곳
	@PostMapping(value = "modifyProduct") 
	@PreAuthorize("isAuthenticated()")
	public String modifyProduct(@AuthenticationPrincipal Principal principal, @RequestParam("boardId") int boardId,
			@RequestParam("child") int child, int productPrice, TradeConditionVO tradeCondition, String postId,
			PostVO modifiedPost, RedirectAttributes rttr) throws IOException {
		modifiedPost.parseAttachInfo(); // 수정했을시에 파일이 삭제 되는것을 방지
		modifiedPost.setId(postId);
		BoardVO board = new BoardVO(boardId, child);
		ProductVO productVO = new ProductVO();
		productVO.setProductPrice(productPrice);
		UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
		CustomUser cu = (CustomUser) upat.getPrincipal();
		Party writer = cu.getCurUser();
		modifiedPost.setWriter(writer);
		if (child == 7) {
		} else {
			if (businessService.updatePost(modifiedPost)) {
				rttr.addFlashAttribute("result", "수정처리가 성공");
			}
		}
		rttr.addFlashAttribute("result", modifiedPost.getId());
		return "redirect:/business/productList?boardId=" + boardId + "&child=" + child;
	}
	// 상품을 등록페이지를 출력하는 부분
	@GetMapping(value = "registerProduct") 
	@PreAuthorize("isAuthenticated()") // 현재 사용자가 로그인 처리 했습니까
	public void registerPost(@RequestParam("boardId") int boardId, @RequestParam("child") int child, Model model,@AuthenticationPrincipal Principal principal,
			final TradeConditionVO tradeCondition) {
		if (tradeCondition.getAuctionEndDate() == null) {
			tradeCondition.setAuctionEndDate(LocalDateTime.now());
		}
		Party curUser = null;
		if (principal != null) {
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("child", child);
		model.addAttribute("boardId", boardId);
		model.addAttribute("childBoardList", boardService.getChildBoardList(4));
	}
	// 상품 등록을 처리하는 부분 
	@PostMapping(value = "registerProduct") // LCRUD 에서 Update 부분
	@PreAuthorize("isAuthenticated()")
	public String registerPost(@AuthenticationPrincipal Principal principal, @RequestParam("boardId") int boardId,
			@RequestParam("child") int child, int productPrice, TradeConditionVO tradeCondition, String postId,
			PostVO newPost, RedirectAttributes rttr) throws IOException {
		newPost.parseAttachInfo();
		newPost.setId(postId);
		BoardVO board = new BoardVO(boardId, child);
		ProductVO productVO = new ProductVO();
		productVO.setProductPrice(productPrice);
		UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
		CustomUser cu = (CustomUser) upat.getPrincipal();
		Party writer = cu.getCurUser();
		newPost.setWriter(writer);
		if (child == 7) {
			businessService.insertAuctionProduct(productVO, newPost, tradeCondition, board);
		} else {
			businessService.insertCommonProduct(productVO, newPost, board);

		}
		rttr.addFlashAttribute("result", newPost.getId());
		return "redirect:/business/productList?boardId=" + boardId + "&child=" + child;
	}
	// 장바구니에 담는 부분을 처리
	@PostMapping(value = "insertShoppingCart") 
	@PreAuthorize("isAuthenticated()")
	public String insertShoppingCart(String productId, @AuthenticationPrincipal Principal principal,
			@RequestParam("boardId") int boardId, @RequestParam("child") int child) {
		Party curUser = getPricipalUser(principal);

		businessService.insertShopphingCart(curUser.getUserId(), productId);
		return "redirect:/business/readProduct?boardId=" + boardId + "&child=" + child + "&productId=" + productId;
	}

	/* 일반 결제창 */
	@GetMapping(value = "payment")
	@PreAuthorize("isAuthenticated()")
	public void paymentProduct(@RequestParam("boardId") int boardId, String productId, @RequestParam("child") int child,
			Model model, @AuthenticationPrincipal Principal principal,
			@ModelAttribute("pagination") Criteria userCriteria) {
		Party curUser = null;
		if (principal != null) {
			TradeConditionVO newProductCondition = new TradeConditionVO();
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			newProductCondition.setBuyerId(curUser.getUserId());
			model.addAttribute("userName", curUser.getName());
			model.addAttribute("negoBuyer",
					businessService.findNegoPriceByBuyerWithProductId(productId, newProductCondition));
			model.addAttribute("buyerId", newProductCondition.getBuyerId());
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("party", partyService.getList(curUser));
			
		}
		model.addAttribute("childBoardList", boardService.getChildBoardList(4));
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("post", replyService.findProductPurchaseRepresentById(productId, child));
		model.addAttribute("product", businessService.findPriceById(productId));
		model.addAttribute("condition", businessService.findAuctionPriceById(productId));
		model.addAttribute("auctionParty", businessService.findAuctionPartyById(productId));
		model.addAttribute("boardId", boardId);
		model.addAttribute("child", child);
		// contactInfo 정보 찾는 부분 
		model.addAttribute("loginContactInfo", partyService.getContactListByUserId(curUser.getUserId()));
		//이부분은 party에 관한 정보 찾는 부분
		model.addAttribute("loginPartyInfo", partyService.findPartyByUserId(curUser.getUserId()));
		
	}

	/* 경매 결제창 */
	@GetMapping(value = "autionPayment")
	@PreAuthorize("isAuthenticated()")
	public void autionPaymentProduct(@RequestParam("boardId") int boardId, String productId,
			@RequestParam("child") int child, Model model, @AuthenticationPrincipal Principal principal,
			@ModelAttribute("pagination") Criteria userCriteria) {
		Party curUser = null;
		if (principal != null) {
			TradeConditionVO newProductCondition = new TradeConditionVO();
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			newProductCondition.setBuyerId(curUser.getUserId());
			model.addAttribute("negoBuyer",
					businessService.findNegoPriceByBuyerWithProductId(productId, newProductCondition));
			model.addAttribute("buyerId", newProductCondition.getBuyerId());
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("party", partyService.getList(curUser));
		}
		model.addAttribute("boardList", boardService.getList());
		model.addAttribute("post", replyService.findProductById(productId, child));
		model.addAttribute("product", businessService.findPriceById(productId));
		model.addAttribute("condition", businessService.findAuctionPriceById(productId));
		model.addAttribute("auctionParty", businessService.findAuctionPartyById(productId));
		model.addAttribute("productList", postService.findProductList(curUser, boardId, child, userCriteria));
		model.addAttribute("boardId", boardId);
		model.addAttribute("child", child);
		model.addAttribute("maxBidPrice", businessService.findMaxBidPrice(productId));
	}

	// Ajax를 통해 진행되는 결제 데이터를 받고 처리하는 부분
	@RequestMapping(value = "/purchase", method = RequestMethod.POST, produces = { "application/json" })
	public @ResponseBody void purchase(@AuthenticationPrincipal Principal principal, 
			@RequestBody ShippingInfoVO shippingInfoVO) {
		Party curUser = null;
		if (principal != null) {
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();			
			businessService.purchaseProduct(shippingInfoVO);
			businessService.selledProdut(shippingInfoVO.getProductId());
			partyService.EarnPoints(shippingInfoVO.getPoints(), curUser.getUserId());
		}
		
		
		
	}
	// 관리자가 결제를 완료시키는 페이지 출력
	@GetMapping(value = "adminPermission") 
	@PreAuthorize("isAuthenticated()") 
	public void adminManage(@AuthenticationPrincipal Principal principal, Model model) {
		Party curUser = null;
		if (principal != null) {
			UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
			CustomUser cu = (CustomUser) upat.getPrincipal();
			curUser = cu.getCurUser();
			model.addAttribute("descrim", curUser.getDescrim());
			model.addAttribute("userId", curUser.getUserId());
		}
		List<PostVO> a = replyService.findPurchasePermission();
		model.addAttribute("adminPermission", replyService.findPurchasePermission());
	}
	// 관리자가 결제를 처리하는 부분
	@PostMapping(value = "adminPermission") 
	@PreAuthorize("isAuthenticated()") 
	public void adminManageAgreePermission(String permissionAgree, String permissionDisAgree, String tradeId) {
		if (permissionAgree != null) {
			businessService.updateAdminPurchase(tradeId);
		}
		if (permissionDisAgree != null) {
			businessService.updateAdminDisAgreepurchase(tradeId);
		}

	}
}