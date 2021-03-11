# this is my first script

library(tidyverse)
library(readxl)
library(here)

data_total <- read_excel(here("data/TECH CHARGES EXAMPLE.xlsx"))
charges_total <- read_excel("data/TECH CHARGES EXAMPLE.xlsx", sheet=2)
payments_total <- read_excel("data/TECH CHARGES EXAMPLE.xlsx", sheet=3)
#trying to rename column "...7"
colnames(charges_total)
view(charges_total)
tibble(charges_total)
colnames(charges_total)
dplyr::rename(charges_total,Paid =...7) 
colnames(charges_total)
view(data_total)


match(colnames(charges_total),colnames(payments_total))
