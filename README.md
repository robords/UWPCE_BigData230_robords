[Final Presentation](https://docs.google.com/presentation/d/1x5lQiqzBvEF6A5zNa1O_Qexnx3rLJ8u0nPwwiNwC6LM/edit#slide=id.gc6f90357f_0_0)

# UWPCE_BigData230_robords

__Description__ 
 My intent is to build out an interactive dashboard that, given a set of food inputs, returns a list of compounds they have in common.  

__Data Source:__ http://foodb.ca/foods
  * They are one-time download files: CSV and JSON available (along with SQL and XML)
  * CSV is probably the way to go, but JSON is possible: https://neo4j.com/developer/guide-import-json-rest-api/; https://stackoverflow.com/questions/27010496/how-to-import-json-data-in-neo4j; https://neo4j-contrib.github.io/neo4j-apoc-procedures/#load-json

__Tools:__ 
 * Docker (https://hub.docker.com/_/neo4j)
 * Neo4j (for exploring the relationships between foods, compounds and nutrients)
 * R & R Shiny (for visualization: https://nicolewhite.github.io/2014/06/30/create-shiny-app-neo4j-graphene.html)

__Questions to Answer:__ 
  * Given a list of foods, what compounds do they have in common (i.e. https://neo4j.com/developer/kb/performing-match-intersection/)?
  * What foods have a given compound?
  * What goods have the most of a given nutrient (i.e. calculate a rank given an input: https://stackoverflow.com/questions/29620450/how-to-calculate-a-rank-in-neo4j)?


Backup plans:

__Data Source:__ https://www.measurementlab.net/data/docs/bq/quickstart/ & https://viz.measurementlab.net/data?aggr=day&clientIsps=AS13367x&format=json&locations=

__Tools:__ 
 * Docker (https://www.docker.elastic.co/)
 * Elastic Stack: Kibana and Elasticsearch (https://www.elastic.co/guide/en/kibana/current/docker.html; https://hub.docker.com/_/kibana; https://hub.docker.com/_/elasticsearch)
 * Python
 
 __Questions to Answer:__
  * TBD
  
  
  http://rs.io/100-interesting-data-sets-for-statistics/
  
  
__Useful:__
 * Start the docker daemon: https://docs.docker.com/config/daemon/systemd/
 * Run docker as non-root and set it to start on reboot: https://docs.docker.com/install/linux/linux-postinstall//
 * Install docker-compose: https://docs.docker.com/compose/install/
