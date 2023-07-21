
<%@ page import="java.util.*"%>
<%@ page import="cn.vente.model.*"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="javax.servlet.http.HttpSession" %>
  

<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser != null) {
    response.sendRedirect(request.getContextPath() + "/vente-system/articles.jsp");
    return;
}
%>
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE html>
<html lang="pt-bt">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="images/valorant.ico" type="image/x-icon">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sign-in_style.css">
	<link rel="icon" href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" /> 
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css">
    <title>Sign up</title>

    <!-- Include jQuery library -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Add your jQuery code here -->
    <script>
        $(document).ready(function() {
            // Form submission validation
            $("#register-form").submit(function(event) {
                // Perform your form validation using jQuery
                var login = $("input[name='login']").val();
                var password = $("input[name='pass']").val();
                var confirmPassword = $("input[name='re_pass']").val();
                var isValid = true;

                // Reset error messages and styles
                $(".error-message").text("").removeClass("error");

                if (login === "") {
                    // Display an error message
                    $("#login-error").text("Please enter a login.").addClass("error");
                    isValid = false;
                }

                if (password === "") {
                    // Display an error message
                    $("#password-error").text("Please enter a password.").addClass("error");
                    isValid = false;
                }

                if (confirmPassword === "") {
                    // Display an error message
                    $("#confirm-password-error").text("Please confirm the password.").addClass("error");
                    isValid = false;
                } else if (confirmPassword !== password) {
                    // Display an error message
                    $("#confirm-password-error").text("Passwords do not match.").addClass("error");
                    isValid = false;
                }

                if (!isValid) {
                    event.preventDefault(); // Prevent the form from submitting
                }
            });
        });
    </script>

    <style>
        .error {
            color: red;
        }
    </style>
</head>
<body>
    <section>
        <div class="img">
            <img src="${pageContext.request.contextPath}/images/glasses.jpg" alt="">
        </div>
        <div class="content">
       
            <div class="form">
             <%
            // un error msg sera recu f URL, melli kan testiw f GeneratePDF w kan jebro ma andnashi quanitity kafia
				       String errorMessage = (String) session.getAttribute("Userr");
				         session.removeAttribute("Userr");
				         if(errorMessage!=null){
				        %>
        
					<div class="alert alert-danger" style=" margin: 30px auto; text-align: center; padding-left: 20px;">
					  <%= errorMessage %>
					</div>
   				     <% } %>
                <h2>Sign up</h2>
                <form method="post" action="sign_up" class="register-form" id="register-form">
                    <div class="input">
                        <span>Login</span>
                        <input type="text" name="login">
                        <div id="login-error" class="error-message"></div>
                    </div>
                     
                    <div class="input">
                        <span>Password</span>
                        <input type="password" name="pass">
                        <div id="password-error" class="error-message"></div>
                    </div>
                    <div class="input">
                        <span>Confirm Password</span>
                        <input type="password" name="re_pass">
                        <div id="confirm-password-error" class="error-message"></div>
                    </div>
                    <div class="input">
                        <input type="submit" value="Sign up" name="submit">
                    </div>
                    <div class="input">
                        <p>Already have an account? <a href="sign-in.jsp">Sign in</a></p>
                    </div>
                </form>
            </div>
        </div>
    </section>
</body>
</html>
