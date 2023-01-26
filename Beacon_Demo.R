####################################################
# Chemical Oceanography Data Analysis Class
# Name: Jose Martinez
# Contact: jose.martinez203@upr.edu
# Week(s) One Lab
# 1/26/23
####################################################

########load required libraries

library(tidyverse) #load tidyverse
#####
# Intro to Using R
x = 3 #assigns the number 3 to variable x
y = 56 #assigns the number 56 to variable y
z = x*y
# we will be using "=" in this class
# we can also do basic math in R
z = x*y #this creates variable z; a product of x multiplied by y
z #if I type a variable name, I can see it in the console (environment tab)
# we can do other maths
z = sqrt(y)
z = sqrt(x+y)
Z = X*pi #certain variables like pi are already in R
z = log(y, base =10) # take log of y using base exponent 10
z = log(y) # this is the natural log
z = log10(y) # this is also log_10 of y
##############################################################################
#Part 2: Introduction to Packages

#install.packages('tidyverse') # this installs the tidyverse package from online, you need quotes for install packages
#library(tidyverse)# the library function loads our package tidyverse, no quotes needed for library
#install.packages("ggplot2")
#install.packages("munsell")
# I only need to install once, no need to keep the code here
##############################################################
##### Lets import our data

beacon <- read_csv("beacon_data.csv")
View(beacon_data) # opens your data frame for viewing
spec(beacon)
names(beacon) # tells us column names of beacon
spec(beacon) # shows you what type of data each column is
dim(beacon) #gives us dimension of dataset
class(beacon) # types of variable not used very much
head(beacon) #shows us first 6 lines of dataset
tail(beacon) #shows us last 6 lines of dataset
