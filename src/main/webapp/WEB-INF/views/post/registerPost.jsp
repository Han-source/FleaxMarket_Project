<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>
<!-- Begin Page Content -->
<div></div>
<p>
<div>
   <div style="margin-left: 20%;">
      <h3>${boardName}</h3>
   </div>
   <div style="margin: 0 auto; width: 60%;">
      <hr style="border: solid 2px #B0C4DE;" />
   </div>
   <div style="width: 100%; height: 100px;">
      <div class="sideImageBanner"
         style="width: 10%; float: left; margin-right: 3%; margin-left: 5%;">
         <p></p>
      </div>
      <div style="width: 60%; float: left;">
         <div class="form-group">
            <form id="frmPost" method="post" action="/post/registerPost">
               <%@ include file="./include/postCommon.jsp"%>
               <button id="btnRegisterPost" type="submit" class="btn btn-primary">등록</button>
               <button type="reset" class="btn btn-secondary">초기화</button>
               <input type="hidden" name="boardId" value="${boardId}"> 
               <input type="hidden" name="child" value="${child}">
            </form>
            <%@include file="../common/attachFileManagement.jsp"%>
         </div>
      </div>
      <div class="sideImageBanner" style="width: 10%; float: left; margin-left: 5%;">
         <img src="/resources/img/logos/sideBanner.png" style="height: 900px;">
      </div>
   </div>
</div>
<%@include file="../includes/footer.jsp"%>

<!-- End of Main Content -->

<script type="text/javascript">
   $(document).ready(function() {
      var csrfHN = "${_csrf.headerName}";
      var csrfTV = "${_csrf.token}";
      
      $(document).ajaxSend(function(e, xhr) {
         xhr.setRequestHeader(csrfHN, csrfTV);
      });
      
      //postCommon 의 controlInput('신규'); 를 실행하여 게시물 등록 가능하도록 하는 함수
      controlInput('신규');
      //attachFileManagement.jsp의 adjustCRUDAtAttach('신규');를 실행하여 첨부파일을 등록할 수 있게 함.
      adjustCRUDAtAttach('신규');

      var frmPost = $("#frmPost");

      $("#btnRegisterPost").on("click", function(e) {
         e.preventDefault();
         addAttachInfo(frmPost, "listAttachInStringFormat");
         frmPost.submit();
      });
   });
</script>