library(tidyverse)
library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)
library(plotly)
library(shiny)
dir()

#rename the columns of dataframe
transport<-read_excel("transportation.xlsx")
#View(transport)
transport[5,6]<-"Total" #replace the value of entries
transport[5,7]<-"Mode"
names(transport)<-transport[5,]

#select needed columns and rows
transport<-transport|>select(-c(1,2,3,5,6,8,10,11,40))|>slice(6:length(Mode))|>rename(Country="Basic data and indicators")

#take out the column countries and make it into a vector with 3 times repetition for each country name
country<-transport|>filter(!is.na(Country)&!(Country %in% c("TF","VF","THS","TCE","The information is the same as that provided in the \"Compendium of Tourism Statistics\"","Source: World Tourism Organization (UNWTO)","..")))|>select(Country)
country<-country$Country
countries<-vector()
for (coun in country) {
  duplicate<-rep(coun,3)
  countries<-c(countries,duplicate)
}
countries
#add the newly created country column to the dataframe and deselect the old one
transport<-transport|>select(-Country)|>filter(!is.na(Mode))|>mutate(Country = countries)

#convert character to numeric in every columns except mode, units, and country
transport<-transport|>mutate(across(.cols = -c(Mode,Units,Country),.fns= parse_number))|>mutate(across(.cols = -c(Mode,Units,Country),.fns= as.numeric))

#pivot so every total number of arrivals is in one column
transport_pivot<-pivot_longer(transport,-c(Units,Mode,Country),
             names_to = "Year",
             values_to = "Arrivals")
#make the country name title-like for uniformity between sources of data
transport_pivot$Country<-str_to_title(transport_pivot$Country)
str_to_title(transport_pivot$Country)
View(transport_pivot)
#get rid of na value
transport_pivot<-transport_pivot|>na.omit()
#sum all the observation grouped by countries and mode of transportation
transport_sum<-transport_pivot|>group_by(Country,Mode)|>summarise(Total = sum(Arrivals))

#save in csv files
write.csv(transport,"modified_transport.csv")                  
write.csv(transport_sum,'total_transport.csv')
write.csv(transport_pivot,'growth_transport.csv')
