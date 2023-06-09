install.packages("usethis")
install.packages("gitcreds")
install.packages("here")
install.packages("tidyverse")
install.packages("medicaldata")
install.packages("cowplot")

library("tidyverse")
setwd("C:/Users/giuli/Documents/1.PHS Summer Course/basic-statistics-and-projects-in-R-main")
dat <- read_csv("data/raw/insurance_with_date.csv")
str(dat)

reformatted <- dat %>%
  mutate(
    across(c(sex, region), factor),
    # sex = factor (sex)
    # region = factor(region)
  )

reformatted <- mutate(dat, )


str(reformatted)
