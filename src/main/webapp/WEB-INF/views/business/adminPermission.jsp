<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link href="/resources/vendor/fontawesome-free/css/all.min.css"
   rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link
   href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
   rel="stylesheet">
<!-- Css Styles -->
<link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="/resources/css/nice-select.css" type="text/css">
<link rel="stylesheet" href="/resources/css/owl.carousel.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/magnific-popup.css" type="text/css">
<link rel="stylesheet" href="/resources/css/slicknav.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/style.css" type="text/css">
<link rel="stylesheet" href="/resources/css/custom.css">
<link rel="stylesheet" href="/resources/css/banner.css" type="text/css">
<!-- CSS end -->

	  <!-- productId, boardId, childId 정보를 받아 Controller /business/readProduct"로 보내는 역할 -->
      <form id="frmSearching" action="/business/readProduct" method="get">
      </form>
      <!-- 사용자의 결제를 정상적으로 수락할 경우 controller에게 특정 정보 전달 -->
      <form id="frmPermissionAgree" action="/business/adminPermission" method="post">
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
      </form>
      <!-- 사용자의 결제를 거절할 경우 controller에게 특정 정보 전달 -->
      <form id="frmPermissionDisAgree" action="/business/adminPermission" method="post">
            <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
      </form>

<div class="inline-blockk">
	<!-- 좌측 세로형 nav바 -->
	<nav class="side_menu_nav">
		<ul class="side_Menu_Bar">
			<li class="side_Menu_Bar_li"><a class="activeMeenu"
				href="/post/adminManage">쇼핑몰 판매 현황</a></li>
			<li class="side_Menu_Bar_li"><a class="activeMeenu"
				href="/business/adminPermission">거래 상품 관리자 허가</a></li>
		</ul>
	</nav>
</div>
<div class="inline-blockk" style="width: 80%;">
	<!--  거래 상품 관리자 허가 페이지 -->
	<div style="margin-bottom: 30px; margin-top: 30px;">
		<h6 align="center">거래 허가</h6>
	</div>
	<hr>
	<section class="order-informationn-table">
		<div class="order-information-header" style="width: 90%;">
			<div class="item-informationn info-top">상품정보</div>
			<div class="item-order-datee">주문일자</div>
			<div class="item-order-numberr-admin">주문번호</div>
			<div class="item-order-amountt">판매자</div>
			<div class="item-order-buyer">구매자</div>
			<div class="item-order-statuss-admin">주문 상태</div>
		</div>
		<!--  상품에 관한 정보가 담겨져 있는 list -->
		<c:forEach items="${adminPermission}" var="product" varStatus="status">
			<div class="order-inforamtion-bottom" style="width: 90%;">
				<div class="order-info-wrapp">
					<div class="item-informationn info-bottom">
						<a class='anchor4product' href="${product.id}">
							<div class="item-info-imagee">
								<div class="slider" id="${product.id}">
									<ul class="slider__images" style="list-style: none;">
										<c:forEach var="attachVoInStr"
											items="${product.attachListInGson}" varStatus="sta">
											<!--  productImgListFunction 함수를 통해 이미지를 출력-->
											<script>
												$(document).ready(
													function() {
														productImgListFunction(
																'<c:out value="${adminPermission[status.index].attachListInGson[sta.index]}" />',
																'<c:out value="${adminPermission[status.index].listAttach[sta.index].uuid}" />',
																'<c:out value="${adminPermission[status.index].id}" />');
												});
											</script>
										</c:forEach>
									</ul>
								</div>
							</div>
							<div class="item-info-text">
								<p>상품명 : ${product.title}</p>
							</div> <!-- hidden 타입을 통해 child, boardId ,tradeId, tradeDate, productPrice 값을 담아주기-->
							<input type="hidden" id="child" name="child" value="${adminPermission[status.index].board.parentId}">
							<input type="hidden" id="boardId" name="boardId" value="${adminPermission[status.index].board.id}">
							<input type="hidden" id="tradeId" name="tradeId" value="${adminPermission[status.index].trade.tradeId}">
							<input type="hidden" id="tradeDate" name="tradeDate" value="${adminPermission[status.index].trade.tradeDate}">
							<input type="hidden" id="productPrice" name="productPrice" value="${adminPermission[status.index].trade.productFinalPrice}">
						</a>
					</div>
					<!-- 결제 날짜 출력 -->
					<div class="item-order-datee">
						<span>${adminPermission[status.index].trade.tradeDate}</span>
					</div>
					<!-- 결제 번호 출력 -->
					<div class="item-order-numberr-admin">
						<span>${adminPermission[status.index].trade.tradeId}</span>
					</div>
					<!-- 판매자id 출력 -->
					<div class="item-order-amountt">
						<p>${adminPermission[status.index].trade.sellerId}</p>
					</div>
					<!-- 구매자id 출력 -->
					<div class="item-order-buyer">
						<p>${adminPermission[status.index].trade.buyerId}</p>
					</div>
					<!-- 관리자가 결제를 승인할지 취소할지 에대한 버튼 -->
					<div class="item-order-statuss-admin">
						<button type="button" id="purchaseAgreePermission" value="${adminPermission[status.index].trade.tradeId}">거래완료</button>
						<button type="button" id="purchaseDisAgreePermission"value="${adminPermission[status.index].trade.tradeId}">거래취소</button>
					</div>
				</div>				
			</div>
		</c:forEach>
	</section>



</div>

<script src="/resources/js/bootstrap.min.js"></script>
<script src="/resources/js/owl.carousel.min.js"></script>
<script src="/resources/js/mixitup.min.js"></script>
<script src="/resources/js/main.js"></script>
<script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script src="/resources/js/sb-admin-2.min.js"></script>
<script src="/resources/js/js-image-slider.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<script src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.bundle.js"></script>
<script src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.bundle.min.js"></script>
<script src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.js"></script>
<script src = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script src="\resources\js\imgList\imgList.js"></script>
<script src="\resources\js\util\utf8.js"></script>
 
<script>
	// 이미지를 출력하여 처리하는 함수(공통화 처리된 imgList.js 에서 가져온 함수)
	function productImgListFunction(attachVOInJson, uuid, id) {
		imgService.productImgList(attachVOInJson, uuid, id, 120, 120);
	}

	var frmSearching = $('#frmSearching');
	// id값 anchor4product을 가진 a태그를 클릭 시 누른 상품 상세 페이지로 이동처리.
	$('.anchor4product').on('click', function(e) {
		e.preventDefault();
		var a = $(this).children('input#tradeId').val();
		var productId = $(this).attr('href')
		frmSearching.append("<input name='productId' type='hidden' value='" + productId + "'>");
		var board = $('#boardId').val();
		var s = $(this).children('input#tradeId').val();
		frmSearching.append("<input name='boardId' type='hidden' value='"+ $('#boardId').val() + "'>");
		frmSearching.append("<input name='child' type='hidden' value='"+ $(this).children('input#child').val()+ "'>");
		frmSearching.submit();
	});

	// 결제 수락을 눌렀을 경우 처리하는 함수
	var frmPermissionAgree = $('#frmPermissionAgree');
	$('#purchaseAgreePermission').on("click", function() {
		frmPermissionAgree.append("<input name='permissionAgree' type='hidden' value='0'>");
		var a = $(this).val();
		frmPermissionAgree.append("<input name='tradeId' type='hidden' value='"+ $(this).val() + "'>");
		frmPermissionAgree.submit();
	})
	// 결제 취소를 눌렀을 경우 처리하는 함수
	var frmPermissionDisAgree = $('#frmPermissionDisAgree');
	$('#purchaseDisAgreePermission').on("click", function() {
		frmPermissionDisAgree.append("<input name='permissionDisAgree' type='hidden' value='0'>");
		var a = $(this).val();
		frmPermissionDisAgree.append("<input name='tradeId' type='hidden' value='"+ $(this).val() + "'>");
		frmPermissionDisAgree.submit();
	})
</script>