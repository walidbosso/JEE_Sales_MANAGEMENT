import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

import cn.vente.model.*;
import cn.vente.dao.*;

public class Search extends ActionSupport implements SessionAware{
	private String query; //name=query (search)
	private String id; //id to remove and admin User darori teeml set w get
		private Map<String, Object> session; 
		
		public String getQuery() {
			return query;
		}

		public void setQuery(String query) {
			this.query = query;
		}
		
		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}
		
		//Search
		public String execute() {			
	        
			ArticlesDAO dao = new ArticlesDAO();
			System.out.println("parameter: " +this.query);
			List<Articles>articles = dao.getByName(this.query);     
			session.put("articles_Search", articles);
			
			return "success";
		}
		
		@Override
		public void setSession(Map<String, Object> session) {
			this.session = session;
		}
		
		public String RemoveUser() {
		    UserDAO dao = new UserDAO();
		   // CommandeDAO dao_cmd = new CommandeDAO();
		    
		    User user = dao.getById(Integer.parseInt(id));

		    if (user.isRole()) {
		        session.put("Userr", user.getLogin() + " can't be deleted because he's an admin.");
		        return "success";
		    }

		    /*  List<Commandes> commandes = dao_cmd.getByUserId(user.getId());

		    for (Commandes commande : commandes) {
		        commande.setId_user(0);
		        dao_cmd.update(commande);
		    }*/

		    dao.delete(user);
		    session.put("Userr", user.getLogin() + " is deleted.");
		    
		    return "success";
		}

		
		public String AdminUser() {
			UserDAO dao = new UserDAO();
			List<User> users = dao.getAll(); 

			for (User user : users) {
				if (user.getId()==Integer.parseInt(id)) {
					user.setRole(true);
					dao.update(user);
					session.put("UserAdmin", user.getLogin()+" is now admin");
					break;
				}
			}
			
			return "success";
		}
}
