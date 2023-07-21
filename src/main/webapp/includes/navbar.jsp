<nav class="navbar navbar-expand-lg navbar-light bg-light"
	style="position: fixed; top: 0; left: 0; right: 0;">

	<div class="container">
		<a class="navbar-brand" href="articles.jsp"> <img
			src="images/logo.jpg" alt="Logo" width="40" height="40"
			style="vertical-align: middle;">
			<h3 style="display: inline-block; margin-left: 2px;">PHONE STORE</h3>
		</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item active"><a class="nav-link"
					href="articles.jsp">Home </a></li>
				<li class="nav-item"><a class="nav-link position-relative"
					href="../vente-system/panier.jsp"> Card <samp
							class="badge badge-success position-absolute bottom-0 start-100 translate-middle-x p-1"
							style="font-size: 10px;">${cart_list.size()}</samp>
				</a></li>
			</ul>

		</div>
	</div>
</nav>
