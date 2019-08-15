```
library(httr)
GET("http://172.19.0.3:7474")
con <- neo4j_api$new(
     url = "http://172.19.0.3:7474/", 
     user = "neo4j", 
     password = "test"
)
con$get_version()

library(magrittr)

```
