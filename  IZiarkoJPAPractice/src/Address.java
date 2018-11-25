import javax.persistence.*;

@Embeddable
public class Address {

    String city;
    String street;
    String postCode;
    int number;

    public Address() {
    }

    public Address(String city, String street, String postCode, int number) {
        this.city = city;
        this.street = street;
        this.postCode = postCode;
        this.number = number;
    }
}
