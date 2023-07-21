
<%@ page import="cn.vente.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.vente.model.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import=" org.springframework.context.support.ClassPathXmlApplicationContext "%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="javax.servlet.http.HttpSession"%>


<%
ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");

List<String> articles_List = (List<String>) session.getAttribute("articles_List");


User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect(request.getContextPath() + "/user-system/sign-in.jsp");
    return;
}
String login = (loggedInUser != null) ? loggedInUser.getLogin() : "";

int number = 0;
int chek_number ;
if (articles_List != null) {
	
	number = articles_List.size();
	
	
	

}
%>


<!DOCTYPE html>
<html>
<head>
<title>Search Result</title>
<meta charset="ISO-8859-1">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/vente-system/css/style.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/vente-system/css/nav_style.css">
<link rel="icon"
	href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" />
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
						style="color: white; background-color: red; border-radius: 5px; position: relative; top: -5px; font-size: 0.7em; padding: 2px 2.5px;">
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

	<% String query = request.getParameter("query"); %>
	<section class="products">
		<h2 style="font-size: 140%; text-shadow: 5px 5px 5px red;">
			Search Result for "	<%= query %> "
		</h2>

		<div class="all-products">
			<%
            
            List<Articles> articles = (List<Articles>) session.getAttribute("articles_Search");
        		%>
			<%
            for (Articles article : articles) {
            %>
			<div class="product" style="height: 500px; width: 300px">

				<img
					src="${pageContext.request.contextPath}/vente-system/images/<%=article.getImage()%>">

				<div class="product-info">
					<h5 class="product-title"><%=article.getNom()%></h5>
					<p class="product-price"><%=article.getPrice()%>
						$
					</p>
					<p class="product-price"><%=article.getDescription()%></p>
					<p class="product-price" style="color: grey; font-size: 50%">
						Quantity left:
						<%=article.getQuantity()%></p>
					<a class="addToCartButton"
						href="toCart.action?id=<%=article.getId()%>">Add to cart</a>
				</div>
			</div>
			<%
            }
            %>
		</div>
	</section>


</body>
</html>

