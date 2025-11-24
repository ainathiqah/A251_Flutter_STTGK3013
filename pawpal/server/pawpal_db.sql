-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Nov 24, 2025 at 10:06 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`) VALUES
(7, 'Ain', 'ain@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0177516813', '2025-11-17 23:41:17'),
(8, 'Ali', 'ali@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0194755041', '2025-11-17 23:42:40'),
(9, 'Rabiatul', 'rabi@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '019587463', '2025-11-21 12:10:32'),
(10, 'Saiful', 'saiful@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0194755041', '2025-11-21 12:27:00'),
(11, 'Nasrullah', 'nas@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0193837257', '2025-11-21 13:03:33'),
(15, 'Salleh', 'slh@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0147258369', '2025-11-23 17:05:01'),
(16, 'Wonwoo', 'wonu@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0147258369', '2025-11-23 23:52:56'),
(21, 'Hana', 'hana@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0147236547', '2025-11-24 15:14:13');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
