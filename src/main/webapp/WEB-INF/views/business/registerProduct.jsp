<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>

<!-- Begin Page Content -->
<div class="container-fluid">
   <p>
      <!-- DataTales Example -->
   <div>
      <div
         style="margin-left: 250px; margin-right: 250px; background-color: #F5F5F5;">
         <c:choose>
            <c:when test="${child == 5}">
               <h3>직접거래 방식입니다.</h3>
            </c:when>
            <c:when test="${child == 6}">
               <h3>안전거래 방식입니다.</h3>
            </c:when>
            <c:when test="${child == 7}">
               <h3>경매거래 방식입니다.</h3>
            </c:when>
         </c:choose>

         <%@include file="./include/ProductattachFileManagement.jsp"%>
         <form id="frmPost" method="post" action="/business/registerProduct" onsubmit="return allValidate();">
            <%@ include file="./include/productCommon.jsp"%>
            <input type="submit" id="btnRegisterPost" class="btn btn-info" value="등록"> 
            <input type="button" class="btn btn-secondary" value="취소" onclick="history.back(-1);"> 
            <input type="hidden" name="boardId" value="${boardId}"> 
            <input type="hidden" name="child" value="${child}">
         </form>
      </div>
   </div>

</div>
<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
   $(document).ready(function() {
      var csrfHN = "${_csrf.headerName}";
      var csrfTV = "${_csrf.token}";
      //ajax post전송시 beforeSend의 역할을 대신 해줌
      $(document).ajaxSend(function(e, xhr) {
         xhr.setRequestHeader(csrfHN, csrfTV);
      });
      //productCommon에서 controlInput('신규')로 실행하여 게시글을 등록할 수 있게함 
      controlInput('신규');
      //ProductattachFileManagement에서 adjustCRUDAtAttach('신규')를 실행하여 첨부파일을 등록할 수 있게함
      adjustCRUDAtAttach('신규');
      var frmPost = $("#frmPost");
      $("#btnRegisterPost").on("click", function(e) {
         e.preventDefault();
         var price = $('#price').val();
         var replacePrice = price.replaceAll(",", "");
         $("input[name='productPrice']").val(replacePrice);
         addAttachInfo(frmPost, "listAttachInStringFormat");
         frmPost.submit();
      });

   });
</script>