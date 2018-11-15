import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.Scanner;

public class Main {
    private static SessionFactory sessionFactory = null;

    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();
        Transaction tx = session.beginTransaction();
        Scanner inputScanner = new Scanner(System.in);
        String prodName = inputScanner.nextLine();

        Product product = new Product("maslo", 10);
        session.save(product);

        Supplier supplier = new Supplier("Krakow", "Czarnowiejska", "AGH");
        supplier.addProduct(product);

        session.save(supplier);
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