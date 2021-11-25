<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../includes/header.jsp"%>
<style>
.spanLabel{
   margin-left: 10%; 
   font: bold;
}
.divInline {
   display: inline-block;
   width: 20%;
}
</style>

<%@ include file="../includes/subMenu.jsp"%>
<div class="inline-blockk" style="width: 80%;">
<div class="container-fluidd">
        <div class = "signUp">
            <h3>내 정보</h3>
        </div>
        <hr style="border: 1px solid black;">
        <!-- DataTales Example -->
                <div class="form-group idBox">
                    <div class="divInline"  style="margin-right: 10%;"><label>사용자 아이디</label></div>
                    <div class="divInline"><span class="spanLabel" >${party[0].userId}</span></div>
                </div>
             <hr>
              <div class="form-group">
                    <div class="divInline"  style="margin-right: 10%;"><label>등급</label></div>
                    <div class="divInline"><span class="spanLabel" id="tierMaster"></span></div>
                    <button type="button" class="btn btn-info" id="classes" style="text-align: center;">등급표</button>
                </div>
             <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>이름</label></div>
               <div class="divInline"><span class="spanLabel">${party[0].name}</span></div>
            </div>
            <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;">
                  <label>생년월일</label>
               </div>
               <div class="divInline">
                  <span class="spanLabel">
                     <fmt:formatDate pattern="yyyy-MM-dd" value="${party[0].birthDate}" />
                  </span>
               </div>
            </div>
            <hr>
                     
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>${party[0].listContactPoint[0].contactPointType}</label></div>
               <div class="divInline"><span class="spanLabel">${party[0].listContactPoint[0].info}</span></div>
            </div>
            <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>${party[0].listContactPoint[1].contactPointType}</label></div>
               <div class="divInline"><span class="spanLabel">${party[0].listContactPoint[1].info}</span></div>
            </div>
            <hr>
            
            <div class="form-group">
               <div class="divInline" style="margin-right: 10%;"><label>${party[0].listContactPoint[2].contactPointType}</label></div>
               <div class="divInline"><span class="spanLabel">${party[0].listContactPoint[2].info}</span></div>
            </div>
            <hr>

      </div>
   </div>
    <%@include file="../includes/footer.jsp"%>
    
   <script>
   // 적립된 Point 수치에 따라서 회원정보 앞에 표시되는 등급
   if(${party[0].point} <= 1000){
         $('#tierMaster').html("평민(" + ${party[0].point} + "포인트)");
   }else if(${party[0].point} > 1000 && ${party[0].point} <= 5000){
       $('#tierMaster').html("상인(" + ${party[0].point} + "포인트)");
   }else if(${party[0].point} > 5000 && ${party[0].point} <= 15000){
         $('#tierMaster').html("귀족(" + ${party[0].point} + "포인트)");
   }else {
       $('#tierMaster').html("왕족(" + ${party[0].point} + "포인트)");
   }
   
   // 등급표 클릭 시 window 오픈하여 등급표 보여주는 함수
   $('#classes').on("click", function(){
  	 var win = window.open("/post/classes", "_blank", "toolbar=yes,top=600,left=500,width=1000,height=700");
   });
   
   </script>