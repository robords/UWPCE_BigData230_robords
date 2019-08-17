```
docker run --network=shiny_default --name testneo4j -p7474:7474 -p7687:7687 -d -v $HOME/neo4j/data:/data -v $HOME/neo4j/logs:/logs -v $HOME/neo4j/import:/var/lib/neo4j/import -v $HOME/neo4j/plugins:/plugins --env NEO4J_AUTH=none --env=NEO4J_dbms_memory_heap_max__size=4G neo4j:latest
docker inspect network shiny_default
docker network ls
```

```
docker run --network=shiny_default --name testneo4j -p7474:7474 -p7687:7687 -d -v $HOME/neo4j/data:/data -v $HOME/neo4j/logs:/logs -v $HOME/neo4j/import:/var/lib/neo4j/import -v $HOME/neo4j/plugins:/plugins --env NEO4J_AUTH=none --env=NEO4J_dbms_memory_heap_max__size=4G neo4j:latest


LOAD CSV WITH HEADERS FROM "file:///nutrients.csv" AS row
CREATE (n:Nutrients)
SET n = row

LOAD CSV WITH HEADERS FROM "file:///contents_nutrients.csv" AS row
CREATE (:Food { name: row.orig_food_common_name, source_id: row.source_id, source_type: row.source_type, standard_content: row.standard_content})

MATCH (f:Food),(n:Nutrients)
WHERE  n.id = f.source_id
CREATE (f)-[:Has_Nutrient]->(n)

MATCH (f:Food),(n:Nutrients)
WHERE  n.id = f.source_id
CREATE (f)-[:Has_Nutrient {standard_content: f.standard_content + 'ppm'}]->(n)

MATCH (n)
DETACH DELETE n
```

