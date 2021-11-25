package www.dream.com.party.control;

import java.io.IOException;
import java.security.Principal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import www.dream.com.bulletinBoard.service.BoardService;
import www.dream.com.bulletinBoard.service.PostService;
import www.dream.com.framework.springSecurityAdapter.CustomUser;
import www.dream.com.party.model.ContactPoint;
import www.dream.com.party.model.Member;
import www.dream.com.party.model.Party;
import www.dream.com.party.service.PartyService;
/**
 * 회원의 정보(가입, 탈퇴, 수정)을 담당하는 Controller
 * @author Fleax_Market
 *
 */
@Controller 
@RequestMapping("/party/*") 
public class PartyController implements AuthenticationSuccessHandler, AccessDeniedHandler { 


   @Autowired 
   private PartyService partyService; 
   @Autowired
   private PostService postService;
   @Autowired
   private BoardService boardService;
   @Autowired
   private PasswordEncoder pwEncoder;

   // 홈페이지 로그인 화면
   @GetMapping("customLogin")
   public void loginInput(String error, String logout, Model model) {
      if (error != null) {
         model.addAttribute("error", "계정을 다시 확인 하세요");
      }

      if (logout != null) {
         model.addAttribute("logout", "로그 아웃 성공!");
      }
   }

   // 로그아웃시에 나타나는 화면
   @PostMapping("customLogout")
   public void processLogoutPost() {
   }

   // 회원가입 Page
   @GetMapping("joinMember")
   public void joinMember(Model model) {
      model.addAttribute("listCPType", partyService.getCPTypeList());
      model.addAttribute("memberType", partyService.getMemberType());
   }

   @PostMapping("joinMember")
   public String joinMember(Member newBie, @DateTimeFormat(pattern = "yyyy-MM-dd") Date birthDate) {
      // 회원가입시 비밀번호 암호화
      newBie.setUserPwd(pwEncoder.encode(newBie.getUserPwd()));
      partyService.joinMember(newBie);
      return "redirect:/";
   }

   // 회원가입시에 ID 중복검사 확인
   @ResponseBody
   @PostMapping(value = "idCheck", produces = "text/plane")
   public String ID_Check(@RequestBody String paramData) throws ParseException {
      // 클라이언트가 보낸 ID값
      String ID = paramData.trim();
      int dto = partyService.IDDuplicateCheck(ID);

      if (dto > 0) {// 결과 값이 있으면 아이디 존재
         return "-1";
      } else { // 없으면 아이디 존재 X
         return "0";
      }
   }

   // 회원 탈퇴 Page
   @GetMapping(value = "removeMember")
   public void deleteId(@AuthenticationPrincipal Principal principal, Model model) {
      Party curUser = null;

      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
      }
      model.addAttribute("userPassword", curUser.getUserPwd());

   }

   @PostMapping(value = "removeMember")
   public String deleteId(@AuthenticationPrincipal Principal principal, String userPwd, String error, Model model) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();

      }
      BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
      if (encoder.matches(userPwd, curUser.getUserPwd())) {
         partyService.deleteId(curUser);
      } else {
         model.addAttribute("error", "비밀번호를 다시 확인해주세요!");
         return null;
      }
      return "redirect:/";
   }

   @GetMapping(value = "modifyMember")
   public void modifyMember(Model model, @AuthenticationPrincipal Principal principal) {
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("partyId", curUser.getUserId());
         model.addAttribute("party", partyService.getList(curUser));
      }
   }

   // 회원가입을 하고, 그 정보 확인하는 Page
   @GetMapping(value = "myPage")
   public void myPage(Model model, @AuthenticationPrincipal Principal principal) {
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("userId", curUser.getUserId());
         model.addAttribute("descrim", curUser.getDescrim());
         List<Party> a = partyService.getList(curUser);
         model.addAttribute("party", partyService.getList(curUser));
      }
   }

   @PostMapping(value = "modifyMember")
   // @PreAuthorize("principal.userId == #userId")
   public String modifyMember(@AuthenticationPrincipal Principal principal, Member newBie, ContactPoint cp) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         newBie.setUserId(curUser.getUserId());
      }
      // 이름변경
      if (newBie.getName() != null) {
         partyService.changeUserName(newBie);
      }
      // 비밀번호 변경
      if (newBie.getUserPwd() != null) {
         newBie.setUserPwd(pwEncoder.encode(newBie.getUserPwd()));
         partyService.changeUserPwd(newBie);
      }
      // 주소 변경
      if (cp.getInfo() != null && cp.getContactPointType().equals("address")) {
         partyService.changeUserAddr(newBie, cp);
      }
      // 핸드폰번호 변경
      if (cp.getInfo() != null && cp.getContactPointType().equals("mobileNum")) {
         partyService.changeUserMobileNum(newBie, cp);
      }
      // 집 전화 번호 변경
      if (cp.getInfo() != null && cp.getContactPointType().equals("PhoneNum")) {
         partyService.changeUserPhoneNum(newBie, cp);
      }

      return "redirect:/party/myPage";
   }

   // 내가 찜한 목록 보는 Page
   @GetMapping(value = "shoppingCart")
   public void shoppingCart(Model model, @AuthenticationPrincipal Principal principal, Integer boardId,
         Integer child) {
      model.addAttribute("boardList", boardService.getList());
      model.addAttribute("childBoardList", boardService.getChildBoardList(4));
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         model.addAttribute("partyId", curUser.getUserId());
         model.addAttribute("childBoardList", boardService.getChildBoardList(4));
         model.addAttribute("shopCart", postService.findProductShoppingCart(curUser.getUserId()));
         model.addAttribute("party", partyService.getList(curUser));
      }
   }

   // 찜목록 제거
   @PostMapping("removeShopppingCart")
   public String removeShopppingCart(@AuthenticationPrincipal Principal principal, String productId) {
      Party curUser = null;
      if (principal != null) {
         UsernamePasswordAuthenticationToken upat = (UsernamePasswordAuthenticationToken) principal;
         CustomUser cu = (CustomUser) upat.getPrincipal();
         curUser = cu.getCurUser();
         postService.removeShoppingCart(curUser.getUserId(), productId);      
      }
      return "redirect:/party/shoppingCart";
   }


   /**
    * 로그인 성공 시 각 사용자의 권한 유형에 따라 개인화된 화면을 연동 시켜주기 위한 기능을 이곳에서 개발합니다.
    */
   @Override
   public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
         Authentication authentication) throws IOException, ServletException {
      List<String> roleNames = new ArrayList<>();
      authentication.getAuthorities().forEach(authority -> {
         roleNames.add(authority.getAuthority());
      });

      if (roleNames.contains("manager")) {
         response.sendRedirect("/");
         return;
      }

      if (roleNames.contains("admin")) {
         response.sendRedirect("/");
         return;
      }

      if (roleNames.contains("manager")) {
         response.sendRedirect("/");
         return;
      }

      response.sendRedirect("/");
   }

   @Override
   public void handle(HttpServletRequest request, HttpServletResponse response,
         AccessDeniedException accessDeniedException) throws IOException, ServletException {
      response.sendRedirect("/party/accessError");
   }
}