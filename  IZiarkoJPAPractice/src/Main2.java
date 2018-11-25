import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

public class Main2 {
    //private static EntityManagerFactory emf = null;

    public static void main(String[] args) {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("myDatabaseConfig");
        EntityManager em = emf.createEntityManager();
        EntityTransaction etx = em.getTransaction();
        etx.begin();

        Product product1 = new Product("maslo", 10);
        Product product2 = new Product("melko", 20);
        Product product3 = new Product("kurczak", 5);
        Product product4 = new Product("kalafior", 40);
        Product product5 = new Product("rzodkiewka",25);

        Supplier supplier1 = new Supplier("Warz-POL", "Leśna", "Białystok", "10-650", 10, 1111111111);
        Supplier supplier2 = new Supplier("Nabiał-POL", "Wrzosowa", "Warszawa", "60-100", 23, 222222222);
        Supplier supplier3 = new Supplier("Mięs-POL", "Akacjowa", "Malbork", "15-230", 8, 333333333);

        Customer customer1 = new Customer("Mięs-POL", "Akacjowa", "Malbork", "15-230", 8, 10);

        Category category1 = new Category("nabiał");
        Category category2 = new Category("mięso");
        Category category3 = new Category("warzywa");

        Invoice invoice1 = new Invoice(5);
        Invoice invoice2 = new Invoice(10);

        em.persist(product1);
        em.persist(product2);
        em.persist(product3);
        em.persist(product4);
        em.persist(product5);

        em.persist(supplier1);
        em.persist(supplier2);
        em.persist(supplier3);

        em.persist(customer1);

        em.persist(category1);
        em.persist(category2);
        em.persist(category3);

        em.persist(invoice1);
        em.persist(invoice2);

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

        etx.commit();
        em.close();

    }
}
