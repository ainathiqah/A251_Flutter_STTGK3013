-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 04:35 PM
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
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `motivation` varchar(255) NOT NULL,
  `adoption_status` varchar(100) NOT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `motivation`, `adoption_status`, `request_date`) VALUES
(7, 29, 44, 'I like cat so much!', 'pending', '2026-01-10 22:19:09');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donation`
--

CREATE TABLE `tbl_donation` (
  `donation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `donation_type` varchar(50) NOT NULL,
  `amount` double NOT NULL,
  `description` text NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donation`
--

INSERT INTO `tbl_donation` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(3, 28, 45, 'Money', 30.5, 'Monetary donation: RM30.50', '2026-01-10 21:34:36'),
(4, 29, 45, 'Money', 30.5, 'Monetary donation: RM30.50', '2026-01-10 22:11:59');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `pet_age` int(255) NOT NULL,
  `pet_gender` varchar(20) DEFAULT NULL,
  `pet_health` varchar(50) DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `pet_age`, `pet_gender`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(44, 27, 'Snowy', 'Cat', 4, 'Female', 'Healthy', 'Adoption', 'For adoption, such as cute and energetic cat!', 'pet_44_1.png, pet_44_2.png, pet_44_3.png', '6.457595', '100.5030417', '2026-01-10 13:03:02'),
(45, 27, 'Hiu', 'Bird', 3, 'Female', 'Medical Treatment Needed', 'Help/Rescue', 'Need to send to veterinary clinic', 'pet_45_1.png, pet_45_2.png', '6.457595', '100.5030417', '2026-01-10 13:06:05'),
(46, 28, 'Alien', 'Rabbit', 7, 'Male', 'Medical Treatment Needed', 'Donation Request', 'Need at least RM 100 to send him to veterinary clinic', 'pet_46_1.png', '6.457595', '100.5030417', '2026-01-10 13:30:21'),
(47, 29, 'Abu', 'Fish', 3, 'Unknown', 'Healthy', 'Adoption', 'Such a cute and active fish', 'pet_47_1.png', '6.457595', '100.5030417', '2026-01-10 14:03:21');

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
  `image` text NOT NULL,
  `reg_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `image`, `reg_date`) VALUES
(27, 'Ain', 'ain@gmail.com', 'f3a249d2e6af8004929a80ebee9c6727769228a9', '0177516813', 'profileImage27.png', '2026-01-10 20:59:40'),
(28, 'Saiful', 'saiful@gmail.com', 'b5ff1b86f76aed940a1c52cd9daead60cd64c463', '0194755041', '', '2026-01-10 21:27:28'),
(29, 'Hana', 'hana@gmail.com', '3f40272cad5eb913bd71c43c8ea6bfe50f0daec2', '0123654789', 'profileImage29.png', '2026-01-10 21:54:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donation`
--
ALTER TABLE `tbl_donation`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_donation`
--
ALTER TABLE `tbl_donation`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
