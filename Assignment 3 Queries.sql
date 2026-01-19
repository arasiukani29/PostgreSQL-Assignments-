												-- Assignment 3 – Advanced PostgreSQL

	-- 1. Views & Materialized Views

	-- a. Create a VIEW that displays:
	-- i. user_id
	-- ii. full_name (first_name + last_name)
	-- iii. email
	-- iv. role_name

	CREATE OR REPLACE VIEW hc.vw_user_role AS SELECT u.user_id , u.first_name ||' '|| u.last_name AS full_name , u.email, r.role_name 
		FROM hc.users u 
		JOIN hc.roles r 
		ON u.role_id = r.role_id;

	SELECT * FROM hc.vw_user_role;

	-- b. Create a VIEW that shows only active users created in the last 30 
	-- days.

	CREATE OR REPLACE VIEW hc.vw_active_user AS SELECT user_id , first_name ||' '|| last_name AS full_name , is_Active , created_date
		FROM hc.users 
		WHERE is_active='true' AND created_date >= NOW() - INTERVAL '30 days';
	
	-- c. Create a MATERIALIZED VIEW that stores:
	-- i. role_name
	-- ii. total_users per role

	CREATE MATERIALIZED VIEW hc.mv_user_role AS SELECT r.role_name , COUNT(*) AS total_user_per_role 
		FROM hc.users u 
		JOIN hc.roles r 
		ON u.role_id = r.role_id 
		GROUP BY role_name;

	SELECT * FROM hc.mv_user_role;

	-- d. Write a query to refresh the materialized view.

	REFRESH MATERIALIZED VIEW  hc.mv_user_role;


																		-- 2. Function

	-- a. Create a SQL function that:

	-- i. Accepts a role_id as input
	-- ii. Returns the total number of users for that role

		CREATE OR REPLACE FUNCTION hc.get_user_count_by_role(p_role_id UUID)
		RETURNS INTEGER
		LANGUAGE plpgsql
		AS $$
		DECLARE
		    v_total INTEGER;
		BEGIN
		    SELECT COUNT(*)
		    INTO v_total
		    FROM hc.users
		    WHERE role_id = p_role_id;  
		
		    RETURN v_total;
		END;
		$$;

	CREATE OR REPLACE FUNCTION hc.get_user_count_by_role(p_role_id UUID)
		RETURNS INTEGER 
		LANGUAGE sql
		AS $$
		    SELECT COUNT(*)
		    FROM hc.users
		    WHERE role_id = p_role_id; 
		$$;

		DROP FUNCTION IF EXISTS hc.get_user_count_by_role(UUID);


		SELECT * FROM hc.get_user_count_by_role('1e2b0545-c57f-4cbe-bbf9-3ebf09cb98c9');



	-- b. Create a PL/pgSQL function that:
	-- i. Accepts a user_id
	-- ii. Returns the user’s full name

	
		CREATE OR REPLACE FUNCTION hc.user_full_name(p_user_id UUID)
		RETURNS  VARCHAR
		LANGUAGE plpgsql
		AS $$
		DECLARE
		    user_name VARCHAR;
		BEGIN
		    SELECT first_name ||' '|| last_name as full_name 
		    INTO user_name
		    FROM hc.users
		    WHERE user_id = p_user_id;  
		
		    RETURN user_name;
		END;
		$$;

	SELECT * FROM hc.user_full_name('42d2274b-33c7-44cf-a00e-95dbad8c12b8')
	DROP FUNCTION hc.user_full_name(UUID)

		CREATE OR REPLACE FUNCTION hc.users(p_user_id UUID)
			RETURNS TABLE (user_name TEXT)
			LANGUAGE plpgsql
			AS $$
			BEGIN 
				RETURN QUERY
			SELECT first_name ||' '|| last_name as user_name 
		    FROM hc.users
		    WHERE user_id = p_user_id; 
		END;
		$$;
		
		DROP FUNCTION IF EXISTS hc.users(UUID);
		SELECT * FROM hc.users('42d2274b-33c7-44cf-a00e-95dbad8c12b8')

	
	-- c. Create a function that:
	-- i. Accepts birth_date
	-- ii. Returns calculated age

	CREATE OR REPLACE FUNCTION hc.get_age_from_birth_date(p_birth_date DATE)
			RETURNS TABLE (user_name TEXT,age_of_user NUMERIC)
			LANGUAGE plpgsql
			AS $$
			BEGIN 
				RETURN QUERY 
			SELECT first_name ||' '||last_name AS user_name,EXTRACT (YEAR FROM AGE(CURRENT_DATE,birth_date)) 
			AS age_of_user 
			FROM hc.users WHERE p_birth_date = birth_date;
		END;
		$$;

		DROP FUNCTION IF EXISTS hc.get_age_from_birth_date(DATE);

		SELECT * FROM hc.get_age_from_birth_date('2006-01-26');


	-- d. Create a function that:
	-- i. Returns all users created today

	CREATE OR REPLACE FUNCTION hc.get_user_created_from_today()
			RETURNS TABLE (user_id UUID,full_name TEXT,email VARCHAR )
			LANGUAGE plpgsql
			AS $$
			BEGIN 
				RETURN QUERY
			SELECT u.user_id,first_name || ' ' || last_name AS full_name, u.email 
		FROM hc.users u 
		WHERE DATE(created_date) = CURRENT_DATE;
		END;
		$$;

		DROP FUNCTION IF EXISTS hc.get_user_created_from_today();
		SELECT * FROM hc.get_user_created_from_today();


	-- e. Demonstrate usage of:
	-- i. IN parameters
	-- ii. OUT parameters
	-- iii. RETURN TABLE


-- 3. Stored Procedures

	-- a. Create a stored procedure to:
	-- i. Insert a new user
	

	CREATE OR REPLACE PROCEDURE hc.insert_new_user1 (
    p_user_id UUID,
    p_first_name TEXT,
    p_last_name TEXT,
    p_email TEXT,
    p_password TEXT,
    p_created_by UUID,
    p_modified_by UUID,
    p_is_active BOOLEAN,
    p_is_deleted BOOLEAN,
    p_birth_date DATE,
    p_address TEXT,
    p_mobile_number TEXT,
    p_role_id UUID)
		
	LANGUAGE plpgsql
	AS $$
	BEGIN
    
    INSERT INTO hc.users ( user_id,first_name,last_name,email,password created_by,modified_by,is_active,is_deleted,birth_date,address,mobile_number,role_id
    ) VALUES (p_user_id,p_first_name, p_last_name,p_email,p_password,p_created_by,p_modified_by,p_is_active,p_is_deleted,p_birth_date,p_address, p_mobile_number,p_role_id
    );
	END;
	$$;

	CALL hc.insert_new_user1(
    gen_random_uuid(), 
    'Nidhi', 
    'Malaviya', 
    'nidhi.malaviya@example.com', 
    crypt('pass123', gen_salt('bf')), 
    NULL, 
    NULL,  
    TRUE, 
    FALSE, 
    '2004-07-28', 
    'Surat', 
    '9974502409',
    '973446d5-5f13-423f-b93e-ea888c09dcf8'
	);

		DROP PROCEDURE IF EXISTS hc.insert_new_user (
		    UUID, TEXT, TEXT, TEXT, TEXT, UUID, UUID, BOOLEAN, BOOLEAN, DATE, TEXT, TEXT, UUID
		);
		call hc.insert_new_user( gen_random_uuid(), 'nidhi', 'Malaviya', 'nidhi.malaviya@example.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2004-07-28', 'Surat', '9974502409','973446d5-5f13-423f-b93e-ea888c09dcf8');

			SELECT * FROM hc.users;

	-- ii. Validate email uniqueness

		
	-- iii. Set created_date automatically

	-- b. Create a stored procedure that:
	-- i. Soft deletes a user (is_deleted = true)


	-- c. Create a stored procedure that:
	-- i. Updates user role

	-- d. Logs old role and new role into an audit table

	-- 4. Triggers
	-- a. Create a trigger that:
	-- i. Automatically updates modified_date on UPDATE of users 
	-- table
	-- b. Create a trigger that:
	-- i. Prevents deletion of users
	-- ii. Raises an exception if DELETE is attempted
	-- c. Create an AFTER INSERT trigger to:
	-- i. Log user creation into an audit table


-- 5. Cursors
-- a. Write a PL/pgSQL block using a cursor to:
-- i. Loop through all users
-- ii. Print user_id and email using RAISE NOTICE

-- 6. Jobs / Scheduling
-- a. Write a job to:
-- i. Refresh a materialized view every hour