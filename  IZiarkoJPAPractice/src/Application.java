import java.util.ArrayList;
import java.util.List;

public class Application {

    private DataBaseOperations dataBaseOperations;

    public Application() {
        this.dataBaseOperations = new DataBaseOperations();
    }

    public boolean parseAndExecute(String input) {
        List<String> words = splitString(input);

        // add category
        if (words.get(0).trim().matches("-aca")) {
            dataBaseOperations.addNewCategory(words.get(1));
        } // add product
        else if (words.get(0).trim().matches("-apr")) {
            dataBaseOperations.addNewProduct(words.get(1), Integer.valueOf(words.get(2)));
        } //add customer
        else if (words.get(0).trim().matches("-acu")) {
            dataBaseOperations.addNewCustomer(words.get(1), words.get(2), words.get(3), words.get(4), Integer.valueOf(words.get(5)), Integer.valueOf(words.get(6)));
        } //add supplier
        else if (words.get(0).trim().matches("-asu")) {
            dataBaseOperations.addNewSupplier(words.get(1), words.get(2), words.get(3), words.get(4), Integer.valueOf(words.get(5)), Integer.valueOf(words.get(6)));
        } //add invoice
        else if (words.get(0).trim().matches("-ain")) {
            dataBaseOperations.addNewInvoice(Integer.valueOf(words.get(1)));
        } //add product to invoice
        else if (words.get(0).trim().matches("-apti")) {

        } //add product to category
        else if (words.get(0).trim().matches("-aptc")) {

        } //start database
        else if (words.get(0).trim().matches("-start")) {
            System.out.println("STARTING DATABASE\n");
            dataBaseOperations.startDatabase();
        } // end of session
        else if (words.get(0).trim().matches("-end")) {
            System.out.println("END OF SESSION");
            dataBaseOperations.endOfSession();
        } // print customers
        else if (words.get(0).trim().matches("-pcu")) {
            System.out.println(dataBaseOperations.showCustomers());
        } // print invoices
        else if (words.get(0).trim().matches("-pin")) {
            System.out.println(dataBaseOperations.showInvoices());
        } // print categories
        else if (words.get(0).trim().matches("-pca")) {
            System.out.println(dataBaseOperations.showCategories());
        } // print suppliers
        else if (words.get(0).trim().matches("-psu")) {
            System.out.println(dataBaseOperations.showSuppliers());
        } // print products
        else if (words.get(0).trim().matches("-ppr")) {
            System.out.println(dataBaseOperations.showProducts());
        } // wrong input
        else if (words.get(0).trim().matches("-kill")){
            System.out.println("SEE U NEXT TIME");
            return false;
        }
        else {
            System.out.println("wrong input");
        }
        return true;

    }


    ArrayList<String> splitString(String input) {
        ArrayList<String> words = new ArrayList<>();
        for (String w : input.split("\\s", 0)) {
            words.add(w);
        }
        return words;
    }


}


