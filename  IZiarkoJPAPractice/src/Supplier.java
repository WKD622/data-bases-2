import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Supplier")
public class Supplier {

    private String companyName;
    private String street;
    private String city;
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @OneToMany
    private Set<Product> products = new HashSet<>();

    public Supplier(){

    }

    public Supplier(String city, String street, String companyName){
        this.companyName = companyName;
        this.street = street;
        this.city = city;

    }

    public void addProduct(Product product){
        products.add(product);
    }

}
