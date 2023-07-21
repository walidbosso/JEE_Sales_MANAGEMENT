<%@ page import="cn.vente.dao.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.vente.model.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page
	import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");

User loggedIdUser = (User) session.getAttribute("loggedInUser");
int total = 0;
if (loggedIdUser == null) {
	response.sendRedirect(request.getContextPath() + "/user-system/sign-in.jsp");
	return;
}

if (loggedIdUser.isRole() == false) {
	response.sendRedirect(request.getContextPath() + "/vente-system/articles.jsp");
	return;
}

String login = (loggedIdUser != null) ? loggedIdUser.getLogin() : "";

List<String> articles_List = (List<String>) session.getAttribute("articles_List");
int number = 0;
int chek_number;
if (articles_List != null)
	number = articles_List.size();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Buy operations report</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/vente-system/css/nav_style.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css">
<link rel="icon"
	href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" />

<style>
body {
	margin: 30px
}
</style>
</head>
<body>
	<header>
		<a href="${pageContext.request.contextPath}/vente-system/articles.jsp"><img
			src="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png"
			alt="Logo"></a>

		<form id="printButton" action="search" method="get"
			class="search-form">
			<input type="text" name="query" placeholder="Search..."
				class="search-input">
			<button type="submit" class="search-button">
				<i class="fas fa-search"></i>
			</button>
		</form>

		<nav class="navbar" id="printButton">
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
						<%
						if (loggedIdUser.isRole() == true) {
						%>
						<li><a
							href="${pageContext.request.contextPath}/vente-system/report.jsp">Report</a></li>
						<%
						}
						%>
						<%
						if (loggedIdUser.isRole() == true) {
						%>
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
	<br />
	<br />
	<br />
	<h1
		style="margin-bottom: 30px; margin-top: 30px; font-family: sans-serif;">Buy
		operations report</h1>

	<table>
		<tr>
			<th>Product Name</th>
			<th>Date of Purchase</th>
			<th>Client Name</th>
			<th>Quantity</th>
			<th>Price</th>

		</tr>
		<%
		ArticlesDAO dao_article = (ArticlesDAO) context.getBean("ArticlesDAO");
		UserDAO dao_user = (UserDAO) context.getBean("UserDAO");
		CommandeDAO dao_commande = (CommandeDAO) context.getBean("CommandeDAO");
		List<Commandes> commandes = dao_commande.getAll();
		%>
		<%
		for (Commandes c : commandes) {
			total += dao_article.getById(c.getId_article()).getPrice() * c.getQuantity();
		%>
		<tr>
			<td><%=dao_article.getById(c.getId_article()).getNom()%></td>
			<td><%=c.getDate()%></td>
			<td><%=dao_user.getById(c.getId_user()).getLogin()%></td>
			<td><%=c.getQuantity()%></td>
			<td><%=dao_article.getById(c.getId_article()).getPrice() * c.getQuantity()%></td>
		</tr>
		<%
		}
		%>
	</table>
	<br>
	<br>
	<p>
		<span
			style="font-size: 150%; position: absolute; left: 40%; display: inline; font-weight: bold; font-family: sans-serif; color: red;">Total
			Profit:</span> <span
			style="font-size: 140%; position: absolute; left: 76%; font-family: sans-serif; font-weight: bold; color: green;"><%=total%>
			$</span>
	</p>

	<button id="printButton" style="margin: 10px;"
		class="btn btn-success col col-md-1" onclick="print()">Print
		Report</button>

	<br>
	<br>

	<a id="printButton" href="#" title="Scroll up" class="up"
		style="font-size: 160%; text-decoration: none; float: right; background-color: red; color: white; border-radius: 10px;">^</a>

	<br>
	<br>

</body>
</html>
