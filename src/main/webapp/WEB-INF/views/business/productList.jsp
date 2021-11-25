<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ page import="www.dream.com.bulletinBoard.model.PostVO"%>
<%@include file="../includes/header.jsp"%>

<!--  TableHeader에 정의된 static method를 사용하기 위함 -->
<jsp:useBean id="tablePrinter"
   class="www.dream.com.framework.printer.TablePrinter" />
<style>
#sliderBody {
   float: left;
   width: 20%;
   height: 100px;
   padding: 0px;
   margin-right: 1%;
}

#header1 {
   height: 100px;
   border-bottom: 1px solid dimgrey;
   box-sizing: border-box;
   text-align: center;
   line-height: 100px;
   font-size: 1.5rem;
}

.slider {
   float: left;
   width: 50%;
   padding: 10px;
   height: 100%;
   overflow: hidden;
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
   
}

h3 {
   float: left;
}
</style>


<div class="container-fluid">
   <p>
   <div>
      <div style="margin-left: 20%;">
         <h3>${childBoardName}</h3>
         <form id="frmSearching" action="/business/productList" method="get">
            <div>
               <div style="width: 1000px; text-align: center;">
                  <div class="searching_box" style="border: 1px solid black; border-radius: 2px; width: 430px; margin: 0px; display: inline-block; text-align: center;">
                     <input type="text" name='searching' value="${page.searching}" style="vertical-align: middle;" placeholder="상품, 내용을 검색해보세요">
                     <span class="icon" id="btnSearch" style="margin-left: -30px;">
                        <i style="width: 20px; height: 20px;" class="fa fa-search"></i>
                     </span>
                  </div>
               </div>
            </div>
            <input type="hidden" name="boardId" value="${boardId}"> 
            <input type="hidden" name="child" value="${child}"> 
            <input type="hidden" name="parentBoardName" value="${parentBoardName}">
            <input type="hidden" name="pageNumber" value="${page.pageNumber}">
            <input type="hidden" name="amount" value="${page.amount}"> 
            <input type="hidden" name="findSelledProdutList" value="0">
         </form>
      </div>
      <div style="margin: 0 auto; width: 60%;">
         <hr style="border: solid 2px #B0C4DE;" />
      </div>
      <div style="width: 100%;">
         <!--  거래 완료된 상품리스트  -->
         <form id="frmSelledproductList" action="/business/productList" method="get">
            <input type="hidden" name="boardId" value="${boardId}"> 
            <input type="hidden" name="child" value="${child}"> 
            <input type="hidden" name="findSelledProdutList" value="1">
         </form>
         <div class="sideImageBanner" style="width: 16.2%; float: left;">
            <p></p>
         </div>
         <div class="itemm_wrapper" style="width: 65%; float: left;">
            <div class="itemm_container">
               <div class="itemm_heading_title" style="margin-left: 10%;"></div>
               <div style="margin-left: 5%;">
                  <p align="center">
                     <b> * ${childBoardName}를 통한 중고거래를 진행해보세요!</b>
                  </p>
                  <p align="center">* 안전거래를 이용하면 Fleax마켓에서 검수 후 물품을 보내드립니다!</p>
                  <button onclick="location.href='/business/productList?boardId=4&child=5'" id="btnMainProductList" class="btn btn-info" style="text-align: center; float: left; margin-right: 1%;">
                     <i class="far fa-list-alt"></i>전체글
                  </button>
                  <button id="btnSelledproductList" class="btn btn-info" style="text-align: center; float: left;">
                     <i class="far fa-list-alt"></i>거래완료글
                  </button>
                  <button type="button" id="btnRegisterProduct" class="btn btn-warning" style="float: right; margin-right: 7%;">
                     <i class="fas fa-pen-square"></i>
                  </button>
               </div>
               <div style="height: 10px;">
                  <p></p>
               </div>
               <br>
               <div style="margin: 0 auto; width: 90%;">
                  <hr style="border: solid 0.5px #8CBDED;" />
               </div>

               <div style="height: 10px;">
                  <p></p>
               </div>
               <div class="itemm_grid" style="padding: 50px;">
                  <!-- 상품  -->
                  <!--  상품 사진 출력 부분. -->
                  <c:forEach items="${productList}" var="product" varStatus="status">
                     <c:forEach var="attachVoInStr"
                        items="${product.attachListInGson}" varStatus="sta">
                        <div class="itemm">
                           <div class="itemm_img" id="${product.id}">
                              <script>
                                   $(document).ready(function() {
                                      productImgListFunction(
                                    		  '<c:out value="${productList[status.index].attachListInGson[sta.index]}" />', 
                                    		  '<c:out value="${productList[status.index].listAttach[sta.index].uuid}" />', 
                                    		  '<c:out value="${productList[status.index].id}" />');
                                   });
                               </script>
                           </div>
                           <!--  상품 추가 정보 입력하기. -->
                           <div class="itemm_details">
                              <p class="name">상품명 : ${product.title}</p>
                              <p class="price" id="${status.index}"></p>
                              <script>
	                                 $(document).ready(function() {
	                                       getConvertWons(${productList[status.index].product.productPrice}, '#${status.index}');
	                                 });
                              </script>
                           </div>
                        </div>
                     </c:forEach>
                  </c:forEach>
               </div>
            </div>
            <div class='fa-pull-right'>${page.pagingDiv}</div>
         </div>
         <div class="sideImageBanner" style="width: 10%; float: left; margin-left: 5%; margin-top: 15%;">
            <img src="/resources/img/logos/sideBannerBoard4.png" style="height: 1100px;">
         </div>
         <!-- Paging 처리 05.27 -->
         <!-- EL로 처리, Criteria.java에 있음  -->
         <!-- Modal -->
         <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
               <div class="modal-content">
                  <div class="modal-header">
                     <h4 class="modal-title" id="myModalLabel">상품 등록 완료!</h4>
                     <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  </div>
                  <div class="modal-body" id="modalBody">처리가 완료 되었습니다.</div>
                  <div class="modal-footer">
                     <button type="button" class="btn btn-info" data-dismiss="modal">닫기</button>
                  </div>
               </div>
            </div>
         </div>

         <!-- 상품 등록 관련 모달 -->
         <div id="productModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
               <div class="modal-content">
                  <div class="modal-header" style="text-align: center;">
                     <h4 class="modal-title" id="myModalLabel" align="center" style="margin: 0 auto;">거래방식을 선택해 주세요</h4>
                  </div>
                  <!-- End of modal-header -->
                  <div class="modal-body" id="modalProductBody" style="text-align: center;">
                     <c:forEach items="${childBoardList}" var="child">
                        <button class='btn btn-default' type="button"
                           onclick="location.href='/business/registerProduct?boardId=4&child=${child.id}'">${child.name}</button>
                     </c:forEach>
                  </div>
                  <div class="modal-footer">
                     <button id='btnCloseModal' type="button" class="btn btn-default">취소</button>
                  </div>
               </div>
            </div>
         </div>
         <!-- /.modal -->

      </div>
<%@include file="../includes/footer.jsp"%>
<script src="\resources\js\util\utf8.js"></script>
<script src="\resources\js\util\dateFormat.js"></script>
<script src="\resources\js\imgList\imgList.js"></script>

<script type="text/javascript">
   $(document).ready(function() {
   //상품 등록 버튼 클릭시
   $("#btnRegisterProduct").on("click", function(e) {
      $("#productModal").modal("show");               
   });
    
    //상품 등록 취소 버튼 클릭시
   $("#btnCloseModal").on("click", function(e) {
      $("#productModal").modal("hide");
   });
      
    var result = '<c:out value="${result}"/>';
   
   checkModal(result); // checkModal 함수 호출
   
   history.replaceState({}, null, null);

   function checkModal(result){
      if (result === '' || history.state){ 
         return;
      }
      if (result.length == ${PostVO.ID_LENGTH}) { 

         $("#modalBody").html("상품이 정상적으로 등록되었습니다!");
      } else {
         $("#modalBody").html("상품" + result + "하였습니다.");
      }
      
      $("#myModal").modal("show");
   }
 
   /*검색어 입력시*/
   var frmSearching = $('#frmSearching');
   $('#btnSearch').on('click', function(eInfo) {
      eInfo.preventDefault();
      
      if ($('input[name="searching"]').val().trim() === '') {
         alert('검색어를 입력하세요');
         return;
      }
      // 신규 조회 이므로 1쪽을 보여줘야 합니다.
      $("input[name='pageNumber']").val("1");
      
      frmSearching.submit();
   });
    //거래완료 글 페이징처리
    var frmSelledproductList = $('#frmSelledproductList');
    $('#btnSelledproductList').on('click', function(eInfo) {
         eInfo.preventDefault();

         //신규 조회이므로 1쪽을 보여줘야합니다
         $("input[name='pageNumber']").val("1");

         frmSelledproductList.submit();
     });      

    /*Paging 처리에서 특정 쪽 번호를 클릭하였을때 해당 page의 정보를 조회하여 목록을 재출력 해줍니다. */
   var frmPaging = $('#frmPaging');
   $('.page-item a').on('click', function(eInfo) {
      eInfo.preventDefault();
      $("input[name='pageNumber']").val($(this).attr('href')); //여기 val이 중요하다. Click이 일어난 곳=this 거기가 href 처리해둔곳
      frmSearching.submit();
   });
   
   /*상품 클릭시 상세 조회*/
   $('.itemm').on('click', function(e) {
      e.preventDefault();
      var productId = $(this).children('.itemm_img').attr('id')
      frmSearching.append("<input name='productId' type='hidden' value='" + productId + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.attr('action', '/business/readProduct');
      frmSearching.attr('method', 'get');
      frmSearching.submit();
   });
});
   
   //상품 이미지 출력 함수
   function productImgListFunction(attachVOInJson, uuid, id){
      imgService.productImgList(attachVOInJson, uuid, id, 271, 300);
   }

   //가격 출력시 1000 -> '1,000원' 으로 변경
   function getConvertWons(price, state){
         dateFormatService.getConvertWon(price, state);
      }
</script>