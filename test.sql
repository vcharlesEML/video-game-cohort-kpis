-- CREATING TABLES IN POSTGRESQL
CREATE TABLE public.users 
(
	cohort_date date,
	country_code varchar,
	network_name varchar,
	user_id varchar
);

CREATE TABLE public.sessions 
(
	user_id varchar,
	"date" date
);

CREATE TABLE public.transactions 
(
	user_id varchar,
	"date" date,
	amount numeric
);

--KPIs computed by date 
CREATE TEMP TABLE gpg AS 
SELECT 
	trans."date",
	trans.Revenue,
	count(distinct sessions.user_id) as DAU,
	trans.Revenue / count(distinct sessions.user_id) as DARPU
FROM
(SELECT
 	trans."date",
 	sum(trans.amount) as Revenue
 	FROM transactions trans
 GROUP BY trans."date"
) trans
LEFT JOIN sessions
ON trans."date" = sessions."date"
GROUP BY trans."date",trans.Revenue
ORDER BY trans."date" ;

--KPIs computed by date + DNU
CREATE TEMP TABLE gpg_dnu AS
SELECT 
	gpg.*,
	COUNT(users.user_id) AS DNU
FROM gpg
INNER JOIN users
ON gpg."date" = users.cohort_date
GROUP BY gpg."date",gpg.revenue,gpg.darpu,gpg.dau
ORDER BY gpg."date";

--Retention Rate at D+1
CREATE TEMP TABLE rr_d1temp AS
SELECT 
users.cohort_date,
COUNT(DISTINCT sessions.user_id) * 1.0 / COUNT(DISTINCT users.user_id) AS RR_D1
FROM users LEFT JOIN
     sessions
     ON sessions.user_id = users.user_id AND
        sessions."date"::date = users.cohort_date::date + interval '1 day'
GROUP BY users.cohort_date;

--Conversion Rate
CREATE TEMP TABLE cr_temp AS
SELECT 
users.cohort_date,
COUNT(DISTINCT transactions.user_id) * 1.0 / COUNT(DISTINCT users.user_id) AS CR
FROM users LEFT JOIN
     transactions
     ON transactions.user_id = users.user_id AND
        transactions."date"::date = users.cohort_date::date 
GROUP BY users.cohort_date;

--Conversion Rate D+2
CREATE TEMP TABLE cr_d2temp AS
SELECT users.cohort_date,
COUNT(DISTINCT transactions.user_id) * 1.0 / COUNT(DISTINCT users.user_id) AS CR_D2
FROM users LEFT JOIN
     transactions
     ON transactions.user_id = users.user_id AND
        transactions."date"::date = users.cohort_date::date + interval '2 day'
GROUP BY users.cohort_date;

--COHORTED KPIs
CREATE TEMP TABLE cohorted_Temp AS
SELECT 
cr_temp.*,
cr_d2temp.cr_d2,
rr_d1temp.rr_D1
FROM cr_temp
LEFT JOIN cr_d2temp 
ON cr_temp.cohort_date =cr_d2temp.cohort_date
LEFT JOIN rr_d1temp 
ON cr_temp.cohort_date =rr_d1temp.cohort_date;

--FINAL TABLE
CREATE TABLE gpg_kpis AS
SELECT 
gpg_dnu.*,
cohorted_Temp.rr_d1,
cohorted_Temp.cr,
cohorted_Temp.cr_d2
FROM gpg_dnu
LEFT JOIN cohorted_Temp
ON gpg_dnu."date" = cohorted_Temp.cohort_date;

select * from gpg_kpis;