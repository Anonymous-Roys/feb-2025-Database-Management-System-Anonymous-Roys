-- Hospital Management System Database
-- Author: Arhin David
-- Last Updated: May 2025
-- Description: Comprehensive database for hospital operations

-- Disable foreign key checks to allow dropping tables
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Patient_Treatment;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Medical_Record;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Insurance_Provider;

-- Create Address Table (Shared Address Management)
CREATE TABLE Address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Create Insurance Provider Table
CREATE TABLE Insurance_Provider (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_name VARCHAR(255) NOT NULL UNIQUE,
    contact_number VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255)
) ENGINE=InnoDB;

-- Create Department Table
CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL UNIQUE,
    department_head VARCHAR(255),
    contact_number VARCHAR(20)
) ENGINE=InnoDB;

-- Create Staff Table (includes Doctors and Other Staff)
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    address_id INT,
    department_id INT,
    role ENUM('Doctor', 'Nurse', 'Administrator', 'Technician', 'Support Staff') NOT NULL,
    employment_status ENUM('Full-Time', 'Part-Time', 'Contract') NOT NULL,
    FOREIGN KEY (address_id) REFERENCES Address(address_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
) ENGINE=InnoDB;

-- Create Doctor Table (Specialized Doctor Information)
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    specialization VARCHAR(255) NOT NULL,
    medical_license_number VARCHAR(50) UNIQUE NOT NULL,
    board_certification VARCHAR(255),
    consultation_fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Staff(staff_id)
) ENGINE=InnoDB;

-- Create Patient Table
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    address_id INT,
    insurance_provider_id INT,
    insurance_policy_number VARCHAR(50),
    emergency_contact_name VARCHAR(255),
    emergency_contact_number VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES Address(address_id),
    FOREIGN KEY (insurance_provider_id) REFERENCES Insurance_Provider(provider_id)
) ENGINE=InnoDB;

-- Create Medical Record Table
CREATE TABLE Medical_Record (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    record_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diagnosis TEXT NOT NULL,
    symptoms TEXT,
    notes TEXT,
    status ENUM('Active', 'Resolved', 'Chronic') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
) ENGINE=InnoDB;

-- Create Appointment Table
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    appointment_type ENUM('Regular Checkup', 'Emergency', 'Follow-up', 'Consultation') NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'Rescheduled') NOT NULL DEFAULT 'Scheduled',
    reason_for_visit TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    UNIQUE KEY unique_appointment (patient_id, doctor_id, appointment_date)
) ENGINE=InnoDB;

-- Create Treatment Table
CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    estimated_cost DECIMAL(10,2) NOT NULL,
    estimated_duration INT COMMENT 'Duration in minutes',
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
) ENGINE=InnoDB;

-- Create Patient_Treatment Linking Table (Many-to-Many Relationship)
CREATE TABLE Patient_Treatment (
    patient_treatment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    treatment_id INT NOT NULL,
    doctor_id INT NOT NULL,
    treatment_date DATETIME NOT NULL,
    notes TEXT,
    status ENUM('Ongoing', 'Completed', 'Discontinued') NOT NULL DEFAULT 'Ongoing',
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatment(treatment_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
) ENGINE=InnoDB;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Indexing for Performance
CREATE INDEX idx_patient_name ON Patient(first_name, last_name);
CREATE INDEX idx_doctor_specialization ON Doctor(specialization);
CREATE INDEX idx_appointment_date ON Appointment(appointment_date);
CREATE INDEX idx_medical_record_date ON Medical_Record(record_date);

-- Sample Data Insertion (Optional)
-- Departments
INSERT INTO Department (department_name, department_head) VALUES 
('Cardiology', 'Dr. Emily Rodriguez'),
('Neurology', 'Dr. Michael Chen'),
('Pediatrics', 'Dr. Sarah Thompson'),
('Emergency', 'Dr. David Kim');

-- Insurance Providers
INSERT INTO Insurance_Provider (provider_name, contact_number, email) VALUES
('Global Health Insurance', '+1-800-INSURANCE', 'support@globalhealth.com'),
('MediCare Plus', '+1-888-MEDICARE', 'contact@medicareplus.org');

-- Address
INSERT INTO Address (street_address, city, state, postal_code, country) VALUES
('123 Medical Lane', 'Healthville', 'CA', '90210', 'United States'),
('456 Wellness Road', 'Wellnessboro', 'NY', '10001', 'United States');

-- Staff (with Doctors)
INSERT INTO Staff (first_name, last_name, gender, date_of_birth, email, phone_number, hire_date, salary, department_id, role, employment_status) VALUES
('Emily', 'Rodriguez', 'Female', '1980-05-15', 'emily.rodriguez@hospital.com', '+1-555-1234', '2010-01-15', 250000.00, 1, 'Doctor', 'Full-Time'),
('Michael', 'Chen', 'Male', '1975-08-22', 'michael.chen@hospital.com', '+1-555-5678', '2012-03-20', 240000.00, 2, 'Doctor', 'Full-Time');

-- Doctors
INSERT INTO Doctor (doctor_id, specialization, medical_license_number, board_certification, consultation_fee) VALUES
(1, 'Cardiology', 'MCL-12345', 'American Board of Cardiology', 300.00),
(2, 'Neurology', 'MCL-67890', 'American Board of Neurology', 350.00);

-- Patients
INSERT INTO Patient (first_name, last_name, gender, date_of_birth, blood_group, email, phone_number, insurance_provider_id, insurance_policy_number) VALUES
('John', 'Doe', 'Male', '1975-03-15', 'A+', 'john.doe@email.com', '+1-555-9876', 1, 'GH-POL-54321'),
('Jane', 'Smith', 'Female', '1985-07-22', 'B-', 'jane.smith@email.com', '+1-555-5432', 2, 'MP-POL-98765');

-- Treatments
INSERT INTO Treatment (name, description, estimated_cost, department_id) VALUES
('Cardiac Stress Test', 'Comprehensive heart health evaluation', 500.00, 1),
('MRI Brain Scan', 'Detailed neurological imaging', 1200.00, 2);