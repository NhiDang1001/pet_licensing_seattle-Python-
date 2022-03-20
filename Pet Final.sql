#Clean

SELECT count(distinct license_number)
FROM seattle_pet_licenses
WHERE license_number is not null;

#Demographic
#1. Species
SELECT count(species) as Numb_Dogs
FROM seattle_pet_licenses
WHERE species = "Dog" and license_number is not null;

SELECT count(species) as Numb_Cats
FROM seattle_pet_licenses
WHERE species = "Cat" and  license_number is not null;

#2. Listing
SELECT primary_breed, count(*) as Top_breeds_dogs
FROM seattle_pet_licenses
WHERE species = "Dog" and license_number is not null
GROUP BY primary_breed
ORDER BY count(*) DESC
limit 5;

SELECT primary_breed, count(*) as Top_breeds_cats
FROM seattle_pet_licenses
WHERE species = "Cat" and license_number is not null
GROUP BY primary_breed
ORDER BY count(*) DESC
limit 5;

#2+: Compare dogs and cats 
SELECT Top_breeds_dogs, Top_breeds_cats
FROM (SELECT primary_breed as Top_breeds_dogs
FROM seattle_pet_licenses
WHERE species = "Dog" and license_number is not null
GROUP BY primary_breed
ORDER BY count(*) DESC
limit 5) as sub1, (SELECT distinct primary_breed as Top_breeds_cats
FROM seattle_pet_licenses
WHERE species = "Cat" and license_number is not null
GROUP BY primary_breed
ORDER BY count(*) DESC
limit 5) as sub2;

#3. Count pet licensed by Zip Code 
SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE species = "Cat" and license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE species = "Dog" and license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

#4. 
SELECT zip_code, avg(Total_Income_Amount)
FROM wa_incomes_zip_code
GROUP BY zip_code
ORDER BY avg(Total_Income_Amount) desc
limit 5;


#5.Find the Adjusted gross income with Highest pet licenses by Zip code - STUCK


#Time difference
#Count number of licensed for each year
SELECT YEAR(license_issue_date), count(*)
FROM seattle_pet_licenses
WHERE license_number is not null
GROUP BY YEAR(license_issue_date)
ORDER BY count(*) desc;

SELECT avg(Total_Income_Amount)
FROM wa_incomes_zip_code
WHERE zip_code = (SELECT zip_code FROM seattle_pet_licenses WHERE year(license_issue_date) = (SELECT YEAR(license_issue_date)
FROM seattle_pet_licenses
WHERE license_number is not null
GROUP BY YEAR(license_issue_date)
ORDER BY count(*) desc));



#Count number of cats by Zip Code
SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE species = "Cat" and license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

#Count number of dogs by Zip code
SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE species = "Dog" and license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

#Count number of licenses pet by Zip code
SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5;

###### AVG income per Return by Zip Code ##############

#part1#
select zip_code,sum(income) as Total_Income
from (
SELECT zip_code, number_of_returns * total_income_amount as income
FROM wa_incomes_zip_code) as sub1
group by zip_code;

#part2#
SELECT zip_code, sum(number_of_returns) as Total_Returns
FROM wa_incomes_zip_code
GROUP BY zip_code;

# combining#
select part1.*, Total_Returns, Total_Income/Total_Returns as AvgIncome_perReturn
from 
(select zip_code,sum(income) as Total_Income
from (
SELECT zip_code, number_of_returns * total_income_amount as income
FROM wa_incomes_zip_code) as sub1
group by zip_code) as part1

inner join (SELECT zip_code, sum(number_of_returns) as Total_Returns
FROM wa_incomes_zip_code
GROUP BY zip_code) as part2

on part1.zip_code=part2.zip_code;


#Link with 5 zipcode order by high number of pets
SELECT sub2.zip_code, sub1.AvgIncome_perReturn
FROM (select part1.*, Total_Returns, Total_Income/Total_Returns as AvgIncome_perReturn
from 
(select zip_code,sum(income) as Total_Income
from (
SELECT zip_code, number_of_returns * total_income_amount as income
FROM wa_incomes_zip_code) as sub1
group by zip_code) as part1

inner join (SELECT zip_code, sum(number_of_returns) as Total_Returns
FROM wa_incomes_zip_code
GROUP BY zip_code) as part2

on part1.zip_code=part2.zip_code) as sub1

INNER JOIN (SELECT zip_code, count(*)
FROM seattle_pet_licenses
WHERE license_number is not null
GROUP BY zip_code
ORDER BY count(*) desc
limit 5) as sub2
ON sub1.zip_code = sub2.zip_code;