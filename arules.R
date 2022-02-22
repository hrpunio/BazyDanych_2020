library("arules")
##library("DBI")
## http://aispiration.com/R-ecology-lesson/06-r-and-sql.html
library(RSQLite)

myDB <- "mbo.db"
conn <- dbConnect(drv = SQLite(), dbname= myDB)

## lista sklepów na rozgrzewkę
shops <- dbGetQuery(conn, "SELECT *  FROM shop")

## lista pozycji (złączenie)
items <- dbGetQuery(conn, "SELECT iid, tid, name  FROM tran 
                    inner join prod on tran.pid=prod.pid")

dbDisconnect(conn)

translist <- split (items$name, items$tid, "transactions")
rul <- apriori(translist, parameter = list(support=0.005, 
                                           confidence=0.5, maxlen=10, minlen=2))
inspect(rul)

#q <- quality(rul)
#lhs <- lhs(rul$data)
