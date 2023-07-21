<%@ page import="java.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="cn.vente.dao.ArticlesDAO"%>
<%@ page import="cn.vente.model.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%
ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");

List<Articles> articles_List = (List<Articles>) session.getAttribute("articles_List");

User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect(request.getContextPath() + "/user-system/sign-in.jsp");
    return;
}
String login = (loggedInUser != null) ? loggedInUser.getLogin() : "";

int number = 0;
if (articles_List != null) {
    number = articles_List.size();
}

int total = 0;
if (articles_List != null) {
    for (Articles c : articles_List) {
        total += c.getPrice() * c.getQuantity();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
     <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/vente-system/css/nav_style.css">
    <link rel="icon" href="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" /> 
    <title>Products added to cart</title>
</head>
<body>

  <header>
        <a href="${pageContext.request.contextPath}/vente-system/articles.jsp"><img src="${pageContext.request.contextPath}/vente-system/images/rayban_logo.png" alt="Logo"></a>
        
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
                        <%        if (loggedInUser.isRole() == true) { %>
				        <li><a href="${pageContext.request.contextPath}/vente-system/report.jsp">Report</a></li> 
				        <%
				            }
				        %>
				         <%        if (loggedInUser.isRole() == true) { %>
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
    <br>
    
    <br><br>
    <%
            
       String errorMessagee = (String) session.getAttribute("error");
         session.removeAttribute("error");
         if(errorMessagee!=null){
        %>
        
        <div class="alert alert-danger" style="width: 35%; margin: 30px auto; text-align: center; padding-left: 20px;">
  <%= errorMessagee %>
</div>
    <%
            }
        %>
     <%
            // un error msg sera recu f URL, melli kan testiw f GeneratePDF w kan jebro ma andnashi quanitity kafia
        String encodedErrorMessage = request.getParameter("error");
        if (encodedErrorMessage != null) {
            // Decode the error message from URL parameter
            String errorMessage = java.net.URLDecoder.decode(encodedErrorMessage, "UTF-8");
        %>
        <div class="alert alert-danger" style=" text-align:center;width: 35%; margin:30px auto; ">
        <%= errorMessage %>
        </div>
        <%
            }
        %>
       
        
    <h2 style="font-family: sans-serif; margin: 10px 10px 10px 10px">Your selected products:</h2>
    <form id="checkout-form" style=" margin: 10px 10px 10px 10px">
        <table id="cart-table">
            <thead>
                <tr>
                    <th></th>
                    <th>Product Name</th>
                    <th>Description</th>
                    <th style="color:text-align:center;">Quantity</th>
                    <th>Price</th>
                    <th>Subtotal</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            
                <% 
                ArticlesDAO dao = (ArticlesDAO) context.getBean("ArticlesDAO");
                %>
                <% 
                if (articles_List != null) {
                    for (Articles c : articles_List) {
                %>
                
                <tr>
                    <td><img src="images/<%=c.getImage()%>" alt="Product Image" width="50"></td>
                    <td><%=c.getNom()%></td>
                    <td><%=c.getDescription()%></td>
                    <td>
                        <a href = "dec_quantity.action?id=<%=c.getId()%>" class="quantity-btn minus-btn" style="color:red;" title="Decrement quantity">
                            <i class="fas fa-minus"></i>
                        </a>
                        <input  value="<%=c.getQuantity()%>" min="1" style="width: 50px; text-align:center;">
                        <a href = "inc_quantity.action?id=<%=c.getId()%>" class="quantity-btn plus-btn" style="color: green;" title="Incerement quantity">
                            <i class="fas fa-plus"></i>
                        </a>
                    </td>
                    <td class="price"><%=c.getPrice()%> $</td>
                    <td class="subtotal"><%=c.getPrice() * c.getQuantity()%>$</td>
                    <td><a href="Remove.action?id=<%=c.getId()%>" class="btn btn-primary delete-btn">Delete</a></td>
                </tr>
                <% 
                    }
                }
                %>
            </tbody>
        </table>
        <br>
        <p>
            <span style="font-size:130%;position: absolute; left: 65%; display: inline; font-weight: bold; font-family: sans-serif; color: red; ;">Total:</span>
            <span style="font-size:130%;position: absolute; left: 76%; font-family: sans-serif; font-weight: bold;color:green;"><%=total %> $</span>
        </p>
    </form>
     
    <a style="margin: 10px 10px 10px 10px" id="myButton" href="invoice_pdf.action" class="btn btn-primary checkout-btn">Checkout</a>
    
    <script>
        function Inc_cart(inc_id) {
            window.location.href = "inc_quantity.action?id=" + inc_id;
        }
        function Dec_cart(dec_id) {
            window.location.href = "dec_quantity.action?id=" + dec_id;
        }
        
        
        $(document).ready(function() {
        	
            $("#myButton").click(function() {
              
                alert("Payment received. Your purchase is confirmed!");
            });
        });
   
        
    </script>
    
    <br><br>
   
</body>
</html>
