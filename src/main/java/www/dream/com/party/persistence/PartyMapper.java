package www.dream.com.party.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import www.dream.com.party.model.ContactPoint;
import www.dream.com.party.model.ContactPointTypeVO;
import www.dream.com.party.model.Member;
import www.dream.com.party.model.Party;
import www.dream.com.party.model.partyOfAuthVO;

/**
 * Mybatis를 활용하여 Party 종류의 객체를 관리하는 인터페이스
 * @author Fleax_Market
 *
 */
public interface PartyMapper { 
   // 함수 정의 순서 LRCUD

   /** --------------------------- R ------------------------------- */

   /* 모든 회원정보를 List로 받기 */ 
   public List<Party> getList(@Param("party") Party member);
   
   /* 회원정보로 Contact를 List로 받기 */
   public List<ContactPoint> getContactListByUserId(@Param("userId") String userId);

   /* 비밀번호 */
   public int setPwd(Party p);

   /** 연락처 관련 정의 영역 **/
   public List<ContactPointTypeVO> getCPTypeList();
   
   /* 회원 가입 함수 */
   public void joinMember(@Param("party") Member member);
   
   /* 회원 가입시에 Id 중복 검사 */
   public int IDDuplicateCheck(@Param("userId") String userId);

   /* DB에 있는 회원 id로 찾기 */ 
   public Party findPartyByUserId(String userId);

   /* 이름찾기 */
   public String findByName(@Param("name") String name);

   /** --------------------------- C ------------------------------- */

   /* partyMapperTest.java에 있는 Code. 함수를 만들어 줄 것 */
   public void insert(@Param("user") Member newBie); 

   /** --------------------------- U ------------------------------- */
   
   /* 회원 이름 변경 처리 */
   public void changeUserName(@Param("user") Member newBie);

   /* 회원 비밀번호 변경 처리 */
   public void changeUserPwd(@Param("user") Member newBie);
   
   /* 회원 주소 변경 처리 */
   public void changeUserAddr(@Param("user") Member newBie, @Param("cp") ContactPoint cp);

   /* 회원 핸드폰번호 변경 처리 */
   public void changeUserMobileNum(@Param("user") Member newBie, @Param("cp") ContactPoint cp);

   /* 회원 집전화번호 변경 처리 */
   public void changeUserPhoneNum(@Param("user") Member newBie, @Param("cp") ContactPoint cp);
   
   /* 권한 처리 관련 영역 */ 
   public partyOfAuthVO getMemberType();

   /* 포인트 적립 처리 */ 
   public void EarnPoints(@Param("points") int points, @Param("userId") String userId);
   
   /** --------------------------- D ------------------------------- */

   /* 회원 정보 삭제 처리 */ 
   public void deleteId(@Param("party") Party party);

}