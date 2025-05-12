# 🏥 Hospital Management System Database

## Overview
A comprehensive MySQL database solution for managing hospital operations, designed to handle complex healthcare management scenarios.

## 🌟 Key Features
- Robust database schema for hospital management
- Multiple interconnected tables
- Comprehensive data modeling
- Supports various hospital operations

## 📊 Database Schema

### Tables Included
1. **Address**: Centralized address management
2. **Insurance_Provider**: Insurance company details
3. **Department**: Hospital departments
4. **Staff**: All staff members
5. **Doctor**: Specialized doctor information
6. **Patient**: Patient personal and medical details
7. **Medical_Record**: Patient medical history
8. **Appointment**: Patient-doctor appointment tracking
9. **Treatment**: Available medical treatments
10. **Patient_Treatment**: Treatment-patient relationships

### Entity Relationships
- One-to-Many: 
  - One Department can have multiple Staff
  - One Patient can have multiple Appointments
  - One Doctor can have multiple Medical Records
- Many-to-Many: 
  - Patients can have multiple Treatments
  - Treatments can be associated with multiple Patients

## 🔑 Key Design Principles
- Normalization to reduce data redundancy
- Comprehensive foreign key constraints
- Performance-optimized indexing
- Flexible schema design

## 📝 Database Constraints
- Enforced data integrity
- Unique constraints on critical fields
- Enumerated fields for standardized data entry
- Default and automatic timestamp management

## 🚀 Setup and Installation

### Prerequisites
- MySQL Server (version 8.0+)
- MySQL Workbench or similar SQL management tool

### Installation Steps
1. Clone the repository
2. Open the SQL script in MySQL Workbench
3. Execute the entire script to create the database

```bash
git clone https://github.com/Anonymous-Roys/feb-2025-Database-Management-System-Anonymous-Roys.git
mysql -u username -p < hospital_management_system.sql
```

## 🗂️ Sample Queries

### Sample Query 1: Get all appointments for a specific patient
```sql
SELECT p.first_name, p.last_name, a.appointment_date, d.specialization
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id
WHERE p.patient_id = 1;
```

### Sample Query 2: Find doctors in a specific department
```sql
SELECT s.first_name, s.last_name, d.specialization
FROM Staff s
JOIN Doctor d ON s.staff_id = d.doctor_id
JOIN Department dept ON s.department_id = dept.department_id
WHERE dept.department_name = 'Cardiology';
```

## 📋 ERD (Entity Relationship Diagram)
[\[Link to ERD or Diagram Image\]](https://www.mermaidchart.com/raw/2443bcbe-67f6-4f97-8e31-bae285654754?theme=dark&version=v0.1&format=svg)

## 🛡️ Security Considerations
- Use parameterized queries
- Implement proper access controls
- Regularly update and patch MySQL

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request


## 🔍 Future Improvements
- Implement stored procedures
- Add more complex queries
- Enhance data validation
- Create backup and recovery scripts

---
