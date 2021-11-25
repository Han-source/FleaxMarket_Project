<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ page import="www.dream.com.bulletinBoard.model.PostVO"%>
<%@include file="../includes/header.jsp"%>

<!--  TableHeader에 정의된 static method를 사용하기 위함 -->
<jsp:useBean id="tablePrinter"
   class="www.dream.com.framework.printer.TablePrinter" />
<body>
 
<div class="container-fluid">
   <p> </p>
   <!-- DataTales Example -->
   <div class="card shadow mb-4">

      <div class="card-body">

 
         <!--  내가 결제한 상품 목록만 조회  -->         
         <div >
            <div>
                <section class="order-informationn-table">
        <div class="order-information-header">
            <div class="item-informationn info-top">상품정보</div>
            <div class="item-order-datee">주문일자</div>
            <div class="item-order-numberr">주문번호</div>
            <div class="item-order-amountt">주문금액</div>
            <div class="item-order-statuss">주문 상태</div>
        </div>
        <div class="order-inforamtion-bottom">
            <!-- start -->
            <div class="order-info-wrapp">
                <div class="item-informationn info-bottom">
                    <a href="#">
                        <div class="item-info-imagee" id="${post.id}">
                           <script>
                        $(document).ready(function() {
                           appendFunction('<c:out value="${post.attachListInGson}" />', '<c:out value="${post.id}" />', 120, 120);
                        });
                     </script>
                        </div>
                        <div class="item-info-text">
                            <p>판매자 : ${post.writer.userId} </p>
                            <p>상품명 : ${post.title} </p>
                            
                        </div>
                    </a>
                </div>
                <div class="item-order-datee">
                    <span>${tradeDate}</span>
                </div>
                <div class="item-order-numberr">
                    <span>${tradeId}</span>
                </div>
                <div class="item-order-amounttt">                                       
                    
                </div>
                <div class="item-order-statuss">
                    <p>구매확정</p>
                    <button>배송조회</button>
                    <button>후기작성</button>
                </div>
            </div>
            <!-- end -->

        </div>
    </section>
               <br>
               <section class="informationn-wrap">
              <div class="shipping-info-wrap">
                  <!-- left -->
                  <h3>배송지 정보</h3>
                  <div class="info-tablee">
                      <div class="ship-info-name info-flex-box">
                          <p class="info-flex-1">닉네임</p>
                          <p class="info-flex-2">${info.buyerId}</p>
                      </div>
                      <div class="ship-info-contact info-flex-box">
                          <p class="info-flex-1">연락처</p>
                          <p class="info-flex-2">${info.phonNum}</p>
                      </div>
                      <div class="ship-info-address info-flex-box">
                          <p class="info-flex-1">배송지 주소</p>
                          <p class="info-flex-2">${info.address}</p>
                      </div>
                      <div class="ship-info-message info-flex-box">
                          <p class="info-flex-1">배송 메세지</p>
                          <p class="info-flex-2">${info.absentMsg}</p>
                      </div>
                  </div>
              </div>
                  <!-- right -->
              <div class="discount-info-wrap">
                  <h3>할인 정보</h3>
                  <div class="info-tablee">

                      <div class="item-discount-info info-flex-box">
                          <p class="info-flex-1">상품할인</p>
                          <p class="info-flex-2">
                     <c:choose>
                             <c:when test="${negoBuyer eq null}"> 
                                 <span class="righttt">0원</span>
                             </c:when>
                             <c:otherwise> 
                                  <span class="righttt" id="minusPrice">
	                                   <script>
	                                   $(document).ready(function() {
	                                   getConvertWons(${product.productPrice - negoBuyer.discountPrice}, '#minusPrice');
	                                  });
	                         		  </script>	                         		  
                          	   </span>
                             </c:otherwise>
                         </c:choose> 

                     </p>
                      </div>

                      <div class="total-discount-info info-flex-box">
                          <p class="info-flex-1">할인 합계</p>
                          <p class="info-flex-2" id="totalPrice">
                           <script>
	                                   $(document).ready(function() {
	                                   getConvertWons(${productPrice}, '#totalPrice');
	                                  });
	                         		  </script>
                          
                          </p>
                      </div>
              </div>
      
              <div class="box_color"></div>
             </section>
            <input type="hidden" id="boardId" name="boardId" value="${paymentList[status.index].board.id}">
            <input type="hidden" id="child" name="child" value="${paymentList[status.index].board.parentId}">



               
               
                  </div>                           
            </div>
            <!-- Paging 처리 05.27 -->
            <!-- EL로 처리, Criteria.java에 있음  -->
            <div class='fa-pull-right'>${page.pagingDiv}</div>
   
   

         </div>
         
         
      </div>
   </div>

</body>
<%@include file="../includes/footer.jsp"%>
<script src="\resources\js\util\utf8.js"></script>
<script src="\resources\js\util\dateFormat.js"></script>
<script src="\resources\js\imgList\imgList.js"></script>
<!-- End of Main Content -->
<script type="text/javascript">
function appendFunction(attachVOInJson, id, w, h){
   imgService.oneImgAppend(attachVOInJson, id, w, h);
}

$(document).ready(function() {
   getConvertWons(${productPrice}, '.item-order-amounttt');
   /*05.31 검색에 관한 처리 -> 06.04 frmPaging 기능 새로 작성하기*/
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
   
   
   $('.anchor4product').on('click', function(e) {
      e.preventDefault();
      var productId = $(this).attr('href')
      frmSearching.append("<input name='productId' type='hidden' value='" + productId + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      var board = $('#boardId').val();
      var child = $(this).children('input#child').val();
      frmSearching.append("<input name='boardId' type='hidden' value='" + $('#boardId').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.append("<input name='child' type='hidden' value='" + $(this).children('input#child').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.attr('action', '/business/readProduct');
      frmSearching.attr('method', 'get');
      frmSearching.submit();
   });
});
   
   
   function productImgListFunction(attachVOInJson, uuid, id){
      imgService.productImgList(attachVOInJson, uuid, id, 120, 120);
   }
   
   function getConvertWons(price, state){
      dateFormatService.getConvertWon(price, state);
   }

</script>