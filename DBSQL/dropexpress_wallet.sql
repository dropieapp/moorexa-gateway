-- phpMyAdmin SQL Dump
-- version 4.9.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 15, 2021 at 02:04 PM
-- Server version: 5.7.26
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `dropexpress_wallet`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer_wallet`
--

CREATE TABLE `customer_wallet` (
  `walletid` bigint(20) NOT NULL,
  `customerid` bigint(20) DEFAULT NULL,
  `account_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wallet_balance` float DEFAULT '0',
  `wallet_pin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `authorization_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_wallet`
--

INSERT INTO `customer_wallet` (`walletid`, `customerid`, `account_number`, `wallet_balance`, `wallet_pin`, `authorization_token`) VALUES
(1, 1, '6832986', 320.5, '24595fce49b45dac62d5edb23731445a', '9406');

-- --------------------------------------------------------

--
-- Table structure for table `customer_wallet_transactions`
--

CREATE TABLE `customer_wallet_transactions` (
  `wallet_transactionid` bigint(20) NOT NULL,
  `walletid` bigint(20) DEFAULT NULL,
  `amount` float DEFAULT NULL,
  `transactionTypeid` int(11) DEFAULT NULL,
  `narration` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_recorded` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_types`
--

CREATE TABLE `transaction_types` (
  `transactionTypeid` bigint(20) NOT NULL,
  `transactionType` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaction_types`
--

INSERT INTO `transaction_types` (`transactionTypeid`, `transactionType`) VALUES
(1, 'funding'),
(2, 'withdrawal'),
(3, 'bonus'),
(4, 'pickup payment');

-- --------------------------------------------------------

--
-- Table structure for table `wallet_status`
--

CREATE TABLE `wallet_status` (
  `statusid` bigint(20) NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallet_status`
--

INSERT INTO `wallet_status` (`statusid`, `status`) VALUES
(1, 'pending'),
(2, 'processing'),
(3, 'complete'),
(4, 'canceled'),
(5, 'failed');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer_wallet`
--
ALTER TABLE `customer_wallet`
  ADD PRIMARY KEY (`walletid`);

--
-- Indexes for table `customer_wallet_transactions`
--
ALTER TABLE `customer_wallet_transactions`
  ADD PRIMARY KEY (`wallet_transactionid`);

--
-- Indexes for table `transaction_types`
--
ALTER TABLE `transaction_types`
  ADD PRIMARY KEY (`transactionTypeid`);

--
-- Indexes for table `wallet_status`
--
ALTER TABLE `wallet_status`
  ADD PRIMARY KEY (`statusid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer_wallet`
--
ALTER TABLE `customer_wallet`
  MODIFY `walletid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_wallet_transactions`
--
ALTER TABLE `customer_wallet_transactions`
  MODIFY `wallet_transactionid` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_types`
--
ALTER TABLE `transaction_types`
  MODIFY `transactionTypeid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `wallet_status`
--
ALTER TABLE `wallet_status`
  MODIFY `statusid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
