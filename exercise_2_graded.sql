CREATE DATABASE IF NOT EXISTS SmartOldAgeHome;
USE SmartOldAgeHome;

CREATE TABLE IF NOT EXISTS medication_stock (
    medication_id INT PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO medication_stock (medication_id, medication_name, quantity) VALUES
(1, 'Paracetamol', 150),
(2, 'Lisinopril', 75),
(3, 'Metformin', 100),
(4, 'Aspirin', 200),
(5, 'Atorvastatin', 50),
(6, 'Omeprazole', 60),
(7, 'Amoxicillin', 40);

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    doctor_id INT
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS treatments (
    treatment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    nurse_id INT,
    treatment_type VARCHAR(100) NOT NULL,
    treatment_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE IF NOT EXISTS nurses (
    nurse_id INT PRIMARY KEY,
    nurse_name VARCHAR(100) NOT NULL,
    shift VARCHAR(50) NOT NULL
);

INSERT INTO doctors (doctor_id, doctor_name, specialization) VALUES
(1, 'Dr. Smith', 'Cardiology'),
(2, 'Dr. Johnson', 'Neurology'),
(3, 'Dr. Williams', 'Cardiology'),
(4, 'Dr. Brown', 'Orthopedics'),
(5, 'Dr. Davis', 'Geriatrics');

INSERT INTO patients (patient_id, patient_name, age, doctor_id) VALUES
(1, 'John Doe', 75, 1),
(2, 'Jane Smith', 82, 1),
(3, 'Robert Johnson', 78, 2),
(4, 'Mary Williams', 85, 3),
(5, 'James Brown', 72, 3),
(6, 'Patricia Davis', 88, 3),
(7, 'Michael Miller', 69, 4),
(8, 'Linda Wilson', 90, 5),
(9, 'David Moore', 76, 1),
(10, 'Barbara Taylor', 81, 2),
(11, 'Richard Anderson', 70, 4),
(12, 'Susan Thomas', 83, 5),
(13, 'Joseph Jackson', 77, 1),
(14, 'Jessica White', 68, 2),
(15, 'Thomas Harris', 84, 3);

INSERT INTO nurses (nurse_id, nurse_name, shift) VALUES
(1, 'Nurse Adams', 'morning'),
(2, 'Nurse Baker', 'afternoon'),
(3, 'Nurse Clark', 'morning'),
(4, 'Nurse Davis', 'night');

INSERT INTO treatments (treatment_id, patient_id, doctor_id, nurse_id, treatment_type, treatment_date) VALUES
(1, 1, 1, 1, 'Consultation', '2023-01-15'),
(2, 2, 1, 1, 'Medication', '2023-01-16'),
(3, 3, 2, 2, 'Consultation', '2023-01-17'),
(4, 4, 3, 3, 'Checkup', '2023-01-18'),
(5, 5, 3, 3, 'Medication', '2023-01-19'),
(6, 6, 3, 1, 'Consultation', '2023-01-20'),
(7, 7, 4, 2, 'Checkup', '2023-01-21'),
(8, 8, 5, 4, 'Medication', '2023-01-22'),
(9, 9, 1, 1, 'Checkup', '2023-01-23'),
(10, 10, 2, 2, 'Consultation', '2023-01-24'),
(11, 11, 4, 3, 'Medication', '2023-01-25'),
(12, 12, 5, 4, 'Checkup', '2023-01-26'),
(13, 13, 1, 1, 'Consultation', '2023-01-27'),
(14, 1, 1, 3, 'Checkup', '2023-02-01'),
(15, 4, 3, 1, 'Medication', '2023-02-02');

SELECT patient_name, age 
FROM patients;

SELECT doctor_name 
FROM doctors 
WHERE specialization = 'Cardiology';

SELECT patient_name, age 
FROM patients 
WHERE age > 80;

SELECT patient_name, age 
FROM patients 
ORDER BY age ASC;

SELECT specialization, COUNT(doctor_id) AS doctor_count 
FROM doctors 
GROUP BY specialization;

SELECT p.patient_name, d.doctor_name 
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

SELECT t.treatment_id, t.treatment_type, t.treatment_date,
       p.patient_name, d.doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON t.doctor_id = d.doctor_id;

SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name;

SELECT AVG(age) AS average_age 
FROM patients;

SELECT treatment_type, COUNT(treatment_type) AS treatment_count
FROM treatments
GROUP BY treatment_type
HAVING COUNT(treatment_type) = (
    SELECT MAX(count) 
    FROM (SELECT COUNT(treatment_type) AS count 
          FROM treatments 
          GROUP BY treatment_type) AS subquery
);

SELECT patient_name, age
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(p.patient_id) > 5;

SELECT t.treatment_id, t.treatment_type, p.patient_name, n.nurse_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN nurses n ON t.nurse_id = n.nurse_id
WHERE n.shift = 'morning';

SELECT p.patient_name, t.treatment_type, t.treatment_date
FROM patients p
JOIN (
    SELECT patient_id, MAX(treatment_date) AS latest_date
    FROM treatments
    GROUP BY patient_id
) AS latest_t ON p.patient_id = latest_t.patient_id
JOIN treatments t ON latest_t.patient_id = t.patient_id 
                  AND latest_t.latest_date = t.treatment_date;

SELECT d.doctor_name, AVG(p.age) AS average_patient_age
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name;

SELECT d.doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.doctor_name
HAVING COUNT(p.patient_id) > 3;

SELECT patient_name
FROM patients
WHERE patient_id NOT IN (
    SELECT DISTINCT patient_id 
    FROM treatments
);

SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

SELECT 
    d.doctor_name,
    p.patient_name,
    p.age,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
ORDER BY d.doctor_name, age_rank;

WITH patient_max_age AS (
    SELECT 
        d.specialization,
        p.doctor_id,
        MAX(p.age) AS max_age
    FROM patients p
    JOIN doctors d ON p.doctor_id = d.doctor_id
    GROUP BY d.specialization, p.doctor_id
),
specialization_max_age AS (
    SELECT 
        specialization,
        MAX(max_age) AS overall_max_age
    FROM patient_max_age
    GROUP BY specialization
)
SELECT 
    pma.specialization,
    d.doctor_name,
    pma.max_age AS oldest_patient_age
FROM patient_max_age pma
JOIN specialization_max_age sma 
    ON pma.specialization = sma.specialization 
    AND pma.max_age = sma.overall_max_age
JOIN doctors d ON pma.doctor_id = d.doctor_id;
