<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/css/login.css" type="text/css">
<meta charset="UTF-8">
<title>Log-In Start</title>

</head>
<body>
   <div class="wrapper fadeInDown"
      style="align: center; margin: 0 auto; padding-top: 10%;">
      <div id="formContent" style="align: center; margin: 0 auto;">
         <!-- Tabs Titles -->
         <img src="/resources/img/icons/FleaxIcon1.png" id="icon" alt="Flex" style="width: 100px; height: 50px;" /> <br>
         <h2 class="active" style="font-size: 25px;">Sign In</h2>

         <!-- Icon -->
         <div class="fadeIn first"></div>

         <!-- Login Form -->
         <form method='post' action="/login" role="form">
            <div class='form-group'>
               <input type="text" style="text-align: center;" name='username'
                class='form-control' placeholder=" ID :아이디를 입력해주세요.">
            </div>
            <br>
            <div class='form-group'>
               <input type="password" style="text-align: center;" name='password'
                class='form-control' placeholder="PW :비밀번호를 입력해주세요">
            </div>
            <br>
               <input type="submit" class="fadeIn fourth" value="Log In">
               <input type='hidden' name='${_csrf.parameterName}' value='${_csrf.token}'>
         </form>

         <!-- Remind Passowrd -->
         <div id="formFooter">
            아직 회원가입을 하지 않으셨나요? <a class="underlineHover" href="/party/joinMember"> 회원가입 </a>
         </div>
      </div>
   </div>
</body>
</html>