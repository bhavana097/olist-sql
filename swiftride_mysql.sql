-- SwiftRide database — MySQL import script
-- Converted from SQLite (swiftride.db)
-- Generated 2026-07-02 07:28

CREATE DATABASE IF NOT EXISTS swiftride
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE swiftride;

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

DROP TABLE IF EXISTS `fact_trips`;
DROP TABLE IF EXISTS `fact_driver_shifts`;
DROP TABLE IF EXISTS `dim_rider`;
DROP TABLE IF EXISTS `dim_driver`;
DROP TABLE IF EXISTS `dim_date`;
DROP TABLE IF EXISTS `dim_city`;

CREATE TABLE `dim_city` (
  `city_id` VARCHAR(50) NOT NULL,
  `city_name` VARCHAR(100),
  `region` VARCHAR(100),
  `market_size` VARCHAR(50),
  `launch_date` DATE,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_date` (
  `full_date` DATE NOT NULL,
  `day_name` VARCHAR(20),
  `day_of_week` INT,
  `is_weekend` TINYINT(1),
  `month_name` VARCHAR(20),
  `month_num` INT,
  `year` INT,
  PRIMARY KEY (`full_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_driver` (
  `driver_id` VARCHAR(50) NOT NULL,
  `driver_name` VARCHAR(100),
  `gender` VARCHAR(20),
  `home_city_id` VARCHAR(50),
  `vehicle_type` VARCHAR(50),
  `join_date` DATE,
  `driver_rating` DECIMAL(3,2),
  `is_active` TINYINT(1),
  PRIMARY KEY (`driver_id`),
  KEY `idx_dim_driver_home_city_id` (`home_city_id`),
  CONSTRAINT `fk_dim_driver_home_city_id` FOREIGN KEY (`home_city_id`) REFERENCES `dim_city` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dim_rider` (
  `rider_id` VARCHAR(50) NOT NULL,
  `rider_name` VARCHAR(100),
  `gender` VARCHAR(20),
  `home_city_id` VARCHAR(50),
  `signup_date` DATE,
  `membership_tier` VARCHAR(50),
  `is_active` TINYINT(1),
  PRIMARY KEY (`rider_id`),
  KEY `idx_dim_rider_home_city_id` (`home_city_id`),
  CONSTRAINT `fk_dim_rider_home_city_id` FOREIGN KEY (`home_city_id`) REFERENCES `dim_city` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fact_driver_shifts` (
  `shift_id` VARCHAR(50) NOT NULL,
  `shift_date` DATE,
  `driver_id` VARCHAR(50),
  `city_id` VARCHAR(50),
  `city_name` VARCHAR(100),
  `online_hours` DECIMAL(6,2),
  `trips_accepted` INT,
  `trips_rejected` INT,
  `total_earnings` DECIMAL(10,2),
  `is_weekend` TINYINT(1),
  PRIMARY KEY (`shift_id`),
  KEY `idx_fact_driver_shifts_driver_id` (`driver_id`),
  KEY `idx_fact_driver_shifts_city_id` (`city_id`),
  CONSTRAINT `fk_fact_driver_shifts_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `dim_driver` (`driver_id`),
  CONSTRAINT `fk_fact_driver_shifts_city_id` FOREIGN KEY (`city_id`) REFERENCES `dim_city` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fact_trips` (
  `trip_id` VARCHAR(50) NOT NULL,
  `trip_date` DATE,
  `day_name` VARCHAR(20),
  `is_weekend` TINYINT(1),
  `rider_id` VARCHAR(50),
  `driver_id` VARCHAR(50),
  `city_id` VARCHAR(50),
  `city_name` VARCHAR(100),
  `vehicle_type` VARCHAR(50),
  `trip_status` VARCHAR(50),
  `payment_method` VARCHAR(50),
  `request_hour` INT,
  `distance_miles` DECIMAL(8,2),
  `duration_min` INT,
  `wait_time_min` DECIMAL(6,2),
  `surge_multiplier` DECIMAL(4,2),
  `fare_amount` DECIMAL(10,2),
  `rating_given` INT,
  PRIMARY KEY (`trip_id`),
  KEY `idx_fact_trips_rider_id` (`rider_id`),
  KEY `idx_fact_trips_driver_id` (`driver_id`),
  KEY `idx_fact_trips_city_id` (`city_id`),
  CONSTRAINT `fk_fact_trips_rider_id` FOREIGN KEY (`rider_id`) REFERENCES `dim_rider` (`rider_id`),
  CONSTRAINT `fk_fact_trips_driver_id` FOREIGN KEY (`driver_id`) REFERENCES `dim_driver` (`driver_id`),
  CONSTRAINT `fk_fact_trips_city_id` FOREIGN KEY (`city_id`) REFERENCES `dim_city` (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for `dim_city` (6 rows)
INSERT INTO `dim_city` (`city_id`,`city_name`,`region`,`market_size`,`launch_date`) VALUES
('C01','Austin','South','Large','2019-03-01'),
('C02','Denver','West','Large','2019-08-15'),
('C03','Columbus','Midwest','Mid','2020-06-10'),
('C04','Portland','West','Mid','2021-01-20'),
('C05','Nashville','South','Small','2022-04-05'),
('C06','Providence','Northeast','Small','2022-09-12');

-- Data for `dim_date` (14 rows)
INSERT INTO `dim_date` (`full_date`,`day_name`,`day_of_week`,`is_weekend`,`month_name`,`month_num`,`year`) VALUES
('2024-05-13','Monday',1,0,'May',5,2024),
('2024-05-14','Tuesday',2,0,'May',5,2024),
('2024-05-15','Wednesday',3,0,'May',5,2024),
('2024-05-16','Thursday',4,0,'May',5,2024),
('2024-05-17','Friday',5,0,'May',5,2024),
('2024-05-18','Saturday',6,1,'May',5,2024),
('2024-05-19','Sunday',7,1,'May',5,2024),
('2024-05-20','Monday',1,0,'May',5,2024),
('2024-05-21','Tuesday',2,0,'May',5,2024),
('2024-05-22','Wednesday',3,0,'May',5,2024),
('2024-05-23','Thursday',4,0,'May',5,2024),
('2024-05-24','Friday',5,0,'May',5,2024),
('2024-05-25','Saturday',6,1,'May',5,2024),
('2024-05-26','Sunday',7,1,'May',5,2024);

-- Data for `dim_driver` (15 rows)
INSERT INTO `dim_driver` (`driver_id`,`driver_name`,`gender`,`home_city_id`,`vehicle_type`,`join_date`,`driver_rating`,`is_active`) VALUES
('D001','James Smith','M','C03','Premium','2022-03-19',4.65,0),
('D002','Mary Williams','F','C05','Standard','2023-04-08',4.15,1),
('D003','Robert Johnson','M','C01','Standard','2022-05-06',4.16,0),
('D004','Jennifer Jones','F','C04','Standard','2023-03-04',4.21,1),
('D005','Michael Brown','M','C06','Comfort','2020-05-06',4.59,1),
('D006','Linda Garcia','F','C02','Standard','2020-09-29',4.35,0),
('D007','David Miller','M','C01','Comfort','2023-02-21',4.79,1),
('D008','Sarah Martinez','F','C05','Comfort','2021-01-19',4.42,1),
('D009','Chris Davis','M','C01','Comfort','2023-06-21',4.28,1),
('D010','Emily Clark','F','C04','XL','2022-08-11',4.6,1),
('D011','Daniel Wilson','M','C03','Standard','2021-01-03',4.69,1),
('D012','Jessica Lewis','F','C05','Standard','2022-10-10',4.84,1),
('D013','Kevin Moore','M','C03','Comfort','2020-05-29',4.2,1),
('D014','Ashley Walker','F','C03','Standard','2022-09-28',4.46,1),
('D015','Brian Taylor','M','C01','XL','2023-03-19',4.77,1);

-- Data for `dim_rider` (20 rows)
INSERT INTO `dim_rider` (`rider_id`,`rider_name`,`gender`,`home_city_id`,`signup_date`,`membership_tier`,`is_active`) VALUES
('R001','John Anderson','M','C03','2022-12-19','Plus',1),
('R002','Patricia Thomas','F','C04','2021-05-21','Premium',1),
('R003','William Jackson','M','C04','2021-05-14','Basic',1),
('R004','Barbara White','F','C06','2023-07-02','Basic',1),
('R005','Richard Harris','M','C06','2022-12-12','Basic',1),
('R006','Susan Martin','F','C02','2021-08-28','Basic',1),
('R007','Joseph Thompson','M','C03','2021-09-22','Plus',1),
('R008','Karen Young','F','C04','2021-06-15','Basic',1),
('R009','Thomas Allen','M','C03','2021-10-08','Premium',1),
('R010','Nancy King','F','C03','2023-05-01','Premium',1),
('R011','Charles Wright','M','C04','2022-04-18','Basic',1),
('R012','Lisa Scott','F','C02','2022-04-23','Basic',1),
('R013','Mark Green','M','C02','2022-06-23','Basic',1),
('R014','Betty Adams','F','C05','2023-01-27','Plus',1),
('R015','Steven Baker','M','C02','2023-11-22','Premium',1),
('R016','Sandra Nelson','F','C06','2021-04-21','Basic',1),
('R017','Paul Carter','M','C06','2023-03-15','Basic',1),
('R018','Ashley Mitchell','F','C04','2023-04-01','Basic',0),
('R019','Andrew Perez','M','C02','2023-06-22','Basic',1),
('R020','Donna Roberts','F','C01','2021-07-29','Basic',1);

-- Data for `fact_driver_shifts` (40 rows)
INSERT INTO `fact_driver_shifts` (`shift_id`,`shift_date`,`driver_id`,`city_id`,`city_name`,`online_hours`,`trips_accepted`,`trips_rejected`,`total_earnings`,`is_weekend`) VALUES
('S0001','2024-05-25','D005','C06','Providence',10.3,20,1,498.43,1),
('S0002','2024-05-15','D001','C03','Columbus',9.4,17,6,363.49,0),
('S0003','2024-05-15','D010','C04','Portland',4.9,9,3,147.85,0),
('S0004','2024-05-25','D010','C04','Portland',3.6,4,6,53.6,1),
('S0005','2024-05-19','D002','C05','Nashville',8.2,12,4,190.64,1),
('S0006','2024-05-19','D015','C01','Austin',3.8,4,4,49.04,1),
('S0007','2024-05-14','D007','C01','Austin',7.0,12,3,163.17,0),
('S0008','2024-05-15','D007','C01','Austin',6.7,13,1,288.86,0),
('S0009','2024-05-26','D013','C03','Columbus',8.3,9,6,138.68,1),
('S0010','2024-05-17','D010','C04','Portland',5.1,6,2,83.93,0),
('S0011','2024-05-16','D003','C01','Austin',5.0,5,4,69.12,0),
('S0012','2024-05-14','D007','C01','Austin',5.0,6,4,86.82,0),
('S0013','2024-05-25','D002','C05','Nashville',8.2,17,0,188.15,1),
('S0014','2024-05-26','D004','C04','Portland',9.7,20,0,483.06,1),
('S0015','2024-05-16','D002','C05','Nashville',3.4,5,6,98.74,0),
('S0016','2024-05-14','D006','C02','Denver',7.1,8,4,119.19,0),
('S0017','2024-05-25','D011','C03','Columbus',10.6,11,4,238.1,1),
('S0018','2024-05-18','D004','C04','Portland',3.3,4,0,56.24,1),
('S0019','2024-05-17','D001','C03','Columbus',7.8,13,1,301.88,0),
('S0020','2024-05-26','D006','C02','Denver',6.3,9,4,141.15,1),
('S0021','2024-05-16','D001','C03','Columbus',9.4,15,0,256.84,0),
('S0022','2024-05-25','D007','C01','Austin',8.3,9,4,111.31,1),
('S0023','2024-05-15','D007','C01','Austin',8.6,12,2,252.21,0),
('S0024','2024-05-19','D001','C03','Columbus',5.5,9,2,154.9,1),
('S0025','2024-05-13','D014','C03','Columbus',9.1,17,5,237.29,0),
('S0026','2024-05-24','D007','C01','Austin',4.6,4,1,69.43,0),
('S0027','2024-05-26','D002','C05','Nashville',6.2,12,3,271.15,1),
('S0028','2024-05-15','D001','C03','Columbus',3.4,3,6,73.94,0),
('S0029','2024-05-14','D010','C04','Portland',8.0,11,4,149.33,0),
('S0030','2024-05-18','D005','C06','Providence',4.3,5,0,63.16,1),
('S0031','2024-05-20','D013','C03','Columbus',9.4,20,1,310.48,0),
('S0032','2024-05-26','D001','C03','Columbus',10.8,17,0,341.95,1),
('S0033','2024-05-23','D007','C01','Austin',3.7,6,5,140.21,0),
('S0034','2024-05-15','D011','C03','Columbus',9.3,11,3,222.43,0),
('S0035','2024-05-16','D014','C03','Columbus',6.8,11,0,186.96,0),
('S0036','2024-05-21','D003','C01','Austin',6.1,7,1,178.92,0),
('S0037','2024-05-26','D015','C01','Austin',4.5,9,6,201.26,1),
('S0038','2024-05-13','D011','C03','Columbus',9.7,11,4,196.2,0),
('S0039','2024-05-26','D011','C03','Columbus',9.2,16,2,315.83,1),
('S0040','2024-05-19','D007','C01','Austin',8.3,12,3,164.18,1);

-- Data for `fact_trips` (72 rows)
INSERT INTO `fact_trips` (`trip_id`,`trip_date`,`day_name`,`is_weekend`,`rider_id`,`driver_id`,`city_id`,`city_name`,`vehicle_type`,`trip_status`,`payment_method`,`request_hour`,`distance_miles`,`duration_min`,`wait_time_min`,`surge_multiplier`,`fare_amount`,`rating_given`) VALUES
('T0001','2024-05-14','Tuesday',0,'R012','D003','C02','Denver','Comfort','Completed','Debit Card',8,13.4,56,2.1,1.2,31.73,5),
('T0002','2024-05-20','Monday',0,'R015','D012','C02','Denver','Comfort','Completed','Credit Card',7,4.3,20,1.6,1.0,11.88,5),
('T0003','2024-05-21','Tuesday',0,'R012','D009','C02','Denver','Standard','Completed','Credit Card',2,9.3,29,4.4,1.0,14.66,3),
('T0004','2024-05-15','Wednesday',0,'R012','D011','C02','Denver','XL','Completed','Credit Card',18,11.5,57,5.9,1.0,30.0,3),
('T0005','2024-05-26','Sunday',1,'R013','D006','C02','Denver','XL','Completed','Apple Pay',14,13.9,63,2.6,1.0,34.8,5),
('T0006','2024-05-22','Wednesday',0,'R012',NULL,'C02','Denver','Standard','No Driver Found',NULL,22,NULL,NULL,11.6,1.0,NULL,NULL),
('T0007','2024-05-18','Saturday',1,'R003','D008','C04','Portland','Standard','Completed','Debit Card',8,12.7,59,5.1,1.0,18.74,5),
('T0008','2024-05-25','Saturday',1,'R003','D012','C04','Portland','XL','Completed','Apple Pay',11,7.1,23,3.3,1.0,21.2,4),
('T0009','2024-05-25','Saturday',1,'R013','D003','C02','Denver','Comfort','Cancelled by Rider',NULL,6,NULL,NULL,3.2,1.0,NULL,NULL),
('T0010','2024-05-15','Wednesday',0,'R001','D010','C03','Columbus','Standard','Cancelled by Driver',NULL,18,NULL,NULL,7.8,1.0,NULL,NULL),
('T0011','2024-05-20','Monday',0,'R012','D013','C02','Denver','Standard','Completed','Cash',2,9.4,38,3.9,1.0,14.78,2),
('T0012','2024-05-26','Sunday',1,'R007','D009','C03','Columbus','XL','Completed','Credit Card',8,8.5,29,2.2,1.0,24.0,5),
('T0013','2024-05-24','Friday',0,'R012','D007','C02','Denver','XL','Completed','Apple Pay',18,12.4,40,4.3,1.2,38.16,5),
('T0014','2024-05-26','Sunday',1,'R015','D003','C02','Denver','XL','Completed','Credit Card',18,9.0,29,5.3,1.0,25.0,5),
('T0015','2024-05-21','Tuesday',0,'R018','D004','C04','Portland','Comfort','Cancelled by Rider',NULL,19,NULL,NULL,3.3,1.0,NULL,NULL),
('T0016','2024-05-13','Monday',0,'R004','D008','C06','Providence','Comfort','Completed','Credit Card',18,13.6,57,3.0,1.0,26.76,5),
('T0017','2024-05-21','Tuesday',0,'R018','D015','C04','Portland','XL','Completed','Apple Pay',8,13.0,62,2.6,1.2,39.6,3),
('T0018','2024-05-20','Monday',0,'R005','D004','C06','Providence','Standard','Completed','Credit Card',9,3.6,12,5.8,1.5,11.73,5),
('T0019','2024-05-24','Friday',0,'R012','D004','C02','Denver','Standard','Cancelled by Driver',NULL,21,NULL,NULL,7.2,1.0,NULL,NULL),
('T0020','2024-05-14','Tuesday',0,'R013','D004','C02','Denver','XL','Completed','Credit Card',17,6.5,26,2.6,1.0,20.0,5),
('T0021','2024-05-18','Saturday',1,'R003','D008','C04','Portland','Comfort','Completed','Apple Pay',14,5.9,23,6.8,1.0,14.44,5),
('T0022','2024-05-14','Tuesday',0,'R008','D015','C04','Portland','Premium','Completed','Apple Pay',8,4.4,14,6.5,1.0,22.32,5),
('T0023','2024-05-26','Sunday',1,'R009','D008','C03','Columbus','Standard','Completed','Apple Pay',13,2.0,6,3.8,1.0,5.9,4),
('T0024','2024-05-14','Tuesday',0,'R009','D010','C03','Columbus','Premium','Completed','Apple Pay',18,1.7,8,3.4,1.0,14.76,5),
('T0025','2024-05-21','Tuesday',0,'R014','D009','C05','Nashville','Premium','Completed','Apple Pay',7,13.2,65,2.5,1.0,46.96,5),
('T0026','2024-05-17','Friday',0,'R010','D011','C03','Columbus','Comfort','Completed','Credit Card',12,5.4,16,1.6,1.0,13.64,5),
('T0027','2024-05-24','Friday',0,'R017','D015','C06','Providence','Comfort','Completed','Credit Card',13,9.5,40,4.5,1.0,20.2,4),
('T0028','2024-05-19','Sunday',1,'R017','D014','C06','Providence','Standard','Completed','Apple Pay',8,10.4,34,6.9,1.0,15.98,1),
('T0029','2024-05-26','Sunday',1,'R005','D003','C06','Providence','Standard','Completed','Credit Card',19,9.6,36,6.8,1.2,18.02,5),
('T0030','2024-05-22','Wednesday',0,'R008','D005','C04','Portland','Comfort','Completed','Credit Card',7,4.3,21,4.5,1.0,11.88,1),
('T0031','2024-05-16','Thursday',0,'R002','D001','C04','Portland','Premium','Completed','Credit Card',10,1.9,6,2.9,1.0,15.32,4),
('T0032','2024-05-25','Saturday',1,'R001','D010','C03','Columbus','Standard','Cancelled by Rider',NULL,7,NULL,NULL,2.3,1.0,NULL,NULL),
('T0033','2024-05-13','Monday',0,'R010','D009','C03','Columbus','Standard','Completed','Apple Pay',15,2.8,13,4.8,1.0,6.86,4),
('T0034','2024-05-25','Saturday',1,'R011','D011','C04','Portland','Comfort','Completed','Credit Card',9,11.7,51,3.9,1.2,28.46,5),
('T0035','2024-05-24','Friday',0,'R017','D014','C06','Providence','Standard','Completed','Apple Pay',13,1.0,4,5.4,1.0,4.7,4),
('T0036','2024-05-24','Friday',0,'R008','D002','C04','Portland','Standard','Completed','Credit Card',16,6.8,21,4.4,1.0,11.66,5),
('T0037','2024-05-16','Thursday',0,'R016','D015','C06','Providence','Standard','Completed','Debit Card',5,7.9,34,5.6,1.0,12.98,5),
('T0038','2024-05-17','Friday',0,'R003','D012','C04','Portland','XL','Completed','Debit Card',18,6.9,32,6.5,1.0,20.8,5),
('T0039','2024-05-17','Friday',0,'R002','D003','C04','Portland','Comfort','Completed','Credit Card',6,9.4,41,2.2,1.0,20.04,4),
('T0040','2024-05-20','Monday',0,'R002',NULL,'C04','Portland','Comfort','No Driver Found',NULL,6,NULL,NULL,5.7,1.0,NULL,NULL),
('T0041','2024-05-20','Monday',0,'R010','D013','C03','Columbus','Comfort','Completed','Credit Card',12,12.6,42,6.6,1.0,25.16,1),
('T0042','2024-05-13','Monday',0,'R010','D008','C03','Columbus','Comfort','Cancelled by Rider',NULL,21,NULL,NULL,9.0,1.0,NULL,NULL),
('T0043','2024-05-19','Sunday',1,'R007',NULL,'C03','Columbus','Premium','No Driver Found',NULL,6,NULL,NULL,4.7,1.0,NULL,NULL),
('T0044','2024-05-24','Friday',0,'R017','D011','C06','Providence','Standard','Completed','Debit Card',16,12.5,55,6.4,1.0,18.5,5),
('T0045','2024-05-20','Monday',0,'R013','D008','C02','Denver','Standard','Completed','Credit Card',13,10.4,39,2.2,1.0,15.98,5),
('T0046','2024-05-18','Saturday',1,'R001','D015','C03','Columbus','Standard','Completed','Credit Card',11,1.0,4,1.9,1.0,4.7,5),
('T0047','2024-05-19','Sunday',1,'R019',NULL,'C02','Denver','Standard','No Driver Found',NULL,18,NULL,NULL,4.4,2.0,NULL,NULL),
('T0048','2024-05-14','Tuesday',0,'R002','D005','C04','Portland','XL','Completed','Credit Card',20,5.0,22,3.9,1.0,17.0,4),
('T0049','2024-05-13','Monday',0,'R013',NULL,'C02','Denver','Premium','No Driver Found',NULL,14,NULL,NULL,9.8,1.0,NULL,NULL),
('T0050','2024-05-13','Monday',0,'R014','D005','C05','Nashville','Standard','Cancelled by Rider',NULL,16,NULL,NULL,5.4,1.0,NULL,NULL),
('T0051','2024-05-21','Tuesday',0,'R005','D012','C06','Providence','Standard','Completed','Apple Pay',9,9.4,35,4.2,1.0,14.78,5),
('T0052','2024-05-23','Thursday',0,'R013','D009','C02','Denver','Standard','Completed','Cash',6,7.4,25,7.0,1.0,12.38,2),
('T0053','2024-05-20','Monday',0,'R014','D006','C05','Nashville','Standard','Completed','Debit Card',6,5.0,18,2.6,1.0,9.5,3),
('T0054','2024-05-13','Monday',0,'R014','D006','C05','Nashville','Standard','Cancelled by Rider',NULL,8,NULL,NULL,7.3,1.0,NULL,NULL),
('T0055','2024-05-20','Monday',0,'R009','D009','C03','Columbus','Comfort','Completed','Debit Card',17,12.2,41,2.9,1.0,24.52,5),
('T0056','2024-05-19','Sunday',1,'R015','D003','C02','Denver','Standard','Completed','Credit Card',18,10.2,48,4.7,1.0,15.74,5),
('T0057','2024-05-13','Monday',0,'R003',NULL,'C04','Portland','Standard','No Driver Found',NULL,19,NULL,NULL,7.7,2.0,NULL,NULL),
('T0058','2024-05-20','Monday',0,'R008','D011','C04','Portland','XL','Completed','Credit Card',7,11.7,51,6.4,1.0,30.4,3),
('T0059','2024-05-14','Tuesday',0,'R018','D010','C04','Portland','XL','Completed','Cash',7,9.3,33,2.9,1.0,25.6,5),
('T0060','2024-05-23','Thursday',0,'R014','D009','C05','Nashville','Comfort','Completed','Cash',5,3.3,11,1.5,1.0,10.28,4),
('T0061','2024-05-21','Tuesday',0,'R010','D015','C03','Columbus','Premium','Completed','Credit Card',9,7.7,31,3.8,2.0,63.12,5),
('T0062','2024-05-23','Thursday',0,'R010','D007','C03','Columbus','Standard','Completed','Credit Card',19,3.8,14,4.2,1.5,12.09,5),
('T0063','2024-05-24','Friday',0,'R011','D001','C04','Portland','Comfort','Completed','Apple Pay',11,10.6,42,6.8,1.0,21.96,5),
('T0064','2024-05-17','Friday',0,'R007','D002','C03','Columbus','Standard','Completed','Cash',18,7.3,24,3.8,1.0,12.26,5),
('T0065','2024-05-23','Thursday',0,'R002','D004','C04','Portland','Premium','Completed','Credit Card',11,8.7,33,2.5,1.0,34.36,4),
('T0066','2024-05-20','Monday',0,'R011',NULL,'C04','Portland','XL','No Driver Found',NULL,20,NULL,NULL,5.5,1.0,NULL,NULL),
('T0067','2024-05-23','Thursday',0,'R017','D007','C06','Providence','XL','Completed','Apple Pay',17,13.8,53,1.9,1.0,34.6,5),
('T0068','2024-05-14','Tuesday',0,'R012','D013','C02','Denver','Standard','Cancelled by Driver',NULL,15,NULL,NULL,3.5,1.0,NULL,NULL),
('T0069','2024-05-18','Saturday',1,'R010','D008','C03','Columbus','XL','Completed','Credit Card',4,7.9,30,5.6,1.0,22.8,5),
('T0070','2024-05-20','Monday',0,'R001','D007','C03','Columbus','Comfort','Completed','Credit Card',16,1.3,4,2.9,1.0,7.08,2),
('T0071','2024-05-24','Friday',0,'R003','D001','C04','Portland','XL','Completed','Credit Card',8,10.3,37,1.5,1.2,33.12,5),
('T0072','2024-05-25','Saturday',1,'R020','D001','C01','Austin','Premium','Completed','Apple Pay',21,2.2,9,5.8,1.0,16.16,5);

SET FOREIGN_KEY_CHECKS = 1;
