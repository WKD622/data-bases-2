package pl.edu.agh.bd.mongo;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.mongodb.*;

public class MongoTasks {
    private MongoClient mongoClient;
    private DB db;

    public MongoTasks() throws UnknownHostException {
        mongoClient = new MongoClient();
        db = mongoClient.getDB("ziarko");
    }

    private void ex1() {
        DBCollection coll = db.getCollection("jeopardy");

        DBObject query = QueryBuilder
                .start()
                .and("value").is("$400")
                .and("category").is("EVERYBODY TALKS ABOUT IT...")
                .get();
        DBCursor cursor = coll.find(query);

        while (cursor.hasNext()) {
            System.out.println(cursor.next());
        }
    }

    private void ex2() {
        DBCollection coll = db.getCollection("jeopardy");

        List<DBObject> pipeline = new ArrayList<DBObject>(Arrays.asList(
                new BasicDBObject("$match", new BasicDBObject("value", "$400")),
                new BasicDBObject("$group",
                        new BasicDBObject("_id", "$round")
                                .append("count", new BasicDBObject("$sum", 1))),
                new BasicDBObject("$sort", new BasicDBObject("count", -1))));

        Cursor cursor = coll.aggregate(
                pipeline,
                AggregationOptions.builder().outputMode(AggregationOptions.OutputMode.CURSOR).build());

        while (cursor.hasNext()) {
            System.out.println(cursor.next());
        }
    }

    private void ex3() {
        DBCollection coll = db.getCollection("jeopardy");

        DBObject query = QueryBuilder
                .start()
                .and("value").is("$400")
                .get();

        MapReduceCommand command = new MapReduceCommand(
                coll,
                "function() { emit(this.round,1); }",
                "function(key, values) {return Array.sum(values)}",
                null,
                MapReduceCommand.OutputType.INLINE,
                query);

        MapReduceOutput result = coll.mapReduce(command);

        for (DBObject o : result.results()) {
            System.out.println(o.toString());
        }
    }


    public static void main(String[] args) throws UnknownHostException {
        MongoTasks mongoLab = new MongoTasks();
        System.out.println("Ex1");
        mongoLab.ex1();
        System.out.println("Ex2");
        mongoLab.ex2();
        System.out.println("Ex3");
        mongoLab.ex3();
    }
}
