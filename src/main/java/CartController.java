import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.SessionAware;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.opensymphony.xwork2.ActionSupport;
import cn.vente.model.Articles;
import cn.vente.dao.ArticlesDAO;

public class CartController extends ActionSupport implements SessionAware {

	private String id;
	private String inc_id;
	private String dec_id;
	private ArrayList<Articles> articles_List = new ArrayList<>();
	private Map<String, Object> session; // autre method pour acceder au session, method akhor howa httpSession,
											// setAttribut getAttribut
	private Articles article;

	// get spring config file
	ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");
	ArticlesDAO dao = (ArticlesDAO) context.getBean("ArticlesDAO");

	public String AddProduct() {

		List<Articles> storedIdList = (List<Articles>) session.get("articles_List");

		if (storedIdList == null) {
			storedIdList = new ArrayList<>();
		}

		// create dao object using Spring
		ArticlesDAO dao = (ArticlesDAO) context.getBean("ArticlesDAO");

		article = dao.getById(Integer.parseInt(id));
		article.setQuantity(1);
		int i = 0;
		for (Articles art : storedIdList)
			if (art.getId() == Integer.parseInt(id)) {
				i = 1;
			}

		// only add when it doesn't exist in session storedList
		if (i == 0) {
			storedIdList.add(article);
			session.put("articles_List", storedIdList);
		}
		return "success";
	}

	public String RemoveProduct() {
		List<Articles> storedIdList = (List<Articles>) session.get("articles_List");

		for (Articles storedArticle : storedIdList) {
			if (storedArticle.getId() == Integer.parseInt(id)) {
				storedIdList.remove(storedArticle);
				break;
			}
		}

		session.put("articles_List", storedIdList);

		return "success";
	}

	@SuppressWarnings("unchecked")
	public String Inc_quantity() {
		List<Articles> storedIdList = (List<Articles>) session.get("articles_List");
		System.out.println(id);
		for (Articles storedArticle : storedIdList) {
			if (storedArticle.getId() == Integer.parseInt(id)) {
				// Articles article = dao.getById(storedArticle.getId());
				int qte = storedArticle.getQuantity();
				qte++;
				System.out.println(qte);
				// if(qte<=article.getQuantity())storedArticle.setQuantity(qte);
				storedArticle.setQuantity(qte);
				System.out.println(qte);
				break;
			}
		}

		session.put("articles_List", storedIdList);

		return "success";
	}

	public String Dec_quantity() {
		List<Articles> storedIdList = (List<Articles>) session.get("articles_List");

		for (Articles storedArticle : storedIdList) {
			if (storedArticle.getId() == Integer.parseInt(id)) {
				int qte = storedArticle.getQuantity();
				if (qte > 1)
					qte--;
				storedArticle.setQuantity(qte);
				break;
			}
		}

		session.put("articles_List", storedIdList);

		return "success";
	}

	public String generatePDF() {
		List<Articles> storedIdList = (List<Articles>) session.get("articles_List");
		System.out.println("Cart is empty: " + storedIdList.isEmpty());
		if (storedIdList.isEmpty()) {
			// System.out.println(storedIdList);
			// new GeneratePDF().downloadPDF(storedIdList);
			session.put("error", "There are no articles in the cart.");
			return "false";

		} else {
			GeneratePDF pdf = new GeneratePDF();
			pdf.downloadPDF(storedIdList);

			// chof had partie zidta bach may emlchi clear, tq ida ret=return yaeni dkhal f
			// quantity machi kafia, ghay rja3 l cart wiy qollo bedl
			String ret = pdf.getret();
			System.out.println("if ret = return, quantity isn't enough");
			System.out.println("ret = " + ret);
			if (ret == "return")
				return "false";

			// Clear the ArrayList
			storedIdList.clear();

			// Store the modified ArrayList back in the session
			session.put("articles_List", storedIdList);
		}
		return "success";
	}

	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getInc_id() {
		return inc_id;
	}

	public void setInc_id(String inc_id) {
		this.inc_id = inc_id;
	}

	public String getDec_id() {
		return dec_id;
	}

	public void setDec_id(String dec_id) {
		this.dec_id = dec_id;
	}

	public ArrayList<Articles> getArticles_List() {
		return articles_List;
	}

	public void setArticles_List(ArrayList<Articles> articles_List) {
		this.articles_List = articles_List;
	}
}
