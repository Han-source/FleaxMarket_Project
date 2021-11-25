<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>


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
            <form id='frmPost' action="/post/modifyPost" method="post">
               <div class="form-group">
                  <input name="id" type="hidden" value="${post.id}"
                     class="form-control" readonly>
               </div>
               <div style="height: 50px;">
                  <label>작성자 : </label> 
                  <span>
                     <b><sec:authentication property="principal.curUser.userId" /></b>
                  </span>
               </div>
               <div style="margin: 0 auto; width: 100%;">
                  <hr style="border: solid 0.5px #f5f5f5;" />
               </div>
               <div>
                  <input id="title" name="title" value="${post.title}" class="form-control" style="width: 60%;" placeholder="제목을 입력해 주세요">
               </div>
               <%@include file="../common/attachFileManagement.jsp"%>
               <div style="height: 300px; width: 100%; display: table-cell; vertical-align: middle;" class="form-group">
                  <textarea id="txaContent" name="content" class="form-control" rows="10" style="width: 700%; margin: 5px 0; padding: 3px;">
                     ${post.content}
                  </textarea>
               </div>

               <sec:authentication property="principal" var="customUser" />
               <sec:authorize access="isAuthenticated()">
                  <c:if test="${customUser.curUser.userId eq post.writer.userId}">
                     <button type="submit" data-oper='modify' class="btn btn-primary">수정</button>
                     <button type="submit" data-oper='remove' class="btn btn-danger">삭제</button>
                  </c:if>
               </sec:authorize>
               <button type="submit" data-oper='list' class="btn btn-secondary">목록으로</button>

               <input id="boardId" type="hidden" name="boardId" value="${boardId}">
               <input type="hidden" name="postId" value="${post.id}"> 
               <input type="hidden" name="child" value="${child}"> 
               <input type="hidden" name="writerId" value="${customUser.curUser.userId}">
               <input type="hidden" name="pageNumber" value="${pagination.pageNumber}"> 
               <input type="hidden" name="amount" value="${pagination.amount}"> 
               <input type="hidden" name="searching" value='${pagination.searching}'>
               <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
            </form>
         </div>
      </div>
      <div class="sideImageBanner"
         style="width: 10%; float: left; margin-left: 5%;">
         <img src="/resources/img/logos/sideBanner.png" style="height: 900px;">
      </div>
   </div>
</div>

<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
   $(document).ready(function() {
      //spring security에서 post방식에선 csrf토큰이 필요
      var csrfHN = "${_csrf.headerName}";
      var csrfTV = "${_csrf.token}";
      
      //Post방식의 ajax 전송시 beforeSend를 개별적으로 수행하지 않고 한번에 실행
      $(document).ajaxSend(function(e, xhr) {
         xhr.setRequestHeader(csrfHN, csrfTV);
      });
      
      //수정이라는 값을 넘겨주어 해당 jsp를 수정할수 있게 함
      adjustCRUDAtAttach('수정');

      //첨부파일 이미지 띄우기
      <c:forEach var="attachVoInStr" items="${post.attachListInGson}" >
         appendUploadUl('<c:out value="${attachVoInStr}" />');
      </c:forEach>

      //empty라고 하는 기능은 form에 담겨있는 모든 하위 요소를 없애버려라.
      var frmPost = $("#frmPost");
      $("button").on("click", function(eventInfo) { 
         // 이벤트 처리의 전파(퍼져 나가는뜻)를 막아서 미리 개발되어있는 event 처리를 막음
         eventInfo.preventDefault(); 
         var oper = $(this).data('oper'); 
         if (oper === 'remove') {
            frmPost.attr('action', "/post/removePost");
         } else if (oper === 'list') {
            var boardIdInput = frmPost.find("#boardId");
            var child = frmPost.find("#child");
            var pageNumber = $('input[name="pageNumber"]');
            var amount = $('input[name="amount"]');

            var searching = $('input[name="searching"]');

            frmPost.attr("method", "get");
            frmPost.attr('action', "/post/listBySearch");
            frmPost.append(boardIdInput);
            frmPost.append(child);
            frmPost.append(pageNumber);
            frmPost.append(amount);
            frmPost.append(searching);

         } else if (oper === 'modify') {
            addAttachInfo(frmPost, "listAttachInStringFormat");
         }
         frmPost.submit(); 
      });
   });
</script>