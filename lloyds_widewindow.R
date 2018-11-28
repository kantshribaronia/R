require("data.table")
require("plyr")
require("rvest")
require("MASS")
library(DBI)
library(RMySQL)
library(dplyr)

##### forming connection ######
cn <- dbConnect(drv = RMySQL::MySQL(), 
                username = "**********", 
                password = "*******", 
                host     = "*********us-east-2.rds.amazonaws.com", 
                port     = 3306, 
                dbname   = "**********")



##### reading data #######

URL1<-"https://uk.investing.com/equities/lloyds-banking-grp-historical-data"
#URL2<-"http://www.livecharts.co.uk/share_prices/historic-data-LLOY"

site1 <- html_session(URL1) %>% read_html()
#site2 <- html_session(URL2) %>% read_html()



####### Daily Window #######

site1%>%html_table()->tb1
#site2%>%html_table()->tb2
tb1[[2]]->TB1
#tb2[[2]]->TB2
TB1[,1] = as.Date(TB1[,1], format = "%b%d, %Y")
#TB2[,1] = as.Date(TB1[,1], format = "%b%d, %Y")
#View(TB1[,1])

##### writing into DB ######
rows_TB1 = nrow(TB1)
for (i in 1:rows_TB1)
{
  query <- paste("INSERT ignore INTO widewindow VALUES('",TB1[i,1],"',",TB1[i,2],",",TB1[i,3],",", TB1[i,4],",", TB1[i,5],",'", TB1[i,6],"','", TB1[i,7],"')", sep="")
  #print(query)
  dbGetQuery(cn,query)
}

dbDisconnect(cn)
