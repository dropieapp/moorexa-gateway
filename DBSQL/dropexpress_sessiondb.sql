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
-- Database: `dropexpress_sessiondb`
--

-- --------------------------------------------------------

--
-- Table structure for table `session_storage`
--

CREATE TABLE `session_storage` (
  `sessionid` bigint(20) NOT NULL,
  `session_identifier` text COLLATE utf8mb4_unicode_ci,
  `session_value` longtext COLLATE utf8mb4_unicode_ci,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `date_created` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `session_storage`
--
ALTER TABLE `session_storage`
  ADD PRIMARY KEY (`sessionid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `session_storage`
--
ALTER TABLE `session_storage`
  MODIFY `sessionid` bigint(20) NOT NULL AUTO_INCREMENT;
