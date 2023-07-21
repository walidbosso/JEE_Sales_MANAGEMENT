import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.SessionAware;
import com.opensymphony.xwork2.ActionSupport;
import cn.vente.dao.UserDAO;
import cn.vente.model.User;


public class UserController extends ActionSupport implements SessionAware {

	private Map<String, Object> session; // we used Httpsession, but we can use this, just use session.put session.get in this page
	private String login;
	private String pass;
	private String new_pass;
	private String re_pass;
	
	ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");
	
	@Override //sessionaware
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}
	
	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getNew_pass() {
		return new_pass;
	}

	public void setNew_pass(String new_pass) {
		this.new_pass = new_pass;
	}

	public String getRe_pass() {
		return re_pass;
	}

	public void setRe_pass(String re_pass) {
		this.re_pass = re_pass;
	}

	// execute method signin
	public String login() {
		UserDAO dao = new UserDAO();
		List<User> users = dao.getAll();
		
		for (User user : users) {
			if (this.login.equals(user.getLogin()) && this.pass.equals(user.getPass())) {
				HttpServletRequest request = ServletActionContext.getRequest();
				HttpSession session = request.getSession();
				session.setAttribute("loggedInUser", user);

				return SUCCESS;
			}
		}

		return ERROR;
	}

	// signup
	public String sign_up() {
		UserDAO dao = new UserDAO();
		User new_user = new User();
		List<User> users = dao.getAll();
		for (User user : users) {
			if (user.getLogin().equals(login)) {
				HttpServletRequest request = ServletActionContext.getRequest();
				HttpSession session = request.getSession();
				session.setAttribute("Userr", "Username already taken, try another one.");
				return ERROR;
			}
		}
		if (login != null && pass != null && re_pass != null && pass.equals(re_pass)) {
			new_user.setLogin(login);

			new_user.setPass(pass);
			new_user.setRole(false);
			dao.save(new_user);
			HttpServletRequest request = ServletActionContext.getRequest();
			HttpSession session = request.getSession();
			session.setAttribute("loggedInUser", new_user);
			return SUCCESS;
		}
		return ERROR;
	}
	
	// execute method
	public String change_password() {
		UserDAO dao = (UserDAO) context.getBean("UserDAO");
		//ServletContext servletContext = ServletActionContext.getServletContext();
        HttpSession session = ServletActionContext.getRequest().getSession(false);
        
		User user = (User) session.getAttribute("loggedInUser");
		if(user.getPass().equals(pass) && new_pass.equals(re_pass)) {
			user.setPass(new_pass);
			dao.update(user);
			
		return SUCCESS ;
		}

		return ERROR;
	}
	
	//logout
    public String logout() {
    	HttpSession session = ServletActionContext.getRequest().getSession(false);
               
        if (session != null) {
            session.invalidate();
        }
        
        return SUCCESS;
    }

}
