<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link href="/resources/vendor/fontawesome-free/css/all.min.css"
   rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
<link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<link rel="stylesheet" href="/resources/css/nice-select.css" type="text/css">
<link rel="stylesheet" href="/resources/css/owl.carousel.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/magnific-popup.css" type="text/css">
<link rel="stylesheet" href="/resources/css/slicknav.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/style.css" type="text/css">
<link rel="stylesheet" href="/resources/css/custom.css">
<link rel="stylesheet" href="/resources/css/banner.css" type="text/css">
<style>
.box-radio-input input[type="radio"] {
   display: none;
}

.box-radio-input input[type="radio"]+span {
   display: inline-block;
   background: none;
   border: 1px solid #dfdfdf;
   padding: 0px 10px;
   text-align: center;
   height: 35px;
   line-height: 33px;
   font-weight: 500;
   cursor: pointer;
}

.box-radio-input input[type="radio"]:checked+span {
   border: 1px solid #23a3a7;
   background: #23a3a7;
   color: #fff;
}
</style>
<div class="inline-blockk">
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
   <div style="margin-bottom: 30px; margin-top: 30px;">
      <h6 align="center">쇼핑몰 판매 현황</h6>
   </div>
   <hr>
   <div style="text-align: center;">
      <button id="zero" class="btn btn-info">전체조회</button>
      <button id="one" class="btn btn-info">일매출액조회</button>
      <button id="two" class="btn btn-info">기간매출액조회</button>
   </div>
   <div class="adminPage" id="sliderAdminPage" style="margin-left: 20%;">
      <p align="center">*총 매출을 시각화한 관리자 페이지입니다.*</p>
      <div class="adminChart" id="allPurchase">
         <canvas id="lookChartProduct" width="600" height="400">
          </canvas>
      </div>
      <div class="adminChart" id="dayPurchase">
         <div style="display: block;">
            <canvas id="day1Purchase" width="600" height="400">
             </canvas>
         </div>
         <div style="text-align: center; margin: 0 auto;">
            <form id="frmDate1Pick" method="get" action="/post/adminManage">
               <input id="datePick" type="date" pattern="yyyy-MM-dd"
                  name="datePick">
               <button id="btnJoin" class="btn btn-warning" type="button">조회</button>
            </form>
         </div>
      </div>
      <div class="adminChart" id="duringPurchase">
         <div style="display: block;">
            <canvas id="betweenDayPurchase" width="600" height="400">
             </canvas>
         </div>
         <div style="text-align: center; margin: 0 auto;">
            <form id="frmDateBetweenPick" method="get"
               action="/post/adminManage">
               <input id="firstDate" type="date" pattern="yyyy-MM-dd"
                  name="firstDate"> <input id="lastDate" type="date"
                  pattern="yyyy-MM-dd" name="lastDate">
               <button id="betweenDatebtn" class="btn btn-warning" type="button">조회</button>
            </form>
         </div>
      </div>
   </div>
</div>

<script src="/resources/js/bootstrap.min.js"></script>
<script src="/resources/js/owl.carousel.min.js"></script>
<script src="/resources/js/mixitup.min.js"></script>
<script src="/resources/js/main.js"></script>
<script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/resources/js/sb-admin-2.min.js"></script>
<script src="/resources/js/js-image-slider.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.bundle.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>
<script type="text/javascript">

   //관리자가 원하는 차트를 조회시 다른 차트를 숨김
   $('#one').on('click', function() {
      $('#dayPurchase').show();
      $('#duringPurchase').hide();
      $('#allPurchase').hide();
   });
   $('#zero').on('click', function() {
      $('#dayPurchase').hide();
      $('#duringPurchase').hide();
      $('#allPurchase').show();
   });
   $('#two').on('click', function() {
      $('#duringPurchase').show();
      $('#dayPurchase').hide();
      $('#allPurchase').hide();
   });

   $(document).ready(function() {
      //처음 화면 띄울때 기본 조회 차트만 보이게
      $('#dayPurchase').hide();
      $('#duringPurchase').hide();
      //만약 조회한 차트가 있으면 url을 검사하여 해당 화면으로 보이게 한다.
      var checkUrl = window.location.search;
      if (checkUrl.indexOf("datePick") >= 0) {
         $('#dayPurchase').show();
         $('#duringPurchase').hide();
         $('#allPurchase').hide();
      }
      if (checkUrl.indexOf("firstDate") >= 0) {
         $('#dayPurchase').hide();
         $('#duringPurchase').show();
         $('#allPurchase').hide();
      }

      var frmDate1Pick = $('#frmDate1Pick');
      var frmDateBetweenPick = $('#frmDateBetweenPick');

      $('#btnJoin').on('click', function() {
         frmDate1Pick.submit();

      })
      $('#betweenDatebtn').on('click', function() {
         frmDateBetweenPick.submit();

      });

   });
</script>
<script type="text/javascript">
   //chart함수를 실행
   $(document).ready(function() {
      makeChart();
      make1ChartPurchase();
      makeChartBetweenDayPurchase();

   });
   //기본차트 생성
   function makeChart() {
      var ctx = document.getElementById("lookChartProduct");
      var date = new Array();
      var price = new Array();

      <c:forEach items="${purchaseList}" var="item" varStatus="status">
      date.push("${item.tradeDate}");
      price.push("${item.productFinalPrice}");
      </c:forEach>

      var chart = new Chart(ctx, {
         type : 'line',
         data : {
            labels : date,
            datasets : [ {
               label : "판매현황",
               backgroundColor : 'rgba(255, 99, 132, 0.2)',
               borderColor : 'rgba(255, 99, 132, 0.2)',
               data : price,
               borderWidth : 1
            } ]
         },
         options : {
            responsive : false,
            scales : {
               yAxes : [ {
                  ticks : {
                     beginAtZero : false
                  }
               } ]
            }
         }
      });
   }
   //일별 조회시 차트
   function make1ChartPurchase() {
      var ctx = document.getElementById("day1Purchase");
      var date = new Array();
      var price = new Array();

      <c:forEach items="${purchase1Day}" var="item" varStatus="status">
      date.push("${item.tradeDate}");
      price.push("${item.productFinalPrice}");
      </c:forEach>

      var chart = new Chart(ctx, {
         type : 'bar',
         data : {
            labels : date,
            datasets : [ {
               label : "판매현황",
               backgroundColor : 'rgba(255, 99, 132, 0.2)',
               borderColor : 'rgba(255, 99, 132, 0.2)',
               data : price,
               borderWidth : 1
            } ]
         },
         options : {
            responsive : false,
            scales : {
               yAxes : [ {
                  ticks : {
                     beginAtZero : false
                  }
               } ]
            }
         }
      });
   }

   //두개의 날짜사이 차트 조회
   function makeChartBetweenDayPurchase() {
      var ctx = document.getElementById("betweenDayPurchase");
      var date = new Array();
      var price = new Array();

      <c:forEach items="${betweenDayPurchase}" var="item" varStatus="status">
      date.push("${item.tradeDate}");
      price.push("${item.productFinalPrice}");
      </c:forEach>

      var chart = new Chart(ctx, {
         type : 'bar',
         data : {
            labels : date,
            datasets : [ {
               label : "판매현황",
               backgroundColor : 'rgba(255, 99, 132, 0.2)',
               borderColor : 'rgba(255, 99, 132, 0.2)',
               data : price,
               borderWidth : 1
            } ]
         },
         options : {
            responsive : false,
            scales : {
               yAxes : [ {
                  ticks : {
                     beginAtZero : false
                  }
               } ]
            }
         }
      });
   }
</script>