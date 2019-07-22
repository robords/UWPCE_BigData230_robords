# UWPCE_BigData230_robords

The project write up is due July 24th at 9pm as a new project in Github and will include your choice of data source, your choice of tools and what questions you intend to answer with your analysis. 

Data Source: http://foodb.ca/foods
  * They are one-time download files: CSV and JSON available (along with SQL and XML)
  * CSV is probably the way to go, but JSON is possible: https://neo4j.com/developer/guide-import-json-rest-api/; https://stackoverflow.com/questions/27010496/how-to-import-json-data-in-neo4j; https://neo4j-contrib.github.io/neo4j-apoc-procedures/#load-json

Tools: 
 * Docker (https://hub.docker.com/_/neo4j)
 * Neo4j (for exploring the relationships between foods, compounds and nutrients)
 * R & R Shiny (for visualization: https://nicolewhite.github.io/2014/06/30/create-shiny-app-neo4j-graphene.html)

Questions to Answer: 
  * Given a list of foods, what compounds do they have in common (i.e. https://neo4j.com/developer/kb/performing-match-intersection/)?
  * What foods have a given compound?
  * What goods have the most of a given nutrient (i.e. calculate a rank given an input: https://stackoverflow.com/questions/29620450/how-to-calculate-a-rank-in-neo4j)?

Possibly interesting dataset to explore alongside this one: https://data.nal.usda.gov/dataset/composition-foods-raw-processed-prepared-usda-national-nutrient-database-standard-reference-release-27

Backup plans:

Data Source: https://www.measurementlab.net/data/docs/bq/quickstart/ & https://viz.measurementlab.net/data?aggr=day&clientIsps=AS13367x&format=json&locations=

Tools: 
 * Docker (https://www.docker.elastic.co/)
 * Elastic Stack: Kibana and Elasticsearch (https://www.elastic.co/guide/en/kibana/current/docker.html; https://hub.docker.com/_/kibana; https://hub.docker.com/_/elasticsearch)
 * Python
 
 Questions to Answer:
  * TBD
  
  
  http://rs.io/100-interesting-data-sets-for-statistics/
  
  
