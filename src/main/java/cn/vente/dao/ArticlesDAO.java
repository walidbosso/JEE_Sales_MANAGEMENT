package cn.vente.dao; 
 
import java.util.ArrayList;
import java.util.List; 
 
import org.hibernate.Session; 
import org.hibernate.Transaction; 
import org.hibernate.query.Query;
import cn.vente.model.*;  
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
 
public class ArticlesDAO { 
 
	 public Articles getById(int id) { 
	  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
	  Transaction transaction = session.beginTransaction(); 
	  Articles produit = session.get(Articles.class, id); 
	 
	  transaction.commit(); 
	  session.close(); 
	  return produit; 
	 } 
 
	// Search 
	 public List<Articles> getByName(String name) {
		 Session session = SessionFact.getSessionfactory().getCurrentSession(); 
		 Transaction transaction = session.beginTransaction(); 
		   // Query<Articles> query = session.createQuery("FROM Articles WHERE nom = :name ", Articles.class);
		    Query<Articles> query = session.createQuery("FROM Articles WHERE nom LIKE CONCAT('%', :name, '%')", Articles.class);
		    query.setParameter("name", name);
		    List<Articles> articles = query.list();
		    System.out.println("Articles found: " + articles);
	
		    transaction.commit();
		    session.close(); 
		    return articles;
		}
	 
	 public void save(Articles article) { 
	 
	  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
	  Transaction transaction = session.beginTransaction(); 
	  session.save(article); 
	 
	  transaction.commit(); 
	  session.close(); 
	 
	 } 
 

/*
 public List<Articles> getCartProducts(ArrayList<Articles> cardList) {
     List<Articles> products = new ArrayList<>();

     try (Session session = SessionFact.getSessionfactory().openSession()) {
         if (cardList.size() > 0) {
             for (Articles item : cardList) {
                 String query = "FROM Articles WHERE id = :id";
                 Query<Articles> hibernateQuery = session.createQuery(query, Articles.class);
                 hibernateQuery.setParameter("id", item.getId());
                 Articles row = hibernateQuery.uniqueResult();

                 if (row != null) {
                     row.setPrice(row.getPrice() * item.getQuantity());
                     row.setQuantity(item.getQuantity());
                     products.add(row);
                 }
             }
         }
     } catch (Exception e) {
         System.out.println(e.getMessage());
     }

     return products;
 }

 public double getTotalCartPrice(ArrayList<Articles> cartList) {
	    double sum = 0;

	    try (Session session = SessionFact.getSessionfactory().openSession()) {
	        if (cartList.size() > 0) {
	            for (Articles item : cartList) {
	                String query = "SELECT price FROM Articles WHERE id = :id";
	                Query<Double> hibernateQuery = session.createQuery(query, Double.class);
	                hibernateQuery.setParameter("id", item.getId());
	                Double price = hibernateQuery.uniqueResult();
	                if (price != null) {
	                    sum += price * item.getQuantity();
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return sum;
	}*/
 
 
	 
	 public void delete(Articles article) { 
	  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
	  Transaction transaction = session.beginTransaction(); 
	  session.delete(article); 
	 
	  transaction.commit(); 
	  session.close(); 
	 
	 } 
	 
	 public void update(Articles article) { 
	  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
	  Transaction transaction = session.beginTransaction(); 
	  session.update(article); 
	  transaction.commit(); 
	  session.close(); 
	 
 } 
  
	 @SuppressWarnings("unchecked") 
	 public List<Articles> getAll(){ 
	     Transaction transaction = null; 
	     List<Articles> articles = null; 
	     try ( Session session = SessionFact.getSessionfactory().openSession()){ 
	       
	      transaction = session.beginTransaction(); 
	      articles = session.createQuery("from Articles").list(); 
	      transaction.commit();  
	      session.close(); 
	       
	       
	     }catch(Exception e) { 
	      System.out.println(e.getMessage()); 
	       if (transaction != null) { 
	          transaction.rollback();} 
	
	     } 
	     
	     return articles ; 
	 } 

 
}