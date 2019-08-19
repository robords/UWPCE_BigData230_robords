Docker
```
docker run --network=shiny_default --name testneo4j -p7474:7474 -p7687:7687 -d -v $HOME/neo4j/data:/data -v $HOME/neo4j/logs:/logs -v $HOME/neo4j/import:/var/lib/neo4j/import -v $HOME/neo4j/plugins:/plugins --env NEO4J_AUTH=none --env=NEO4J_dbms_memory_heap_max__size=4G neo4j:latest
docker inspect network shiny_default
docker network ls
```

NEO4J Commands
```


LOAD CSV WITH HEADERS FROM "file:///nutrients.csv" AS row
CREATE (n:Nutrients)
SET n = row

LOAD CSV WITH HEADERS FROM "file:///foods.csv" AS row
CREATE (n:Foods)
SET n = row

LOAD CSV WITH HEADERS FROM "file:///contents_nutrients.csv" AS row
MATCH (nutrient:Nutrients {id: row.source_id}), (food:Foods {id: row.food_id})
CREATE (food)-[:Has_Nutrient {standard_content: toInteger(row.standard_content), standard_content_unit:  row.orig_unit, orig_food_common_name: row.orig_food_common_name}]->(nutrient)

WITH ["Pineapple", "Dill"] as names
MATCH (f:Foods)-[h:Has_Nutrient]->(n:Nutrients)
WHERE f.name in names AND h.standard_content > 0 AND f.name = h.orig_food_common_name
RETURN DISTINCT f.name,  n.name, avg(h.standard_content), h.standard_content_unit, h.orig_food_common_name
ORDER BY avg(h.standard_content) DESC



LOAD CSV WITH HEADERS FROM "file:///compounds.csv" AS row
CREATE (n:Compounds)
SET n = row

LOAD CSV WITH HEADERS FROM "file:///foods.csv" AS row
CREATE (n:Foods)
SET n = row

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///contents_compounds.csv" AS row
MATCH (compound:Compounds {id: row.source_id}), (food:Foods {id: row.food_id})
CREATE (food)-[:IS_MADE_OF {standard_content: toInteger(row.standard_content), standard_content_unit:  row.orig_unit, orig_food_common_name: row.orig_food_common_name}]->(compound)



MATCH (n)
DETACH DELETE n
```

