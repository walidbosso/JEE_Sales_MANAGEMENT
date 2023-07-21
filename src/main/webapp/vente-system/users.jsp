<%@ page import="java.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="cn.vente.dao.UserDAO"%>
<%@ page import="cn.vente.model.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");

List<Articles> articles_List = (List<Articles>) session.getAttribute("articles_List");

User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect(request.getContextPath() + "/user-system/sign-in.jsp");
    return;
}


if (loggedInUser.isRole() == false) {
    response.sendRedirect(request.getContextPath() + "/vente-system/articles.jsp");
    return;
}

String login = (loggedInUser != null) ? loggedInUser.getLogin() : "";

int number = 0;
if (articles_List != null) {
    number = articles_List.size();
}


%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/vente-system/css/nav_style.css">
<link rel="icon"
	href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" />
<title>Users Management</title>

<style>
</style>
</head>

<body>

	<header>
		<a href="${pageContext.request.contextPath}/vente-system/articles.jsp"><img
			src="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png"
			alt="Logo"></a>

		<form action="search" method="get" class="search-form">
			<input type="text" name="query" placeholder="Search..."
				class="search-input">
			<button type="submit" class="search-button">
				<i class="fas fa-search"></i>
			</button>
		</form>

		<nav class="navbar">
			<ul>
				<li><a
					href="${pageContext.request.contextPath}/vente-system/articles.jsp">Home</a></li>
				<li><a href="/Vente_management/vente-system/cart.jsp">Cart
						<span
						style="background-color: rgb(144, 238, 144); border-radius: 5px; position: relative; top: -5px; font-size: 0.7em; padding: 2px 2.5px;">
							<%=number%>
					</span>
				</a></li>
				<li><a href="#"><%=login%> </a>
					<ul>
						<li><a
							href="${pageContext.request.contextPath}/vente-system/orders.jsp">Orders</a></li>
						<li><a
							href="${pageContext.request.contextPath}/user-system/reset-password.jsp">Change
								password</a></li>
						<%        if (loggedInUser.isRole() == true) { %>
						<li><a
							href="${pageContext.request.contextPath}/vente-system/report.jsp">Report</a></li>
						<%
				            }
				        %>
						<%        if (loggedInUser.isRole() == true) { %>
						<li><a
							href="${pageContext.request.contextPath}/vente-system/users.jsp">Users
								Management</a></li>
						<%
				            }
				        %>
						<li><a href="logout.action">Log out</a></li>
					</ul></li>
			</ul>
		</nav>
	</header>
	<br>

	<br>
	<br>

	<%
            // un error msg sera recu f URL, melli kan testiw f GeneratePDF w kan jebro ma andnashi quanitity kafia
       String errorMessage = (String) session.getAttribute("Userr");
         session.removeAttribute("Userr");
         if(errorMessage!=null){
        %>

	<div class="alert alert-danger"
		style="width: 35%; margin: 30px auto; text-align: center; padding-left: 20px;">
		<%= errorMessage %>
	</div>

	<% } %>

	<%
            // un error msg sera recu f URL, melli kan testiw f GeneratePDF w kan jebro ma andnashi quanitity kafia
       String validMessage = (String) session.getAttribute("UserAdmin");
         session.removeAttribute("UserAdmin");
         if(validMessage!=null){
        %>

	<div class="alert alert-success"
		style="width: 35%; margin: 30px auto; text-align: center; padding-left: 20px;">
		<%= validMessage %>
	</div>

	<% } %>

	<h2 style="text-align: center; font-family: sans-serif; margin: 30px">Users
		Management</h2>

	<form id="checkout-form" style="margin: 30px;">
		<table id="cart-table">
			<thead>
				<tr>
					<th></th>
					<th style="text-align: center;">User Id</th>
					<th style="text-align: center;">User name</th>
					<th style="text-align: center;">Admin</th>
					<th style="text-align: center;">Action</th>


				</tr>
			</thead>
			<tbody>
				<%      
    UserDAO dao_user = (UserDAO) context.getBean("UserDAO");
    
    List<User> users = dao_user.getAll(); %>
				<%       
     for (User user : users) {
    	 if (user.getId()==0) continue;
    	
    %>
				<tr>
					<td></td>
					<td style="text-align: center;"><%=user.getId()%></td>
					<td style="text-align: center;"><%=user.getLogin()%></td>
					<td style="text-align: center;"><%=user.isRole()%></td>
					<td style="text-align: center"><a
						onclick="showConfirmation(event, this)"
						href="AdminUser.action?id=<%=user.getId()%>"
						class="btn btn-primary success-btn myButtonAdmin">Make Admin</a> <a
						onclick="showConfirmation(event, this)"
						href="RemoveUser.action?id=<%=user.getId()%>"
						class="btn btn-danger myButtonDelete">Delete User</a></td>



				</tr>
				<% 
             }
         
         %>
			</tbody>
		</table>

	</form>

	<!-- Custom Confirmation Dialog -->
	<div id="confirmationDialog" class="confirmation-dialog">
		<div class="dialog-content">
			<h3 class="dialog-title">Confirmation</h3>
			<p class="dialog-message"></p>
			<div class="dialog-buttons">
				<button class="confirm-button">Confirm</button>
				<button class="cancel-button">Cancel</button>
			</div>
		</div>
	</div>

	<br>
	<br>

	<script>
        
    function showConfirmation(event, button) {
    	//1 hot div, 2 css, 3 had script
    	  event.preventDefault();

    	  var userName = $(button).closest("tr").find("td:nth-child(3)").text(); // a9raf tr (lign) jib data li f col 3 hadi dial jquery
    	  var dialog = $("#confirmationDialog"); //div kamla
    	  var message = dialog.find(".dialog-message"); // f dak fiv find li ando dak class, f had lhala dak <p> bach n affichiwha  bghina nzido fiha userName eliha kanet khawia f html
    	  var confirmButton = dialog.find(".confirm-button"); // on click fiha chghay wqa3
    	  var cancelButton = dialog.find(".cancel-button");
    	  
    	  message.text("Are you sure you want to proceed with this action for '" + userName + "'?"); //<p class="dialog-message"></p>

    	  dialog.fadeIn(); //show div confirmationDialog  

    	  confirmButton.off().on("click", function() {
       	    dialog.fadeOut(); //hide div
    	    // User clicked Confirm, perform the action
    	    window.location.href = button.getAttribute("href");//mshi l dak href li f href
    	  });

    	  cancelButton.off().on("click", function() {
    	    dialog.fadeOut();//hide div
    	    // User clicked Cancel, do nothing
    	  });
    	  
    	 
    	}

    
	    // Normal window.confirm khass gha teeml  a href class="MyButtonAdmin"
	    /*
	    $(document).ready(function() {
	        	
	    	  $(".myButtonAdmin").click(function() { // khass class, hit id ki fa3al ghi button lowel
	    	      event.preventDefault(); // Prevent the default navigation behavior
	
	    	      var userName = $(this).closest("tr").find("td:nth-child(3)").text();
	    	      var confirmResult = confirm("Are you sure you want to make ' " + userName + " ' an admin?");
	
	    	      if (confirmResult) {
	    	        // User clicked OK, navigate to the specified URL
	    	        window.location.href = $(this).attr("href");
	    	      } else {
	    	        // User clicked Cancel, do nothing
	    	      }
	    	    });
	            
	    	  $(".myButtonDelete").click(function() {
	    	      event.preventDefault(); //Prevent the default navigation behavior
	
	    	      var userName = $(this).closest("tr").find("td:nth-child(3)").text(); //closesr tr (ligne), surf td col 3 jQuery, will find the third <td> 
	    	      var confirmResult = confirm("Are you sure you want to delete ' " + userName + " ' ?");
	
	    	      if (confirmResult) {
	    	        // User clicked OK, navigate to the specified URL
	    	        window.location.href = $(this).attr("href");
	    	      } else {
	    	        // User clicked Cancel, do nothing
	    	      }
	    	    });
	        });*/
      </script>
</body>
</html>
