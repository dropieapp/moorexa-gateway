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
-- Database: `dropexpress_authentication`
--

-- --------------------------------------------------------

--
-- Table structure for table `authentication`
--

CREATE TABLE `authentication` (
  `authenticationid` bigint(20) NOT NULL,
  `customerid` bigint(11) DEFAULT NULL,
  `authentication_token` varchar(100) DEFAULT NULL,
  `expire_at` varchar(45) DEFAULT NULL,
  `last_seen` varchar(45) NOT NULL COMMENT 'This should be a timestamp of when last the customer was seen using the app'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `authentication`
--

INSERT INTO `authentication` (`authenticationid`, `customerid`, `authentication_token`, `expire_at`, `last_seen`) VALUES
(1, 1, '1b9701ef468caf98f01c48fa673e069a', '1636721977', '1636718377');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authentication`
--
ALTER TABLE `authentication`
  ADD PRIMARY KEY (`authenticationid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authentication`
--
ALTER TABLE `authentication`
  MODIFY `authenticationid` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
