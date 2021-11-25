<!-- 분할/정복 으로 첨부 파일 관리 복잡도 관리를 합니다., 유지보수성 향상 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 첨부 파일 목록 출력 부분 -->
   <div>
   <li>
      <label>상품 이미지</label>
   </li>
   </div>
         <div class="form-group" style="width: 100%; height: 400px;">
	         <div id="uploadDiv" style="width: 40%; display: inline-block; float: left; padding-left: 1%;">
	            <label> 
	            <img src="\resources\img\icons\enrollimgtext.png">
	            <input type="file" id="inFiles"  name="upLoadFile"  style="display: none;" multiple>
	              </label>
	               	  <p>    * 상품 이미지는 640x640에 최적화 되어 있습니다. </p>
					  <p>	- 이미지는 상품등록 시 정사각형으로 짤려서 등록됩니다. </p>
					  <p>	- 이미지를 클릭 할 경우 원본이미지를 확인할 수 있습니다. </p>		
					  <p>	- 큰 이미지일경우 이미지가 깨지는 경우가 발생할 수 있습니다. </p>
	         </div>
	         
	         <div id="uploadResult" style="width: 40%; float: left;">
	         </div>
   
			<div class="bigWrapper">
            <div class="bigNested">
            </div>
         </div>
   </div>

<script type="text/javascript" src="\resources\js\util\utf8.js"> </script>
<script type="text/javascript">
var updateMode;
//adjustCRUDAtAttach에 특정 인자를 넘겨 상품 게시글에 관해 수정 허용, 불가를 선택.
function adjustCRUDAtAttach(includer) {
   
   if (includer === '수정' || includer === '신규') {
      updateMode = true;
      $('#uploadDiv').show();
   } else if  (includer === '조회') {
      updateMode = false;
      $('#uploadDiv').hide();
   }
}
// 이미지를 동적으로 받아 어떤 형식으로 출력할지 지정하는 함수
function appendUploadUl(attachVOInJson) {
   var liTags = "";
   var attachVO = JSON.parse(decodeURL(attachVOInJson));
   
   if (attachVO.multimediaType === "others") {
      liTags += "<li data-attach_info=" + attachVOInJson + "><a href='/uploadFiles/download?fileName=" 
         + encodeURIComponent(attachVO.originalFileCallPath) + "'><img src='/resources/img/attachfileicon.png'>" 
         + attachVO.pureFileName + "</a>"
         if(updateMode) {
            liTags += "<span>X</span>";
         }
         liTags += "</li>";
   } else {
      if (attachVO.multimediaType === "audio") {
         liTags += "<li data-attach_info=" + attachVOInJson + ">"
               + "<a>"
               + "<img src='/resources/img/speaker.png'>" 
               + attachVO.pureFileName + "</a>"; 
               if(updateMode) {
                  liTags += "<span>X</span>";
               }
               liTags += "</li>";
               
      } else if (attachVO.multimediaType === "image" || attachVO.multimediaType === "video") {
         liTags += "<li data-attach_info=" + attachVOInJson + ">"
               + "<a>"
               + "<img src='/uploadFiles/display?fileName=" 
               + encodeURIComponent(attachVO.fileCallPath) + "'>"
               + attachVO.pureFileName + "</a>"; 
               if(updateMode) {
                  liTags += "<span>X</span>";
               }
               liTags += "</li>";
         }      
      }
   $("#uploadResult").append(liTags); //append 쓴이유  > 업로드 또하면
}

   $(document).ready(function() {
      //업로드 파일에 대한 확장자 제한하는 정규식
      var uploadConstraintByExt = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
      //업로드 파일에 대한 최대크기를 제한
      var uploadMaxSize = 1036870912;
      
      //화면이 맨 처음 로드 시 들어 있는 깨끗한 상태 기억
      var initClearStatus = $("#uploadDiv").html();
      
      $("#uploadDiv").on("change", "input", function() {
         alert("Upload가 성공하면 이 문구가 나올거야");
         var formData = new FormData();
         var files = $("#inFiles")[0].files;
         
         for (var i = 0; i < files.length; i++) {
            if (! checkFileConstraints(files[i].name, files[i].size))
               return false;
            formData.append("uploadFile", files[i]);
         }
         
         $.ajax({ // Json으로 나타날때 아래와 같이 처리함
            url : "/uploadFiles/upload", 
            processData : false,
            contentType : false,
            data : formData,
            type : 'post',
            success : function (result) {
               showUploadedFile(result); //업로드이후 청소
               //동적인 청소는 연동되어 있는 Event Listener까지 날아가버린다. 이에 대해서 유임방식을 채용
               $("#uploadDiv").html(initClearStatus);
            }
         });
      });
   
   /* $("#inFiles").change(uploadFiles(initClearStatus)); */
   // IE11까지 고려한 보여 준 이후에 클릭하면 사라지게합니다.
   $(".bigWrapper").on("click", function() {
      $(".bigNested").animate({width:'0%', height:'0%'}, 1000);
      setTimeout(function() {
         $(".bigWrapper").hide();
      }, 1000);
   });
   
   //업로드 파일에 대한 제약 사항을 미리 검사해줍니다.
   function checkFileConstraints(fileName, fileSize) {
      //크기 검사
      if (fileSize > uploadMaxSize) {
         return false;
      }
      //종류 검사
      if (uploadConstraintByExt.test(fileName)) {
         return false;
      }
      return true;
   }
   
   // 이미지클릭시 자동재생 및 원본파일재생
   $("#uploadResult").on("click", "a", function(){
      var attachVO = $(this).closest("li").data("attach_info");
      attachVO = JSON.parse(decodeURL(attachVO));
      
      $(".bigWrapper").css("display", "flex").show();
      if (attachVO.multimediaType === "audio") {
         $(".bigNested").html("<audio src='/uploadFiles/display?fileName=" +  encodeURI(attachVO.originalFileCallPath) + "' autoplay>"
               ).animate({width:'100%', height:'100%'}, 1000);
      } else if (attachVO.multimediaType === "image") {
         $(".bigNested").html("<img src='/uploadFiles/display?fileName=" +  encodeURI(attachVO.originalFileCallPath) + "'>"
               ).animate({width:'100%', height:'100%'}, 1000);
      } else if (attachVO.multimediaType === "video") {
         $(".bigNested").html("<video src='/uploadFiles/display?fileName=" + encodeURI(attachVO.originalFileCallPath) + "' autoplay>"
               ).animate({width:'100%', height:'100%'}, 1000);   
      }
   });
   
   //첨부 취소하기
   $("#uploadResult").on("click", "span", function(){
      var targetLi = $(this).closest("li");
      var attachVO = targetLi.data("attach_info");
      attachVO = JSON.parse(decodeURL(attachVO));
      
      $.ajax({
         url : "/uploadFiles/deleteFile",
         data : attachVO,
         type : 'post',
         dataType : 'text',
         success : function (result) {
            targetLi.remove();
         }
      });
   });
});
// 업로드 show 함수
function showUploadedFile(result) {
   
   $(result).each(function (i, attachVOInJson) {
      appendUploadUl(attachVOInJson);
   });
}

/**
 * 첨부 파일 기능은 여러 화면에서 재 사용될 가능성이 높다.
 이를 각 화면에서 중복 개발하기 보다는 이곳에서 통합적으로 서비스 할 수 있도록 모듈화 함
 */
function addAttachInfo(frmContainer, varName) {
   var inputAttaches = "";
   $("#uploadResult li").each(function(i, attachLi){
      var jobObj = $(attachLi);
      var attachVO = jobObj.data("attach_info");
      
      inputAttaches += "<input type='hidden' name='" + varName + "[" + i + "]' value=" + attachVO + ">";
   });
   //
   frmContainer.append(inputAttaches);
}
</script>