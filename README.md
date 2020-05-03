# Mobile video game cohort KPIs
SQL computed cohort KPIs from raw data generated during a week by a game that has been launched in beta test w/ PostgreSQL 

## First look at the data

I worked with three datasets containing information of a mobile game for one week: "users" which concerns the installations, "transactions" the in-app purchases and "sessions" which corresponds to the connections of the players.

The users table includes the fields cohort_date which is the date of installation of the game, country_code which is the identifier of the country where the game has been installed, network_name which corresponds to the acquisition channel of the user and a field user_id allowing to identify each player

37,719 players from 28 different countries downloaded the game from September 1 to 7 of 2017. The session table tells us that among these new players and during this same week, 20,169 users played for a total of 101,652 game sessions.

The transactions table informs us that a revenue of 865.38 was generated from the in-app purchases of 70 of these new players during this week, with an average spend of 5.6 per order.

## Computing some KPIs

All the SQL queries are in the attached file and the final table is stored in the csv file "GPG_KPIs".

From these three datasets, I performed several SQL queries by creating temporary tables in order to compute different KPIs and to gather them afterwards according to the different days of the week.

## KPIs by date

### DAU (daily active users)	
Number of distinct users who have played the game during a given day	
> 100 for 2017-09-01 means that 100 unique users have played during that day 

### DNU (daily new users)	
Number of people who have installed the game at a given date	
> 100 for 2017-09-01 means that 100 people installed the game that day.

### Revenue	
Revenue generated by players during a given day with in-app purchases (IAP) 	
> 100$ for 2017-09-01 means that IAP generated 100$ of revenue that day

### DARPU(Daily Average Revenue per User)	
Average revenue generated during a given day by players who had been active that day	
> 0.1$ for 2017-09-01 means that each user who have played during that day has generated on average a revenue of 0.1$


## Cohort KPIs

### Retention rate at D+1 (rr_d1)
Proportion of users who have played the day after installing the game	
> 40% for 2017-09-01 means that among users who have installed the game on 2017-09-01, 40% have played on 2017-09-02

### Cohort Conversion Rate (cr)	
Proportion of users who have paid at least once	
> 1% for 2017-09-01 means that 1% of users who have installed the game on 2017-09-01 have made at least one IAP since then.

### Cohort Conversion Rate at D+2 (cr_d2)
Proportion of users who have paid at least once in the three first days since install	
> 1% for 2017-09-01 means that 1% of users who have installed the game on 2017-09-01 have made at least one IAP between 2017-09-01 and 2017-09-03
