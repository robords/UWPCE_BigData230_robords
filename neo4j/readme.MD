```
docker run --network=shiny_default --name testneo4j -p7474:7474 -p7687:7687 -d -v $HOME/neo4j/data:/data -v $HOME/neo4j/logs:/logs -v $HOME/neo4j/import:/var/lib/neo4j/import -v $HOME/neo4j/plugins:/plugins --env NEO4J_AUTH=none --env=NEO4J_dbms_memory_heap_max__size=4G neo4j:latest
docker inspect network shiny_default
docker network ls
```

```
http://www.nagraj.net/notes/how-to-create-small-random-sample-from-large-csv-file/
```

```
LOAD CSV WITH HEADERS FROM "file:///foods.csv" AS row
CREATE (n:Foods)
SET n = row

LOAD CSV WITH HEADERS FROM "file:///contents_trim.csv" AS row
CREATE (n:Contents)
SET n = row

CREATE INDEX ON :Foods(id)

CREATE INDEX ON :Contents(id)

MATCH (f:Foods),(c:Contents)
WHERE f.id = c.food_id
CREATE (f)-[:Contains]->(o)

MATCH (f:Foods),(c:Contents)
WHERE  f.id = c.food_id AND c.source_type = "Nutrient"
CREATE (f)-[:Has_Nutrient]->(o)

MATCH (f:Foods),(c:Contents)
WHERE  f.id = c.food_id AND c.source_type = "Compounds"
CREATE (f)-[:Composed_Of]->(o)

MATCH (f:Foods),(c:Contents)
WHERE  f.id = c.food_id
CREATE (o)-[:Associated_Food]->(f)

MATCH (n:Foods) RETURN n LIMIT 25
```

