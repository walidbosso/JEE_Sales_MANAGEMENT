import java.awt.Desktop;
import java.io.FileOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.Map;
import org.apache.struts2.interceptor.SessionAware;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import org.apache.struts2.ServletActionContext;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import cn.vente.model.*;
import cn.vente.dao.*;
import org.apache.struts2.ServletActionContext;

import java.net.URLEncoder;


public class GeneratePDF implements SessionAware {
	private Map<String, Object> session;
	static BaseColor color = new BaseColor(135, 206, 235); // RGB values for #2c3e50
	private String login;
	private User user;
	private ApplicationContext context = new ClassPathXmlApplicationContext("ApplicationCentext.xml");
	public String ret; //return when articles quantity is not enough, its to prevent cartcontroller generatepdf from continuing the code and delete the cartlist

	public GeneratePDF() {
		super();
	}
	
	public String getret() {
		
		return ret;
	}
	
	public void downloadPDF(List<Articles> pdflist) {
		try {
			
			ServletContext servletContext = ServletActionContext.getServletContext();
			HttpSession session_user = ServletActionContext.getRequest().getSession(false);
			
			//Test quantity if its correct, and not > stock
			for (Articles art : pdflist) {
			int id = art.getId();
			ArticlesDAO dao_art = (ArticlesDAO) context.getBean("ArticlesDAO");
			Articles article = dao_art.getById(id);
			ret="";
			if (article.getQuantity() - art.getQuantity() < 0)  {
	        	 ret = "return";
	        	 String errorMessage = "Insufficient quantity for " + article.getNom() + ", the quantity in our store is actually " + article.getQuantity();
	             // Encode the error message for URL
	             String encodedErrorMessage = URLEncoder.encode(errorMessage, "UTF-8");
	             //ghayrja3 l cart b msg, w khesna hta hta generate lif CartController may kmlchi ela code bach maymsahchi List eliha staemlt variable ret
	             String redirectUrl = ServletActionContext.getRequest().getContextPath() + "/vente-system/cart.jsp?error=" + encodedErrorMessage;
	             
	             try {
	                 ServletActionContext.getResponse().sendRedirect(redirectUrl);
	             } catch (IOException e) {
	                 // Handle the exception
	             }
	             return; // Return null to prevent further processing
	        	}}
					
			if (session_user != null) {
				user = (User) session_user.getAttribute("loggedInUser");
				login = (user != null) ? user.getLogin() : "";
			}
			DateFormat dateFormat1 = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss", Locale.ENGLISH);
			Date date1 = new Date();
			
			String file_name = "C:\\Users\\packardbell\\Desktop\\Rayban_invoice_details_"+ dateFormat1.format(date1)+".pdf";
			Document document = new Document();
			PdfWriter.getInstance(document, new FileOutputStream(file_name));
			document.open();

			// Add logo
			Image logo = Image.getInstance(
					"C:\\Users\\packardbell\\Desktop\\Master M2I\\M2I_S2\\1-Génie Logiciel\\6-Master 2023 (projet)\\Projet_fin_de_module\\Vente_management\\src\\main\\webapp\\images\\rayban_logo.png");
			logo.scalePercent(17);
			logo.setAbsolutePosition(36, document.getPageSize().getHeight() - 36 - logo.getScaledHeight());
			document.add(logo);

			// Add invoice title
			Font paraFont = new Font(Font.FontFamily.HELVETICA, 17);
			Paragraph para = new Paragraph("Your invoice ", paraFont);
			para.setAlignment(Element.ALIGN_CENTER);
			para.setSpacingBefore(25);
			para.setSpacingAfter(75);
			document.add(para);

			// Add current date
			DateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM dd, yyyy 'at' HH:mm:ss", Locale.ENGLISH);
			Date date = new Date();
			Phrase timePhrase = new Phrase("Mr. " + login + " on " + dateFormat.format(date));
			document.add(timePhrase);

			// Create the table
			PdfPTable table = new PdfPTable(5); // Number of columns
			table.setTotalWidth(500);
			table.setLockedWidth(true); // Lock the width of the table

			// Set the relative widths of the columns
			float[] columnWidths = { 3, 6, 3, 2, 3 }; // Relative widths of columns (change as per your requirement)
			table.setWidths(columnWidths);

			// Define header font
			Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);

			PdfPCell cell = new PdfPCell(new Phrase("Name", headerFont));
			cell.setBackgroundColor(color);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);

			cell = new PdfPCell(new Phrase("Description", headerFont));
			cell.setBackgroundColor(color);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);

			cell = new PdfPCell(new Phrase("Price", headerFont));
			cell.setBackgroundColor(color);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);

			cell = new PdfPCell(new Phrase("Quantity", headerFont));
			cell.setBackgroundColor(color);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);

			cell = new PdfPCell(new Phrase("SubTotal", headerFont));
			cell.setBackgroundColor(color);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);

			table.setHeaderRows(1);

			// Set the minimum height for cells
			float minimumHeight = 20f;
			
			CommandeDAO dao_cmd = (CommandeDAO) context.getBean("CommandeDAO");
			int total = 0;
			
			for (Articles art : pdflist) {
				Commandes cmd = (Commandes) context.getBean("Commandes");
					
				
				PdfPCell cell1 = new PdfPCell(new Phrase(art.getNom()));
				cell1.setMinimumHeight(minimumHeight);
				table.addCell(cell1);

				PdfPCell cell2 = new PdfPCell(new Phrase(art.getDescription()));
				cell2.setMinimumHeight(minimumHeight);
				table.addCell(cell2);

				PdfPCell cell3 = new PdfPCell(new Phrase(Double.toString(art.getPrice()) + " $"));
				cell3.setMinimumHeight(minimumHeight);
				table.addCell(cell3);

				PdfPCell cell4 = new PdfPCell(new Phrase(Integer.toString(art.getQuantity())));
				cell4.setMinimumHeight(minimumHeight);
				table.addCell(cell4);

				PdfPCell cell5 = new PdfPCell(new Phrase(Double.toString(art.getPrice() * art.getQuantity()) + " $"));
				cell5.setMinimumHeight(minimumHeight);
				table.addCell(cell5);

				total += art.getPrice() * art.getQuantity();
				
				
				int id = art.getId(); // chaque article dans CartList de session
				ArticlesDAO dao_art = (ArticlesDAO) context.getBean("ArticlesDAO");
				Articles article = dao_art.getById(id); // kan chof dak article f BD
				ret="";
				if (article.getQuantity() - art.getQuantity() >= 0) {
		            article.setQuantity(article.getQuantity() - art.getQuantity());
		            dao_art.update(article);
		            
		        } else { //deja emlna test hada maghay teqrashi mais hania khalliha
		        	 ret = "return";
		        	 String errorMessage = "Error: Insufficient quantity for " + article.getNom() + ", the quantity in our store is actually " + article.getQuantity();
		             // Encode the error message for URL
		             String encodedErrorMessage = URLEncoder.encode(errorMessage, "UTF-8");
		             //ghayrja3 l cart b msg, w khesna hta hta generate lif CartController may kmlchi ela code bach maymsahchi List eliha staemlt variable ret
		             String redirectUrl = ServletActionContext.getRequest().getContextPath() + "/vente-system/cart.jsp?error=" + encodedErrorMessage;
		             
		             try {
		                 ServletActionContext.getResponse().sendRedirect(redirectUrl);
		             } catch (IOException e) {
		                 // Handle the exception
		             }
		             return; // Return null to prevent further processing
		        	}
				
				
				cmd.setDate(date);
				cmd.setId_article(art.getId());
				cmd.setId_user(user.getId());
				cmd.setQuantity(art.getQuantity());
				dao_cmd.save(cmd);
							

			}
			
			
			  
			document.add(table);
			Phrase timePhrase1 = new Phrase("\n  Total : " + total + " $");
			document.add(timePhrase1);
			document.close();
			
			File file = new File(file_name);
            
            
            if (file.exists()) {
                // Open the file using the default application
                Desktop.getDesktop().open(file);
            } else {
                System.out.println("File does not exist.");
            }
		} catch (Exception e) {
			System.err.print(e);
		}
	}

	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}
}
