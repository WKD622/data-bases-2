import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import javax.persistence.TypedQuery;
import java.util.List;

public class Main {
    private static SessionFactory sessionFactory = null;

    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();
        Transaction tx = session.beginTransaction();

        Product product1 = new Product("maslo", 10);
        Product product2 = new Product("melko", 20);
        Product product3 = new Product("kurczak", 5);
        Product product4 = new Product("kalafior", 40);
        Product product5 = new Product("rzodkiewka",25);

        Supplier supplier1 = new Supplier("Warz-POL", "Leśna", "Białystok", "10-650", 10, 1111111111);
        Supplier supplier2 = new Supplier("Nabiał-POL", "Wrzosowa", "Warszawa", "60-100", 23, 222222222);
        Supplier supplier3 = new Supplier("Mięs-POL", "Akacjowa", "Malbork", "15-230", 8, 333333333);

        Category category1 = new Category("nabiał");
        Category category2 = new Category("mięso");
        Category category3 = new Category("warzywa");

        Invoice invoice1 = new Invoice(5);
        Invoice invoice2 = new Invoice(10);

        session.save(product1);
        session.save(product2);
        session.save(product3);
        session.save(product4);
        session.save(product5);

        session.save(supplier1);
        session.save(supplier2);
        session.save(supplier3);

        session.save(category1);
        session.save(category2);
        session.save(category3);

        session.save(invoice1);
        session.save(invoice2);

        supplier1.addProduct(product4);
        supplier1.addProduct(product5);
        supplier2.addProduct(product1);
        supplier2.addProduct(product2);
        supplier3.addProduct(product3);

        category1.addProduct(product4);
        category1.addProduct(product5);
        category2.addProduct(product3);
        category3.addProduct(product1);
        category3.addProduct(product2);

        invoice1.addProduct(product1);
        invoice1.addProduct(product4);

        invoice2.addProduct(product3);
        invoice2.addProduct(product2);
        invoice2.addProduct(product5);

//        TypedQuery<Product> q1 = session.createQuery("select p.productName from Product p where p.category = 5");
//        TypedQuery<Category> q2 = session.createQuery("select c.name from Category c inner join Product p " +
//                "on p.category = c.categoryID where p.productName = 'kurczak'");
        TypedQuery<Product> q3 = session.createQuery("select p.productName from Product p inner join Invoice i on i.invoiceNumber=p.invoices where i.invoiceNumber = 12");

        List<Product> products2 = q3.getResultList();
        System.out.println(products2.toString());
//        List<Product> products1 = q1.getResultList();
//        List<Category> categories1 = q2.getResultList();
//        System.out.println(products1.toString());
//        System.out.println(categories1.toString());

        tx.commit();
        session.close();

    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration configuration = new Configuration();
            sessionFactory = configuration.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}