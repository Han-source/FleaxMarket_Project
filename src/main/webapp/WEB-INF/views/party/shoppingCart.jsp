<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ page import="www.dream.com.bulletinBoard.model.PostVO"%>
<%@include file="../includes/header.jsp"%>

<!--  TableHeader에 정의된 static method를 사용하기 위함 -->
<jsp:useBean id="tablePrinter"
   class="www.dream.com.framework.printer.TablePrinter" />
<!-- Begin Page Content -->
<%@ include file="../includes/subMenu.jsp"%>
<div class="inline-blockk" style="width: 80%;">
   <h3>장바구니</h3>
   <div class="container-fluid">
      <p></p>
      <!-- DataTales Example -->
      <div>
         <div>

            <form id="frmSearching" action="/product/readProduct" method="get">
            </form>
            <!--  내가 결제한 상품 목록만 조회  -->
            <div>
               <div>
                  <section class="order-informationn-table">
                     <div class="order-information-header">
                        <div class="item-informationn info-top">상품정보</div>
                        <div class="item-order-product-name">판매자</div>
                        <div class="item-order-numberr">등록일</div>
                        <div class="item-order-amountt">상품금액</div>
                        <div class="item-order-buyer">장바구니에서 삭제</div>
                     </div>
                     <c:forEach items="${shopCart}" var="product" varStatus="status">
                        <div class="order-inforamtion-bottom">
                           <!-- start -->
                           <div class="order-info-wrapp">
                              <div class="item-informationn info-bottom">
                                 <a class='anchor4product' href="${product.id}">
                                    <div class="item-info-imagee">
                                       <div class="slider" id="${product.id}">
                                          <ul class="slider__images" style="list-style: none;">
                                             <c:forEach var="attachVoInStr"
                                                items="${product.attachListInGson}" varStatus="sta">
                                                <script>
                                                // 장바구니 게시물에 등록되어있는 사진을 띄워주는 함수
                                                  $(document).ready(function() {
                                                    productImgListFunction('<c:out value="${shopCart[status.index].attachListInGson[sta.index]}" />',
                                                          '<c:out value="${shopCart[status.index].listAttach[sta.index].uuid}" />',
                                                          '<c:out value="${shopCart[status.index].id}" />');
                                                   });
                                               </script>
                                             </c:forEach>
                                          </ul>
                                       </div>
                                    </div>
                                    <div class="item-info-text">
                                       <p>상품명 : ${product.title}</p>
                                    </div>
                                    <input type="hidden" id="childId" name="child" value="${shopCart[status.index].board.parentId}">
                                    <input type="hidden" id="boardId" name="boardId" value="${shopCart[status.index].board.id}">

                                    <form id="frmRemoveShopCart" action="/party/removeShopppingCart" method="post">
                                       <input type="hidden" id="productId" name="productId" value="${product.id}">
                                       <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
                                    </form>
                                 </a>
                              </div>
                              <div class="item-order-datee">
                                 <span>${shopCart[status.index].writer.userId}</span>
                              </div>
                              <div class="item-order-numberr">
                                 <span>${shopCart[status.index].registrationDate}</span>
                              </div>
                              <div class="item-order-amountt" id="${status.index}">
                                 <span> <script>
                                 // 장바구니에서 게시글의 가격을 보여주는 함수
                                       $(document).ready(function() {
                                          getConvertWons(${shopCart[status.index].product.productPrice}, '#${status.index}');
                                       });
                                    </script>
                                 </span>
                              </div>
                              <div class="item-order-buyer">
                                 <button class="btn btn-danger" id="btnRemoveShopCart">삭제</button>
                              </div>

                           </div>
                           <!-- end -->
                        </div>
                        <div class="card-body" style="float: left; width: 50%; padding: 10px;">
                           <br> <br>
                        </div>
                     </c:forEach>
                  </section>
               </div>
            </div>
            <div class='fa-pull-right'>${page.pagingDiv}</div>
         </div>
      </div>
   </div>
</div>


<%@include file="../includes/footer.jsp"%>
<script src="\resources\js\util\utf8.js"></script>
<script src="\resources\js\util\dateFormat.js"></script>
<script src="\resources\js\imgList\imgList.js"></script>

<!-- End of Main Content -->
<script type="text/javascript">
   $(document).ready(function() {
    // 등록 버튼 클릭시에 등록 기능을 작동하는 함수
   $("#btnRegisterPost").on("click", function() {
      frmSearching.attr('action', '/post/registerPost');
      frmSearching.submit();
   });
    
   //상품 등록 버튼 클릭시에 나오는 Modal창
   $("#btnRegisterProduct").on("click", function(e) {
      $("#productModal").modal("show");               
   });
    
   //Modal창 닫기 버튼
   $("#btnCloseModal").on("click", function(e) {
      $("#productModal").modal("hide");
   });
      
    var result = '<c:out value="${result}"/>';
   
            
   // history.replaceState({}, null, null); 여기에 위치하면, 아무리 등록해도 Modal창이 안뜰것
   // 부르기 전에 상태를 넣었기때문에 글을 등록해도 Modal창이 안뜰것
   
   checkModal(result); // checkModal 함수 호출
   
   history.replaceState({}, null, null);
   // Modal창이 여러번 뜨는걸 방지하기 위한 Code1 (stateObj, title[, url]) -> Obj = {}이다 이는 null과 같은 의미
   // history객체야 상태를 변경하자, ({}, null, null) 한마디로 null이라는 상황이다. 넣어야하는 객체가 위처럼 3개라서 그렇지. 
   
   function checkModal(result){
      if (result === '' || history.state){ 
         return;
      }
      if (result.length == ${PostVO.ID_LENGTH}) { 

         $("#modalBody").html("게시글 " + result + "번이 등록되었습니다.");
      } else {
         $("#modalBody").html("게시글에 대한 " + result + "하였습니다.");
      }
      
      $("#myModal").modal("show");
   }
   
   
   //frmPaging 기능을 통해 검색에 관한 처리
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
   
   // Paging 처리에서 특정 쪽 번호를 클릭하였을때 해당 page의 정보를 조회하여 목록을 재출력 해줍니다.
   var frmPaging = $('#frmPaging');
   $('.page-item a').on('click', function(eInfo) {
      eInfo.preventDefault();
      $("input[name='pageNumber']").val($(this).attr('href')); 
      frmSearching.submit();
   });
   
   // 특정 게시물에 대한 상세 조회 처리 함수
   $('.anchor4product').on('click', function(e) {
      e.preventDefault();
      var productId = $(this).attr('href');
      var as =  $('#boardId').val();
      var asb =   $(this).children('#childId').val() 
      frmSearching.append("<input name='productId' type='hidden' value='" + productId + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.append("<input name='boardId' type='hidden' value='" + $('#boardId').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.append("<input name='child' type='hidden' value='" + $(this).children('input#childId').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.attr('action', '/business/readProduct');
      frmSearching.attr('method', 'get');
      frmSearching.submit();
   });
   
   // 장바구니에 담아둔 목록 제거 함수
   var frmRemoveShopCart = $('#frmRemoveShopCart');
   $('#btnRemoveShopCart').on("click", function() {
      frmRemoveShopCart.submit();
   });
   
});
   
   
     function productImgListFunction(attachVOInJson, uuid, id){
         imgService.productImgList(attachVOInJson, uuid, id, 120, 120);
      }
     
     function getConvertWons(price, state){
       dateFormatService.getConvertWon(price, state);
    }

</script>