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
	SELECT c.category_name , s.service_type_name FROM hc.categories c INNER JOIN hc.service_types s on c.service_type_id = s. service_type_id;

-- b. LEFT JOIN:
-- i. Fetch all service types including those without categories
	SELECT s.service_type_name , category_name FROM hc.service_types s LEFT JOIN hc.categories c on c.service_type_id = s. service_type_id;

-- c. RIGHT JOIN:
-- i. Fetch all categories even if they have no sub-categories
	SELECT c.category_name , sb.sub_category_name FROM hc.sub_categories sb  RIGHT JOIN hc.categories c on c.category_id = sb.category_id;




														-- 4. EXISTS

-- a. Fetch roles that have at least one user

	SELECT role_name FROM hc.roles r WHERE EXISTS 
		(SELECT user_id from hc.users u WHERE u.role_id = r.role_id );

	SELECT r.role_id, r.role_name FROM hc.roles r WHERE EXISTS (
    SELECT 1
    FROM hc.users u
    WHERE u.role_id = r.role_id);


-- b. Fetch service types that have categories

	SELECT service_type_name from hc.service_types s WHERE EXISTS(SELECT category_id from hc.categories c where s.service_type_id = c.service_type_id); 


-- c. Fetch categories that have sub-categories

	SELECT category_name from hc.categories c WHERE EXISTS (SELECT sub_category_name from hc.sub_categories sb WHERE c.category_id = sb.category_id); 



-- d. Fetch users whose role exists

	SELECT first_name FROM hc.users;
	SELECT first_name FROM hc.users u WHERE EXISTS (SELECT role_id FROM hc.roles r WHERE u.role_id = r.role_id);


										-- 5. Common Table Expression (CTE)

-- a. Use a CTE to count the number of categories per service type

	WITH category_counts AS(
		SELECT service_type_name , COUNT(category_name) AS count_number_of_categories FROM hc.service_types s JOIN hc.categories c ON s.service_type_id = c.service_type_id GROUP BY service_type_name )
	SELECT service_type_name,count_number_of_categories FROM category_counts;

											-- 6. Constraints

-- a. UNIQUE Constraint:
-- i. Ensure users.email is unique
	ALTER TABLE hc.users ADD CONSTRAINT user_emain UNIQUE(email);
	SELECT * FROM hc.users;
	SELECT email , COUNT(*) FROM hc.users GROUP BY email HAVING COUNT(*)=1;

	INSERT INTO hc.users
	(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number, role_id)
	VALUES
	(
    gen_random_uuid(), 'dhvani', 'chatrola', 'dhvaniChatrola@gmail.com', crypt('pass123', gen_salt('bf')), 
    NULL, NULL, TRUE, FALSE, '2006-01-26', 'Surat', '9979602409',
    (SELECT role_id FROM hc.roles WHERE role_name='Manager')
	)

-- b. FOREIGN KEY Constraints:
-- i. users → roles
	ALTER TABLE hc.users
	ADD COLUMN role_id UUID REFERENCES hc.roles(role_id);

-- ii. categories → service_types
	ALTER TABLE hc.categories
	ADD CONSTRAINT fk_categories_service_types
	FOREIGN KEY (service_type_id)
	REFERENCES hc.service_types(service_type_id);


-- iii. sub_categories → categories
	ALTER TABLE hc.sub_categories
	ADD CONSTRAINT fk_sub_categories_categories
	FOREIGN KEY (category_id)
	REFERENCES hc.categories(category_id);

-- c. CHECK Constraints:

-- i. Mobile number must have a valid length

	SELECT * FROM hc.users;
	ALTER TABLE hc.users ADD CONSTRAINT mobile_num CHECK (mobile_number ~ '^[0-9]{10}$');

	INSERT INTO hc.users
	(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number, role_id)
	VALUES
	(
    gen_random_uuid(), 'dhvani', 'chatrola', 'dhvaniChatrola@gmail.com', crypt('pass123', gen_salt('bf')), 
    NULL, NULL, TRUE, FALSE, '2006-01-26', 'Surat', '997960240239',
    (SELECT role_id FROM hc.roles WHERE role_name='Manager')
	)
	

-- ii. birth_date must be a past date
	ALTER TABLE hc.users ADD CONSTRAINT b_date CHECK (birth_date < CURRENT_DATE);
	
	INSERT INTO hc.users
	(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number, role_id)
	VALUES
	(
    gen_random_uuid(), 'dhvani', 'chatrola', 'dhvaniChatrola12@gmail.com', crypt('pass123', gen_salt('bf')), 
    NULL, NULL, TRUE, FALSE, '2027-01-26', 'Surat', '5432198765',
    (SELECT role_id FROM hc.roles WHERE role_name='Manager')
	)

													-- 7. Indexes

-- a. Create an index on users.email
	CREATE INDEX ind_email ON hc.users(email);
	EXPLAIN SELECT * FROM hc.users WHERE email = 'arasiukani23@gmail.com';



									-- 	8. Date & Time Handling

-- a. Fetch users created today
	SELECT first_name || ' ' || last_name AS full_name FROM hc.users WHERE DATE(created_date) = CURRENT_DATE;


-- b. Fetch users created in the last 30 days
	SELECT first_name || ' ' || last_name AS full_name FROM hc.users WHERE created_date >= NOW() - INTERVAL '30 days';

-- c. Extract year from users.birth_date
	SELECT first_name || ' ' || last_name AS full_name, EXTRACT(YEAR FROM birth_date) AS year FROM hc.users;

-- d. Calculate age of each user
 	SELECT first_name || ' ' || last_name AS full_name , EXTRACT (YEAR FROM AGE(CURRENT_DATE,birth_date)) AS age_of_user FROM hc.users;

-- e. Group users by birth year
	SELECT  EXTRACT(YEAR FROM birth_date) AS birth_year, COUNT(*) AS total_user FROM hc.users GROUP BY birth_year ORDER BY birth_year;


						-- 9. Window Functions (ROW_NUMBER, RANK, LAG, LEAD)

-- a. Assign row numbers to users within each role based on created_date	
	SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    r.role_name,
    u.created_date,
    ROW_NUMBER() OVER (PARTITION BY u.role_id ORDER BY u.created_date) AS row_number
	FROM hc.users u
	JOIN hc.roles r ON u.role_id = r.role_id
	ORDER BY r.role_name, row_number;

-- b. Rank roles based on number of users

	SELECT r.role_name,
       COUNT(u.user_id) AS user_count,
       RANK() OVER (ORDER BY COUNT(u.user_id) DESC) AS role_rank
		FROM hc.roles r
		LEFT JOIN hc.users u ON r.role_id = u.role_id
		GROUP BY r.role_name
		ORDER BY role_rank;



-- c. Use LAG to fetch previous user creation date per role
	SELECT 
    u.user_id,
    u.first_name,
    r.role_name,
    u.created_date,
    LAG(u.created_date) OVER (
    PARTITION BY u.role_id
    ORDER BY u.created_date, u.user_id
    ) AS previous_created_date FROM hc.users u JOIN hc.roles r ON r.role_id = u.role_id
	ORDER BY r.role_name, u.created_date, u.user_id;

-- d. Use LEAD to fetch next user creation date per role
	SELECT 
    u.user_id,
    u.first_name,
    r.role_name,
    u.created_date,
    LEAD(u.created_date) OVER (
    PARTITION BY u.role_id
    ORDER BY u.created_date, u.user_id
    ) AS previous_created_date FROM hc.users u JOIN hc.roles r ON r.role_id = u.role_id
	ORDER BY r.role_name, u.created_date, u.user_id;

-- e. Fetch the second oldest user per rol

	SELECT 
    user_id,
    first_name,
    role_name,
    created_date FROM (
    SELECT 
     	u.user_id,
        u.first_name,
        r.role_name,
        u.created_date,
        ROW_NUMBER() OVER (
            PARTITION BY u.role_id
            ORDER BY u.created_date ASC, u.user_id
        ) AS rn
    FROM hc.users u
    JOIN hc.roles r ON r.role_id = u.role_id
) sub
WHERE rn = 2;

	
	