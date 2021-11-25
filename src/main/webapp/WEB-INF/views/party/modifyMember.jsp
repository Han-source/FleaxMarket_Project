<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="../includes/header.jsp"%>
<style>
.divInline {
   display: inline-block;
   width: 20%;
   height: 10%;
}
</style>
<%@ include file="../includes/subMenu.jsp"%>
<div class="inline-blockk" style="width: 80%;">
<div class="container-fluidd">
        <div class = "signUp">
            <h3>회원정보 수정</h3>
        </div>
        <hr style="border: 1px solid black;">
                <div >
               <div class="divInline" style="margin-right: 10%;"><label>이름</label></div>
               <div class="divInline" style="width: 40%;">
                  <span class="spanLabel">${party[0].name}</span>
               </div>
               <div class="divInline">
                  <button class="btn btn-info" id="nameChange">개명시? 이름변경</button>
               </div>
            </div>
            <hr>
              
                <div id="PwdCheck" class="form-group">
                       <div class="divInline"  style="margin-right: 10%;"><label>비밀번호 변경</label></div>
                       <div class="divInline" style="width: 40%;">
                           <input id="userPwdOrgin" style="width: 300px;" name="userPwdOrigin" placeholder="비밀번호" type="password"><br>
                           <input id="userPwdCheck" style="width: 300px;" name="userPwd" placeholder="비밀번호 재확인" type="password">
                           <p id="pwCheckMsg"></p>
                        </div>
                        <div class="divInline"><button class="btn btn-info" id="pwdChange">비밀번호 변경</button></div>
                </div>
             <hr>
             
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>내 주소</label></div>
               <div class="divInline" style="width: 40%;">
                  <span class="spanLabel">
                     <span id = "originalAddr">${party[0].listContactPoint[0].info}</span>
                     <input name="info" id="address" style="width: 300px;" placeholder="주소"><br>
                     <input name="info" id="detailAddress" style="width: 300px;" placeholder="상세주소">
                  </span>
               </div>
               
               <div class="divInline">
                  <button class="btn btn-info" type="button" id="findPost" onclick="execPostcode();" style="margin-bottom: 5px;">우편번호 찾기</button><br>
                  <div class="divInline" style="width: 40%;">
                     <button class="btn btn-info" id="addrChange">주소지 변경</button>
                     <button class="btn btn-info" id="lastAddrChange">변경하기</button>
                  </div>
                  <div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
                       <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer"
                           style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()"
                           alt="닫기 버튼">
                  </div>            
                </div>
            </div>
            <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>휴대폰 번호</label></div>
               <div class="divInline" style="width: 40%;">
                  <span id="originalMobileNum" class="spanLabel">${party[0].listContactPoint[1].info}</span>
                  <input name="info" id="mobileNum" style="width: 300px;" placeholder="핸드폰 번호를 입력하세요">
               </div>
               <div class="divInline">
                  <button class="btn btn-info" id="mobileNumChage">핸드폰 번호 변경</button>
                  <button class="btn btn-info" id="lastMobileNumChage">변경하기</button>
               </div>
            </div>
            <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>집 전화 번호</label></div>
               <div class="divInline" style="width: 40%;">
                  <span id="originalPhoneNum" class="spanLabel">${party[0].listContactPoint[2].info}</span>
                  <input name="info" id="PhoneNum" style="width: 300px;" placeholder="집 전화 번호를 입력하세요">
               </div>
               <div class="divInline">
                  <button class="btn btn-info" id="phoneNumChage">집전화 번호 변경</button>
                  <button class="btn btn-info" id="lastPhoneNumChage">변경하기</button>
               </div>
            </div>
            <hr>
            
         <form id="chageUserName" method="post" action="/party/modifyMember">   
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>
         
         <form id="chageUserPwd" method="post" action="/party/modifyMember">   
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>

         <form id="chageUserAddr" method="post" action="/party/modifyMember">   
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>

         <form id="chageUserMobileNum" method="post" action="/party/modifyMember">   
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>

         <form id="chageUserPhoneNum" method="post" action="/party/modifyMember">   
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>


         <button id="btnJoin" type="button" class="btn btn-primary" onclick="location.href='/party/modifyMember'" >취소</button>
         <button id="btnRemoveMember" type="button"  class="btn btn-primary" onclick="location.href='/party/removeMember'">회원탈퇴</button>
      </div>
   </div>


<div id="modalChangeUserName" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <h4 class="modal-title" id="myModalLabel">바꾸실 이름을 입력하세요</h4>
         </div>
         <div class="modal-body">
            <div class="form-group">
               <label>이름을 입력하세요</label>
                <input class="form-control" name='name' id = "changeName" value=''>
            </div>
         </div>
         <div class="modal-footer">
            <button id='btnModifyUserName' type="button" class="btn btn-danger">수정하기</button>
            <button id='btnCloseModal' type="button" class="btn btn-warning">취소</button>
         </div>
      </div>
   </div>
</div>

   <%@include file="../includes/footer.jsp"%>
   
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
var nameChange = $('#nameChange');
var modalChangeUserName = $('#modalChangeUserName');
nameChange.on("click", function(){
   modalChangeUserName.modal("show");
})

$('#btnCloseModal').on("click", function(){
   modalChangeUserName.modal("hide");
})

//사용자 이름 변경하기
$('#btnModifyUserName').on("click", function(){
   if($('#changeName').val() == ""){
      alert('이름을 입력해 주세요');
      return;
   }
   $('#chageUserAddr').append("<input name='name' type='hidden' value='" + $('#changeName').val() + "'>");
   $('#chageUserAddr').submit();
   modalChangeUserName.modal("hide");
})

//비밀번호 변경하기
$('#pwdChange').on("click", function(){
   if($('#userPwdCheck').val() == ""){
      alert('비밀번호를 입력해주세요');
      return;
   }
   $('#chageUserPwd').append("<input name='userPwd' type='hidden' value='" + $('#userPwdCheck').val() + "'>");
   $('#chageUserPwd').submit();
})
//주소지 변경하기
$('#lastAddrChange').on("click", function(){
   if($('#address').val() == ""){
      alert('주소를 입력해 주세요');
      return;
   }
   if($('#detailAddress').val() == ""){
      alert('상세 주소를 입력해 주세요');
      return;
   }
   $('#chageUserAddr').append("<input name='info' type='hidden' value='" + $('#address').val() + "'>");
   $('#chageUserAddr').append("<input name='info' type='hidden' value='" + $('#detailAddress').val() + "'>");
   $('#chageUserAddr').append("<input name='contactPointType' type='hidden' value='address'>");
   $('#chageUserAddr').submit();
})
//핸드폰 번호 변경하기
$('#lastMobileNumChage').on("click", function(){
   if($('#mobileNum').val() == ""){
      alert('전화번호를 입력해주세요');
      return;
   }
   $('#chageUserMobileNum').append("<input name='info' type='hidden' value='" + $('#mobileNum').val() + "'>");
   $('#chageUserMobileNum').append("<input name='contactPointType' type='hidden' value='mobileNum'>");
   $('#chageUserMobileNum').submit();
})

//집전화 번호 변경하기
$('#lastPhoneNumChage').on("click", function(){
   if($('#PhoneNum').val() == ""){
      alert('전화번호를 입력해주세요');
      return;
   }
   $('#chageUserPhoneNum').append("<input name='info' type='hidden' value='" + $('#PhoneNum').val() + "'>");
   $('#chageUserPhoneNum').append("<input name='contactPointType' type='hidden' value='PhoneNum'>");
   $('#chageUserPhoneNum').submit();
})


//우편번호 변경하기 눌렀을때
$('#addrChange').on("click", function() {
   $('#postcode').show();
   $('#address').show();
   $('#detailAddress').show();
   $('#findPost').show();
   $('#lastAddrChange').show();
   $('#addrChange').hide();
   $('#originalAddr').hide();
})

//핸드폰 번호 바뀌기 눌렀을때
$('#mobileNumChage').on("click", function() {
   $('#mobileNum').show();
   $('#lastMobileNumChage').show();
      
   $('#mobileNumChage').hide();
   $('#originalMobileNum').hide();
})

//집 전화 번호 바뀌기 눌렀을때
$('#phoneNumChage').on("click", function() {
   $('#PhoneNum').show();
   $('#lastPhoneNumChage').show();
      
   $('#phoneNumChage').hide();
   $('#originalPhoneNum').hide();
})

   $(document).ready(function() {
      //주소 관련
      $('#postcode').hide();
      $('#address').hide();
      $('#detailAddress').hide();
      $('#findPost').hide();
      $('#lastAddrChange').hide();
      
      //핸드폰 번호 관련
      $('#mobileNum').hide();
      $('#lastMobileNumChage').hide();
      
      //집 전화 번호 관련
      $('#PhoneNum').hide();
      $('#lastPhoneNumChage').hide();
      
      var csrfHN = "${_csrf.headerName}";
       var csrfTV = "${_csrf.token}";
       $(document).ajaxSend(
           function(e, xhr){
               xhr.setRequestHeader(csrfHN, csrfTV);
           }
       );
       
       //비밀번호 일치 확인
       $('#PwdCheck').keyup(function(){
           if($('#userPwdOrgin').val()!=$('#userPwdCheck').val()){
               $('#pwCheckMsg').text('');
                 $('#pwCheckMsg').html("<font color='#FF3333'>패스워드 확인이 불일치 합니다. </font>");
            }else{
                 $('#pwCheckMsg').text('');
                 $('#pwCheckMsg').html("<font color='#70AD47'>패스워드 확인이 일치 합니다.</font>");
            }
       });
       
   });

var result1 = document.querySelector(".result1");
// 회원정보 수정 Page에서 바꿀 (핸드폰)번호가 올바른 형식인지 검사
function validation1() {
    var number = document.getElementById("addressTelNum").value;
    var numberpattern = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;

    if (numberpattern.test(number)) {
        result1.innerHTML = "올바른 주소 전화번호입니다!";
    }
    else {
        result1.innerHTML = "올바른 주소 전화번호를 입력해주세요!";
    }
}

// 회원정보 수정 Page에서 바꿀 (집)번호가 올바른 형식인지 검사
var result2 = document.querySelector(".result2");

function validation2() {
    var number = document.getElementById("phoneNumber").value;
    var numberpattern = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;

    if (numberpattern.test(number)) {
        result2.innerHTML = "올바른 번호입니다!";
    }
    else {
        result2.innerHTML = "올바른 번호를 입력해주세요!";
    }
}

// 우편번호 찾기 화면을 넣을 element
var element_layer = document.getElementById('layer');

function closeDaumPostcode() {
    // iframe을 넣은 element를 안보이게 한다.
    element_layer.style.display = 'none';
}

function execPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 우편번호와 주소 정보를 해당 필 에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("detailAddress").focus();

            // iframe을 넣은 element를 안보이게 한다.
            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
            element_layer.style.display = 'none';
        },
        width: '100%',
        height: '100%',
        maxSuggestItems: 5
    }).embed(element_layer);

    // iframe을 넣은 element를 보이게 한다.
    element_layer.style.display = 'block';

    // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
    initLayerPosition();
}

function initLayerPosition() {
    var width = 300; //팝업창 width
    var height = 400; //팝업창 height
    var borderWidth = 5; //팝업창 border 두께

    // 위에서 선언한 값들을 실제 element에 넣는다.
    element_layer.style.width = width + 'px';
    element_layer.style.height = height + 'px';
    element_layer.style.border = borderWidth + 'px solid';
    // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
    element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
    element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
}
   </script>