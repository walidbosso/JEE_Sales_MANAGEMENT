package cn.vente.dao;

import org.hibernate.SessionFactory; 
import org.hibernate.boot.registry.StandardServiceRegistryBuilder; 
import org.hibernate.cfg.Configuration; 
import org.hibernate.service.ServiceRegistry;

import cn.vente.model.*;

public class SessionFact {

	private static final ServiceRegistry serviceRegistry;
	private static final SessionFactory sessionFactory;
	
	static {
	Configuration config = new Configuration();
	config.configure();

	config.addAnnotatedClass(Articles.class);
	config.addAnnotatedClass(Commandes.class);
	config.addAnnotatedClass(User.class);


	serviceRegistry = new StandardServiceRegistryBuilder().applySettings(config.getProperties()).build();
	sessionFactory = config.buildSessionFactory(serviceRegistry);
	}

	public static SessionFactory getSessionfactory() {
		return sessionFactory;
	}
}
