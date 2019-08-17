__Data Source:__ http://foodb.ca/foods
  * They are one-time download files: CSV and JSON available (along with SQL and XML)
  
```
wget -c http://www.foodb.ca/system/foodb_2017_06_29_csv.tar.gz -O - | tar -xz
cd foodb_2017_06_29_csv
cat contents.csv | grep -E "Nutrient|source_id" > contents_nutrients.csv
```
