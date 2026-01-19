CREATE EXTENSION pgcrypto;

-- create users table
CREATE TABLE hc.users(
	user_id UUID PRIMARY KEY DEFAULT gen_random_uuid() ,
	first_name VARCHAR(20),
	last_name VARCHAR(20), 
	email VARCHAR(255),
	password Text NOT NULL,
	created_by UUID REFERENCES hc.users(user_id),
	created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by UUID REFERENCES hc.users(user_id),
	modified_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN,
	is_deleted BOOLEAN,
	birth_date DATE,
	address TEXT,
	mobile_number VARCHAR(25),
	role_id UUID REFERENCES hc.roles(role_id)
);

ALTER TABLE hc.users
ADD COLUMN role_id UUID REFERENCES hc.roles(role_id);


-- insert data

-- INSERT INTO hc.users(user_id,first_name,last_name,email,password,created_by,modified_by,is_active,is_deleted,birth_date,address,mobile_number )VALUES
-- 	(gen_random_uuid(),'John','Doe','john.doe@example.com',crypt('pass123', gen_salt('bf')),NULL,NULL, TRUE,FALSE,'2004-10-29','Surat','9979602409'),
-- 	(gen_random_uuid(),'arsi','ukani','arasiukani23@gmail.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2002-09-23','Ahemdabad','9879870657'),
-- 	(gen_random_uuid(),'Ravi','Patel','ravi.patel@gmail.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2001-05-14','Ahmedabad','9898123456'),
-- 	(gen_random_uuid(),'Neha','Shah','neha.shah@yahoo.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2003-11-22','Surat','9876543210'),
-- 	(gen_random_uuid(),'Amit','Mehta','amit.mehta@outlook.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'1999-08-09','Vadodara','9825012345'),
-- 	(gen_random_uuid(),'Pooja','Desai','pooja.desai@gmail.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2002-02-18','Rajkot','9909011122'),
-- 	(gen_random_uuid(),'Karan','Joshi','karan.joshi@gmail.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2000-06-30','Bhavnagar','9712345678'),
-- 	(gen_random_uuid(),'Sneha','Trivedi','sneha.trivedi@yahoo.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2004-01-12','Jamnagar','9638527410'),
-- 	(gen_random_uuid(),'Vikas','Rana','vikas.rana@icloud.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'1998-09-05','Gandhinagar','9870012345'),
-- 	(gen_random_uuid(),'Anjali','Pandya','anjali.pandya@gmail.com',crypt('pass123', gen_salt('bf')),NULL,NULL,TRUE,FALSE,'2003-04-27','Junagadh','9823456789');

	INSERT INTO hc.users
	(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number, role_id)
	VALUES
	(
	    gen_random_uuid(), 'John', 'Doe', 'john.doe@example.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2004-10-29', 'Surat', '9979602409',
	    (SELECT role_id FROM hc.roles WHERE role_name='Admin')
	),
	(
	    gen_random_uuid(), 'Arsi', 'Ukani', 'arasiukani23@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2002-09-23', 'Ahmedabad', '9879870657',
	    (SELECT role_id FROM hc.roles WHERE role_name='Admin')
	),
	(
	    gen_random_uuid(), 'Ravi', 'Patel', 'ravi.patel@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2001-05-14', 'Ahmedabad', '9898123456',
	    (SELECT role_id FROM hc.roles WHERE role_name='Nurse')
	),
	(
	    gen_random_uuid(), 'Neha', 'Shah', 'neha.shah@yahoo.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2003-11-22', 'Surat', '9876543210',
	    (SELECT role_id FROM hc.roles WHERE role_name='Nurse')
	),
	(
	    gen_random_uuid(), 'Amit', 'Mehta', 'amit.mehta@outlook.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '1999-08-09', 'Vadodara', '9825012345',
	    (SELECT role_id FROM hc.roles WHERE role_name='Doctor')
	),
	(
	    gen_random_uuid(), 'Pooja', 'Desai', 'pooja.desai@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2002-02-18', 'Rajkot', '9909011122',
	    (SELECT role_id FROM hc.roles WHERE role_name='Doctor')
	),
	(
	    gen_random_uuid(), 'Karan', 'Joshi', 'karan.joshi@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2000-06-30', 'Bhavnagar', '9712345678',
	    (SELECT role_id FROM hc.roles WHERE role_name='Nurse')
	),
	(
	    gen_random_uuid(), 'Sneha', 'Trivedi', 'sneha.trivedi@yahoo.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2004-01-12', 'Jamnagar', '9638527410',
	    (SELECT role_id FROM hc.roles WHERE role_name='Patient')
	),
	(
	    gen_random_uuid(), 'Vikas', 'Rana', 'vikas.rana@icloud.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '1998-09-05', 'Gandhinagar', '9870012345',
	    (SELECT role_id FROM hc.roles WHERE role_name='Patient')
	),
	(
	    gen_random_uuid(), 'Anjali', 'Pandya', 'anjali.pandya@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2003-04-27', 'Junagadh', '9823456789',
	    (SELECT role_id FROM hc.roles WHERE role_name='Patient')
	);
		INSERT INTO hc.users
		(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number, role_id)
		VALUES
		(
		    gen_random_uuid(), 'dhvani', 'chatrola', 'dhvaniChatrola@gmail.com', crypt('pass123', gen_salt('bf')), 
		    NULL, NULL, TRUE, FALSE, '2006-01-26', 'Surat', '9979602409',
		    (SELECT role_id FROM hc.roles WHERE role_name='Manager')
		)
	
	INSERT INTO hc.users
	(user_id, first_name, last_name, email, password, created_by, modified_by, is_active, is_deleted, birth_date, address, mobile_number)
	VALUES
	(
	    gen_random_uuid(), 'Manya', 'Sojitra', 'ManyaSojitra@gmail.com', crypt('pass123', gen_salt('bf')), 
	    NULL, NULL, TRUE, FALSE, '2017-08-05', 'Ahemdabad', '8976509865'
	)
		
	

	DELETE FROM hc.users;
	SELECT * FROM hc.users;

	UPDATE hc.users SET is_active = FALSE WHERE first_name='arsi'; 





	
