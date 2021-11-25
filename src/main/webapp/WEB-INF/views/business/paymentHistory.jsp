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
<%@ include file="../includes/subMenu.jsp"%>
<div class="inline-blockk" style="width: 80%;">
<h3>결제내역</h3>
<div class="container-fluid">
   <div>
      <div>
         <form id="frmSearching" action="/product/readProduct" method="get">
         </form>
         <!--  내가 결제 완료한 상품 목록 출력  -->         
         <div >
            <div>
               <section class="order-informationn-table">
                    <div class="order-information-header">
                        <div class="item-informationn info-top">상품정보</div>
                        <div class="item-order-datee">주문일자</div>
                        <div class="item-order-numberr">주문번호</div>
                        <div class="item-order-amountt">주문금액(수량)</div>
                        <div class="item-order-statuss">주문 상태</div>
                    </div>
                  <c:forEach items="${paymentList}" var="product" varStatus="status">                                           
                        <div class="order-inforamtion-bottom">
                           <!-- start -->
                           <div class="order-info-wrapp">
                               <div class="item-informationn info-bottom">
                                   <a class='anchor4product' href="${product.id}" >
                                   <div class="item-info-imagee">
                                         <div class="slider" id="${product.id}">
		                                     <ul class="slider__images" style="list-style:none;">
		                                        <c:forEach var="attachVoInStr" items="${product.attachListInGson}" varStatus="sta">
		                                          <script>
		                                             $(document).ready(function() {
		                                                productImgListFunction('<c:out value="${paymentList[status.index].attachListInGson[sta.index]}" />', '<c:out value="${paymentList[status.index].listAttach[sta.index].uuid}" />', '<c:out value="${paymentList[status.index].id}" />');
		                                             });
		                                          </script>                     
		                                    </c:forEach>
		                                    </ul>
		                                    </div>  
                                   </div>
                                       <div class="item-info-text">
                                           <p>판매자 : ${post.writer.userId}</p>
                                           <p>상품명 : ${product.title}</p>
                                       </div>
                              <input type="hidden" id="child" name="child" value="${paymentList[status.index].board.parentId}">
                              <input type="hidden" id="boardId" name="boardId" value="${paymentList[status.index].board.id}">                              
                              <input type="hidden" id="tradeId" name="tradeId" value="${paymentList[status.index].trade.tradeId}">                      
                              <input type="hidden" id="tradeDate" name="tradeDate" value="${paymentList[status.index].trade.tradeDate}">
                               <input type="hidden" id="productPrice" name="productPrice" value="${paymentList[status.index].trade.productFinalPrice}">
                                   </a>
                               </div>
                               <div class="item-order-datee">
                                   <span>${paymentList[status.index].trade.tradeDate}</span>
                               </div>
                               <div class="item-order-numberr">
                                   <span>${paymentList[status.index].trade.tradeId}</span>
                               </div>
                               <div class="item-order-amountt" id="${status.index}">
                                   <script>
                                        $(document).ready(function() {
	                                        getConvertWons(${paymentList[status.index].trade.productFinalPrice}, '#${status.index}');
                                        });
                                 </script>
                               </div>
                               
                               <c:if test="${paymentList[status.index].trade.adminPermission  == 0}">
								   <div class="item-order-statuss">
	                                   <p>관리자 확인중</p>
	                               </div>
	                           </c:if>        
                               <c:if test="${paymentList[status.index].trade.adminPermission  == 1}">
	                               <div class="item-order-statuss">
	                                   <p>구매확정</p>
	                                   <button>배송조회</button>
	                                   <button>후기작성</button>
	                               </div>
	                           </c:if>
	                           <c:if test="${paymentList[status.index].trade.adminPermission  == 2}">
	                               <div class="item-order-statuss">
	                                   <p>관리자가 거래를 거절했습니다.</p>
	                               </div>
	                           </c:if>
                           </div>
                           <!-- end -->
                         </div>
                        <div class="card-body" style="float: left; width: 50%; padding:10px;">

                              
                       
                           <br>

                           <br>

                        </div> 
               </c:forEach>
               </section>   
                  </div>                           
            </div>
            <!-- Paging 처리 05.27 -->
            <!-- EL로 처리, Criteria.java에 있음  -->
            <div class='fa-pull-right'>${page.pagingDiv}</div>
   
   

         </div>
         
         
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
   $(document).ready(function() {
      

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
      var a = $(this).children('input#tradeId').val();
      
      var productId = $(this).attr('href')
      frmSearching.append("<input name='productId' type='hidden' value='" + productId + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      var board = $('#boardId').val();
      var s = $(this).children('input#tradeId').val();
      
      frmSearching.append("<input name='boardId' type='hidden' value='" + $('#boardId').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.append("<input name='child' type='hidden' value='" + $(this).children('input#child').val() + "'>"); // 문자열을 끝내고 이어받아서 return값 호출
      frmSearching.append("<input name='tradeId' type='hidden' value='" + $(this).children('input#tradeId').val() + "'>");
      frmSearching.append("<input name='tradeDate' type='hidden' value='" + $(this).children('input#tradeDate').val() + "'>");
      frmSearching.append("<input name='productPrice' type='hidden' value='" + $(this).children('input#productPrice').val() + "'>");
      frmSearching.attr('action', '/business/paymentReadHistory');
      frmSearching.attr('method', 'get');
      frmSearching.submit();
   });
});
   
   // 이미지를 출력해주는 함수
   function productImgListFunction(attachVOInJson, uuid, id){
      imgService.productImgList(attachVOInJson, uuid, id, 120, 120);
   }
 	//가격 출력시 1000 -> '1,000원' 으로 변경
   function getConvertWons(price, state){
      dateFormatService.getConvertWon(price, state);
   }

</script>