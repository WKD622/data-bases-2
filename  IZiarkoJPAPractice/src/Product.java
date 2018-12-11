import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    private String productName;
    private int unitsOnStock;

    @ManyToOne
    @JoinColumn(name = "Supplier_fk")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name = "Category_fk")
    private Category category;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private Set<Invoice> invoices = new HashSet<>();

    public Product() {

    }

    public void addInvoice(Invoice invoice) {
        this.invoices.add(invoice);
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Product(String productName, int unitsOnStock) {
        this.productName = productName;
        this.unitsOnStock = unitsOnStock;
    }

    @Override
    public String toString() {
        if (category != null && supplier != null) {
            return "product id: " + id + " | product name: " + productName + " | units on stock: " + unitsOnStock + " | category_fk: " + category.categoryID + " | supplier_fk: " + supplier.getId();
        } else if (category != null && supplier == null) {
            return "product id: " + id + " | product name: " + productName + " | units on stock: " + unitsOnStock + " | category_fk: " + category.categoryID;
        } else if (supplier != null && category == null) {
            return "product id: " + id + " | product name: " + productName + " | units on stock: " + unitsOnStock + " | supplier_fk: " + supplier.getId();
        } else {
            return "product id: " + id + " | product name: " + productName + " | units on stock: " + unitsOnStock;
        }
    }
}
