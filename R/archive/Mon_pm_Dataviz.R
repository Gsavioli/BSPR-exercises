#load lirbraries
library(ggplot2)
library(dplyr)

# read Ebola data
edata <- read.csv("data/raw/ebola.csv")

#reformat Date column as a date (rather than character chr)

edata$Date <- as.Date(edata$Date)

#sort data by date
edata <- arrange(edata, Date)

plot_ebola_point_v0 <- ggplot()
str(edata)

head(edata)
