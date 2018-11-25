import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.ArrayList;
import java.util.List;

public class Application {

    private DataBaseOperations dataBaseOperations;

    public Application() {
        this.dataBaseOperations = new DataBaseOperations();
    }

    public void parseAndExecute(String input) {
        List<String> words = splitString(input);

        System.out.println(words.get(0));
        // add category
        if (words.get(0).trim() == "-aca") {
            dataBaseOperations.addNewCategory(words.get(1));
        } // add product
        else if (words.get(0).trim() == "-apr") {
            dataBaseOperations.addNewProduct(words.get(1), Integer.valueOf(words.get(2)));
        } //add customer
        else if (words.get(0).trim().matches("-acu")) {
            System.out.println("adding new customer");
            dataBaseOperations.addNewCustomer(words.get(1), words.get(2), words.get(3), words.get(4), Integer.valueOf(words.get(5)), Integer.valueOf(words.get(6)));
        } //add supplier
        else if (words.get(0).trim() == "-aco") {
            dataBaseOperations.addNewSupplier(words.get(1), words.get(2), words.get(3), words.get(4), Integer.valueOf(words.get(5)), Integer.valueOf(words.get(6)));
        } //add invoice
        else if (words.get(0).trim() == "-ain") {
            dataBaseOperations.addNewInvoice(Integer.valueOf(words.get(1)));
        } //add product to invoice
        else if (words.get(0).trim() == "-apti") {

        } //add product to category
        else if (words.get(0).trim() == "-aptc") {

        } //start database
        else if (words.get(0).trim().matches("-start")) {
            System.out.println("Starting database");
            dataBaseOperations.startDatabase();
        } // end of session
        else if (words.get(0).trim() == "-end") {
            System.out.println("end of session");
            dataBaseOperations.endOfSession();
        } //print customers
        else if (words.get(0).trim() == "-scu") {
            System.out.println(dataBaseOperations.seeCustomers());
        } // wrong input
        else {
            System.out.println("wrong input");
        }

    }


    ArrayList<String> splitString(String input) {
        ArrayList<String> words = new ArrayList<>();
        for (String w : input.split("\\s", 0)) {
            words.add(w);
        }
        return words;
    }


}


