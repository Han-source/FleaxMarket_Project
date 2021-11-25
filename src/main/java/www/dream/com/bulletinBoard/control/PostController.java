package www.dream.com.bulletinBoard.control;

import java.io.IOException;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import www.dream.com.bulletinBoard.model.BoardVO;
import www.dream.com.bulletinBoard.model.PostVO;
import www.dream.com.bulletinBoard.service.BoardService;
import www.dream.com.bulletinBoard.service.PostService;
import www.dream.com.business.model.TradeVO;
import www.dream.com.business.service.BusinessService;
import www.dream.com.common.dto.Criteria;
import www.dream.com.framework.springSecurityAdapter.CustomUser;
import www.dream.com.party.model.Party;
import www.dream.com.party.service.PartyService;

@Controller
@RequestMapping("/post/*")
/**
 * 게시물을 띄워주는 컨트롤러
 * @author Fleax_Market
 *
 */
public class PostController {
   @Autowired
   private PostService postService;
   @Autowired
   private PartyService partyService;
   @Autowired
   private BoardService boardService;
   @Autowired
   private BusinessService businessService;

   // 상품 목록을 띄워준다.
   @GetMapping(value = "listBySearch")
   public void listBySearch(@RequestParam("boardId") int boardId, @RequestParam("child") int child,
         @ModelAttribute("pagination") Criteria userCriteria, @AuthenticationPrincipal Principal principal,
         Model model) {
      // 로그인한 현재 사용자의 정보를 가져온다.
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("userId", curUser.getUserId());
         model.addAttribute("descrim", curUser.getDescrim());
         model.addAttribute("party", partyService.getList(curUser));
      }
      model.addAttribute("boardId", boardId);
      model.addAttribute("child", child);
      model.addAttribute("listPost", postService.getListByHashTag(curUser, boardId, child, userCriteria));
      model.addAttribute("boardName", boardService.getBoard(boardId).getName());
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      userCriteria.setTotal(postService.getSearchTotalCount(boardId, child, userCriteria));
   }

   // 게시물 수정과 조회.
   @GetMapping(value = { "readPost", "modifyPost" })
   public void findPostById(@RequestParam("boardId") int boardId, @RequestParam("child") int child, String toId,
         @RequestParam("postId") String id, Model model, @AuthenticationPrincipal Principal principal,
         @ModelAttribute("pagination") Criteria fromUser) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("userId", curUser.getUserId());
         model.addAttribute("descrim", curUser.getDescrim());
         model.addAttribute("party", partyService.getList(curUser));
      }
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("child", child);
      model.addAttribute("post", postService.findPostById(id, child));
      model.addAttribute("boardId", boardId);
      model.addAttribute("boardName", boardService.getBoard(boardId).getName());

      postService.cntPlus(id);// 조회수
   }

   // 상품 등록시에 띄워줄 화면
   @GetMapping(value = "registerPost")
   @PreAuthorize("isAuthenticated()")
   public void registerPost(@RequestParam("boardId") int boardId, @RequestParam("child") int child, Model model,
         @AuthenticationPrincipal Principal principal) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("party", partyService.getList(curUser));
      }
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("boardId", boardId);
      model.addAttribute("child", child);
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      model.addAttribute("boardName", boardService.getBoard(boardId).getName());
   }

   @PostMapping(value = "registerPost")
   @PreAuthorize("isAuthenticated()")
   public String registerPost(@AuthenticationPrincipal Principal principal, @RequestParam("boardId") int boardId,
         @RequestParam("child") int child, PostVO newPost, RedirectAttributes rttr) throws IOException {
      newPost.parseAttachInfo();
      BoardVO board = new BoardVO(boardId, child);
      UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
      CustomUser cu = (CustomUser) upat.getPrincipal();
      Party writer = cu.getCurUser();
      newPost.setWriter(writer);
      postService.insert(board, child, newPost);

      rttr.addFlashAttribute("result", newPost.getId());

      return "redirect:/post/listBySearch?boardId=" + boardId + "&child=" + child;
   }

   @PostMapping(value = "modifyPost")
   @PreAuthorize("principal.username == #writerId")
   public String openModifyPost(@RequestParam("boardId") int boardId, PostVO modifiedPost,
         @RequestParam("child") int child, RedirectAttributes rttr, Criteria fromUser, String writerId) {
      // 수정했을시에 파일이 삭제 되는것을 방지
      modifiedPost.parseAttachInfo();
      if (postService.updatePost(modifiedPost)) {
         rttr.addFlashAttribute("result", "수정처리가 성공");
      }
      // 수정 버튼을 눌렀을때, 수정한 게시글이 있던 곳으로 돌아옴, 1페이지로 초기화 안됨

      UriComponentsBuilder builder = UriComponentsBuilder.fromPath("");
      builder.queryParam("boardId", boardId);
      builder.queryParam("child", child);
      fromUser.appendQueryParam(builder);
      // 게시글의 전체 내용이 바뀌기 보다는 조금의 내용이 바뀌는 것이 수정 행위의 일반적인 경향
      return "redirect:/post/listBySearch" + builder.toUriString();
   }

   // Post방식 을 통해 RedirectAttributes를 이용한 삭제 방법
   @PostMapping(value = "removePost")
   //로그인한 사용자가 글을 쓴사람인지 다시 검사
   @PreAuthorize("principal.username == #writerId")
   public String removePost(@RequestParam("boardId") int boardId, @RequestParam("postId") String id,
         @RequestParam("child") int child, RedirectAttributes rttr, Criteria fromUser, String writerId) {
      // 삭제 버튼을 눌렀을때, 삭제한 게시글이 있던 곳으로 돌아오도록
      if (postService.deletePostById(id)) { 
         rttr.addFlashAttribute("result", "삭제처리가 성공");
      }
      UriComponentsBuilder builder = UriComponentsBuilder.fromPath("");
      builder.queryParam("boardId", boardId);
      builder.queryParam("child", child);
      fromUser.appendQueryParam(builder);
      return "redirect:/post/listBySearch" + builder.toUriString();
   }

   //Ajax를 통한 사용자가 좋아요를 눌렀는지 검사한다.
   @ResponseBody
   @PostMapping(value = "UDlikeCnt")
   public String UDlike(String id, String userId, int checkLike) {
      if (checkLike == 0) {
         postService.uplike(id);
         postService.upcheckLike(id, userId);
      } else {
         postService.downlike(id);
         postService.deleteCheckLike(id, userId);
      }
      String var = String.valueOf(postService.getLike(id, userId));
      return var;
   }

   //사용자가 이미 좋아요를 눌렀는지 검사
   @ResponseBody
   @GetMapping(value = "checkLike")
   public String checkLike(@AuthenticationPrincipal Principal principal, String id, String userId) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
      }
      String var = String.valueOf(postService.checkLike(id, curUser.getUserId()));

      return var;
   }

   //관리자 게시글 다중 삭제
   @PreAuthorize("isAuthenticated()")
   @PostMapping(value = "batchDeletePost") 
   public String batchDeletePost(@RequestParam("boardId") int boardId, @RequestParam("child") int child,
         @RequestParam("postIds") ArrayList<String> postIds, RedirectAttributes rttr, Criteria fromUser,
         String writerId) {
      UriComponentsBuilder builder = UriComponentsBuilder.fromPath("");
      builder.queryParam("boardId", boardId);
      builder.queryParam("child", child);
      fromUser.appendQueryParam(builder);
      postService.batchDeletePost(postIds);
      return "redirect:/post/listBySearch" + builder.toUriString();
   }

   //쇼핑몰 현황 관리자 함수
   @GetMapping(value = "adminManage") // LCRUD 에서 Create 부분
   @PreAuthorize("isAuthenticated()") // 현재 사용자가 로그인 처리 했습니까?
   public void adminManage(@AuthenticationPrincipal Principal principal, Model model, String datePick,
         String firstDate, String lastDate) {
      if (datePick != null) {
         model.addAttribute("purchase1Day", businessService.find1DayPurchase(datePick));
      }
      if (firstDate != null && lastDate != null) {
         model.addAttribute("betweenDayPurchase", businessService.findBetweenDayPurchase(firstDate, lastDate));
      }
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("descrim", curUser.getDescrim());
         model.addAttribute("userId", curUser.getUserId());
         model.addAttribute("party", partyService.getList(curUser));
      }
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("purchaseList", businessService.findAllPurchase());
   }
   // 등급표 출력
   @GetMapping(value = "classes") 
   @PreAuthorize("isAuthenticated()") 
   public void classes() {
   }
   

}