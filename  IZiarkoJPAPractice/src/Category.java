import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    int categoryID;
    private String name;

    @OneToMany(mappedBy = "category")
    List<Product> listProducts = new ArrayList<>();

    public void addProduct(Product product){
        listProducts.add(product);
        product.setCategory(this);
    }

    public Category(String name) {
        this.name = name;
    }

    public Category() {
    }
}
