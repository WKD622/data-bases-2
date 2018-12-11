import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Level;

public class Main3 {

    public static void main(String[] args) throws IOException {

        @SuppressWarnings("unused")
        org.jboss.logging.Logger logger = org.jboss.logging.Logger.getLogger("org.hibernate");
        java.util.logging.Logger.getLogger("org.hibernate").setLevel(java.util.logging.Level.OFF);
        Application application = new Application();

        boolean on = true;
        String input = "";
        while (on) {
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            try {
                input = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
            on = application.parseAndExecute(input);

        }

    }
}

//                application.parseAndExecute("-start");
//
//                // adding customers
//                application.parseAndExecute("-acu AGH Kraków Dobczycka 30-620 19 20");
//                application.parseAndExecute("-acu UJ Kraków Majewska 32-620 32 10");
//
//                // adding categories
//                application.parseAndExecute("-aca nabiał");
//                application.parseAndExecute("-aca mięso");
//                application.parseAndExecute("-aca warzywa");
//
//                // adding products
//                application.parseAndExecute("-apr maslo 10");
//                application.parseAndExecute("-apr mleko 20");
//                application.parseAndExecute("-apr kurczak 11");
//                application.parseAndExecute("-apr wołowina 22");
//                application.parseAndExecute("-apr ogórek 200");
//
//                // adding supplier
//                application.parseAndExecute("-asu UP Aleje Krakow 33-771 12 3333333")
//                // adding invoices
//                application.parseAndExecute("-ain 7");
//                application.parseAndExecute("-ain 9");
//
//                // printing categories
//                application.parseAndExecute("-pca");
//
//                // printing customers
//                application.parseAndExecute("-pcu");
//
//                // printing products
//                application.parseAndExecute("-ppr");
//
//                // printing invoices
//                application.parseAndExecute("-pin");