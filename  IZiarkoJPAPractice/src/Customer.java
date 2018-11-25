import javax.persistence.Entity;

@Entity
public class Customer extends Company{

    private int discount;

    public Customer(String companyName, String city, String street, String zipCode, int number, int discount) {
        super(companyName, city, street, zipCode, number);
        this.discount = discount;
    }

    public Customer() {
    }

    @Override
    public String toString() {
        return "Company: " + super.getCompanyName() + " | city: " + super.getCity() + " | street: " + super.getStreet() + " | zip code: " + getZipCode() + " | number: " + String.valueOf(super.getNumber()) + " | discount: " + String.valueOf(discount);
    }
}
