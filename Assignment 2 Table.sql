-- roles table

CREATE TABLE hc.roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(50) UNIQUE NOT NULL,
	created_by UUID REFERENCES hc.users(user_id),
	created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by UUID REFERENCES hc.users(user_id),
	modified_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE,
	is_deleted BOOLEAN DEFAULT FALSE   
);


--insert data into roles table 

DELETE FROM hc.roles;
DELETE FROM hc.users;

INSERT INTO hc.roles (role_name)
VALUES('Admin'),('Doctor'),('Nurse'),('Patient');

-- service_type table

CREATE TABLE hc.service_types (
    service_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_type_name VARCHAR(100) NOT NULL,
	created_by UUID REFERENCES hc.users(user_id),
	created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by UUID REFERENCES hc.users(user_id),
	modified_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE,
	is_deleted BOOLEAN DEFAULT FALSE
);

DELETE FROM hc.service_types;
DELETE FROM hc.categories;
DELETE FROM hc.sub_categories; 
--insert data into service_types table 
INSERT INTO hc.service_types (service_type_name) 
VALUES ('Healthcare'), ('Laboratory'), ('Pharmacy'), ('Radiology');

INSERT INTO hc.service_types (service_type_name) VALUES ('HomeCare');



-- categories

CREATE TABLE hc.categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_name VARCHAR(100) NOT NULL,
    service_type_id UUID ,
    created_by UUID REFERENCES hc.users(user_id),
	created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by UUID REFERENCES hc.users(user_id),
	modified_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE,
	is_deleted BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_service_type
        FOREIGN KEY (service_type_id)
        REFERENCES hc.service_types(service_type_id)
);



--insert data into categories table 
INSERT INTO hc.categories (category_name, service_type_id)
VALUES
-- Healthcare
('General Medicine', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Healthcare')),
('Pediatrics', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Healthcare')),
('Cardiology', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Healthcare')),
('Dermatology', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Healthcare')),

-- Laboratory
('Blood Tests', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Laboratory')),
('Urine Tests', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Laboratory')),
('Pathology', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Laboratory')),
('Microbiology', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Laboratory')),

-- Pharmacy
('Prescription Medicines', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Pharmacy')),
('Over-the-Counter Drugs', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Pharmacy')),
('Medical Supplies', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Pharmacy')),
('Health Supplements', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Pharmacy')),

-- Radiology
('X-Ray', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Radiology')),
('CT Scan', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Radiology')),
('MRI', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Radiology')),
('Ultrasound', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Radiology'));

INSERT INTO hc.categories (category_name, service_type_id)
VALUES ('diet planning', (SELECT service_type_id FROM hc.service_types WHERE service_type_name='Healthcare'));
-- sub_categories

CREATE TABLE hc.sub_categories (
    sub_category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sub_category_name VARCHAR(100) NOT NULL,
    category_id UUID NOT NULL,
    created_by UUID REFERENCES hc.users(user_id),
	created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by UUID REFERENCES hc.users(user_id),
	modified_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE,
	is_deleted BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_category
        FOREIGN KEY (category_id)
        REFERENCES hc.categories(category_id)
);

--insert data into sub_categories table 
INSERT INTO hc.sub_categories (sub_category_name, category_id)
VALUES
-- Healthcare → General Medicine
('OPD Consultation', (SELECT category_id FROM hc.categories WHERE category_name='General Medicine')),
('Follow-up Visit', (SELECT category_id FROM hc.categories WHERE category_name='General Medicine')),
('Health Checkup', (SELECT category_id FROM hc.categories WHERE category_name='General Medicine')),
('Chronic Disease Care', (SELECT category_id FROM hc.categories WHERE category_name='General Medicine')),

-- Healthcare → Pediatrics
('Child Consultation', (SELECT category_id FROM hc.categories WHERE category_name='Pediatrics')),
('Vaccination', (SELECT category_id FROM hc.categories WHERE category_name='Pediatrics')),
('Growth Monitoring', (SELECT category_id FROM hc.categories WHERE category_name='Pediatrics')),
('Newborn Care', (SELECT category_id FROM hc.categories WHERE category_name='Pediatrics')),

-- Healthcare → Cardiology
('ECG', (SELECT category_id FROM hc.categories WHERE category_name='Cardiology')),
('Heart Consultation', (SELECT category_id FROM hc.categories WHERE category_name='Cardiology')),
('Stress Test', (SELECT category_id FROM hc.categories WHERE category_name='Cardiology')),
('Blood Pressure Monitoring', (SELECT category_id FROM hc.categories WHERE category_name='Cardiology')),

-- Healthcare → Dermatology
('Skin Consultation', (SELECT category_id FROM hc.categories WHERE category_name='Dermatology')),
('Acne Treatment', (SELECT category_id FROM hc.categories WHERE category_name='Dermatology')),
('Allergy Treatment', (SELECT category_id FROM hc.categories WHERE category_name='Dermatology')),
('Hair Loss Treatment', (SELECT category_id FROM hc.categories WHERE category_name='Dermatology')),

-- Laboratory → Blood Tests
('CBC Test', (SELECT category_id FROM hc.categories WHERE category_name='Blood Tests')),
('Blood Sugar Test', (SELECT category_id FROM hc.categories WHERE category_name='Blood Tests')),
('Lipid Profile', (SELECT category_id FROM hc.categories WHERE category_name='Blood Tests')),
('Thyroid Test', (SELECT category_id FROM hc.categories WHERE category_name='Blood Tests')),

-- Laboratory → Urine Tests
('Routine Urine Test', (SELECT category_id FROM hc.categories WHERE category_name='Urine Tests')),
('Urine Culture', (SELECT category_id FROM hc.categories WHERE category_name='Urine Tests')),
('Pregnancy Test', (SELECT category_id FROM hc.categories WHERE category_name='Urine Tests')),
('Protein Test', (SELECT category_id FROM hc.categories WHERE category_name='Urine Tests')),

-- Laboratory → Pathology
('Biopsy Analysis', (SELECT category_id FROM hc.categories WHERE category_name='Pathology')),
('Histopathology', (SELECT category_id FROM hc.categories WHERE category_name='Pathology')),
('Cytology', (SELECT category_id FROM hc.categories WHERE category_name='Pathology')),
('Tissue Examination', (SELECT category_id FROM hc.categories WHERE category_name='Pathology')),

-- Laboratory → Microbiology
('Culture Test', (SELECT category_id FROM hc.categories WHERE category_name='Microbiology')),
('Sensitivity Test', (SELECT category_id FROM hc.categories WHERE category_name='Microbiology')),
('Stool Test', (SELECT category_id FROM hc.categories WHERE category_name='Microbiology')),
('Infection Screening', (SELECT category_id FROM hc.categories WHERE category_name='Microbiology')),

-- Pharmacy → Prescription Medicines
('Antibiotics', (SELECT category_id FROM hc.categories WHERE category_name='Prescription Medicines')),
('Pain Relievers', (SELECT category_id FROM hc.categories WHERE category_name='Prescription Medicines')),
('Chronic Medications', (SELECT category_id FROM hc.categories WHERE category_name='Prescription Medicines')),
('Specialty Drugs', (SELECT category_id FROM hc.categories WHERE category_name='Prescription Medicines')),

-- Pharmacy → Over-the-Counter Drugs
('Cold & Flu Medicines', (SELECT category_id FROM hc.categories WHERE category_name='Over-the-Counter Drugs')),
('Pain Killers', (SELECT category_id FROM hc.categories WHERE category_name='Over-the-Counter Drugs')),
('Antacids', (SELECT category_id FROM hc.categories WHERE category_name='Over-the-Counter Drugs')),
('Allergy Medicines', (SELECT category_id FROM hc.categories WHERE category_name='Over-the-Counter Drugs')),

-- Pharmacy → Medical Supplies
('Bandages', (SELECT category_id FROM hc.categories WHERE category_name='Medical Supplies')),
('Syringes', (SELECT category_id FROM hc.categories WHERE category_name='Medical Supplies')),
('Glucose Meters', (SELECT category_id FROM hc.categories WHERE category_name='Medical Supplies')),
('BP Monitors', (SELECT category_id FROM hc.categories WHERE category_name='Medical Supplies')),

-- Pharmacy → Health Supplements
('Vitamins', (SELECT category_id FROM hc.categories WHERE category_name='Health Supplements')),
('Protein Supplements', (SELECT category_id FROM hc.categories WHERE category_name='Health Supplements')),
('Mineral Supplements', (SELECT category_id FROM hc.categories WHERE category_name='Health Supplements')),
('Herbal Supplements', (SELECT category_id FROM hc.categories WHERE category_name='Health Supplements')),

-- Radiology → X-Ray
('Chest X-Ray', (SELECT category_id FROM hc.categories WHERE category_name='X-Ray')),
('Limb X-Ray', (SELECT category_id FROM hc.categories WHERE category_name='X-Ray')),
('Spine X-Ray', (SELECT category_id FROM hc.categories WHERE category_name='X-Ray')),
('Dental X-Ray', (SELECT category_id FROM hc.categories WHERE category_name='X-Ray')),

-- Radiology → CT Scan
('CT Brain', (SELECT category_id FROM hc.categories WHERE category_name='CT Scan')),
('CT Chest', (SELECT category_id FROM hc.categories WHERE category_name='CT Scan')),
('CT Abdomen', (SELECT category_id FROM hc.categories WHERE category_name='CT Scan')),
('CT Spine', (SELECT category_id FROM hc.categories WHERE category_name='CT Scan')),

-- Radiology → MRI
('MRI Brain', (SELECT category_id FROM hc.categories WHERE category_name='MRI')),
('MRI Knee', (SELECT category_id FROM hc.categories WHERE category_name='MRI')),
('MRI Spine', (SELECT category_id FROM hc.categories WHERE category_name='MRI')),
('MRI Abdomen', (SELECT category_id FROM hc.categories WHERE category_name='MRI')),

-- Radiology → Ultrasound
('Abdominal Ultrasound', (SELECT category_id FROM hc.categories WHERE category_name='Ultrasound')),
('Pelvic Ultrasound', (SELECT category_id FROM hc.categories WHERE category_name='Ultrasound')),
('Pregnancy Scan', (SELECT category_id FROM hc.categories WHERE category_name='Ultrasound')),
('Doppler Scan', (SELECT category_id FROM hc.categories WHERE category_name='Ultrasound'));



select * from hc.roles;
select * from hc.service_types;
select * from hc.categories;
select * from hc.sub_categories;


