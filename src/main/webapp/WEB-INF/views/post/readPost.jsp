<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../includes/header.jsp"%>

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
      <div class="sideImageBanner" style="width: 10%; float: left; margin-right: 3%; margin-left: 5%;">
         <p></p>
      </div>
      <div style="width: 60%; float: left;">
         <div style="margin-bottom: 3%;">
            <input name="id" type="hidden" value="${post.id}" class="form-control" readonly>
         </div>
         <div style="margin-bottom: 3%;">
            <span><h4>${post.title}</h4></span>
         </div>
         <div class="form-group">
            <span style="margin-right: 10%;">${post.writer.name}</span> 
            <span><fmt:formatDate pattern="yyyy-MM-dd" value="${post.registrationDate}" /></span> 
            <span id="like" style="float: right;"> 
               <i class="fas fa-heart"></i>
               <i id="likecnt">${post.likeCnt}</i>
            </span>
         </div>
         <hr>
         <div style="height: 300px; display: table-cell; vertical-align: middle;">
            <span>${post.content}</span>
         </div>

         <div class="form-group" style="float: right;">
            <p> 조회 
               <b>${post.readCnt}</b> 회
            </p>
         </div>

         <sec:authentication property="principal" var="customUser" />
         <sec:authorize access="isAuthenticated()">
            <c:if test="${customUser.curUser.userId eq post.writer.userId}">
               <button data-oper='modify' class="btn btn-primary">수정</button>
            </c:if>
            <c:if test="${customUser.curUser.userId ne post.writer.userId}">
               <button data-oper='chat' class="btn btn-warning">채팅하기</button>
            </c:if>
         </sec:authorize>

         <button data-oper='list' class="btn btn-info">목록</button>

         <form id="frmChat" action="/chat/chatting" method="get">
            <input type="hidden" id="toId" name="toId"
               value="${post.writer.userId}">
         </form>

         <form id='frmOper' action="/post/modifyPost" method="get">
            <input type="hidden" name="boardId" value="${boardId}"> <input
               type="hidden" name="child" value="${child}"> <input
               type="hidden" id="postId" name="postId" value="${post.id}">
            <input type="hidden" name="pageNumber"
               value="${pagination.pageNumber}"> <input type="hidden"
               name="amount" value="${pagination.amount}"> <input
               type="hidden" name="searching" value='${pagination.searching}'>
         </form>
         <%@include file="../common/attachFileManagement.jsp"%>
         <%@include file="./include/replyManagement.jsp"%>
      </div>
      <div class="sideImageBanner"
         style="width: 10%; float: left; margin-left: 5%;">
         <img src="/resources/img/logos/sideBanner.png" style="height: 900px;">
      </div>
   </div>
</div>
<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
$(document).ready( function() {
   // adjustCRUDAtAttach함수에 조회 라는 인자를 던져주어 조회만 할 수 있게 함
   adjustCRUDAtAttach('조회');
   
   // 해달 게시물에 사진띄우기
   <c:forEach var="attachVoInStr" items="${post.attachListInGson}" >
      appendUploadUl('<c:out value="${attachVoInStr}" />');
   </c:forEach>

   //수정하기
   $("button[data-oper='modify']").on("click", function() {
      $("#frmOper").submit();
   });

   //목록으로 돌아가기
   $("button[data-oper='list']").on("click", function() {
      $("#frmOper").find("#postId").remove();
      $("#frmOper").attr("action", "/post/listBySearch").submit();
   });

   //채팅 팝업 띄우기
   $("button[data-oper='chat']").on("click", function() {
      window.open("../chat/chatting?toId=${post.writer.userId}", "_blank", "width=400,height=500,left=1200,top=10");
   });
});

   //좋아요를 눌렀을때
   $("#like").click(function() {
      var id = "${post.id}"
      var userId = "${userId}"
      //좋아요를 누른적이 있는지 검사하는 함수.
      var checkLike = checkLikeSelect();

      var header = $("meta[name='_csrf_header']").attr("content");
      var token = $("meta[name='_csrf']").attr("content");
      var csrfHN = "${_csrf.headerName}";
      var csrfTV = "${_csrf.token}";
      $.ajax({
         url : "/post/UDlikeCnt",
         type : "POST",
         data : {
            id : id,
            userId : userId,
            checkLike : checkLike
         },
         beforeSend : function(xhr) {
            xhr.setRequestHeader(csrfHN, csrfTV);
         },
         success : function(data) {
            if ($('#check').val() == '1') {
               $('#check').val('0');
            } else {
               $('#check').val('1');
            }
            //alert(data);
            console.log(data);
            $("#likecnt").html(data);
         }
      })
   });

   /**
   좋아요를 누를적이 있는지 검사하는 함수
   */
   function checkLikeSelect() {
      var id = "${post.id}"
      var userId = "${userId}"
      var check;
      $.ajax({
         url : "/post/checkLike",
         type : "GET",
         async : false,
         data : {
            id : id,
            userId : userId,
         },
         success : function(data) {
            check = data
         }
      })
      return check;
   }
</script>
