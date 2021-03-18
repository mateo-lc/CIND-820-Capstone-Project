---
  title: "Restaurant Recommendation System"
  author: "Mateo Lara"
  date: "03/15/2021"
---
      
## Captstone Restaurant Recommendation Project
    
## Overview:
#The purpose of this capstone is to find if data analysis and machine learning can aid the hospitality and restaurant industry.
  
## Dataset:
#The dataset chosen for this project is the Zomato Bangalore Restaurants dataset found on Kaggle.
#As discussed with my advisor, this dataset is a better choice than the initial choice as it has more relevant attributes.

resdata <- read.csv("C:/Users/Mateo/Desktop/zomato.csv")

#Deleting Unnecessary Columns
resdata2 <- resdata[-c(1,8,11,14,15)]

#Removing Duplicate Data
resclean <- resdata2[!duplicated(resdata2$name), ]
count(resclean, vars = "name")
##There are 8792 restaurants being considered in this dataset

resclean <- resclean %>% filter(rest_type !="")
resclean <- resclean %>% filter(approx_cost.for.two.people. !="")
resclean <- resclean %>% filter(votes !="0")
##There are 6328 restaurants being considered after removing any without customer ratings/votes

resclean$online_order <- lapply(resclean$online_order, function(x) as.integer(x=="Yes"))
resclean$book_table <- lapply(resclean$book_table, function(x) as.integer(x=="Yes"))
#Converting Yes/No to 1/0 for analysis


#Data Exploration
head(resclean)
str(resclean)
##
glimpse(resclean)
summary(resclean)
skim(resclean)

resclean$rate <- sapply(resclean$rate, function(x) eval(parse(text=x))*100) #converting fraction to whole number/percentage
hist(resclean$rate)
## Rate column is normally distributed, and there are no outliers.

perc <- names(quantile(resrating,seq(0.01,0.99,0.01)))
score <- unname(quantile(resrating,seq(0.01,0.99,0.01)))
topbottom <- data.frame(percentile=perc,score=score)
topbottom%>%arrange(desc(score))%>%head(10)
## 61% of all restaurants are rated 74% or lower

rated_res <- select(resclean, -address, name, -online_order, -book_table, rate, -votes, -location, -rest_type, -cuisines, -approx_cost.for.two.people., -listed_in.type., -listed_in.city.)
highest_rated <- arrange(rated_res, desc(rate))
head(highest_rated)
tail(highest_rated)

## Top 5 restaurants are the highest rated at 98 - Byg Brewski Brewing Company
## Lowest rated restaurant is Taste of Kerala

plot(resclean$votes ~ resclean$rate, col=ifelse(resclean$rate==100, "red", "black"))
## It appears ratings increase with the number of reviews

rate_vs_vote <- select(resclean, -address, name, -online_order, -book_table, rate, votes, -location, -rest_type, -cuisines, -approx_cost.for.two.people., -listed_in.type., -listed_in.city.)
highest_rated <- arrange(rate_vs_vote, desc(rate))
head(highest_rated)
tail(highest_rated)
# Best rated restaurant has the highest number of reviews/votes in dataset
# Lowest rated have a smaller number of reviews/votes

