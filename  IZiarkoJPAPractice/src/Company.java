import javax.persistence.*;

@Entity
@Inheritance(strategy= InheritanceType.TABLE_PER_CLASS)
public abstract class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    private String companyName;
    private String city;

    public int getId() {
        return id;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getCity() {
        return city;
    }

    public String getStreet() {
        return street;
    }

    public String getZipCode() {
        return zipCode;
    }

    public int getNumber() {
        return number;
    }

    private String street;
    private String zipCode;
    private int number;

    public Company(String companyName, String street, String city, String zipCode, int number) {
        this.companyName = companyName;
        this.city = city;
        this.street = street;
        this.zipCode = zipCode;
        this.number = number;
    }

    public Company() {
    }
}
