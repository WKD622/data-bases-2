import javax.persistence.*;

@Entity
@Table(name = "Products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    private String productName;
    private int unitsOnStock;

    public Product() {

    }

    public Product(String name, int unitsOnStock) {
        this.productName = name;
        this.unitsOnStock = unitsOnStock;
    }
}
