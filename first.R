
#form connection
library(DBI)
library(shiny)
conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "k*********",
  host = "k**********.us-east-2.rds.amazonaws.com",
  username = "k******",
  password = "**********")

input<-list();
input$LenderName = 'Gaurav Jalan';
input$TenureBucket = 'Two Months'
input$AmountDisbursed = 500
input$StartDate = '2017-01-10'
input$EndDate = '2018-01-11'

#get Lenders
#query1 = sprintf("SELECT distinct(`LenderName`) FROM LoanDetails;")
dbGetQuery(conn, "SELECT distinct(`LenderName`) FROM LoanDetails;")


#Tenure Bucket
query2 = paste("SELECT distinct(case when `LoanTenure`=1 then 'One Month' when `LoanTenure`=2 then 'Two Months' when `LoanTenure`=3 then 'Three Months' else 'NA' end) as TenureBucket from LoanDetails where `LenderName` ='",input$LenderName,"' order by LoanTenure;", sep="")
#print(query2)
dbGetQuery(conn, query2)

######### Disbursed Amount ###########

query3 = paste("SELECT distinct(`AmountDisbursed`) from LoanDetails where `LenderName`='",input$LenderName,"' and `LoanTenure` = (case when '",input$TenureBucket,"'='One Month' then 1 when '",input$TenureBucket,"'= 'Two Months' then 2 else 3 end) order by LoanTenure", sep="");
#print(query3)
dbGetQuery(conn, query3)


######### Date Range ############

query4 = paste("SELECT min(`DateDisbursed`) as StartDate, max(`DateDisbursed`) as EndDate from LoanDetails where `LenderName`='",input$LenderName,"' and `LoanTenure` = (case when '",input$TenureBucket,"'='One Month' then 1 when '",input$TenureBucket,"'= 'Two Months' then 2 else 3 end) and `AmountDisbursed` =",input$AmountDisbursed, sep="")
#print(query4)
dbGetQuery(conn, query4)


########## Subsetting Data ###########
query5 = paste("SELECT * from LoanDetails where `LenderName`='",input$LenderName,"' and `LoanTenure` = (case when '",input$TenureBucket,"'='One Month' then 1 when '",input$TenureBucket,"'= 'Two Months' then 2 else 3 end) and AmountDisbursed =",input$AmountDisbursed," and DateDisbursed between '",input$StartDate, "' and '", input$EndDate,"'",sep="")
#print(query5)
dbGetQuery(conn, query5)



######### Getting LoanIDs #########

temp=dbGetQuery(conn, query5)
#View(temp)
LoanIDs = temp$LoanID
#View(LoanIDs)


######### closing connection ############
dbDisconnect(conn)



