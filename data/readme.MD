__Data Source:__ http://foodb.ca/foods
  * They are one-time download files: CSV and JSON available (along with SQL and XML)
  
```
cd ~/neo4j/import/ 
wget -c http://www.foodb.ca/system/foodb_2017_06_29_csv.tar.gz -O - | tar -xz
cd foodb_2017_06_29_csv
cat contents.csv | grep -E "Nutrient|source_id" > contents_nutrients.csv
mv contents_nutrients.csv ../
mv nutrients.csv ../

```

Possibly interesting dataset to explore alongside this one: https://data.nal.usda.gov/dataset/composition-foods-raw-processed-prepared-usda-national-nutrient-database-standard-reference-release-27
