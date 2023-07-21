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
<html>
<head>
    <meta charset="UTF-8">
    <title>History of orders</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/vente-system/css/nav_style.css">
    <link rel="icon" href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" /> 
    
    <style>
		
		.up{transition : all 0.4s ease-out;margin:10px;}
		.up:hover{border-radius:400px; transform:rotate(720deg); text-shadow: 0 0 4px blue; box-shadow: 0px 0px 7px red;}
		.up:hover{background-color:red;transition : all 0s ease-out;}
		html {
		  scroll-behavior: smooth;
		}
        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-family: sans-serif;
        }

        th {
            background-color: #2c3e50;
            color: #fff;
        }
    </style>
</head>
<body>
  <header>
        <a href="${pageContext.request.contextPath}/vente-system/articles.jsp"><img src="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" alt="Logo"></a>
        
         <!-- Search Form -->
       <form action="search" method="get" class="search-form">
				  <input type="text" name="query" placeholder="Search..." class="search-input">
				  <button type="submit" class="search-button">
				    <i class="fas fa-search"></i>
				  </button>
		</form>
        
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
  <br/><br/><br/>
  <h1 style="font-family: sans-serif;"> <%=login%>'s orders:</h1>
  <%  
    ArticlesDAO dao_article = (ArticlesDAO) context.getBean("ArticlesDAO");
    UserDAO dao_user = (UserDAO) context.getBean("UserDAO");
    CommandeDAO dao_commande = (CommandeDAO) context.getBean("CommandeDAO");
    List<Commandes> commandes = dao_commande.getAll();
  %>
  <table>
    <tr>
        <th>Product Name</th>
        <th>Date of Purchase</th>
        <th>Client Name</th>
        <th>Quantity</th>
        <th>Price</th>
    </tr>
    <% for (Commandes c : commandes) {
       if(c.getId_user() == loggedIdUser.getId()) {
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
    } %>
  </table>
  <br>
	<a href="#" title="Scroll up" class="up" style="font-size:160%; text-decoration:none; float:left; border-radius:10px;background-color:red;color:white">^</a>
	<a href="#" title="Scroll up" class="up" style="font-size:160%; text-decoration:none;float:right; border-radius:10px;background-color:red;color:white">^</a>
	<br><br>
</body>
</html>
