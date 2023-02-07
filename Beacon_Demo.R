####################################################
# Chemical Oceanography Data Analysis Class
# Name: Jose Martinez
# Contact: jose.martinez203@upr.edu
# Week(s) One Lab
# 1/26/23
####################################################

########load required libraries


library(tidyverse)
beac #load tidyverse
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
###############################################
#install.packages('tidyverse') # this installs the tidyverse package from online, you need quotes for install packages
#library(tidyverse)# the library function loads our package tidyverse, no quotes needed for library
#install.packages("ggplot2")
#install.packages("munsell")
# I only need to install once, no need to keep the code here
##############################################################
##### Lets import our data

beacon = read_csv("beacon_data.csv")
View(beacon_data) # opens your data frame for viewing
spec(beacon)
names(beacon) # tells us column names of beacon
spec(beacon) # shows you what type of data each column is
dim(beacon) #gives us dimension of dataset
class(beacon) # types of variable not used very much
head(beacon) #shows us first 6 lines of dataset
tail(beacon) #shows us last 6 lines of dataset

# if I want access just one of those variables, I can use the $ operator

sites = beacon$ReefSiteName #creates a variable names sites, by extracting on the ReefSiteName variable from beacon
view (sites) # display sites variable
sites # display sites in console window
# yes it worked

# I can also perform operators on columns
max(beacon$Temperature) #reports a NA value
beacon$Temperature # there are both NA and NaN
max(beacon$Temperature,na.rm = TRUE)
# using the $ notation, I can also select variables and do operations with them 
beacon$nope = beacon$Temperature + beacon$Salinity

##############################################################################
#Part 3: Data Wrangling (dplyr Functions)
###############################################
beacon = read_csv("beacon_data.csv")
select(beacon, ReefSiteName:Temperature)
# how to use select
df1 = select(beacon, ReefSiteName:Temperature) # selects columns from beacon dataframe only ReefSiteName through temperature and stores it as a new dataframe df1 # : notation is the same for numbers and in this case returns all columns between and including ReefSiteName and Temperature 
select(beacon, !Temperature) # #exclamation point means dont select that column
view (df1)

# heres how we can use filter
?filter
filter(df1, ReefSiteName == "B33") # only selects reefsite B33
# but I can combine filters
df2 = filter(df1,ReefSiteName == "B33" & DecimalDate >=2010 & DecimalDate <2011) 
# filters so that only rows are retained if the ReefSiteName column is 'B33' and year is 2010 or greated and year is less than 2011, stores as a new data frame as 'df2'

view(df2)
?arrange
df3 = arrange(df2, ReefSiteName,Temperature) # arrange data first by alphabetical order in ReefSiteName column then by ascending value in Temperature column, save as new dataframe df3

view(df3) # always view to check work

?mutate

df4 = mutate(df3, DegreesKelvin = Temperature + 273.15) #adds a new column called DegreesKelvin to 'df3' is temp (*C) plus 273.15 in a new dataframe df4
head(df4)

summary(df4) # provide summary statistics of our data
#if for example, the DecimalDate was characters instead of numbers, we can force R to change this

df4$DecimalDate = as.numeric(df4$DecimalDate) # replace DecimalDate column with a version of DecimaldDate that is characters

class(df4$DecimalDate) # now confirms that is a character
df4$DecimalDate = as.numeric(df4$DecimalDate) # replace DecimalDate

# this might seem inefficien, we wrote 30 lines of code to select columns and sort them and do some math on them  --> theres an easier way to do this thats much easier to follow and understand in code. Its called "piping"

# What if we wanted to keep columns ReefSiteName, Decimal Date, and Temperature, then arrange by low to high temperatures? we could follow the same process as before or use piping

# the piping operator is %>% control+shift+m (pc) or command+shift+m (mac)

# the %>% operator is a way of saying "and then,,,"

beacon_temps = beacon %>% 
  filter(DecimalDate>= 2010 & DecimalDate<=2011) %>% #filter for only 2010 and then
  select(ReefSiteName,DecimalDate,Temperature) # select only these columns
# we'll save this as a new data frame called beacon_temps
view(beacon_temps)
# it can also be good to check each line in a a piping operation to make sure everything is doing what you would like it to do 

# Take Beacon Data
# Select all data after 2011
# I only want only the data from MP site
# Only Salinity Data (nothing else)
# Arrange it from low to high
# subtract 30 from salinity data
# what is the mean of modified salinity data

beacon %>% 
  filter(ReefSiteName == "MP")%>% 
  filter(DecimalDate >=2012) %>% 
  select(Salinity) %>% 
  arrange(Salinity) %>% 
  mutate(SalMod = Salinity-30) %>% 
  summarize(SalModMean = mean(SalMod)) 

view(beacon_temps)
plot(beacon$DecimalDate,beacon$Temperature) # 

# ggplot2
# we need to assign the x and y variables
# need to decide what kind of plot were going to make 
# we need to make it beautiful

beacon_SST_2010 = ggplot(beacon_temps, aes(x=DecimalDate, y=Temperature))+
 # geom_point(aes(color=ReefSiteName, shape = ReefSiteName),size=2, alpha = 0.7) +
  
 # tells ggplot that we want to plot points colored by reefsite name, shapes by reefsite name, increase the size to 2 and make it 30% transperent 
  
  geom_point(aes(color=ReefSiteName), size = 5, alpha = 0.7) +
  geom_line(aes(color = ReefSiteName),size = 4,alpha = 0.7) +
# we can set a title to match the points

# this isn't great either
# always use a combination of color and shapes
# ggtitle good for a,b,c,& d identifiers on multiple plots
  ggtitle("BEACON Site Temperature 2011") +
  # we can change x label to something better
  xlab("\nYear") + # \n gives space between axis titles and axis itself
  # can also change y label
  # degree symbol is opt+shift+8 (mac) and alt+0176 (pc)
  ylab("Temperature (°C)\n") +
  labs(color = 'Reef Site', shape = "Reef Site")+
  # we can also make the axes ticks and range better
  #limits sets the min and max  c(min,max)
  #breaks sets all the label breaks to the values i entered c(v1,v2,v3,...)
  scale_x_continuous(limits = c(2010,2011),breaks = c(2010,2010.25,2010.5,2010.75))+
  # We can do the same for the y-axis
  scale_y_continuous(limits = c(16,32),breaks = seq(16,32,2)) +
  # we can use premade themse like theme_classic() or set our own themes manually
  
  #theme_classic(), comma then enter makes everything its own line
  theme(panel.grid.major = element_blank(), #remove major gridlines
        panel.grid.minor = element_blank(), #remove minor gridlines
        panel.background = element_blank(), #remove panel background
        axis.line = element_line(color='black'), #set axis lines to black
        text = element_text(size =15),# increase our font size to 15
        plot.title = element_text(hjust = 0.5)) 
our_first_plot # this is the name of our first plot
# you can add things to plots using the + sign
our_first_plot + theme(panel.background = element_rect(color = "black"))
our_second_plot = our_first_plot + theme(panel.background = element_rect(color = "black"))

# if we want to save our plot we can use ggsave
ggsave("Figure1.pdf",beacon_SST_2010,width = 10, height = 6.5) # width and height affects proportion 

library(plotly)
ggplotly(beacon_SST_2010) # creates an interactive ggplot

#######Day 4 coding in R
# well focus on a monthly climatology

# we see that month is the 5th and 6th character of date variable
# we can use subscript to select 5th and 6th character from date column to get the month and create a new month column

beacon$month = as.numeric(substr(beacon$Date,5,6)) - 0.5 #beacon$month creates column at end of beacon

beacon_dates = beacon[complete.cases(beacon$Date),]
unique(beacon_dates$month) # shows unique values
unique(beacon$month)# shows unique values

# we decide we want to show the full time series of data and also the monthly climatology so we can start with the full time series
temperature_ts_plot =
  ggplot()+
  geom_line(data=beacon_dates,aes(x=DecimalDate, y=Temperature, group=ReefSiteName,color=ReefSiteName),size =1)+
  xlab("Year")+
  ylab("Temperature(*C)")+
  scale_x_continuous(breaks = seq(2000,2032,0.5))+
  scale_y_continuous(limits=c(16,32),breaks=seq(16,32,2))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(color="black"),
        text = element_text(size = 24),
        legend.position= "top",
        plot.title = element_text(hjust = 0.5))

temperature_ts_plot

#install.packages("Hmisc")
library(Hmisc)

beacon_climatology =
  beacon_dates %>% 
  group_by(ReefSiteName,month) %>% 
  summarise(ci = list(mean_cl_normal(Temperature) %>%  #compute mean +- 95%
                        rename(Temp_mean=y,Temp_lwr=ymin,Temp_upr=ymax))) %>% 
  unnest(cols=c(ci)) # unnest the output list so it goes back to a logical dataframe


view(beacon_climatology)

temperature_climate_plot =
  ggplot()+
  geom_line(data=beacon_climatology,aes(x=month, y=Temp_mean, group=ReefSiteName,color=ReefSiteName),size =1,alpha =0.7)+
  geom_ribbon(data=beacon_climatology,aes(x=month, y=Temp_mean,ymin=Temp_lwr,ymax=Temp_upr, group=ReefSiteName,fill=ReefSiteName),alpha =0.2)+
  xlab("Month")+
  ylab("Temperature(*C)")+
  scale_x_continuous(breaks = seq(0,12,1))+
  scale_y_continuous(limits=c(16,32),breaks=seq(16,32,2))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(color="black"),
        text = element_text(size = 24),
        legend.position= "top",
        plot.title = element_text(hjust = 0.5))

temperature_climate_plot