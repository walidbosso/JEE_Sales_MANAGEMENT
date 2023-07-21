<%@ page import="cn.vente.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.vente.model.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");

User loggedIdUser = (User) session.getAttribute("loggedInUser");

if (loggedIdUser == null) {
    response.sendRedirect(request.getContextPath() + "/user-system/sign-in.jsp");
    return;
}
String login = (loggedIdUser != null) ? loggedIdUser.getLogin() : "";

List<String> articles_List = (List<String>) session.getAttribute("articles_List");
int number = 0;
int chek_number ;
if (articles_List != null) {
	
	number = articles_List.size();
	
	
	

}
%>

<!DOCTYPE html>
<html lang="pt-bt">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="shortcut icon" href="images/valorant.ico" type="image/x-icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sign-in_style.css">
<link rel="icon" href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" /> 
<title>Reset Password</title>

<!-- Include jQuery library -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Add your jQuery code here -->
<script>
    $(document).ready(function() {
        // Form submission validation
        $("#register-form").submit(function(event) {
            // Perform your form validation using jQuery
            var currentPassword = $("input[name='current_pass']").val();
            var newPassword = $("input[name='new_pass']").val();
            var confirmPassword = $("input[name='re_pass']").val();
            var isValid = true;

            // Reset error messages and styles
            $(".error-message").text("").removeClass("error");

            if (currentPassword === "") {
                // Display an error message
                $("#current-password-error").text("Please enter the current password.").addClass("error");
                isValid = false;
            }

            if (newPassword === "") {
                // Display an error message
                $("#new-password-error").text("Please enter a new password.").addClass("error");
                isValid = false;
            }

            if (confirmPassword === "") {
                // Display an error message
                $("#confirm-password-error").text("Please confirm the new password.").addClass("error");
                isValid = false;
            } else if (confirmPassword !== newPassword) {
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
    <header>
        <a href="${pageContext.request.contextPath}/vente-system/articles.jsp"><img src="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" alt="Logo"></a>
        <nav class="navbar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/vente-system/articles.jsp">Home</a></li>
                <li>
                    <a href="/Vente_management/vente-system/cart.jsp">Cart
                        <span style="background-color: rgb(144, 238, 144); border-radius: 5px; position: relative; top: -5px; font-size: 0.7em; padding: 2px 2.5px;">
                            <%=number%>
                        </span>
                    </a>
                </li>
                <li>
                    <a href="#"><%=login%> </a>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/vente-system/orders.jsp">Orders</a></li>
                       
                        <li><a href="${pageContext.request.contextPath}/user-system/reset-password.jsp">Change password</a></li>
                       <%        if (loggedIdUser.isRole() == true) { %>
				        <li><a href="${pageContext.request.contextPath}/vente-system/report.jsp">Report</a></li> 
				        <%
				            }
				        %>
				         <%        if (loggedIdUser.isRole() == true) { %>
				        <li><a href="${pageContext.request.contextPath}/vente-system/users.jsp">Users Management</a></li> 
				        <%
				            }
				        %>
                        <li><a href="logout.action">Log out</a></li> 
                    </ul>
                </li>
            </ul>
        </nav>
    </header>
    <section>
        <div class="content">
            <div class="form">
                <h2>Reset Password</h2>
                <form method="post" action="change_pass" class="register-form" id="register-form">
                    <div class="input">
                        <span>Current password</span>
                        <input type="password" name="pass" style="font-size: 14px; padding: 5px;">
                        <div id="current-password-error" class="error-message"></div>
                    </div>
                    <div class="input">
                        <span>Password</span>
                        <input type="password" name="new_pass" style="font-size: 14px; padding: 5px;">
                        <div id="new-password-error" class="error-message"></div>
                    </div>
                    <div class="input">
                        <span>Confirm Password</span>
                        <input type="password" name="re_pass" style="font-size: 14px; padding: 5px;">
                        <div id="confirm-password-error" class="error-message"></div>
                    </div>
                    <div class="input">
                        <input type="submit" value="Change Password" name="submit" style="font-size: 14px; padding: 5px;">
                    </div>
                </form>
            </div>
        </div>
    </section>
</body>
</html>
