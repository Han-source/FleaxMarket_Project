<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Spring Project</title>

<link rel="stylesheet" href="/resources/css/signup.css" type="text/css">
<script src="https://kit.fontawesome.com/3ab5ee8c30.js"
   crossorigin="anonymous"></script>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>

</head>

<body id="page-top">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign Up</title>
</head>
<body>
   <div id="formContent" style="align: center; margin: 0 auto;">
      <a href="/"><img src="/resources/img/icons/FleaxIcon1.png" alt="FleaxImg"></a>
      <!-- <h2 class="active" style="font-size:25px;">Sign Up</h2> -->
      <form id="frmMember" method="post" action="/party/joinMember">
         <div class="comment">
            <span>회원정보를 입력해주세요.</span>
         </div>
         
         <div class="form-group inputId">
            <i class="far fa-id-card"></i>
               <input id="userId" name="userId" type="text" onchange="inputFilled()"
               placeholder="아이디를 입력해주세요." class="form-control" required>
            <p id="idCheckMsg"></p>
         </div>
         
         <div id="PwdCheck" class="form-group pwdGroup">
            <i class="fas fa-lock"></i>
               <input id="userPwdOrgin" name="userPwdOrigin" placeholder="비밀번호" type="password"
               onchange="inputFilled()" class="form-control" required>
               <input id="userPwdCheck" name="userPwd" placeholder="비밀번호 재확인"
               type="password" onchange="inputFilled()" class="form-control" required>
            <p id="pwCheckMsg"></p>
         </div>
         
         <div class="form-group nameBlock">
            <i class="fas fa-user-edit"></i>
               <input type="text" onchange="inputFilled()" name="name"
               placeholder="이름을 입력해주세요." class="form-control" required>
         </div>
         
         <div class="form-group birthDtBox">
            <input id="birthDt" type="date" onchange="inputFilled()" pattern="yyyy-MM-dd"
             class="form-control" placeholder="생년월일" value='1980-01-01' name="birthDate" required>
         </div>
         
         <!-- gender-select -->
         <div class="form-group gender">
            <i class="fas fa-venus-double"></i>
            <select type="select" onchange="selectFilled()" style="width: 100%; height: 100%;">
               <option type="option" disabled selected hidden; class="form-control">성별을 선택해주세요</option>
               <option type="option" onchange="inputFilled()" class="form-control"name="male" value="1">남자</option>
               <option type="option" onchange="inputFilled()" class="form-control" name="male" value="0">여자</option>
            </select>
         </div>
         <br>
         <c:forEach items="${listCPType}" var="contactPointType" varStatus="status">
            <c:if test="${status.index eq 0}">
               <div class="postBox">
                  <div class="postcodebtn">
                     <button id="findPost" type="button" onclick="execPostcode()">
                        <i class="far fa-envelope-open"></i>
                     </button>
                  </div>
                  <%-- <label>${contactPointType.description}</label> --%>
                  <i class="fas fa-map-pin"></i>
                  <p id="postcode" placeholder="우편번호">
                     <input name="listContactPoint[${status.index}].contactPointType" type="hidden" 
                        value="${contactPointType.cpType}" class="form-control" readonly required>
                        
                     <input name="listContactPoint[${status.index}].info" id="address" 
                        type="text" onchange="inputFilled()" class="form-control" placeholder="주소" required>
                        
                     <input name="listContactPoint[${status.index}].info" id="detailAddress"
                        type="text" onchange="inputFilled()" class="form-control" placeholder="상세주소" required>
                        
                  <div id="layer" style="display: none; position: fixed;
                     overflow: hidden; z-index: 1; -webkit-overflow-scrolling: touch;">
                     <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnCloseLayer"
                     style="cursor: pointer; position: absolute; right: -3px; top: -3px; z-index: 1"
                     onclick="closeDaumPostcode()" alt="닫기 버튼">
                   </div>
               </div>

            </c:if>
            <c:if test="${status.index eq 1}">
               <div class="form-group phoneNum">
                  <i class="fas fa-phone"></i>
                      <input type="hidden" name="listContactPoint[${status.index}].contactPointType"
                     value="${contactPointType.cpType}" class="form-control" readonly required>
                     
                     <input type="text" onchange="inputFilled()" id="addressTelNum" onkeyup="validation1()"
                     name="listContactPoint[${status.index}].info" class="form-control" maxlength="11"
                     placeholder="자택 전화번호" required>
                     
                  <section class="result1" style="color: red;"></section>
               </div>
            </c:if>
            <c:if test="${status.index eq 2}">
               <div class="form-group phoneNum">
                  <i class="fas fa-mobile-alt"></i>
                     <input type="hidden" name="listContactPoint[${status.index}].contactPointType"
                     value="${contactPointType.cpType}" class="form-control" readonly required>
                     
                     <input type="text" onchange="inputFilled()" id="phoneNumber" onkeyup="validation2()"
                     name="listContactPoint[${status.index}].info" class="form-control" placeholder="휴대전화번호" required>
                     
                  <section class="result2" style="color: blue;"></section>
               </div>
            </c:if>
         </c:forEach>
            <input type="hidden" name="descrim" value="${memberType.partyType}" required>
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}' required>
            <button id="btnJoin" class="btn btn-primary"
            onclick="checkAllJoinMember(this.form).submit()" type="button">회원가입</button>
      </form>
   </div>

   <!-- End of Main Content -->
   <script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

   <!-- Core plugin JavaScript-->
   <script src="/resources/vendor/jquery-easing/jquery.easing.min.js"></script>

   <!-- Custom scripts for all pages-->
   <script src="/resources/js/sb-admin-2.min.js"></script>


   <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <script type="text/javascript">
    
    $(document).ready(function() {
       // Spring Security 기반에 의한 POST방식으로 전송시 csrf Token이 필요
        var csrfHN = "${_csrf.headerName}";
        var csrfTV = "${_csrf.token}";
        
        // Ajax 전송시 beforeSend 역할을 대신 할 수 있다.
        $(document).ajaxSend(
            function(e, xhr){
                xhr.setRequestHeader(csrfHN, csrfTV);
            }
        );
        
        var frmPost = $("#frmPost");
    
        //비밀번호 일치 확인
        $('#PwdCheck').keyup(function(){
           var a = $('#userPwdCheck').val();
           if($('#userPwdOrgin').val() == null){
              return;
           }
           if($('#userPwdCheck').val() != ""){
               if($('#userPwdOrgin').val()!=$('#userPwdCheck').val()){
                   $('#pwCheckMsg').text('');
                     $('#pwCheckMsg').html("<font color='#FF3333'>패스워드가 불일치 합니다. </font>");
                }else{
                     $('#pwCheckMsg').text('');
                     $('#pwCheckMsg').html("<font color='#70AD47'>패스워드가 일치 합니다.</font>");
                }
           }else{
              return;
           }
        });
        
            //회원 ID가 유일한가를 Ajax 검사하고 그렇지 못할 때는 Focus를 다시 받아야 합니다. 
            $("#userId").blur(function(e){
                e.preventDefault();
                
            // 회원가입시에 Id 중복 검사    
            id = $("#userId").val();
            $.ajax({   
                url: '/party/idCheck',
                type: 'POST',
                dataType: 'text', //서버로부터 내가 받는 데이터의 타입
                contentType : 'text/plain; charset=utf-8;',//내가 서버로 보내는 데이터의 타입
                data: id,
                success: function(data){
                     if(data == 0){
                     console.log("아이디 없음");
                     $("#idCheckMsg").text("사용하실 수 있는 아이디입니다.");
                     }else{
                         console.log("아이디 있음");
                         $("#idCheckMsg").text("중복된 아이디가 존재합니다.");
                     }
                },
                error: function (){        
                }
              });
        });
    });
    
    var result1 = document.querySelector(".result1");
    
    // 회원가입시에 (핸드폰)번호 등록할 때 올바른 형식 검사
    function validation1() {
        var number = document.getElementById("addressTelNum").value;
        var numberpattern = /^01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$/;
    
        if (numberpattern.test(number)) {
            result1.innerHTML = "올바른 전화번호입니다!";
        }
        else {
            result1.innerHTML = "올바른 전화번호를 입력해주세요!";
        }
    }
    var result2 = document.querySelector(".result2");
    
    // 회원가입시에 (집)번호 등록할 때 올바른 형식 검사
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
        var width = 350; //팝업창 width
        var height = 450; //팝업창 height
        var borderWidth = 5; //팝업창 border 두께
    
        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.right = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth) + 'px';
    }
    
    function checkAllJoinMember(form) {
        // 회원가입시에 정보 입력을 해야 가입이 가능
        if(form.userId.value == "") {
            alert('아이디를 입력하세요');
            form.userId.focus();
         return ;
        }
        if(form.userPwdOrigin.value == "") {
            alert('비밀번호를 입력하세요');
            form.userPwdOrigin.focus();
            return ;
        }
        if(form.userPwd.value == "") {
            alert('비밀번호를 재확인합니다.');
            form.userPwd.focus();
            return ;
        }
        if(form.name.value == "") {
            alert('이름을 입력하세요');
            form.name.focus();
            return ;
        }
        if(form.birthDt.value == "") {
            alert('생년월일을 입력하세요');
            form.birthDt.focus();
            return ;
        }
        if(form.address.value == "") {
            alert('주소를 입력하세요');
            form.address.focus();
            return ;
        }
        if(form.detailAddress.value == "") {
            alert('상세주소를 입력하세요');
            form.detailAddress.focus();
            return ;
        }
        
        if(form.addressTelNum.value == "") {
            alert('주소지에 있는 전화번호를 입력하세요');
            form.addressTelNum.focus();
            return ;
        }
        
        if(form.phoneNumber.value == "") {
            alert('핸드폰 번호를 입력하세요');
            form.phoneNumber.focus();
            return ;
        }
        
        $("#frmMember").submit();
        
        alert(form.userId.value + '(' + form.name.value + ") 님의 \n 회원가입이 완료되었습니다.");
        
    }
    </script>

   <script>
    window.onload = function() {
 
    function onClick() {
        document.querySelector('.modal_wrap').style.display ='block';
        document.querySelector('.black_bg').style.display ='block';
    }   
    function offClick() {
        document.querySelector('.modal_wrap').style.display ='none';
        document.querySelector('.black_bg').style.display ='none';
    }
 
    document.getElementById('modal_btn').addEventListener('click', onClick);
    document.querySelector('.modal_close').addEventListener('click', offClick);
 
};
 
 
function inputFilled(){
    const input = document.querySelector('input');
    if (input.value !== ""){
        input.style.backgroundColor = "#E8F0FE";
    } else{
        input.style.backgroundColor = "";
    }
}
inputFilled();
   const select = document.querySelector('select');
   
function selectFilled(){
        if (select.value !== ""){
            select.style.backgroundColor="#E8F0FE";
        } else{
            select.style.backgroundColor = "";
        }
    }
    select.addEventListener("click", () => {
       selectFilled();
    })
</script>

</body>
</html>