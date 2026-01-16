													--Assignment 2 Queries

                                      -- 1. Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
	
-- a. Count the total number of users
	SELECT COUNT(*) FROM hc.users;

-- b. Count the number of active users
	SELECT COUNT(is_active) FROM hc.users WHERE is_active='true';

-- c. Count the number of users per role
	SELECT r.role_name,COUNT(u.user_id) AS UserCount FROM hc.roles r LEFT JOIN hc.users u ON r.role_id = u.role_id GROUP BY r.role_name ORDER BY UserCount DESC;

-- d. Find the minimum and maximum birth_date of users
	SELECT MIN(birth_date) AS min_Birth_date, MAX(birth_date) AS max_Birth_date from hc.users;

-- e. Calculate the average age of users
	SELECT ROUND(AVG(EXTRACT(YEAR FROM AGE(birth_date)))) AS avg_age FROM hc.users;

-- f. Count total categories per service type
	SELECT s.service_type_name , COUNT(c.category_id) AS total_categories FROM hc.service_types s LEFT JOIN  hc.categories c ON s.service_type_id = c.service_type_id GROUP BY s.service_type_name ORDER BY total_categories DESC;

-- g. Count total sub-categories per category
	SELECT c.category_name , COUNT(sb.sub_category_id) AS total_sub_categories FROM hc.categories c LEFT JOIN hc.sub_categories sb ON sb.category_id = c.category_id GROUP BY c.category_name;

SELECT*FROM hc.users;
UPDATE hc.users SET is_active = 'false' WHERE birth_date='2002-09-23';
UPDATE hc.users SET is_active = 'false' WHERE birth_date='2004-10-29';

SELECT * FROM hc.users;
SELECT * FROM hc.roles;
select * from hc.service_types;
select * from hc.categories;
select * from hc.sub_categories;


														-- 2. GROUP BY & HAVING


-- a. Fetch the number of users grouped by role

	SELECT COUNT(user_id) AS Number_Of_User from hc.users GROUP BY role_id;


-- b. Fetch roles having more than 2 users
	SELECT  COUNT(*) AS roles FROM hc.users GROUP BY role_id HAVING COUNT(*) >2; 

-- c. Fetch service types having more than 3 categories
	SELECT COUNT(*) as categories_count FROM hc.categories GROUP BY service_type_id HAVING COUNT(*)>3;

 

-- d. Fetch categories having at least 2 sub-categories
	
	SELECT 
	    c.category_id,
	    c.category_name,
	    COUNT(sc.sub_category_id) AS sub_category_count
	FROM hc.categories c
	JOIN hc.sub_categories sc 
	    ON sc.category_id = c.category_id
	GROUP BY c.category_id, c.category_name
	HAVING COUNT(sc.sub_category_id) >= 2;


-- e. Fetch users grouped by birth year
	SELECT 
    EXTRACT(YEAR FROM birth_date) AS birth_year,
    COUNT(user_id) AS user_count
	FROM hc.users
	GROUP BY EXTRACT(YEAR FROM birth_date)
	ORDER BY birth_year;


-- f. Fetch birth years having more than 5 users
	SELECT 
    EXTRACT(YEAR FROM birth_date) AS birth_year,
    COUNT(user_id) AS user_count
	FROM hc.users
	GROUP BY EXTRACT(YEAR FROM birth_date)
	HAVING COUNT(user_id) > 5
	ORDER BY birth_year;




																	-- 3. Joins

-- a. INNER JOIN:
-- i. Fetch categories with service type names
	SELECT c.category_name , s.service_type_name FROM hc.categories c inner join hc.service_types s on c.service_type_id = s. service_type_id;

-- b. LEFT JOIN:
-- i. Fetch all service types including those without categories
	SELECT s.service_type_name , category_name FROM hc.service_types s LEFT JOIN hc.categories c on c.service_type_id = s. service_type_id;

-- c. RIGHT JOIN:
-- i. Fetch all categories even if they have no sub-categories
	SELECT c.category_name , sb.sub_category_name FROM hc.sub_categories sb  RIGHT JOIN hc.categories c on c.category_id = sb.category_id;




																		-- 4. EXISTS

-- a. Fetch roles that have at least one user

	SELECT role_name FROM hc.roles r WHERE EXISTS (SELECT user_id from hc.users u );

-- b. Fetch service types that have categories


-- c. Fetch categories that have sub-categories



-- d. Fetch users whose role exists