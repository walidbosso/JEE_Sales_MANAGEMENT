package cn.vente.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.CascadeType;


@Entity
public class Commandes {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int id_cmd;
	@ManyToOne(cascade = CascadeType.REMOVE)//when a User entity is deleted, Hibernate will automatically delete any associated COMMANDES entities as well.
    @JoinColumn(name = "id_user", referencedColumnName = "id")
    private User user;
	@ManyToOne
    @JoinColumn(name = "id_article", referencedColumnName = "id")
    private Articles article;
	@Column
	private Date date;
	@Column
	private int quantity;
	

	public int getId_cmd() {
		return id_cmd;
	}

	public void setId_cmd(int id_cmd) {
		this.id_cmd = id_cmd;
	}



	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getId_user() {
        return user != null ? user.getId() : 0;
    }

    public void setId_user(int id_user) {
      
        if (user == null) {
            user = new User();
        }
        user.setId(id_user);
    }
    
    
    public int getId_article() {
        return article != null ? article.getId() : 0;
    }

    public void setId_article(int id_user) {
      
        if (article == null) {
            article = new Articles();
        }
        article.setId(id_user);
    }
	
}
