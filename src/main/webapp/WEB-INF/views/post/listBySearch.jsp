<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../includes/header.jsp"%>
<%@ page import="www.dream.com.bulletinBoard.model.PostVO"%>

<!-- TableHeader에 정의된 static method를 사용하기 위해 정의함 -->
<jsp:useBean id="tablePrinter"
   class="www.dream.com.framework.printer.TablePrinter" />
<style>
table {
   width: 100%;
   border-top: 1px solid #444444;
   border-collapse: collapse;
}

th, td {
   border-bottom: 1px solid #444444;
   padding: 10px;
}

.searching_box {
   width: 900px;
}

/* input text css 건드리기 */
input[type=text] {
   font-size: 15px;
   width: 400px;
   padding: 10px;
   border: 0px;
   outline: none;
   float: center;
}

/* input text안에 image를 넣을 생각을 하는중 */
input[type=button] {
   width: 50px;
   height: 42px;
   border: 0px;
   background: #1b5ac2;
   outline: none;
   color: #aaaaaa;
   font-size: 14px;
   float: center;
   margin-left: -50px;
}

/* 검색 전 보여주는 placeholder 글씨 색상 조절 크롬에서 */
input ::-webkit-input-placeholder {
   color: red;
}
/* input tag를 넣는 div 값 */
.searching_box {
   width: 420px;
}
</style>
<!-- End of Topbar -->

<!-- Begin Page Content -->
<div class="container-fluid">
   <!-- DataTales Example -->
   <p>
   <div>
      <div style="margin-left: 20%;">
         <h3>${boardName}</h3>
      </div>
      <div style="margin: 0 auto; width: 60%;">
         <hr style="border: solid 2px #B0C4DE;" />
      </div>

      <div>
         <div style="margin-left: 40%;">
            <!-- Paging 이벤트에서 서버로 요청보낸 인자들을 관리합니다. -->
            <form id="frmSearching" action="/post/listBySearch" method="get">
               <!--  정렬 방식 -->
               <div>
                  <div style="width: 630px;">
                     <div class="searching_box"
                        style="border: 1px solid black; border-radius: 2px; width: 430px; margin: 0px; display: inline-block;">
                        <input type="text" name="searching" placeholder="내용을 검색해보세요" value="${pagination.searching}" /> 
                        <span class="icon" id="btnSearch" style="margin-left: -30px;">
                           <i style="width: 20px; height: 20px;" class="fa fa-search"></i>
                        </span>
                     </div>
                     <c:choose>
                        <c:when test="${descrim eq 'User' and boardId eq 3}">
                           <button id="btnRegisterPost" class="btn btn-warning" style="float: right; vertical-align: top;">
                              <i class="fas fa-pen-square"></i>
                           </button>
                        </c:when>
                        <c:when test="${descrim eq 'Admin'}">
                           <button id="btnRegisterPost" class="btn btn-warning">
                              <i class="fas fa-pen-square"></i>
                           </button>
                           <button id="btnBatchDeletePost" class="btn btn-info">일괄삭제</button>
                        </c:when>
                     </c:choose>
                  </div>
               </div>
               <!-- c: if 조건문으로, descrim이 관리자인지, 공지사항, faq 의 boardId(1,2) => 이 두조건이 해당할때만 열어줌 -->
               <input type="hidden" name="boardId" value="${boardId}"> <input
                  type="hidden" name="child" value="${child}"> <input
                  type="hidden" name="pageNumber" value="${pagination.pageNumber}">
               <input type="hidden" name="amount" value="${pagination.amount}">
               <input type='hidden' name='${_csrf.parameterName}'
                  value='${_csrf.token}'> <input type="hidden"
                  name="ListFromLike" value="0">
            </form>

            <form id="frmLikeRank" action="/post/listBySearch" method="get">
               <input type="hidden" name="boardId" value="${boardId}"> <input
                  type="hidden" name="child" value="${child}"> <input
                  type="hidden" name="pageNumber" value="${pagination.pageNumber}">
               <input type="hidden" name="amount" value="${pagination.amount}">
               <input type='hidden' name='${_csrf.parameterName}'
                  value='${_csrf.token}'> <input type="hidden"
                  name="ListFromLike" value="1">
            </form>

         </div>
         <div style="margin-left: 18%;">
            <a href="/post/listBySearch?boardId=3&child=0"><button
                  class="btn btn-success">전체글</button></a> <a><button
                  id="btnRankingLike" class="btn btn-success">개념글</button></a>
         </div>
         <div style="width: 100%;">
            <p></p>
         </div>

         <div style="width: 100%; height: 100px;">
            <div class="sideImageBanner"
               style="width: 10%; float: left; margin-right: 3%; margin-left: 5%;">
               <p></p>
            </div>
            <div style="width: 60%; float: left;">
               <table id="dataTable" width="100%" cellspacing="0">
                  <thead>
                     <tr>
                        <th id="noneAdmin">선택</th>
                        <%=tablePrinter.printHeader(PostVO.class)%>
                     </tr>
                  </thead>

                  <tbody>
                     <c:forEach items="${listPost}" var="post">
                        <tr class="anchor4post" id="${post.id}">
                           <c:choose>
                              <c:when test="${empty post.listAttach}">
                                 <c:if test="${descrim eq 'Admin'}">
                                    <td id="noneAdmin1" style="text-align: center;" onclick="event.cancelBubble=true">
                                    <input type="checkbox" name="chkpost" id="chkposts" value="${post.id}"></td>
                                 </c:if>
                                 <td style="text-align: left;">
                                    <i class="far fa-comment-dots" style="margin-right: 40%;"></i>${post.title}
                                 </td>
                                 <td style="text-align: center;">${post.writer.name}</td>
                                 <td style="text-align: center;">${post.readCnt}</td>
                                 <td style="text-align: center;"><fmt:formatDate
                                       pattern="yyyy년 MM월 dd일" value="${post.updateDate}" /></td>
                              </c:when>
                              <c:otherwise>
                                 <c:if test="${descrim eq 'Admin'}">
                                    <td id="noneAdmin1" style="text-align: center;"
                                       onclick="event.cancelBubble=true"><input
                                       type="checkbox" name="chkpost" id="chkposts"
                                       value="${post.id}"></td>
                                 </c:if>
                                 <td style="text-align: left;"><i class="far fa-images"
                                    style="margin-right: 40%;"></i>${post.title}</td>
                                 <td style="text-align: center;">${post.writer.name}</td>
                                 <td style="text-align: center;">${post.readCnt}</td>
                                 <td style="text-align: center;"><fmt:formatDate
                                       pattern="yyyy년 MM월 dd일" value="${post.updateDate}" /></td>
                              </c:otherwise>
                           </c:choose>
                        </tr>
                     </c:forEach>
                  </tbody>
               </table>

               <!-- 페이징 처리 -->
               <div class='fa-pull-right'>${pagination.pagingDiv}</div>
               <!-- Modal -->
               <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
                  aria-labelledby="myModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                     <div class="modal-content">
                        <div class="modal-header">
                           <h4 class="modal-title" id="myModalLabel">게시글 등록 완료!</h4>
                           <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modal-body">처리가 완료 되었습니다.</div>
                        <div class="modal-footer">
                           <button type="button" class="btn btn-info"  data-dismiss="modal">닫기</button>                          
                        </div>
                     </div>
                     <!-- /.modal-content -->
                  </div>
                  <!-- /.modal-dialog -->
               </div>
               <!-- /.modal -->
            </div>

            <div class="sideImageBanner"
               style="width: 10%; float: left; margin-left: 5%;">
               <img src="/resources/img/logos/sideBanner.png"
                  style="height: 900px;">
            </div>
         </div>
      </div>
   </div>
</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->

<%@ include file="../includes/footer.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
   
// 비 로그인 상황일때 보여줄 화면
if (${descrim != 'User' and descrim != 'Admin'}){
      $('#noneAdmin').remove();
      var nA1 = $('#noneAdmin1');
      for (nA1 = 0; nA1 < 10; nA1++) {
         $('#noneAdmin1').remove();
      } 
   // User일때 보여줄 화면 
   } else if(${descrim == 'User'}){
      $('#noneAdmin').remove();
      var nA1 = $('#noneAdmin1');
      for (nA1 = 0; nA1 < 10; nA1++) {
         $('#noneAdmin1').remove(); // 이쪽 부분이 반복이 안돌아감.
      }
   }
   
      var frmSearching = $('#frmSearching');
      
      //글쓰기 버튼
      $("#btnRegisterPost").on("click", function(){
           frmSearching.attr('action', '/post/registerPost');
           frmSearching.submit();   
     });
   
     //모달 띄우기
     var result = '<c:out value="${result}" />';
     checkModal(result);
     history.replaceState({} , null, null);
     
     function checkModal(result){
        if(result === '' || history.state){
           return;
        }
        if(result.length == ${PostVO.ID_LENGTH}){
           $(".modal-body").html("게시글이  정상적으로 등록되었습니다!");
        }else{
           $(".modal-body").html("게시글이 " + result + " 되었습니다");
        }
        $("#myModal").modal("show");
     }

     //검색 버튼
     $('#btnSearch').on('click', function(eInfo) {
        eInfo.preventDefault();
        if ($('input[name="searching"]').val() === '') {
           alert('검색어를 입력하세요');
           return;
        }
        //신규 조회시 페이지를 1로 설정
        $("input[name='pageNumber']").val("1");
        frmSearching.submit();
     });
     
     // 버튼 누를 시 좋아요 제일 높은거 출력
     $('#btnRankingLike').on('click', function(eInfo) {
         eInfo.preventDefault();
        //신규 조회시 페이지를 1로 설정
         $("input[name='pageNumber']").val("1");
         frmLikeRank.submit();
      });

     /* 페이징 처리에서 특정 쪽 번호를 클릭하였을 때 해당 페이지의 정보를 조회하여 목록을 재 출력해 줍니다. */
     $('.page-item a').on('click', function(eInfo) {
        eInfo.preventDefault();
        $("input[name='pageNumber']").val($(this).attr('href'));
        frmSearching.submit();
     });

     /* 특정 게시물에 대한 상세 조회 처리 */
     $('.anchor4post').on('click', function(e) {
        e.preventDefault();
        var postId = $(this).attr('id');
        frmSearching.append("<input name='postId' type='hidden' value='" + postId + "'>");
        frmSearching.attr('action', '/post/readPost');
        frmSearching.attr('method', 'get');
        frmSearching.submit();
     });
     
     /* 관리자 Mode 여러 게시물을 선택하여 일괄적으로 삭제, 선택이 안되어있으면 삭제 불가능 */
    $('#btnBatchDeletePost').on('click', function(e) {
       var a = document.querySelectorAll('input[name="chkpost"]:checked');
       if(document.querySelectorAll('input[name="chkpost"]:checked').length == 0) {
        alert('삭제할 게시글을 선택해주세요.');
          } else {
          document.querySelectorAll('input[name="chkpost"]:checked').forEach((cel)=> {
                frmSearching.append("<input name='postIds' type='hidden' value='" + cel.value + "'>");
             });
             frmSearching.attr('action', '/post/batchDeletePost');
             frmSearching.attr('method', 'post');
             frmSearching.submit();
             }
          });
});

</script>