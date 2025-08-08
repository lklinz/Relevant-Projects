library(tidyverse)
library(sf)
library(ggplot2)
library(dplyr)
library(leaflet) 
library(readxl)
employment<-read_excel("employment.xlsx") #read the employment data
View(employment)

employ_2022<-employment|>filter(Divison %in% c("55-68","56","79") & Time == 2022 & !(`Status in employment`=='STE_TOTAL' & Sex != 'SEX_T'))|>mutate(Total=as.numeric(Total))#select only data in 2022 and observations for self-employment/employment for female and male along with the total of employees in each type of employment, not in each gender
View(employ_2022)

self_employ_total<-employ_2022|>filter(Sex=='SEX_T'& `Status in employment`=='STE_SLF' )|>select(`ISO 3 Letter`,Area_label,Sex,`Status in employment`,Divison,Total) #select the observations for total of female and male employee in self-employment 
View(self_employ_total)

employed_total<-employ_2022|>filter(Sex=='SEX_T'& `Status in employment`=='STE_EES' )|>select(Area_label,Sex,`Status in employment`,Divison,Total) #select the observations for total of female and male employee in employment 
View(employed_total)

selfemployed_and_employed<-self_employ_total|>full_join(employed_total,by=c('Area_label','Divison'))|>mutate(Self_employed_total=Total.x,Employed_total=Total.y)|>select(1,2,3,5,10,11) #join two dataframes above, select only the necessary columns, and rename them to distinguish total of self-employment and employment
View(selfemployed_and_employed)

divison_total<-employ_2022|>filter(Sex=='SEX_T'& `Status in employment`=='STE_TOTAL' )|>select(Area_label,Sex,`Status in employment`,Divison,Total) #select the observations for total of female and male employee in each divison, regardless of self-employment or employment 
View(divison_total)

divison_selfemployed_employed_total<-divison_total|>full_join(selfemployed_and_employed,by=c('Area_label','Divison'))|>mutate(Divison_total=Total)|>select(1,2,4,6,8,9,10) #join the data frame above with the one with total of employee in self employment and employment
View(divison_selfemployed_employed_total)

#extracting the total number of female/male employees in self-employment and employment
female_self_employed<-employ_2022|>filter(Sex=="SEX_F"&`Status in employment`=='STE_SLF')|>mutate(female_self_employed_total=Total)|>select(1,2,3,7,9,12)
View(female_self_employed)
female_employed<-employ_2022|>filter(Sex=="SEX_F"&`Status in employment`=='STE_EES')|>mutate(female_employed_total=Total)|>select(1,2,3,7,9,12)
male_self_employed<-employ_2022|>filter(Sex=="SEX_M"&`Status in employment`=='STE_SLF')|>mutate(male_self_employed_total=Total)|>select(1,2,3,7,9,12)
male_employed<-employ_2022|>filter(Sex=="SEX_M"&`Status in employment`=='STE_EES')|>mutate(male_employed_total=Total)|>select(1,2,3,7,9,12)

#join 4 dataframes above with the dataframe with the total of employees by self-employment, employments, and divisons
full_data<-divison_selfemployed_employed_total|>inner_join(female_employed,by=(c("ISO 3 Letter","Divison")))|>
  inner_join(female_self_employed,by=(c("ISO 3 Letter","Divison")))|>
  inner_join(male_self_employed,by=(c("ISO 3 Letter","Divison")))|>
  inner_join(male_employed,by=(c("ISO 3 Letter","Divison")))|>
  select(1,3,4,8,5,6,7,11,15,19,23)|>rename(Country=Area_label.x,iso3num = `ISO 3 Number.x`)

View(full_data)
#calculate the percent of female and male employees in total of employees by self-employment, employments, and divisons
percent<-full_data|>mutate(female_self_employed_percent_divison=female_self_employed_total/Divison_total*100,
                           female_employed_percent_divison=female_employed_total/Divison_total*100,
                           male_self_employed_percent_divison=male_self_employed_total/Divison_total*100,
                           male_employed_percent_divison=male_employed_total/Divison_total*100,
                           female_self_employed_percent_slf=female_self_employed_total/Self_employed_total*100,
                           male_self_employed_percent_slf=male_self_employed_total/Self_employed_total*100,
                           female_employed_percent_ees=female_employed_total/Employed_total*100,
                           male_employed_percent_ees=male_employed_total/Employed_total*100)
View(percent)
write.csv(percent,'employment_2022.csv') #write the dataframe in a csv file