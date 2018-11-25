import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Suppliers")
public class Supplier extends Company{

    int bankAccountNumber;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @OneToMany(mappedBy = "supplier")
    private Set<Product> products = new HashSet<>();

    public Supplier(){

    }

    public Supplier(String companyName, String street, String city, String zipCode, int number, int bankAccountNumber) {
        super(companyName, city, street, zipCode, number);
        this.bankAccountNumber = bankAccountNumber;
    }

    public Supplier(int bankAccountNumber, Set<Product> products) {
        this.bankAccountNumber = bankAccountNumber;
        this.products = products;
    }

    public void addProduct(Product product){
        products.add(product);
        product.setSupplier(this);
    }
}





