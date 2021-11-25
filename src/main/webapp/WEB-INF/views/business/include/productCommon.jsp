   <%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<!--  중고 상품  게시글등록 시 입력할 정보 및 표시할 내용들  -->
<div class="form-group">
   <input name="postId" type="hidden" value="${post.id}" class="form-control"  readonly/>

</div>

<div class="form-group" style="padding-left: 1%; padding-right: 1%;">
   <label>제목</label>  <input id="title"  name="title" value="${post.title}" maxlength='30' onkeydown="validationTitle1()" class="form-control"  autofocus  readonly/>
   <section class="validationTitle" style="color: #F6BB43;"></section>
   <p id="title_cnt" align="right">(0 / 30)</p>
</div>

<div class="form-group" style="padding-left: 1%; padding-right: 1%;">
   <label>내용</label>
   <textarea id="txaContent" name="content"  maxlength='4000' class="form-control" rows="3"  readonly >${post.content}</textarea>
   <p id="content_cnt" align="right">(0 / 4000)</p>
   
   <!-- rows: 몇줄까지 화면에 보이게 할건지 -->
</div>

<div class="form-group" style="padding-left: 1%; padding-right: 1%;">
   <c:choose>
        <c:when test="${negoBuyer eq null}"> 
            <label>가격</label> <input type="text" id="price" name="productPrice" value="${product.productPrice}"  class="form-control"   readonly />
        </c:when>
        <c:otherwise> 
             <label>가격</label> <input type="text" id="price" name="productPrice" value="${negoBuyer.discountPrice}"   class="form-control"  readonly />
        </c:otherwise>
    </c:choose>
</div>

<div class="form-group" id="regiDate">
   <label>등록일 : </label>
   <fmt:formatDate pattern="yyyy-MM-dd" value="${post.registrationDate}" />
</div>
    <c:if test="${child == 7}">
         
      <div class="form-group">
         <label>종료 시간: </label>
         <input type="datetime-local" id="auctionEndDate" name="auctionEndDate" value="${condition.auctionEndDate}"  readonly>
      </div>


   </c:if>            
<input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>

<script type="text/javascript">


$(document).ready(function() {
   // 제목에 관한 글자 수 카운트 유효 검사
    $('#title').on('keyup', function() {
        $('#title_cnt').html("(" + $(this).val().length + " / 30)");

        if($(this).val().length > 30) {
            $(this).val($(this).val().substring(0, 30));
            $('#title_cnt').html("(30 / 30)");
        }
    });
   // 내용에 관한 글자 수 카운트 유효 검사
    $('#txaContent').on('keyup', function() {
        $('#content_cnt').html("(" + $(this).val().length + " / 4000)");

        if($(this).val().length > 4000) {
            $(this).val($(this).val().substring(0, 4000));
            $('#content_cnt').html("(4000 / 4000)");
        }
    });
    
    
});

// 원 단위 ,찍기
const input = document.querySelector('#price');
input.addEventListener('keyup', function(e) {
  let value = e.target.value;
  value = Number(value.replaceAll(',', ''));
  if(isNaN(value)) {
    input.value = 0;
  }else {
    const formatValue = value.toLocaleString('ko-KR');
    input.value = formatValue;
  }
});
	// 글 입력 시 글자 수 및 특정 단어 유효 검사 처리
   var validationTitle = document.querySelector(".validationTitle");
   function validationTitle1() {
       var title = document.getElementById("title").value;
              
       var nameJ = /^[가-힣|ㄱ-ㅎ|ㅏ-ㅣ|a-z|0-9|/\s|/g]{2,30}$/;
       if (nameJ.test(title)) {
          validationTitle.innerHTML = "";
          
       }else {
          validationTitle.innerHTML = "상품의 제목을 2자 이상 입력해주세요.";
       }
       
   }
    // 입력 안한 상품 유효 검사 처리
    function allValidate(){
       var title = document.getElementById("title");
       var txaContent = document.getElementById("txaContent");
       var price = document.getElementById("price");
       if(title.value=="") {
              alert("제목을 입력해주세요!");
              title.focus();
              return false;
          }
       if(txaContent.value=="") {
              alert("내용을 입력해주세요!");
              txaContent.focus();
              return false;
          }
       if(price.value=="") {
              alert("가격을 입력해주세요!");
              price.focus();
              return false;
          }
    }
   
	// controlInput 수정이거나 신규이면 readonly flase 처리 하는 함수
   function controlInput(includer) {
      if(includer === '수정' || includer === '신규')  { //includer가 갖고있는 요소가 수정이니 아님 신규이니 라고 묻는다면
         $('#title').attr("readonly" , false);         
         //document.getElementById("txaContent").readonly =  false;
          $('#txaContent').attr("readonly" , false); //title, content 부분을 readonly를 false로 바꿔주면
          $('#price').attr("readonly" , false);
          $('#auctionCurrentPrice').attr("readonly" , false);
          $('#auctionEndDate').attr("readonly" , false);
          $('#regiDate').hide();
      }
   }
   
  
   
</script>