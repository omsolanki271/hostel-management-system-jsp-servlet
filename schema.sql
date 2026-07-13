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



