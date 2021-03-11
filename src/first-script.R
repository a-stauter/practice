# This script will convert tech-charges to a reporting format


# Load libraries ----------------------------------------------------------
library(tidyverse)
library(here)
library(readxl)
library(lubridate)
library(gt)
# Import data -------------------------------------------------------------
tech_charges <- read_excel(here("data","tech-charges-example.xlsx"), 
                           sheet = "Charges")

tech_payments <- read_excel(here("data","tech-charges-example.xlsx"),
                            sheet = "Payments")

# Recreate totals sheet ----------------------------------------------------

##Grouping data by client
by_client_charges <-
  tech_charges %>%
  group_by(Group, Client) %>%
  summarise(charge_amount = sum(charge_amount)) %>%
  ungroup()


by_client_payments <-
  tech_payments %>% 
  group_by(Client) %>% 
  summarise(payment_amount = sum(payment_amount)) %>%
  ungroup()

##joining the two data frames
charges_payments_joined <- full_join(by_client_charges, by_client_payments)

##Creating totals column
tech_totals <- mutate(charges_payments_joined,
                      total= charge_amount+payment_amount,
                      Group = case_when(
                        is.na(Group) ~ str_to_title(Client),
                        TRUE ~ Group
                      ))
expanded_tech_totals <- 
  as.data.frame(t(tech_totals))

#Income Statement Creation----------------------------------------------------------------
##selecting useful information
select_ch <-  
  tech_charges  %>% 
  select(Group,Client, date, Invoice_num,charge_amount) 
  

select_pmt <- 
  tech_payments %>% 
  select(Group,Client, date, Invoice_num,payment_amount) 
 

##joining 

select_join <- 
  full_join(select_ch,select_pmt, 
            by = c("Group", "Client","Invoice_num", "date")) %>% 
  mutate(year=year(date), 
         month=month(date), 
         day=day(date))

total<- select_join %>% 
  group_by(month, Client) %>% 
  summarise_at(vars(contains("amount")), sum, na.rm=TRUE) %>% 
  ungroup()



client_group_total <- select_join %>% 
  group_by(Client, month) %>% 
  summarise_at(vars(contains("amount")), sum, na.rm=TRUE) %>% 
  mutate(starting_balance = lag(cumsum(charge_amount)+cumsum(payment_amount))) %>% 
  relocate(starting_balance, .after = month) %>% 
  replace(is.na(.), 0)%>% 
  mutate(ending_balance = round(rowSums(across(c(starting_balance,charge_amount,payment_amount))), 2))

##split by Client
NCMC <- total %>% 
  filter(Client=="NCMC") %>% 
  mutate(starting_balance = lag(cumsum(charge_amount)+cumsum(payment_amount))) %>% 
  relocate(starting_balance, .after = Client) %>% 
  replace(is.na(.), 0) %>% 
  mutate(ending_balance = rowSums(across(c(3:5)))) 

ggplot(data = NCMC)+
  geom_line(mapping = aes(x=month, y= ending_balance))

##gt testing-------------------------------------------------------------------
gt_ncmc <- NCMC %>% 
  select(-Client) %>% 
  gt(rowname_col = "month") %>% 
  tab_header(
    title = "NCMC 2020",
    subtitle = "Monthly Charges and Payments"
  ) %>% 
  tab_spanner(
    label = "Balance",
    columns = vars(starting_balance,charge_amount,payment_amount,ending_balance)
  ) %>% 
  cols_label(
    starting_balance ="Start",
    charge_amount = "Charges",
    payment_amount = "Payments",
    ending_balance = "End"
  )
 
gt_total <- client_group_total %>% 
  gt(rowname_col = "month") %>% 
  tab_header(
    title = "Total 2020", 
    subtitle = "Monthly Charges and Payments by Client"
  ) %>% 
  tab_spanner(
    label = "Balance",
    columns = vars(starting_balance,charge_amount,payment_amount,ending_balance)
  ) %>% 
  tab_stubhead(
    label = "Client"
  ) %>% 
  cols_label(
    starting_balance ="Start",
    charge_amount = "Charges",
    payment_amount = "Payments",
    ending_balance = "End"
  )
print(gt_ncmc)
print(gt_total)
