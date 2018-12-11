import javax.persistence.*;
import java.util.List;

public class DataBaseOperations {
    private EntityManagerFactory emf2;
    private EntityManager em;

    public void startDatabase() {
        this.emf2 = Persistence.createEntityManagerFactory("myDatabaseConfig");
        this.em = emf2.createEntityManager();
        System.out.println("STARTING DATABASE\n");
    }

    public void endOfSession() {
        emf2.close();
        System.out.println("END OF SESSION");
    }

    public Customer addNewCustomer(String companyName, String city, String street, String zipCode, int number, int discount) {
        Customer customer = new Customer(companyName, city, street, zipCode, number, discount);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(customer);
        etx.commit();
        System.out.println("NEW CUSTOMER ADDED");
        return customer;
    }

    public Supplier addNewSupplier(String companyName, String street, String city, String zipCode, int number, int bankAccountNumber) {
        Supplier supplier = new Supplier(companyName, street, city, zipCode, number, bankAccountNumber);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(supplier);
        etx.commit();
        System.out.println("NEW SUPPLIER ADDED");
        return supplier;
    }

    public Category addNewCategory(String name) {
        Category category = new Category(name);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(category);
        etx.commit();
        System.out.println("NEW CATEGORY ADDED");
        return category;
    }

    Product addNewProduct(String productName, int unitsOnStock) {
        Product product = new Product(productName, unitsOnStock);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(product);
        etx.commit();
        System.out.println("NEW PRODUCT ADDED");
        return product;
    }

    public Invoice addNewInvoice(int quantity) {
        Invoice invoice = new Invoice(quantity);
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        em.persist(invoice);
        etx.commit();
        System.out.println("NEW INVOICE ADDED");
        return invoice;
    }

    public void addProductToCategory(int productId, int categoryId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Category> q1 = em.createQuery("from Category c where c.id = :categoryId", Category.class).setParameter("categoryId", categoryId);
        TypedQuery<Product> q2 = em.createQuery("from Product p where p.id = :productId", Product.class).setParameter("productId", productId);
        Category category = q1.getSingleResult();
        Product product = q2.getSingleResult();
        category.addProduct(product);
        System.out.println("PRODUCT: " + product + "  ADDED TO CATEGORY: " + category + "\n");
        etx.commit();
    }


    public void addProductToInvoice(int productId, int invoiceNumber) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Invoice> q1 = em.createQuery("from Invoice i where i.invoiceNumber = :invoiceNumber", Invoice.class).setParameter("invoiceNumber", invoiceNumber);
        TypedQuery<Product> q2 = em.createQuery("from Product p where p.id = :productId", Product.class).setParameter("productId", productId);
        Invoice invoice = q1.getSingleResult();
        Product product = q2.getSingleResult();
        invoice.addProduct(product);
        System.out.println("PRODUCT: " + product + "  ADDED TO INVOICE: " + invoice + "\n");
        etx.commit();
    }

    public void addProductToSupplier(int productId, int supplierId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Supplier> q1 = em.createQuery("from Supplier s where s.id = :supplierId", Supplier.class).setParameter("supplierId", supplierId);
        TypedQuery<Product> q2 = em.createQuery("from Product p where p.id = :productId", Product.class).setParameter("productId", productId);
        Supplier supplier = q1.getSingleResult();
        Product product = q2.getSingleResult();
        supplier.addProduct(product);
        System.out.println("PRODUCT: " + product + "  ADDED TO SUPPLIER: " + supplier + "\n");
        etx.commit();
    }

    public String showCustomers() {
        String output = "CUSTOMERS:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Customer> q1 = em.createQuery("from Customer", Customer.class).getResultList();
        etx.commit();
        for (Customer customer : q1) {
            output = output.concat(customer.toString() + "\n");
        }
        return output;
    }

    public String showProducts() {
        String output = "PRODUCTS:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Product> q1 = em.createQuery("from Product", Product.class).getResultList();
        etx.commit();
        for (Product product : q1) {
            output = output.concat(product.toString() + "\n");
        }
        return output;
    }

    public String showSuppliers() {
        String output = "SUPPLIERS:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Supplier> q1 = em.createQuery("from Supplier", Supplier.class).getResultList();
        etx.commit();
        for (Supplier supplier : q1) {
            output = output.concat(supplier.toString() + "\n");
        }
        return output;
    }

    public String showCategories() {
        String output = "CATEGORIES:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Category> q1 = em.createQuery("from Category", Category.class).getResultList();
        etx.commit();
        for (Category category : q1) {
            output = output.concat(category.toString() + "\n");
        }
        return output;
    }

    public String showInvoices() {
        String output = "INVOICES:\n";
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        List<Invoice> q1 = em.createQuery("from Invoice", Invoice.class).getResultList();
        etx.commit();
        for (Invoice invoice : q1) {
            output = output.concat(invoice.toString() + "\n");
        }
        return output;
    }

    public void deleteCustomer(int customerId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Customer> q = em.createQuery("from Customer c where c.id = :customerId", Customer.class).setParameter("customerId", customerId);
        Customer customer = q.getSingleResult();
        em.remove(customer);
        System.out.println("CUSTOMER\n " + customer + "\nDELETED\n");
        etx.commit();
    }

    public void deleteProduct(int productId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Product> q = em.createQuery("from Product p where p.id = :productId", Product.class).setParameter("productId", productId);
        Product product = q.getSingleResult();
        em.remove(product);
        System.out.println("PRODUCT\n " + product + "\nDELETED\n");
        etx.commit();
    }

    public void deleteInvoice(int invoiceNumber) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Invoice> q = em.createQuery("from Invoice i where i.invoiceNumber = :invoiceNumber", Invoice.class).setParameter("invoiceNumber", invoiceNumber);
        Invoice invoice = q.getSingleResult();
        em.remove(invoice);
        System.out.println("CUSTOMER\n " + invoice + "\nDELETED\n");
        etx.commit();
    }

    public void deleteSupplier(int supplierId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Supplier> q = em.createQuery("from Supplier s where s.id = :supplierId", Supplier.class).setParameter("supplierId", supplierId);
        Supplier supplier = q.getSingleResult();
        em.remove(supplier);
        System.out.println("CUSTOMER\n " + supplier + "\nDELETED\n");
        etx.commit();
    }

    public void deleteCategory(int categoryId) {
        EntityTransaction etx = this.em.getTransaction();
        etx.begin();
        TypedQuery<Category> q = em.createQuery("from Category c where c.id = :categoryId", Category.class).setParameter("categoryId", categoryId);
        Category category = q.getSingleResult();
        em.remove(category);
        System.out.println("CUSTOMER\n " + category + "\nDELETED\n");
        etx.commit();
    }

}
