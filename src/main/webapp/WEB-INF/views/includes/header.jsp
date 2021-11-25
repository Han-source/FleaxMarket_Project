<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
   prefix="sec"%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
   content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>Fleax Market</title>

<!-- Custom fonts for this template -->
<link href="/resources/vendor/fontawesome-free/css/all.min.css"
   rel="stylesheet" type="text/css">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link
   href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
   rel="stylesheet">
<!-- <link href="/resources/css/sb-admin-2.min.css" rel="stylesheet"> -->
<!-- Custom fonts for this template end-->

<!-- <link href="/resources/vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet"> -->
<!-- Css Styles -->
<link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
<!-- <link rel="stylesheet" href="/resources/css/font-awesome.min.css" type="text/css"> -->
<link rel="stylesheet" href="/resources/css/nice-select.css" type="text/css">
<link rel="stylesheet" href="/resources/css/owl.carousel.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/magnific-popup.css" type="text/css">
<link rel="stylesheet" href="/resources/css/slicknav.min.css" type="text/css">
<link rel="stylesheet" href="/resources/css/style.css" type="text/css">
<!--     <link rel="stylesheet" href="/resources/css/dropdw.css" type="text/css"> -->
<link rel="stylesheet" href="/resources/css/custom.css">
<link rel="stylesheet" href="/resources/css/banner.css" type="text/css">

<!-- Css Styles  end-->
</head>
<sec:authorize access="isAuthenticated()">
      <p id="tier" style="float: right; margin-right: 3%;"></p>
</sec:authorize>
<header class="header-section">
   <sec:authorize access="isAnonymous()">
      <div class="logoutt" style="height: 100%;">
         <div class="wrapLogin">
            <a class="buttonLogin" href="/party/customLogin">LOGIN</a>
         </div>
         </div>
      </sec:authorize>
      <sec:authorize access="isAuthenticated()">
      
      <div class="logoutt" style="height: 100%;">
      <div>
            <form action="/" method="POST">
               <fieldset style="float: right; border: 2 solid #9FB6FF; padding: 15">
                  <input type="hidden" name="${_csrf.parameterName}"value="${_csrf.token}" autofocus /> 
                  <button type="submit" class="custom-btn btn-15"><span>로그아웃</span></button>
               </fieldset>
            </form>
            <div class="inner-header">
      <!-- Menu Bar -->
      <nav class="main-menu2">
         <ul class="sub-menu">
            <sec:authorize access="isAuthenticated()">

               <li>
                    <img src="\resources\img\icons\messicon.png" style="width:25px; height:25px; margin-right: 50px;"> 
                   <ul class="sub-menu2" id="boxTable"> </ul>
               </li>
               <li>
                   <a href="/party/myPage">
                   		<img src="\resources\img\icons\humaninformation.png" style="width:25px; height:25px; margin-right: 30px;">
                   </a>
               </li>
            </sec:authorize>
         </ul>
      </nav>
   </div>
               
      
      </div>
      </div>            
      </sec:authorize>
   
   <div class="logo">
         <a href="/"><img src="/resources/img/icons/FleaxIcon1.png" alt="FleaxImg"></a>
      </div>
   
      <div class="inner-header">
        <hr>
      
      <!-- Menu Bar -->
      <nav class="main-menu">
         <ul class="sub-menu">
            <!-- ul tag에서 공지사항bd=1, FAQbd=2, 자유게시판bd=3, 중고거래bd=4 -->
            <sec:authorize access="permitAll()">
               <c:forEach items="${boardList}" var="board">
                           <c:if test="${board.id == 1}">
                           <li>
                              <a href="/post/listBySearch?boardId=${board.id}&child=0">
                                 ${board.name}
                              </a>
                              </li>                                    
                           </c:if>
                           <c:if test="${board.id == 3}">
                           <li>
                              <a href="/post/listBySearch?boardId=${board.id}&child=0">
                                 ${board.name}
                              </a>
                           </li>
                           </c:if>
                        <c:if test="${board.id == 4}">
                           <li>
                           ${board.name}
                             <ul class="sub-menu">
                                 <c:forEach items="${childBoardList}" var="child">
                                 <c:if test="${child.id != 7}">
                                  	<li><a href="/business/productList?boardId=4&child=${child.id}">${child.name}</a></li>
                                  </c:if>
                           </c:forEach>
                             </ul>
                           </li>
                           
                           <li>
                           <c:forEach items="${childBoardList}" var="child">
                                 <c:if test="${child.id == 7}">
                                  	<a href="/business/productList?boardId=4&child=${child.id}">${child.name}</a>
                                  </c:if>
                           </c:forEach>
                           </li>
                           
                        </c:if>
               </c:forEach>
                        <c:if test="${descrim eq 'Admin'}">
                                <li><a id="adminMana">쇼핑몰판매현황</a></li>
                        </c:if>
            </sec:authorize>
         </ul>
      </nav>
   </div>
</header>
<div style="height: 8%;" class="ymym">

</div>
<hr>