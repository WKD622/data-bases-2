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
//        application.parseAndExecute("-start");
//        application.parseAndExecute("-acu AGH Kraków Dobczycka 30-620 19 20");
//        application.parseAndExecute("-acu UJ Kraków Majewska 32-620 32 10");
//        application.parseAndExecute("-aca nabiał");
//        application.parseAndExecute("-aca mięso");
//        application.parseAndExecute("-aca warzywa");
//        application.parseAndExecute("-pca");
//        application.parseAndExecute("-pcu");
//        application.parseAndExecute("-end");
    }
}