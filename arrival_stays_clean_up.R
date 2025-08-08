library(ggridges)
library(lubridate)
library(viridis)
library(plotly)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
dir()
arrivals<-read_excel("arrivals.xlsx") #read the file
View(arrivals)
arrivals<-arrivals|>select(-c(1,2,3,5,6,8,9,10,11,40)) #select all the necessary columns
arrivals[5,1]<-"Country" #change the content of the entry at row 5 column 1 to country
arrivals[5,2]<-"Visitor_Type" #change the content of the entry at row 5 column 2 to visitor type
names(arrivals)<-arrivals[5,] #set the columns name as the entries of row 5
arrivals<-arrivals|>slice(6:1343) #slice to get rid of unnecessary rows
country_name<-arrivals|>filter(!is.na(Country))|>select(Country) #putting the countries' names in a vector
country_name<-str_to_title(country_name$Country) #change all the countries' name to only capitalizing the first letter
country_name

countries<-vector() # create an empty vector. Loop through every country in the country_name vector and add 2 copies of it to the empty vector
for (coun in country_name) {
  duplicate<-rep(coun,2)
  countries<-c(countries,duplicate)
}
countries

arrivals<-arrivals|>filter(!is.na(Visitor_Type))|>mutate(Country=countries) #filter out all the row with NA in the visitor type column and add the countries vector as a new country column
arrivals<-arrivals|>mutate(across(.cols = -c(Country,Visitor_Type),.fns= parse_number))#except country and visitor_type column, convert every column to numeric

arrivals_pivot<-pivot_longer(arrivals,-c(Country,Visitor_Type),
                             names_to = "Year",
                             values_to = "Number of visitors") #make a pivot table with year column to row

arrivals_pivot$Year<-parse_number(arrivals_pivot$Year) #convert Year data type from character to numeric
arrivals_pivot<-arrivals_pivot|>mutate(Text = paste("Country: ", Country, "\nYear: ", Year, "\nVisitor: ", Visitor_Type, "\nNumber of visitors: ", `Number of visitors`, sep="")) #create text column for the interactive plot 
arrivals_pivot<-arrivals_pivot|>filter(!is.na(`Number of visitors`)) #get rid of all NA entries in number of visitors column
View(arrivals_pivot)
write.csv(arrivals_pivot,"arrivals_pivot.csv") #write the new dataframe in a csv file

stay<-read_excel('length_of_stays.xlsx') #read the file
View(stay)

stay<-stay|>select(-c(1,2,3,5,7,8,9,10,11,39)) #select all the necessary columns
stay[5,1]<-"Country" #change the content of the entry at row 5 column 1 to country
stay[5,2]<-"Stay_Info" #change the content of the entry at row 5 column 2 to stay info
names(stay)<-stay[5,] #set the columns name as the entries of row 5
stay<-stay|>slice(6:1790) #slice to get rid of unnecessary rows
country_name<-stay|>filter(!is.na(Country))|>select(Country) #putting the countries' names in a vector
country_name<-str_to_title(country_name$Country) #change all the countries' name to only capitalizing the first letter
country_name


countries<-vector() # create an empty vector. Loop through every country in the country_name vector and add 6 copies of it to the empty vector
for (coun in country_name) {
  duplicate<-rep(coun,6)
  countries<-c(countries,duplicate)
}


stay<-stay|>filter(!is.na(Stay_Info)&Stay_Info!="Available capacity (bed-places per 1000 inhabitans)")|>mutate(Country=countries) #filter out all the row with NA in the stay info column and add the countries vector as a new country column
stay<-stay|>mutate(across(.cols = -c(Country,Stay_Info),.fns= parse_number)) #except country and stay_info column, convert every column to numeric

stay_pivot<-pivot_longer(stay,-c(Country,Stay_Info),
                             names_to = "Year",
                             values_to = "Quantity") #make a pivot table with year column to row

stay_pivot$Year<-parse_number(stay_pivot$Year) #convert Year data type from character to numeric
stay_pivot<-stay_pivot|>filter(!is.na(Quantity)) #get rid of all NA entries in number of visitors column
View(stay_pivot)
write.csv(stay_pivot,"stays_pivot.csv")  #write the new dataframe in a csv file
