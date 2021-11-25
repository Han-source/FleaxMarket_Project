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
</style>
<%@ include file="../includes/subMenu.jsp"%>
<div class="inline-blockk" style="width: 70%;">
	<div class="container-fluid">
		<div>
			<div>
				<form id="frmSearching" action="/product/readProduct" method="get">
				</form>
				<!--  내가 결제한 상품 목록만 조회  -->
				<div class="itemm_wrapper">
					<div class="itemm_container">
						<!--  판매 완료여부 따른 선택 페이지 -->
						<div class="itemm_heading_title">
							<a><button id="btnSelllist" class="btn btn-default">판매중인상품</button></a> 
							<a><button id="btnSelledList" class="btn btn-default">판매완료한상품</button></a>
							<div>
								<section class="order-informationn-table">
									<div class="order-information-header">
										<div class="item-shoppingCart-informationn info-top">상품정보</div>
										<div class="item-order-trdatee">거래종류</div>
										<div class="item-order-datee">판매일자</div>
										<div class="item-order-buyer">구매자</div>
										<div class="item-order-productFP">거래금액</div>
									</div>
									 
									 <!--  내가 판매 완료한 상품 list를 화면에 출력  -->
									<c:forEach items="${productUploaded}" var="product" varStatus="status">
										<div class="order-inforamtion-bottom">
											<!-- start -->
											<div class="order-info-wrapp">
												<div class="item-shoppingCart-informationn info-bottom">
													<a class='anchor4product' href="${product.id}">
														<div class="item-info-imagee">
															<div class="slider" id="${product.id}">
																<ul class="slider__images" style="list-style: none;">
																	<c:forEach var="attachVoInStr"
																		items="${product.attachListInGson}" varStatus="sta">
																		<script>
								                                             $(document).ready(function() {
								                                                productImgListFunction('<c:out value="${productUploaded[status.index].attachListInGson[sta.index]}" />', '<c:out value="${productUploaded[status.index].listAttach[sta.index].uuid}" />', '<c:out value="${productUploaded[status.index].id}" />');
								                                             });
							                                          </script>
																	</c:forEach>
																</ul>
															</div>
														</div>
														<div class="item-info-text">
															<span>상품명 : ${product.title}</span>
														</div> <input type="hidden" id="child" name="child" value="${productUploaded[status.index].board.parentId}">
														<input type="hidden" id="boardId" name="boardId" value="${productUploaded[status.index].board.id}">
														<input type="hidden" id="buyerId" name="buyerId" value="${productUploaded[status.index].trade.buyerId}">
														<input type="hidden" id="tradeDate" name="tradeDate" value="${productUploaded[status.index].trade.tradeDate}">
														<input type="hidden" id="productPrice" name="productPrice" value="${productUploaded[status.index].trade.productFinalPrice}">
													</a>
												</div>
												<c:if
													test="${productUploaded[status.index].board.parentId == 5}">
													<div class="item-order-datee">
														<span>직접거래</span>
													</div>
												</c:if>
												<c:if
													test="${productUploaded[status.index].board.parentId == 6}">
													<div class="item-order-datee">
														<span>안전거래</span>
													</div>
												</c:if>
												<c:if
													test="${productUploaded[status.index].board.parentId == 7}">
													<div class="item-order-datee">
														<span>경매거래</span>
													</div>
												</c:if>
												<div class="item-order-trdatee">
													<span>${productUploaded[status.index].trade.tradeDate}</span>
												</div>
												<div class="item-order-buyer">
													<span>${productUploaded[status.index].trade.buyerId}</span>
												</div>
												<div class="item-order-productFP" id="${status.index}">
													<p>
														<script>
			                                   $(document).ready(function() {
			                                   getConvertWons(${productUploaded[status.index].product.productPrice}, '#${status.index}');
			                                 	});
                           		  		</script>
													</p>

												</div>
											</div>
											<!-- end -->
										</div>

									</c:forEach>
								</section>
							</div>
							<!--  판매 현황에 관한 차트 시각화 -->
							<div id="defaultChart">
								<button class="btn btn-info" id="searchDuringChart" style="right: 110px; top: 700px; position: fixed;">기간별현황 조회 하기</button>
								<p style="right: 100px; top: 300px; position: fixed;">* 기본 7일간의 판매 현황 조회 *</p>
								<canvas id="lookChartProduct" style="right: 50px; top: 350px; position: fixed;"></canvas>
							</div>

							<div id="duringChart" style="right: 100px; top: 300px; position: fixed;">
								<p style="right: 100px; top: 300px; position: fixed;">* 기간별 판매 현황 조회 *</p>
								<span style="right: 250px; top: 600px; position: fixed;">시작일자</span>
								<input id="firstDate" type="date" pattern="yyyy-MM-dd" name="firstDate" style="right: 80px; top: 600px; position: fixed;">
								<span style="right: 250px; top: 650px; position: fixed;">끝나는일자</span>
								<input id="lastDate" type="date" pattern="yyyy-MM-dd" name="lastDate" style="right: 80px; top: 650px; position: fixed;">
								<button class="btn btn-info" id="searchDefaultChart" style="right: 150px; top: 700px; position: fixed;">7일간 현황보기</button>
								<button id="betweenDatebtn" class="btn btn-warning" type="button" style="right: 70px; top: 700px; position: fixed;">조회</button>
								<canvas id="selledChart" style="right: 50px; top: 350px; position: fixed;"></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

<!--  판매리스트 form -->
<form id="frmSelllist" action="/business/myProductUploaded" method="get">
	<input type="hidden" name="boardId" value="${boardId}"> <input
		type="hidden" name="child" value="${child}"> <input
		type="hidden" name="getMySelledList" value="0">
</form>
<!--  판매 완료 form -->
<form id="frmSelledList" action="/business/myProductSelled" method="get">
	<input type="hidden" name="boardId" value="${boardId}"> <input
		type="hidden" name="child" value="${child}"> <input
		type="hidden" name="getMySelledList" value="1">
</form>

<%@include file="../includes/footer.jsp"%>
<script src="\resources\js\util\utf8.js"></script>
<script src="\resources\js\util\dateFormat.js"></script>
<script src="\resources\js\imgList\imgList.js"></script>
<!-- End of Main Content -->
<script type="text/javascript">

   $(document).ready(function() {
      makeChart();
      selledChart();
   $('#duringChart').hide();
// 	차트 클릭시 처리하는 영역
   $('#searchDuringChart').on('click', function(){
      $('#duringChart').show();
      $('#defaultChart').hide();
   });
//	차트 클릭시 처리하는 영역   
   $('#searchDefaultChart').on('click', function(){
     $('#duringChart').hide();
     $('#defaultChart').show();
   })
   
   var a = window.location.search;
   
   if(a.indexOf("firstDate")>=0){
      $('#duringChart').show();
      $('#defaultChart').hide();  
   }
   var frmSearching = $('#frmSearching');
   
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
   
   var frmSelllist = $('#frmSelllist');
      $('#btnSelllist').on('click', function(eInfo) {
           eInfo.preventDefault();

           //신규 조회이므로 1쪽을 보여줘야합니다
           $("input[name='pageNumber']").val("1");

           frmSelllist.submit();
   });
      
   var frmSelledList = $('#frmSelledList');
      $('#btnSelledList').on('click', function(eInfo) {
           eInfo.preventDefault();

           //신규 조회이므로 1쪽을 보여줘야합니다
           $("input[name='pageNumber']").val("1");

          frmSelledList.submit();
    });
      
      
      $('#betweenDatebtn').on('click', function(e){
            e.preventDefault();
            frmSelledList.append("<input name='firstDate' type='hidden' value='" + $('#firstDate').val() + "'>"); 
            frmSelledList.append("<input name='lastDate' type='hidden' value='" + $('#lastDate').val() + "'>");
            frmSelledList.submit();
      })
        
</script>

<script>
// 	차트를 생성하는 함수
   function makeChart() {
      var ctx = document.getElementById("lookChartProduct");
      var tradeDate = new Array();
      var price = new Array();
      <c:forEach items="${sellChart}" var="item" varStatus="status">
         tradeDate.push("${item.tradeDate}");
         price.push("${item.productFinalPrice}");
      </c:forEach>
      
      var chart = new Chart(ctx, {
         type : 'bar',
         data : {
            labels : tradeDate,
            datasets : [ {
               label : "날짜",
               borderColor : 'rgb(204, 102, 255)',
               data : price
            } ]   
         },
         options : {
            responsive : false,
            scales : {
               yAxes : [ {
                  ticks : {
                     beginAtZero : true
                  }
               } ]
            }
         }
      });
   }
</script>



<script>
   function selledChart() {
      var ctx = document.getElementById("selledChart");
      var tradeDate = new Array();
      var price = new Array();
      <c:forEach items="${mySelledDateChart}" var="item" varStatus="status">
         tradeDate.push("${item.tradeDate}");
         price.push("${item.productFinalPrice}");
      </c:forEach>
      
      var chart = new Chart(ctx, {
         type : 'bar',
         data : {
            labels : tradeDate,
            datasets : [ {
               label : "날짜",
               borderColor : 'rgb(204, 102, 255)',
               data : price
            } ]   
         },
         options : {
            responsive : false,
            scales : {
               yAxes : [ {
                  ticks : {
                     beginAtZero : true
                  }
               } ]
            }
         }
      });
   }
   
   function getConvertWons(price, state){
	      dateFormatService.getConvertWon(price, state);
	   }
</script>