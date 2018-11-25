import javax.persistence.*;
import java.util.List;

public class DataBaseOperations {
    private EntityManagerFactory emf2;
    private EntityManager em;

    public void startDatabase() {
        this.emf2 = Persistence.createEntityManagerFactory("myDatabaseConfig");
        this.em = emf2.createEntityManager();
    }

    public void endOfSession() {
        emf2.close();

    }

    public Customer addNewCustomer(String companyName, String city, String street, String zipCode, int number, int discount) {
        Customer customer = new Customer(companyName, city, street, zipCode, number, discount);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(customer);
        etx.commit();
        return customer;
    }

    public Supplier addNewSupplier(String companyName, String street, String city, String zipCode, int number, int bankAccountNumber) {
        Supplier supplier = new Supplier(companyName, street, city, zipCode, number, bankAccountNumber);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(supplier);
        etx.commit();
        return supplier;
    }

    public Category addNewCategory(String name) {
        Category category = new Category(name);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(category);
        etx.commit();
        return category;
    }

    Product addNewProduct(String productName, int unitsOnStock) {
        Product product = new Product(productName, unitsOnStock);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(product);
        etx.commit();
        return product;
    }

    public Invoice addNewInvoice(int quantity) {
        Invoice invoice = new Invoice(quantity);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(invoice);
        etx.commit();
        return invoice;
    }


    public void addProductToCategory(Category category, Product product) {
        EntityTransaction etx = this.em.getTransaction();
        category.addProduct(product);
        etx.commit();
    }


    public void addProductToInvoice(Invoice invoice, Product product) {
        EntityTransaction etx = this.em.getTransaction();
        invoice.addProduct(product);
        etx.commit();
    }

    public String seeCustomers() {
        String output = "CUSTOMERS:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Customer> q1 = em.createQuery("from Customer", Customer.class).getResultList();
        etx.commit();
        for (Customer customer: q1) {
            output = output.concat(customer.toString() + "\n");
        }
        return output;
    }

}
