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
		System.out.println(createTwoNewNodes("Film o Kocie", "Kot"));
		System.out.println(actorsWhoPlayedInAtLeastSixMovies());
		System.out.println(avgNumberOfAppearsInMovies());
		System.out.println(actorsWhoActedInAtLeastOneMovieAndDirectedAtLeastOneMovie());
		System.out.println(usersFriendsWhoRatedFilmWithAtLeastThreeStars("Thomas"));
		System.out.println(pathBetweenTwoActors("Kevin Bacon", "Tomasz Karolak"));
		System.out.println(compareTimeOfExecuteWithAndWithoutIndex());
	}

	/*
	 * 3. Zaimplementować metody z klasy Solution (z katalogu src, można od początku
	 * stworzyć projekt, można zmienić użytkowników w zapytaniach). Można korzystać
	 * też z JDBC
	 */
	private String findActorByName(final String actorName) {
		return graphDatabase.runCypher(
				String.format("MATCH (actorName:Person) WHERE actorName.name = \"%s\" RETURN actorName", actorName));
	}

	private String findMovieByTitleLike(final String movieName) {
		return graphDatabase.runCypher(String.format(
				"MATCH (moviesTitleLike:Movie) WHERE moviesTitleLike.title CONTAINS \"%s\" RETURN moviesTitleLike",
				movieName));
	}

	private String findRatedMoviesForUser(final String userLogin) {
		return graphDatabase.runCypher(String.format(
				"MATCH (p:Person {login: \"%s\"})-[:RATED]->(moviesRated:Movie) RETURN moviesRated", userLogin));

	}

	private String findCommonMoviesForActors(String actorOne, String actorTwo) {
		return graphDatabase.runCypher(String.format(
				"MATCH (p:Person)-[:ACTS_IN]->(commonMovies)<-[:ACTS_IN]-(p2:Person) WHERE p.name = \"%s\" AND p2.name = \"%s\" RETURN commonMovies",
				actorOne, actorTwo));
	}

	private String findMovieRecommendationForUser(final String userLogin) {
		return graphDatabase.runCypher(String.format(
				"MATCH (p:Person)<-[:FRIEND]-(p2:Person)-[:RATED]->(recommendedMovies) WHERE p.login = \"%s\" AND NOT (p)-[:RATED]->(recommendedMovies) RETURN recommendedMovies",
				userLogin));
	}

	/*
	 * 4. Stworzyć dwa nowe węzły reprezentujące film oraz aktora, następnie
	 * stworzyć relacje ich łączącą (np. ACTS_IN)
	 * 
	 * 5. Ustawić zapytaniem pozostałe właściwości nowo dodanego węzła
	 * reprezentującego aktora (np. Birthplace, birthdate)
	 */
	private String createTwoNewNodes(String filmTitle, String actorName) {
		return graphDatabase
				// adding two new nodes with relationship
				.runCypher(String.format("CREATE (p:Person {Name : \"%s\"}) - [:ACTS_IN] -> (m:Movie {title: \"%s\"})",
						actorName, filmTitle))
				+ "\n"
				// setting some properties of this nodes
				+ graphDatabase.runCypher(String.format(
						"MATCH (p:Person {Name : \"%s\"}) - [:ACTS_IN] -> (m:Movie {Name: \"%s\"}) SET p.password = \"password\",m.language = \"English\"",
						actorName, filmTitle))
				+ "\n"
				// checking if they exists
				+ graphDatabase.runCypher(String.format(
						"MATCH (addedActor:Person {Name : \"%s\"}) - [:ACTS_IN] -> (movieAdded:Movie {title: \"%s\"}) RETURN addedActor, movieAdded",
						actorName, filmTitle))
				+ "\n"
				// deleting them
				+ graphDatabase.runCypher(String.format(
						"MATCH (p:Person {Name : \"%s\"}) - [r:ACTS_IN] -> (m:Movie {title: \"%s\"}) DELETE p, m, r",
						actorName, filmTitle));

	}

	/*
	 * 6. Zapytanie o aktorów którzy grali w conajmniej 6 filmach (użyć collect i
	 * length),
	 */
	// ograniczone do pierwszych 25 wierszy (wynik cos ponad 2300 wierszy)
	private String actorsWhoPlayedInAtLeastSixMovies() {
		return graphDatabase.runCypher("MATCH (p:Person) - [:ACTS_IN] -> (m:Movie)"
				+ " WITH length(collect({title: m.title})) as numberOfMovies, p WHERE numberOfMovies > 6"
				+ " RETURN p.name, numberOfMovies limit 25");
	}

	/*
	 * 7. Policzyć średnią wystąpień w filmach dla grupy aktorów, którzy wystąpili
	 * conajmniej 7 filmach
	 */
	private String avgNumberOfAppearsInMovies() {
		return graphDatabase.runCypher("MATCH (p:Person) - [:ACTS_IN] -> (m:Movie)"
				+ " WITH length(collect({title: m.title})) as numberOfMovies, p WHERE numberOfMovies > 7"
				+ " RETURN avg(numberOfMovies)");
	}

	/*
	 * 8. Wyświetlić aktorów, którzy zagrali w conajmniej pięciu filmach i
	 * wyreżyserowali conajmniej jeden film (z użyciem WITH), posortować ich wg
	 * liczby wystąpień w filmach
	 */
	// ograniczone do pierwszych 25 wierszy (wynik cos okolo 200 wierszy)
	private String actorsWhoActedInAtLeastOneMovieAndDirectedAtLeastOneMovie() {
		return graphDatabase.runCypher("MATCH (a:Actor) -[:ACTS_IN]-> (m:Movie) " + "WITH a, count(m) as movies "
				+ "WHERE movies > 5 " + "WITH a, movies " + "MATCH (a:Director) - [:DIRECTED] -> (m:Movie) "
				+ "WITH a, movies, count(m.title) as directed, collect(m.title) as directedTitles "
				+ "WHERE directed > 0 " + "RETURN a.name, movies, directed, directedTitles "
				+ "ORDER BY movies DESC LIMIT 25");
	}

	/*
	 * 9. Zapytanie o znajomych wybranego usera którzy ocenili film na conajmniej
	 * trzy gwiazdki (wyświetlić znajomego, tytuł, liczbę gwiazdek)
	 */
	private String usersFriendsWhoRatedFilmWithAtLeastThreeStars(String userName) {
		return graphDatabase.runCypher(String.format(
				"MATCH (u1:User) - [:FRIEND] - (u2:User) - [r:RATED] -> (m:Movie)"
						+ "WHERE r.stars >= 1 AND u1.name = \"%s\"" + "RETURN u2 as user, m AS movie, r.stars as stars",
				userName));
	}

	/*
	 * 10. Zapytanie o ścieżki między wybranymi aktorami (np.2), w ścieżkach mają
	 * nie znajdować się filmy (funkcja filter(), [x IN xs WHERE predicate |
	 * extraction])
	 */
	private String pathBetweenTwoActors(String actorOne, String actorTwo) {
		return graphDatabase.runCypher(String.format(
				"MATCH p=shortestPath((a:Actor {name: \"%s\"})-[*]-(a1:Actor {name: \"%s\"})) "
						+ " return extract(n in filter(x in nodes(p) where (x:Actor)) | n.name) as path",
				actorOne, actorTwo));
	}

	/*
	 * 11. Porównać czas wykonania zapytania o wybranego aktora bez oraz z indeksem
	 * w bazie nałożonym na atrybut name (DROP INDEX i CREATE INDEX oraz użyć
	 * komendy EXPLAIN lub PROFILE), dokonać porównania dla zapytania shortestPath
	 * pomiędzy dwoma wybranymi aktorami.
	 */
	private String compareTimeOfExecuteWithAndWithoutIndex() {
		String s = "";
		long startTime = System.currentTimeMillis();
		s = s + findActorByName("Tomasz Karolak");
		long stopTime = System.currentTimeMillis();
		long elapsedTime = stopTime - startTime;
		s = s + "\nTime in milliseconds elapsed without index: " + elapsedTime + "\n";
		s = s + graphDatabase.runCypher("CREATE INDEX ON :Actor(Name)\n");
		startTime = System.currentTimeMillis();
		s = s + findActorByName("Tomasz Karolak");
		stopTime = System.currentTimeMillis();
		elapsedTime = stopTime - startTime;
		s = s + "\nTime in milliseconds elapsed with index: " + elapsedTime + "\n";
		s = s + graphDatabase.runCypher("DROP INDEX ON :Actor(Name)");
		return s;
	}
}
