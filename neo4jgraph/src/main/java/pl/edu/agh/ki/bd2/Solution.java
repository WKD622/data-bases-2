package pl.edu.agh.ki.bd2;

public class Solution {

    private final GraphDatabase graphDatabase = GraphDatabase.createDatabase();

    public void databaseStatistics() {
        System.out.println(graphDatabase.runCypher("CALL db.labels()"));
        System.out.println(graphDatabase.runCypher("CALL db.relationshipTypes()"));
    }

    public void runAllTests() {
        System.out.println(findActorByName("Emma Watson"));
        System.out.println(findMovieByTitleLike("Star Wars"));
        System.out.println(findRatedMoviesForUser("maheshksp"));
        System.out.println(findCommonMoviesForActors("Emma Watson", "Daniel Radcliffe"));
        System.out.println(findMovieRecommendationForUser("emileifrem"));
    }

    private String findActorByName(final String actorName) {
        return null;
    }

    private String findMovieByTitleLike(final String movieName) {
        return null;
    }

    private String findRatedMoviesForUser(final String userLogin) {
        return null;
    }

    private String findCommonMoviesForActors(String actorOne, String actrorTwo) {
        return null;
    }

    private String findMovieRecommendationForUser(final String userLogin) {
        return null;
    }

}
