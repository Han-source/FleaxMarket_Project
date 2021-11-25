package www.dream.com.party.service;
/**
 * @author Fleax_Market
 */

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import www.dream.com.framework.springSecurityAdapter.CustomUser;
import www.dream.com.party.model.ContactPoint;
import www.dream.com.party.model.ContactPointTypeVO;
import www.dream.com.party.model.Member;
import www.dream.com.party.model.Party;
import www.dream.com.party.model.partyOfAuthVO;
import www.dream.com.party.persistence.PartyMapper;

@Service 
@AllArgsConstructor 
@NoArgsConstructor
public class PartyService implements UserDetailsService { 
   @Autowired 
   private PartyMapper partyMapper; 
   
   /* 회원 정보를 getList로 받기 */
   public List<Party> getList(Party member) { 
      return partyMapper.getList(member); 
   }
   
   /* 회원정보로 Contact를 List로 받기 */
   public List<ContactPoint> getContactListByUserId(String userId){
      return partyMapper.getContactListByUserId(userId);
   }
   
   /* DB에 있는 회원 id로 찾기 */
   public Party findPartyByUserId(String userId) {
      return partyMapper.findPartyByUserId(userId);
   };

   /*  회원 이름 변경 처리 */
   public void changeUserName(Member newBie) {
      partyMapper.changeUserName(newBie);
   }
   
   /* 회원 비밀번호 변경 처리 */
   public void changeUserPwd(Member newBie) {
      partyMapper.changeUserPwd(newBie);
   }
   
   /* 회원 주소 변경 처리 */ 
   public void changeUserAddr(Member newBie, ContactPoint cp) {
      partyMapper.changeUserAddr(newBie, cp);
   }
   
   /* 회원 핸드폰번호 변경 처리 */
   public void changeUserMobileNum(Member newBie, ContactPoint cp) {
      partyMapper.changeUserMobileNum(newBie, cp);
   }

   /* 회원 집전화번호 변경 처리 */
   public void changeUserPhoneNum(Member newBie, ContactPoint cp) {
      partyMapper.changeUserPhoneNum(newBie, cp);
   }
   
   /* 포인트 적립 처리 */
   public  void EarnPoints(int points,  String userId) {
      partyMapper.EarnPoints(points, userId);
   }
   
   
   /* 사용자 회원 탈퇴 */
   public void deleteId(Party party) {
      partyMapper.deleteId(party);
   }

   /* 연락처 유형 목록 조회 */
   public List<ContactPointTypeVO> getCPTypeList() {
      return partyMapper.getCPTypeList();
   }

   /* 권한 테이블에서 사용자 조회 */
   public partyOfAuthVO getMemberType() {
      return partyMapper.getMemberType();
   };
   
   /* ID 중복 검사*/
   public int IDDuplicateCheck(String userId) {
      return partyMapper.IDDuplicateCheck(userId);
   }

   @Override
   /* Spring Security에서의 인증 절차 */
   public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
      Party loginParty = partyMapper.findPartyByUserId(username);
      return loginParty == null ? null : new CustomUser(loginParty);
   }
   
   /* 회원 가입 함수 */
   public void joinMember(Member m) {
      partyMapper.joinMember(m);
   }

}