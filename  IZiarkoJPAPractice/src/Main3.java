import java.util.logging.Level;

public class Main3 {

    public static void main(String[] args) {

        @SuppressWarnings("unused")
        org.jboss.logging.Logger logger = org.jboss.logging.Logger.getLogger("org.hibernate");
        java.util.logging.Logger.getLogger("org.hibernate").setLevel(java.util.logging.Level.WARNING);
        Application application = new Application();

        application.parseAndExecute("-start");
        application.parseAndExecute("-acu AGH Kraków Dobczycka 30-620 19 20");
        application.parseAndExecute("-acu UJ Kraków Majewska 32-620 32 10");
        application.parseAndExecute("-scu");
        application.parseAndExecute("-end");
    }
}