-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 15, 2021 at 02:02 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `dropexpress_accounts`
--

-- --------------------------------------------------------

--
-- Table structure for table `account_services`
--

CREATE TABLE `account_services` (
  `account_serviceid` bigint(20) NOT NULL,
  `service_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `account_services`
--

INSERT INTO `account_services` (`account_serviceid`, `service_name`) VALUES
(1, 'downline alert'),
(2, 'login alert'),
(3, 'pickup alert'),
(4, 'withdraw alert'),
(5, 'funding alert'),
(6, 'credit alert'),
(7, 'delivery alert');

-- --------------------------------------------------------

--
-- Table structure for table `account_types`
--

CREATE TABLE `account_types` (
  `accounttypeid` int(11) NOT NULL,
  `accounttype` varchar(45) DEFAULT 'customer',
  `terms_and_conditions` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `account_types`
--

INSERT INTO `account_types` (`accounttypeid`, `accounttype`, `terms_and_conditions`) VALUES
(1, 'sender', ''),
(2, 'rider', '');

-- --------------------------------------------------------

--
-- Table structure for table `business_accounts`
--

CREATE TABLE `business_accounts` (
  `businessid` bigint(20) NOT NULL,
  `customerid` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customerid` bigint(11) NOT NULL,
  `firstname` varchar(200) DEFAULT NULL,
  `lastname` varchar(200) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `telephone` varchar(45) DEFAULT NULL,
  `stateid` int(11) DEFAULT NULL,
  `referer_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customerid`, `firstname`, `lastname`, `email`, `telephone`, `stateid`, `referer_code`) VALUES
(1, 'ifeanyi', 'amadi', 'helloamadiify@gmail.com', '07017170555', NULL, 'c18498');

-- --------------------------------------------------------

--
-- Table structure for table `customer_account`
--

CREATE TABLE `customer_account` (
  `accountid` bigint(11) NOT NULL,
  `customerid` bigint(11) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `securityid` int(11) DEFAULT NULL,
  `security_answer` varchar(100) DEFAULT NULL,
  `isactivated` tinyint(2) DEFAULT '0',
  `date_created` varchar(45) DEFAULT NULL,
  `accounttypeid` int(11) DEFAULT NULL,
  `activation_code` text NOT NULL,
  `agreed_to_terms` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer_account`
--

INSERT INTO `customer_account` (`accountid`, `customerid`, `password`, `securityid`, `security_answer`, `isactivated`, `date_created`, `accounttypeid`, `activation_code`, `agreed_to_terms`) VALUES
(1, 1, '$2y$10$GAfN2ziAZ7dtx3deEiNMaOP1NahGXh1zP7W8Mvhcv8paFKkkx2IKS', 1, '7b3e646f4a26261be2e7154db01fd345', 0, '1594384447', 2, '1938', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_downlines`
--

CREATE TABLE `customer_downlines` (
  `customer_downlineid` bigint(20) NOT NULL,
  `customerid` bigint(20) DEFAULT NULL,
  `downlineid` bigint(20) DEFAULT NULL,
  `transactions` int(11) DEFAULT '0',
  `bonus_earned` float DEFAULT '0',
  `time_registered` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_salts`
--

CREATE TABLE `customer_salts` (
  `customersaltid` int(11) NOT NULL,
  `customerid` bigint(11) NOT NULL,
  `customer_salt` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer_salts`
--

INSERT INTO `customer_salts` (`customersaltid`, `customerid`, `customer_salt`) VALUES
(1, 1, 'ad2aa79127d83228cda1837c8ef7969a');

-- --------------------------------------------------------

--
-- Table structure for table `customer_services`
--

CREATE TABLE `customer_services` (
  `customer_serviceid` bigint(20) NOT NULL,
  `customerid` int(11) DEFAULT NULL,
  `serviceid` int(11) DEFAULT NULL,
  `isenabled` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_services`
--

INSERT INTO `customer_services` (`customer_serviceid`, `customerid`, `serviceid`, `isenabled`) VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 1, 3, 1),
(4, 1, 4, 1),
(5, 1, 5, 1),
(6, 1, 6, 1),
(7, 1, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `security_questions`
--

CREATE TABLE `security_questions` (
  `security_questionid` bigint(20) NOT NULL,
  `security_question` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `security_questions`
--

INSERT INTO `security_questions` (`security_questionid`, `security_question`) VALUES
(1, 'What is your pet name?'),
(2, 'What is your favorite country?'),
(3, 'What is your favorite car?'),
(4, 'What would you do if given 100 million dollars?'),
(5, 'Where do you see yourself in 5 - 10 years from now?');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_services`
--
ALTER TABLE `account_services`
  ADD PRIMARY KEY (`account_serviceid`);

--
-- Indexes for table `account_types`
--
ALTER TABLE `account_types`
  ADD PRIMARY KEY (`accounttypeid`);

--
-- Indexes for table `business_accounts`
--
ALTER TABLE `business_accounts`
  ADD PRIMARY KEY (`businessid`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `customer_account`
--
ALTER TABLE `customer_account`
  ADD PRIMARY KEY (`accountid`);

--
-- Indexes for table `customer_downlines`
--
ALTER TABLE `customer_downlines`
  ADD PRIMARY KEY (`customer_downlineid`);

--
-- Indexes for table `customer_salts`
--
ALTER TABLE `customer_salts`
  ADD PRIMARY KEY (`customersaltid`);

--
-- Indexes for table `customer_services`
--
ALTER TABLE `customer_services`
  ADD PRIMARY KEY (`customer_serviceid`);

--
-- Indexes for table `security_questions`
--
ALTER TABLE `security_questions`
  ADD PRIMARY KEY (`security_questionid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_services`
--
ALTER TABLE `account_services`
  MODIFY `account_serviceid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `account_types`
--
ALTER TABLE `account_types`
  MODIFY `accounttypeid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `business_accounts`
--
ALTER TABLE `business_accounts`
  MODIFY `businessid` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customerid` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_account`
--
ALTER TABLE `customer_account`
  MODIFY `accountid` bigint(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_downlines`
--
ALTER TABLE `customer_downlines`
  MODIFY `customer_downlineid` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_salts`
--
ALTER TABLE `customer_salts`
  MODIFY `customersaltid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_services`
--
ALTER TABLE `customer_services`
  MODIFY `customer_serviceid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `security_questions`
--
ALTER TABLE `security_questions`
  MODIFY `security_questionid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
