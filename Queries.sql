-- SQL Queries

-- a. Write SQL queries for the following requirements:

-- i. Fetch all users
 select*from hc.users;

-- ii. Fetch only user name (first_name + last_name) and email
select first_name ||' '||last_name AS Full_Name,email from hc.users;

-- iii. Fetch only inactive users
select first_name ||' '||last_name AS Users from hc.users WHERE is_active='FALSE';

-- iv. Users whose first_name starts with 'A' and last_name ends with 'i'
SELECT *FROM hc.users WHERE first_name LIKE 'a%' AND last_name LIKE '%i';

-- v. Users whose email contains '@example'
SELECT *FROM hc.users WHERE email LIKE '%@example%';

-- vi. Case-insensitive search for first_name starting with 'A'
SELECT *FROM hc.users WHERE first_name ILIKE 'a%';

-- vii. Users ordered by created_date (descending)
SELECT *FROM hc.users ORDER BY created_date DESC;

-- viii. Top 5 latest created users
select first_name from hc.users  ORDER BY created_by DESC limit 5;

-- ix. Second page of results (5 records per page)
SELECT *FROM hc.users ORDER BY created_by DESC LIMIT 5 OFFSET 5;


