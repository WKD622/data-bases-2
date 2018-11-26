import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Invoices")
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int invoiceNumber;
    private int quantity;

    @ManyToMany(mappedBy = "invoices", cascade = CascadeType.PERSIST)
    Set<Product> products = new HashSet<>();

    public void addProduct(Product product) {
        this.products.add(product);
        product.addInvoice(this);
    }

    public Invoice() {
    }

    public Invoice(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "invoice number: " + invoiceNumber + " | quantity: " + quantity;
    }
}
