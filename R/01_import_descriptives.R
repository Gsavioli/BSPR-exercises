#load libraries
library(usethis)
library(gitcreds)
library(here)
library(tidyverse)
library(medicaldata)
library(cowplot)
library(gtsummary)
library(dplyr)

#import data

setwd("C:/Users/giuli/Documents/..WORK, EDUCATION/Bern BLV/ECVPH Residency/PHS_Summer_Course/BSPR-exercises")
dat <- read.csv("data/raw/perulung_ems.csv")
str(dat)


#want to change the categorical values (factors)

dat$asthma_hist <- as.factor(dat$asthma_hist)
dat$sex <- factor(as.character(dat$sex), levels=c(0,1), labels=c("f","m"))
dat$respsymptoms <- factor(as.character(dat$respsymptoms), levels=c(0,1), labels=c("no","yes"))
str(dat)
dat

#make a summary table for the report
tabl_summary <- dat |>   
  tbl_summary(
    by = sex,
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean} ({sd})", 
                                     "{median} ({p25}, {p75})", 
                                     "{min}, {max}")
 ) %>%
  add_overall()

tabl_summary
str(dat)

#plotting the data
dat %>%
  ggplot(aes(fev1)) +
  geom_histogram(color = "black",
                 fill = "steelblue", 
                 bins = 30) + 
  theme_bw()

#new plots for fev1, separated by sex
dat %>%
  ggplot(aes(fev1)) +
  geom_histogram(color = "black",
                 fill = "steelblue", 
                 bins = 30) + 
  theme_bw() +
  facet_grid(sex~.)

#(horizontal wrap)
dat %>%
  ggplot(aes(fev1)) +
  geom_histogram(color = "black",
                 fill = "steelblue", 
                 bins = 30) + 
  theme_bw() +
  facet_wrap(sex~.)

#box plots
ggplot(dat, aes(y=fev1, color=sex)) +
  geom_boxplot() +
  scale_x_discrete()

#QQplot - to visually assess normality - DO THIS BY GROUPS

qqnorm(dat$fev1[dat$sex=="f"], pch = 1, frame = FALSE)
qqline(dat$fev1[dat$sex=="f"], col = "steelblue", lwd = 2)

qqnorm(dat$fev1[dat$sex=="m"], pch = 1, frame = FALSE)
qqline(dat$fev1[dat$sex=="m"], col = "steelblue", lwd = 2)

#Shapiro Wilk
datfev1m <- select(filter(dat, sex == "m"),fev1)
datfev1f <- select(filter(dat, sex == "f"),fev1)
str(datfev1f)

shapiro.test(datfev1f$fev1)
shapiro.test(datfev1m$fev1)
shapiro.test(dat$fev1)

#The Shapiro-Wilk test suggests that FEV1 data for males is normally
#distributed (p > 0.05). However, there is evidence against normality for
#FEV1 in females. Given the sample size is large (>300) for both male and 
#female groups, we proceeded nonetheless to a T-test.

#T-test: requirements are either 1. that your data is normally distributed (for
#small samples), or 2. the sample is very large (this sample is large, each
# group is > 300). Therefore, we can use the T-test here - because the sample 
#size is large and deviation from normality is not severe.

t.test(fev1~sex, data = dat)

#strong evidence against H0 (= males and females have the same mean lung function)


#Testing proportions, answering the question: is presence of respiratory 
#symptoms associated with sex?
table(dat$sex,dat$respsymptoms)
chisq.test(dat$sex,dat$respsymptoms)
table(dat$respsymptoms,dat$asthma_hist)
chisq.test(dat$asthma_hist,dat$respsymptoms)

#We do not reject H0 = (that the variables are dependent), i.e. sex does not 
#seem to have an effect on whether or not respiratory symptoms are reported
