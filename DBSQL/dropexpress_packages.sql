-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 15, 2021 at 02:03 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `dropexpress_packages`
--

-- --------------------------------------------------------

--
-- Table structure for table `coupon_codes`
--

CREATE TABLE `coupon_codes` (
  `couponid` bigint(20) NOT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `coupon_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_description` text COLLATE utf8mb4_unicode_ci,
  `isavaliable` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupon_codes`
--

INSERT INTO `coupon_codes` (`couponid`, `coupon_code`, `discount`, `coupon_title`, `coupon_description`, `isavaliable`) VALUES
(1, '800900', 10, 'Pre launch offer', 'With this coupon code, you get a 10% discount ', 1);

-- --------------------------------------------------------

--
-- Table structure for table `delivery_methods`
--

CREATE TABLE `delivery_methods` (
  `delivery_methodid` bigint(20) NOT NULL,
  `delivery_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_base_fare` float DEFAULT NULL,
  `delivery_white_icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_method_note` text COLLATE utf8mb4_unicode_ci,
  `visible` tinyint(4) DEFAULT '1',
  `minimum_mile` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `delivery_methods`
--

INSERT INTO `delivery_methods` (`delivery_methodid`, `delivery_method`, `delivery_base_fare`, `delivery_white_icon`, `delivery_method_note`, `visible`, `minimum_mile`) VALUES
(1, 'Bicycle', 150, 'bike-white.svg', 'Bicycles are a great way to deliver food,  mail, percel and factory parts', 1, 4),
(2, 'Motocycle', 300, 'motorcycle-white.svg', '', 1, 14),
(3, 'Tricycle', 350, 'tricycle.svg', '', 1, 15),
(4, 'Car', 400, 'car-white.svg', '', 1, 80),
(5, 'Mini Van', 700, 'mini-van-white.svg', '', 1, 100),
(6, 'Truck', 1000, 'truck-white.svg', '', 1, 500),
(7, 'Drone', 500, 'drone-white.svg', '', 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `delivery_rates`
--

CREATE TABLE `delivery_rates` (
  `rateid` bigint(20) NOT NULL,
  `current_day` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_5_7_am` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_7_12_pm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_12_4_pm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_4_7_pm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `from_7_10_pm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `delivery_rates`
--

INSERT INTO `delivery_rates` (`rateid`, `current_day`, `from_5_7_am`, `from_7_12_pm`, `from_12_4_pm`, `from_4_7_pm`, `from_7_10_pm`) VALUES
(1, '2020-07-07', '80', '75', '70', '75', '80'),
(2, '2020-07-08', '80', '75', '70', '75', '80'),
(3, '2020-07-09', '80', '75', '70', '75', '80'),
(4, '2020-07-10', '80', '75', '70', '75', '80'),
(5, '2020-07-11', '80', '75', '70', '75', '80'),
(6, '2020-07-12', '80', '75', '70', '75', '80'),
(7, '2020-07-13', '80', '75', '70', '75', '80'),
(8, '2020-07-14', '80', '75', '70', '75', '80');

-- --------------------------------------------------------

--
-- Table structure for table `pickup_requests`
--

CREATE TABLE `pickup_requests` (
  `requestid` bigint(20) NOT NULL,
  `customerid` bigint(20) DEFAULT '0',
  `riderid` bigint(20) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `sender_fullname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sender_handshake_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sender_telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reciever_fullname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reciever_telephone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_methodid` int(11) DEFAULT NULL,
  `pickup_address` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pickup_coordinates` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dropoff_address` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dropoff_coordinates` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `package_hint` text COLLATE utf8mb4_unicode_ci,
  `package_quantity` int(11) DEFAULT '1',
  `dateadded` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_approved` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_tip` float DEFAULT '0',
  `approved` int(11) NOT NULL DEFAULT '0',
  `completed` int(11) NOT NULL DEFAULT '0',
  `reference` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tracking_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dispatch_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `handshake_made` int(11) NOT NULL DEFAULT '0',
  `completed_by_rider` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pickup_requests`
--

INSERT INTO `pickup_requests` (`requestid`, `customerid`, `riderid`, `amount`, `sender_fullname`, `sender_handshake_code`, `sender_telephone`, `reciever_fullname`, `reciever_telephone`, `delivery_methodid`, `pickup_address`, `pickup_coordinates`, `dropoff_address`, `dropoff_coordinates`, `coupon_code`, `package_hint`, `package_quantity`, `dateadded`, `time_approved`, `extra_tip`, `approved`, `completed`, `reference`, `tracking_number`, `dispatch_code`, `handshake_made`, `completed_by_rider`) VALUES
(1, 1, 1, 335, 'Amadi Ifeanyi', '333839391', '07017170555', 'frank ogwu', '08018180555', 2, 'Ayetobi Road, Lagos, Nigeria', '{\\\"latitude\\\":6.648493600000002,\\\"longitude\\\":3.2497105}', 'no 3 Kaslat Avenue, Lagos, Nigeria', '{\\\"latitude\\\":6.6551475,\\\"longitude\\\":3.252895}', '0', 'no hint', 1, '1595345263', '1595403878', 0, 1, 0, 'vhd2734s2q', 'DEX89841', '9153', 1, 0),
(2, 1, 1, 755, 'frank sam', '4fa8e96d73', '07017170555', 'odu sam', '08144234526', 2, '22 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5241942,\\\"longitude\\\":3.3793648}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'no hint', 1, '1595589654', NULL, 0, 0, 0, 'xkq07crrda', 'DEX18981', NULL, 0, 0),
(3, 1, 1, 755, 'mike gavvy', 'c4a21490a0', '07017170555', 'odu sam', '08144234526', 2, '22 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5241942,\\\"longitude\\\":3.3793648}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'no hint', 1, '1595590375', NULL, 0, 0, 0, '2mvds4nyt8', 'DEX74381', NULL, 0, 0),
(4, 1, 1, 755, 'susan micheal', '89366ac66b', '07017170555', 'odu sam', '08144234526', 2, '22 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5241942,\\\"longitude\\\":3.3793648}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'no hint', 1, '1595590920', '1595590961', 0, 1, 0, 'lioa1z0m05', 'DEX54471', '0096', 1, 0),
(5, 1, 0, 705, 'charles frank', '5a63f60a12', '07017170555', 'ugoma', '08144234526', 2, '21 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5243793,\\\"longitude\\\":3.3792057}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'A cake', 1, '1595620338', NULL, 0, 0, 0, 'ykywxh8fr3', 'DEX69511', NULL, 0, 0),
(6, 1, 1, 705, 'charles frank', 'e7c6b72cef', '07017170555', 'ugoma', '08144234526', 2, '21 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5243793,\\\"longitude\\\":3.3792057}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'A cake', 1, '1595620470', '1595620536', 0, 1, 0, 'ogfx21738w', 'DEX41241', '9184', 1, 0),
(7, 1, 0, 705, 'frank sam', 'aaf8c5fd37', '07017170555', 'odu sam', '08144234526', 2, '21 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5243793,\\\"longitude\\\":3.3792057}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'no hint', 1, '1595674240', NULL, 0, 0, 0, 'p0c1ppepz6', 'DEX65521', NULL, 0, 0),
(8, 1, 1, 705, 'mike gavvy', '38f8d9463e', '07017170555', 'odu sam', '08144234526', 2, '21 Kayode St, Abule ijesha 100001, Lagos, Nigeria', '{\\\"latitude\\\":6.5243793,\\\"longitude\\\":3.3792057}', 'No. 56 Ogundana Street Ogundana Street, Ikeja, Nigeria', '{\\\"latitude\\\":6.600318100000001,\\\"longitude\\\":3.358127699999999}', '0', 'no hint', 1, '1595722678', '1595722728', 0, 1, 0, '3wu2scoxen', 'DEX96151', '0496', 1, 0),
(9, 1, 1, 560, 'charles frank', '3498569ce2', '07017170555', 'odu sam', '08144234526', 2, '42 Onitsha Cres, Garki, Abuja, Nigeria', '{\\\"latitude\\\":9.040509223937985,\\\"longitude\\\":7.5070495605468714}', 'Vom Banex Plaza, Alexandria Crescent, Abuja, Nigeria', '{\\\"latitude\\\":9.083983299999998,\\\"longitude\\\":7.468987200000001}', '0', 'no hint', 1, '1597075442', '1597075463', 0, 1, 0, 'araqcq1e6e', 'DEX91231', '4315', 1, 0),
(10, 1, 0, 950, 'Justin', '4b31069207', '08185624125', 'Sandra', '07015231599', 4, '49 Ebitu Ukiwe St, Jabi, Abuja, Nigeria', '{\\\"latitude\\\":9.066658160661035,\\\"longitude\\\":7.431061499861916}', '23 Rabo Madaki Street, Abuja, Nigeria', '{\\\"latitude\\\":8.979884499999999,\\\"longitude\\\":7.505408800000001}', '0', 'A cake', 1, '1599744042', NULL, 0, 0, 0, '7rcj0ag6ml', 'DEX51051', NULL, 0, 0),
(11, 1, 1, 490, 'charles frank', 'd8118c0ebd', '07017170555', 'Sandra adam', '08144234526', 2, '274 Ebitu Ukiwe St, Jabi, Abuja, Nigeria', '{\\\"latitude\\\":9.066650006392214,\\\"longitude\\\":7.4310834653296665}', 'Wuse 2, Abuja, Nigeria', '{\\\"latitude\\\":9.078749000000002,\\\"longitude\\\":7.4701862}', '0', 'no hint', 1, '1599744708', '1599744746', 0, 1, 0, 'tocgwx03rk', 'DEX66311', '5687', 1, 0),
(12, 1, 1, 490, 'frank ugo', '02e6a8f810', '07017170555', 'odu sam', '08144234526', 2, '282 Ebitu Ukiwe St, Jabi, Abuja, Nigeria', '{\\\"latitude\\\":9.06669602314442,\\\"longitude\\\":7.4311038632852275}', 'Wuse 2, Abuja, Nigeria', '{\\\"latitude\\\":9.078749000000002,\\\"longitude\\\":7.4701862}', '0', 'no hint', 1, '1601034865', '1601034966', 0, 1, 0, 'ub02rvgmh9', 'DEX98271', '8882', 1, 0),
(13, 1, 1, 505, 'ifeanyi amadi', '4ab3523774', '08185624125', 'bola tinibu', '08144234526', 2, 'L19C Bala Sokoto Way, Jabi, Abuja, Nigeria', '{\\\"latitude\\\":9.076536682820358,\\\"longitude\\\":7.425252532325535}', 'Wuse 2, Abuja, Nigeria', '{\\\"latitude\\\":9.078749,\\\"longitude\\\":7.4701862}', '0', 'an envelope', 1, '1604856603', '1604856661', 0, 1, 0, 'qsfaetwou0', 'DEX57161', '3772', 1, 0),
(14, 1, 0, 455, 'mike,harry', '7ceebffdf8', '07017170555', 'Joan micheal', '08144234526', 2, 'Ameh Ebute St, Utako, Abuja, Nigeria', '{\\\"latitude\\\":9.049877312140476,\\\"longitude\\\":7.435736855094095}', 'no 41 Ebitu Ukiwe Street, Abuja, Nigeria', '{\\\"latitude\\\":9.0667511,\\\"longitude\\\":7.429809899999999}', '0', 'a letter', 1, '1620052084', NULL, 0, 0, 0, 'dc5pu33gkn', 'DEX50251', NULL, 0, 0),
(15, 1, 1, 455, 'Frank, Lampard', '2e4dd3ba98', '07066156036', 'Joan micheal', '08144234526', 2, 'Ameh Ebute St, Utako, Abuja, Nigeria', '{\\\"latitude\\\":9.049877312922359,\\\"longitude\\\":7.435736854206117}', '41 Ebitu Ukiwe Street, Abuja, Nigeria', '{\\\"latitude\\\":9.066587199999999,\\\"longitude\\\":7.4298666}', '0', 'no hint', 1, '1620052425', '1620052484', 0, 1, 0, 'vycvxfshxk', 'DEX95041', '0752', 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `coupon_codes`
--
ALTER TABLE `coupon_codes`
  ADD PRIMARY KEY (`couponid`);

--
-- Indexes for table `delivery_methods`
--
ALTER TABLE `delivery_methods`
  ADD PRIMARY KEY (`delivery_methodid`);

--
-- Indexes for table `delivery_rates`
--
ALTER TABLE `delivery_rates`
  ADD PRIMARY KEY (`rateid`);

--
-- Indexes for table `pickup_requests`
--
ALTER TABLE `pickup_requests`
  ADD PRIMARY KEY (`requestid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `coupon_codes`
--
ALTER TABLE `coupon_codes`
  MODIFY `couponid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `delivery_methods`
--
ALTER TABLE `delivery_methods`
  MODIFY `delivery_methodid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `delivery_rates`
--
ALTER TABLE `delivery_rates`
  MODIFY `rateid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pickup_requests`
--
ALTER TABLE `pickup_requests`
  MODIFY `requestid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
