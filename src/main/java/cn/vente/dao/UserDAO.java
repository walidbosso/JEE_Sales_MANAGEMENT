package cn.vente.dao; 
 
import java.util.List;
import org.hibernate.Session; 
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import cn.vente.model.*;  
 
public class UserDAO { 
 
 public User getById(int id) { 
  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
  Transaction transaction = session.beginTransaction(); 
  User user = session.get(User.class, id); 
 
  transaction.commit(); 
  session.close(); 
  return user; 
 } 
 public User getByName(String name) {
	    Session session = SessionFact.getSessionfactory().getCurrentSession();
	    Transaction transaction = session.beginTransaction();

	    Query<User> query = session.createQuery("FROM User WHERE name = :name", User.class);
	    query.setParameter("name", name);

	    User user = query.uniqueResult();

	    transaction.commit();
	    session.close();

	    return user;
	}

 
 public void save(User user) { 
 
  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
  Transaction transaction = session.beginTransaction(); 
  session.save(user); 
 
  transaction.commit(); 
  session.close(); 
 
 } 
 
 public void delete(User user) { 
  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
  Transaction transaction = session.beginTransaction(); 
  session.delete(user); 
 
  transaction.commit(); 
  session.close(); 
 
 } 
 
 public void update(User user) { 
  Session session = SessionFact.getSessionfactory().getCurrentSession(); 
  Transaction transaction = session.beginTransaction(); 
  session.update(user); 
  transaction.commit(); 
  session.close(); 
 
 } 
  
 @SuppressWarnings("unchecked") 
  public List<User> getAll(){ 
      Transaction transaction = null; 
      List<User> users = null; 
      try ( Session session = SessionFact.getSessionfactory().openSession()){ 
        
       transaction = session.beginTransaction(); 
       users = session.createQuery("from User").list(); 
       transaction.commit();
       session.close(); 
       
        
        
      }catch(Exception e) { 
       System.out.println(e.getMessage()); 
        if (transaction != null) { 
           transaction.rollback();} 
 
      } 
       
      return users; 
  } 
 
}