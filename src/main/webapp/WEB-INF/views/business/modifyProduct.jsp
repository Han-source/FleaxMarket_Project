<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>


<div class="container-fluid">
<p>
   <!-- 상단에 어떤 거래방식인지 출력. -->
   <div>
      <div style="margin-left: 250px; margin-right: 250px; background-color: #F5F5F5;">
      <c:choose>
       <c:when test="${child == 5}">
       <h3> 직접거래 방식입니다. </h3>
       </c:when>
       <c:when test="${child == 6}">
       <h3> 안전거래 방식입니다. </h3>
       </c:when>
       <c:when test="${child == 7}">
       <h3> 경매거래 방식입니다. </h3>
       </c:when>
    </c:choose>
     	<!-- 수정페이지 처리 부분 -->
         <%@include file="./include/ProductattachFileManagement.jsp"%>
            <form id="frmPost" method="post" action="/business/modifyProduct">
               <%@ include file="./include/productCommon.jsp" %>
            <button id="btnRegisterPost" type="submit" class="btn btn-primary">등록</button>
            <button type="reset" class="btn btn-secondary">초기화</button>
            <input type="hidden" name="boardId" value="${boardId}">
            <input type="hidden" name="child" value="${child}">
         </form>

      </div>
   </div>
</div>

<%@include file="../includes/footer.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	post방식 
   var csrfHN = "${_csrf.headerName}";
   var csrfTV = "${_csrf.token}";
   
   $(document).ajaxSend(
      function(e, xhr){
         xhr.setRequestHeader(csrfHN, csrfTV);
      }
   );
   controlInput('신규');
   var frmPost = $("#frmPost");
//    수정된 값들을 처리 하는 함수
   $("#btnRegisterPost").on("click", function(e) {
      e.preventDefault();
      var price = $('#price').val();      
      var replacePrice = price.replaceAll(",", "");    
      $("input[name='productPrice']").val(replacePrice);
      
      addAttachInfo(frmPost, "listAttachInStringFormat");
      frmPost.submit();
   }); 
   adjustCRUDAtAttach('수정');	
	<c:forEach var="attachVoInStr" items="${post.attachListInGson}" >
		appendUploadUl('<c:out value="${attachVoInStr}" />');
	</c:forEach>
});
</script>