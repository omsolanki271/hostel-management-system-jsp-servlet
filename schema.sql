-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS hostel;
USE hostel;

-- 1. Table structure for table `admin`
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(300) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updation_date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_unique` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Seed default admin credentials (plain text: admin / admin123)
INSERT INTO `admin` (`username`, `email`, `password`) 
VALUES ('admin', 'admin@hostel.com', 'admin123')
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`), `password` = VALUES(`password`);

-- 2. Table structure for table `userregistration`
DROP TABLE IF EXISTS `userregistration`;
CREATE TABLE `userregistration` (
  `id` int NOT NULL AUTO_INCREMENT,
  `regNo` varchar(255) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `middleName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `contactNo` bigint NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `regDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updationDate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regNo_unique` (`regNo`),
  UNIQUE KEY `email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3. Table structure for table `rooms`
CREATE TABLE IF NOT EXISTS `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seater` int NOT NULL,
  `room_no` int NOT NULL,
  `fees` int NOT NULL,
  `posting_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_no_unique` (`room_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table structure for table `courses`
CREATE TABLE IF NOT EXISTS `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_code` varchar(255) NOT NULL,
  `course_sn` varchar(255) NOT NULL,
  `course_fn` varchar(255) NOT NULL,
  `posting_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_code_unique` (`course_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Table structure for table `states`
CREATE TABLE IF NOT EXISTS `states` (
  `id` int NOT NULL AUTO_INCREMENT,
  `State` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `state_unique` (`State`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed default states & courses for registration dropdowns
INSERT IGNORE INTO `states` (`State`) VALUES 
('Andhra Pradesh'), ('Arunachal Pradesh'), ('Assam'), ('Bihar'), ('Chhattisgarh'), 
('Goa'), ('Gujarat'), ('Haryana'), ('Himachal Pradesh'), ('Jharkhand'), ('Karnataka'), 
('Kerala'), ('Madhya Pradesh'), ('Maharashtra'), ('Manipur'), ('Meghalaya'), ('Mizoram'), 
('Nagaland'), ('Odisha'), ('Punjab'), ('Rajasthan'), ('Sikkim'), ('Tamil Nadu'), 
('Telangana'), ('Tripura'), ('Uttar Pradesh'), ('Uttarakhand'), ('West Bengal');

INSERT IGNORE INTO `courses` (`course_code`, `course_sn`, `course_fn`) VALUES 
('BCA101', 'BCA', 'Bachelor of Computer Applications'),
('MCA201', 'MCA', 'Master of Computer Applications'),
('BTECH301', 'B.Tech', 'Bachelor of Technology');

-- 6. Table structure for table `registration`
CREATE TABLE IF NOT EXISTS `registration` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomno` int NOT NULL,
  `seater` int NOT NULL,
  `feespm` int NOT NULL,
  `foodstatus` int NOT NULL,
  `stayfrom` varchar(255) NOT NULL,
  `duration` int NOT NULL,
  `course` varchar(255) NOT NULL,
  `regno` varchar(255) NOT NULL,
  `firstName` varchar(255) NOT NULL,
  `middleName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `contactno` varchar(255) NOT NULL,
  `emailid` varchar(255) NOT NULL,
  `egycontactno` varchar(255) NOT NULL,
  `guardianName` varchar(255) NOT NULL,
  `guardianRelation` varchar(255) NOT NULL,
  `guardianContactno` varchar(255) NOT NULL,
  `corresAddress` text NOT NULL,
  `corresCIty` varchar(255) NOT NULL,
  `corresState` varchar(255) NOT NULL,
  `corresPincode` int NOT NULL,
  `pmntAddress` text NOT NULL,
  `pmntCity` varchar(255) NOT NULL,
  `pmnatetState` varchar(255) NOT NULL,
  `pmntPincode` int NOT NULL,
  `postingDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regno_unique` (`regno`),
  UNIQUE KEY `emailid_unique` (`emailid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Table structure for table `complaints`
CREATE TABLE IF NOT EXISTS `complaints` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ComplainNumber` int NOT NULL,
  `userId` int NOT NULL,
  `complaintType` varchar(255) NOT NULL,
  `complaintDetails` text NOT NULL,
  `complaintDoc` varchar(255) DEFAULT NULL,
  `complaintStatus` varchar(255) DEFAULT NULL,
  `registrationDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Table structure for table `complainthistory`
CREATE TABLE IF NOT EXISTS `complainthistory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `complaintid` int NOT NULL,
  `compalintStatus` varchar(255) NOT NULL,
  `complaintRemark` text NOT NULL,
  `postingDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Table structure for table `leave_applications`
CREATE TABLE IF NOT EXISTS `leave_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `reason` text NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'Pending',
  `remarks` text DEFAULT NULL,
  `applied_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;





/*
===========================================================
Project Name : Hostel Management System
Technology   : Java, JSP, Servlet, JDBC, MySQL
Database     : MySQL
Author       : Om Solanki
Description  : Database schema for Hostel Management System
===========================================================
*/

SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS hostel;
CREATE DATABASE hostel;
USE hostel;

-- =========================================================
-- TABLE : admin
-- =========================================================

DROP TABLE IF EXISTS admin;

CREATE TABLE admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updation_date TIMESTAMP NULL DEFAULT NULL
);

INSERT INTO admin(username,email,password)
VALUES
('admin','admin@hostel.com','admin123');

-- =========================================================
-- TABLE : userregistration
-- =========================================================

DROP TABLE IF EXISTS userregistration;

CREATE TABLE userregistration (

    id INT AUTO_INCREMENT PRIMARY KEY,

    regNo VARCHAR(20) NOT NULL UNIQUE,

    firstName VARCHAR(50) NOT NULL,

    middleName VARCHAR(50),

    lastName VARCHAR(50) NOT NULL,

    gender VARCHAR(10) NOT NULL,

    contactNo VARCHAR(15) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    password VARCHAR(100) NOT NULL,

    regDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updationDate TIMESTAMP NULL DEFAULT NULL,

    passUdateDate TIMESTAMP NULL DEFAULT NULL

);

CREATE INDEX idx_student_email
ON userregistration(email);

CREATE INDEX idx_student_regno
ON userregistration(regNo);

-- =========================================================
-- TABLE : rooms
-- =========================================================

DROP TABLE IF EXISTS rooms;

CREATE TABLE rooms(

    id INT AUTO_INCREMENT PRIMARY KEY,

    seater INT NOT NULL,

    room_no INT NOT NULL UNIQUE,

    fees INT NOT NULL,

    posting_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

INSERT INTO rooms(seater,room_no,fees)
VALUES
(2,201,6000),
(2,202,6000),
(3,301,4500),
(3,302,4500),
(4,401,3500);

-- =========================================================
-- TABLE : courses
-- =========================================================

DROP TABLE IF EXISTS courses;

CREATE TABLE courses(

    id INT AUTO_INCREMENT PRIMARY KEY,

    course_code VARCHAR(20) UNIQUE,

    course_sn VARCHAR(50),

    course_fn VARCHAR(100),

    posting_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

INSERT INTO courses(course_code,course_sn,course_fn)
VALUES

('BCA101','BCA','Bachelor of Computer Applications'),

('MCA201','MCA','Master of Computer Applications'),

('BTECH301','B.Tech','Bachelor of Technology'),

('MBA401','MBA','Master of Business Administration'),

('BCOM501','B.Com','Bachelor of Commerce');

-- =========================================================
-- TABLE : states
-- =========================================================

DROP TABLE IF EXISTS states;

CREATE TABLE states(

    id INT AUTO_INCREMENT PRIMARY KEY,

    State VARCHAR(50) UNIQUE

);

INSERT INTO states(State) VALUES
('Andhra Pradesh'),
('Arunachal Pradesh'),
('Assam'),
('Bihar'),
('Chhattisgarh'),
('Goa'),
('Gujarat'),
('Haryana'),
('Himachal Pradesh'),
('Jharkhand'),
('Karnataka'),
('Kerala'),
('Madhya Pradesh'),
('Maharashtra'),
('Manipur'),
('Meghalaya'),
('Mizoram'),
('Nagaland'),
('Odisha'),
('Punjab'),
('Rajasthan'),
('Sikkim'),
('Tamil Nadu'),
('Telangana'),
('Tripura'),
('Uttar Pradesh'),
('Uttarakhand'),
('West Bengal');


-- =========================================================
-- TABLE : registration
-- =========================================================

DROP TABLE IF EXISTS registration;

CREATE TABLE registration (

    id INT AUTO_INCREMENT PRIMARY KEY,

    roomno INT NOT NULL,

    seater INT NOT NULL,

    feespm INT NOT NULL,

    foodstatus INT NOT NULL,

    stayfrom DATE NOT NULL,

    duration INT NOT NULL,

    course VARCHAR(100) NOT NULL,

    regno VARCHAR(20) NOT NULL,

    firstName VARCHAR(50) NOT NULL,

    middleName VARCHAR(50),

    lastName VARCHAR(50) NOT NULL,

    gender VARCHAR(10) NOT NULL,

    contactno VARCHAR(15) NOT NULL,

    emailid VARCHAR(100) NOT NULL,

    egycontactno VARCHAR(15) NOT NULL,

    guardianName VARCHAR(100) NOT NULL,

    guardianRelation VARCHAR(50) NOT NULL,

    guardianContactno VARCHAR(15) NOT NULL,

    corresAddress TEXT NOT NULL,

    corresCIty VARCHAR(50) NOT NULL,

    corresState VARCHAR(50) NOT NULL,

    corresPincode INT NOT NULL,

    pmntAddress TEXT NOT NULL,

    pmntCity VARCHAR(50) NOT NULL,

    pmnatetState VARCHAR(50) NOT NULL,

    pmntPincode INT NOT NULL,

    postingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updationDate TIMESTAMP NULL DEFAULT NULL,

    UNIQUE KEY uq_registration_regno(regno),

    UNIQUE KEY uq_registration_email(emailid),

    CONSTRAINT fk_registration_user
        FOREIGN KEY (regno)
        REFERENCES userregistration(regNo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_registration_room
        FOREIGN KEY (roomno)
        REFERENCES rooms(room_no)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

CREATE INDEX idx_registration_room
ON registration(roomno);

CREATE INDEX idx_registration_email
ON registration(emailid);

-- =========================================================
-- TABLE : complaints
-- =========================================================

DROP TABLE IF EXISTS complaints;

CREATE TABLE complaints (

    id INT AUTO_INCREMENT PRIMARY KEY,

    ComplainNumber BIGINT NOT NULL,

    userId INT NOT NULL,

    complaintType VARCHAR(100) NOT NULL,

    complaintDetails TEXT NOT NULL,

    complaintDoc VARCHAR(255),

    complaintStatus VARCHAR(30) DEFAULT 'Pending',

    registrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_complaint_number(ComplainNumber),

    CONSTRAINT fk_complaint_user

        FOREIGN KEY(userId)

        REFERENCES userregistration(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

);

CREATE INDEX idx_complaint_user
ON complaints(userId);

CREATE INDEX idx_complaint_status
ON complaints(complaintStatus);

-- =========================================================
-- TABLE : complainthistory
-- =========================================================

DROP TABLE IF EXISTS complainthistory;

CREATE TABLE complainthistory (

    id INT AUTO_INCREMENT PRIMARY KEY,

    complaintid INT NOT NULL,

    compalintStatus VARCHAR(30) NOT NULL,

    complaintRemark TEXT NOT NULL,

    postingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_history_complaint

        FOREIGN KEY (complaintid)

        REFERENCES complaints(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

);

CREATE INDEX idx_history_complaint
ON complainthistory(complaintid);

-- =========================================================
-- TABLE : leave_applications
-- =========================================================

DROP TABLE IF EXISTS leave_applications;

CREATE TABLE leave_applications (

    id INT AUTO_INCREMENT PRIMARY KEY,

    student_id INT NOT NULL,

    from_date DATE NOT NULL,

    to_date DATE NOT NULL,

    reason TEXT NOT NULL,

    status VARCHAR(30) DEFAULT 'Pending',

    remarks TEXT,

    applied_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_leave_student

        FOREIGN KEY(student_id)

        REFERENCES userregistration(id)

        ON UPDATE CASCADE

        ON DELETE CASCADE

);

CREATE INDEX idx_leave_student
ON leave_applications(student_id);

CREATE INDEX idx_leave_status
ON leave_applications(status);
-- =========================================================
-- SAMPLE STUDENTS
-- =========================================================

INSERT INTO userregistration
(regNo, firstName, middleName, lastName, gender, contactNo, email, password)
VALUES

('101','Raj','Kumar','Patel','Male','9876543210','raj@gmail.com','123'),

('102','Priya','R','Shah','Female','9876543211','priya@gmail.com','123'),

('103','Amit','K','Joshi','Male','9876543212','amit@gmail.com','123');

-- =========================================================
-- SAMPLE ROOM REGISTRATIONS
-- =========================================================

INSERT INTO registration
(

roomno,
seater,
feespm,
foodstatus,
stayfrom,
duration,
course,
regno,
firstName,
middleName,
lastName,
gender,
contactno,
emailid,
egycontactno,
guardianName,
guardianRelation,
guardianContactno,
corresAddress,
corresCIty,
corresState,
corresPincode,
pmntAddress,
pmntCity,
pmnatetState,
pmntPincode

)

VALUES

(

201,
2,
6000,
1,
'2026-01-01',
12,
'Bachelor of Computer Applications',
'101',
'Raj',
'Kumar',
'Patel',
'Male',
'9876543210',
'raj@gmail.com',
'9898989898',
'Arvind Patel',
'Father',
'9898989800',
'Ahmedabad',
'Ahmedabad',
'Gujarat',
380001,
'Ahmedabad',
'Ahmedabad',
'Gujarat',
380001

),

(

301,
3,
4500,
0,
'2026-01-05',
12,
'Master of Computer Applications',
'102',
'Priya',
'R',
'Shah',
'Female',
'9876543211',
'priya@gmail.com',
'9898989801',
'Mahesh Shah',
'Father',
'9898989802',
'Surat',
'Surat',
'Gujarat',
395001,
'Surat',
'Surat',
'Gujarat',
395001

);

-- =========================================================
-- SAMPLE COMPLAINTS
-- =========================================================

INSERT INTO complaints
(

ComplainNumber,
userId,
complaintType,
complaintDetails,
complaintStatus

)

VALUES

(

100001,
1,
'Electrical',
'Tube light is not working.',
'Pending'

),

(

100002,
2,
'Room',
'Fan is making noise.',
'In Process'

),

(

100003,
3,
'Food',
'Food quality needs improvement.',
'Closed'

);

-- =========================================================
-- SAMPLE COMPLAINT HISTORY
-- =========================================================

INSERT INTO complainthistory
(

complaintid,
compalintStatus,
complaintRemark

)

VALUES

(

2,
'In Process',
'Electrician assigned.'

),

(

3,
'Closed',
'Complaint resolved successfully.'

);

-- =========================================================
-- SAMPLE LEAVE APPLICATIONS
-- =========================================================

INSERT INTO leave_applications
(

student_id,
from_date,
to_date,
reason,
status,
remarks

)

VALUES

(

1,
'2026-02-10',
'2026-02-15',
'Going home for family function.',
'Approved',
'Approved by Admin'

),

(

2,
'2026-03-01',
'2026-03-03',
'Medical Leave',
'Pending',
NULL

),

(

3,
'2026-03-15',
'2026-03-18',
'Festival Vacation',
'Rejected',
'Not enough attendance.'

);

-- =========================================================
-- DATABASE SETUP COMPLETED
-- =========================================================

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;

-- =========================================================
-- Hostel Management System Database Created Successfully
-- =========================================================