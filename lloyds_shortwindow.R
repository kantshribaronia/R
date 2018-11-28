require("data.table")
require("plyr")
require("rvest")
require("MASS")
library(DBI)
library(RMySQL)
library(dplyr)

######### reading data #######

URL1<-"https://uk.investing.com/equities/lloyds-banking-grp-historical-data"
#URL2<-"http://www.livecharts.co.uk/share_prices/historic-data-LLOY"

site1 <- html_session(URL1) %>% read_html()
#site2 <- html_session(URL2) %>% read_html()


site1%>%html_node("#last_last")%>%html_text()->price
site1%>%html_node(".greenFont")%>%html_text()->change
site1%>%html_node(".parentheses")%>%html_text()->cum_chng
site1%>%html_node(".pid-287-volume")%>%html_text()->vol
vol=as.numeric(gsub(",","",vol))
site1%>%html_node(".pid-287-time")%>%html_text()->time


##### forming connection ######
cn <- dbConnect(drv = RMySQL::MySQL(), 
                username = "i*******", 
                password = "***********", 
                host     = "*******.us-east-2.rds.amazonaws.com", 
                port     = 3306, 
                dbname   = "**********")



##### writing data ######

query <- paste("INSERT ignore INTO shortwindow VALUES(",price,",",change,",'",cum_chng,"',",vol,",'",time,"',time(sysdate()))", sep="")
#print(query)
dbGetQuery(cn,query)


dbDisconnect(cn)
