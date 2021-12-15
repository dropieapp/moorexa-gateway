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
-- Database: `dropexpress_riders`
--

-- --------------------------------------------------------

--
-- Table structure for table `drivers_information`
--

CREATE TABLE `drivers_information` (
  `driverid` int(11) NOT NULL,
  `customerid` varchar(45) DEFAULT NULL,
  `on_trip` tinyint(4) DEFAULT '0',
  `isactivated` tinyint(4) DEFAULT '0',
  `deliveryclassid` int(11) DEFAULT NULL,
  `current_longitude` varchar(100) DEFAULT NULL,
  `current_latitude` varchar(100) DEFAULT NULL,
  `isavaliable` tinyint(4) NOT NULL DEFAULT '0',
  `username` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `drivers_information`
--

INSERT INTO `drivers_information` (`driverid`, `customerid`, `on_trip`, `isactivated`, `deliveryclassid`, `current_longitude`, `current_latitude`, `isavaliable`, `username`) VALUES
(1, '1', 1, 1, 2, '7.4357368543016', '9.0498773128383', 1, 'amadiify');

-- --------------------------------------------------------

--
-- Table structure for table `drivers_rating`
--

CREATE TABLE `drivers_rating` (
  `drivers_ratingid` bigint(20) NOT NULL,
  `customerid` bigint(20) DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `public_comment` text COLLATE utf8mb4_unicode_ci,
  `sender_fullname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sender_phonenumber` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_submitted` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drivers_information`
--
ALTER TABLE `drivers_information`
  ADD PRIMARY KEY (`driverid`);

--
-- Indexes for table `drivers_rating`
--
ALTER TABLE `drivers_rating`
  ADD PRIMARY KEY (`drivers_ratingid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `drivers_information`
--
ALTER TABLE `drivers_information`
  MODIFY `driverid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `drivers_rating`
--
ALTER TABLE `drivers_rating`
  MODIFY `drivers_ratingid` bigint(20) NOT NULL AUTO_INCREMENT;
