package de.atiw.sportfest.atiw_sportfest.xml;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;

public class XML {

	public static void main(String[] args) throws JDOMException {
		// TODO Auto-generated method stub

		SAXBuilder sax = new SAXBuilder();
		Document doc = null;

		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		System.out.println("TOMCAT Installation");
		int eingabe = 0;
		try {

			do {
				System.out.println("Was soll bearbeitet werden?");
				System.out.println("2) Context");
				System.out.println("1) Users");
				System.out.println("0) Beenden");
				eingabe = Integer.parseInt(br.readLine());
				switch (eingabe) {
				case 0:
					break;
				case 1:

					System.out.println("Bitte einen Usernamen eingeben");
					String userString = br.readLine();
					System.out.println("Bitte einen Passwort eingeben");
					String pwd = br.readLine();

					File f = new File("S:\\Steffen-Baehr\\Sportfest\\j\\atiw-sportfest\\out\\tomcat-users.xml");
					doc = sax.build(f);

					Element root = doc.getRootElement();
					List<Element> kinder = root.getChildren();

					Element user = new Element("user", "http://tomcat.apache.org/xml");
					user.setAttribute("username", userString);
					user.setAttribute("password", pwd);

					System.out.println(user.getAttributeValue("username"));
					System.out.println(user.getAttributeValue("password"));

					kinder.add(user);

					new XMLOutputter().output(doc, System.out);

					break;
				case 2:

					System.out.println("Bitte einen Usernamen für die Datenbank eingeben");
					String userDB = br.readLine();
					System.out.println("Bitte das Passwort eingeben");
					String pwdDB = br.readLine();
					System.out.println("Bitte die IP-Adresse der Datenbank angeben");
					String IPDB = br.readLine();
					System.out.println("Bitte den Namen der Datenbank angeben");
					String DBName = br.readLine();

					f = new File("S:\\Steffen-Baehr\\Sportfest\\j\\atiw-sportfest\\out\\context.xml");
					doc = sax.build(f);

					root = null;
					kinder = null;
					root = doc.getRootElement();
					kinder = root.getChildren();

					Element ressource = new Element("Resource");
					ressource.setAttribute("name", "jdbc/sportfest");
					ressource.setAttribute("auth", "Container");
					ressource.setAttribute("type", "javax.sql.DataSource");
					ressource.setAttribute("maxTotal", "100");
					ressource.setAttribute("maxIdle", "30");
					ressource.setAttribute("maxWaitMillis", "10000");
					ressource.setAttribute("username", userDB);
					ressource.setAttribute("password", pwdDB);
					ressource.setAttribute("driverClassName", "com.mysql.jdbc.Driver");
					StringBuilder sb = new StringBuilder();
					sb.append("jdbc:mysql://").append(IPDB).append(":3306/").append(DBName);
					ressource.setAttribute("url", sb.toString());

					System.out.println(ressource.getAttributeValue("username"));
					System.out.println(ressource.getAttributeValue("password"));

					kinder.add(ressource);

					new XMLOutputter().output(doc, System.out);

					break;
				default:
					System.out.println("Falsche Eingabe! Bitte erneut versuchen!");

				}

			} while (eingabe != 0);
			br.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
