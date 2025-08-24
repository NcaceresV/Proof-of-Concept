-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 30, 2025 at 01:43 AM
-- Server version: 10.4.34-MariaDB-1:10.4.34+maria~ubu2004
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `RCTI`
--
----------------------------------------------------------

--
-- Table structure for table `suppliers`
--
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    abn VARCHAR(20) NOT NULL,         -- Australian Business Number
    address VARCHAR(255),
    email VARCHAR(100),
    phone VARCHAR(20),
    bank_account VARCHAR(50)          -- para pagos
);

--
-- Table structure for table `recipients`
--

CREATE TABLE recipients (
    recipient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    abn VARCHAR(20) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(100),
    phone VARCHAR(20)
);

--
-- Table structure for table `rcti`
--

CREATE TABLE rcti (
    rcti_id INT AUTO_INCREMENT PRIMARY KEY,
    rcti_number VARCHAR(50) UNIQUE NOT NULL,  -- Ej: RCTI-2025-0001
    supplier_id INT NOT NULL,
    recipient_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE,
    subtotal DECIMAL(10,2),
    gst DECIMAL(10,2),
    total DECIMAL(10,2),
    status ENUM('Draft','Issued','Paid','Cancelled') DEFAULT 'Draft',
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id)
);


--
-- Table structure for table `rcti_items`
--

CREATE TABLE rcti_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    rcti_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    gst DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (rcti_id) REFERENCES rcti(rcti_id)
);

--
-- Table structure for table `payments`
--

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    rcti_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method ENUM('Bank Transfer','Cheque','Other') DEFAULT 'Bank Transfer',
    FOREIGN KEY (rcti_id) REFERENCES rcti(rcti_id)
);


-- ========================================
-- Insertar datos de ejemplo
-- ========================================

-- Suppliers
INSERT INTO suppliers (name, abn, address, email, phone, bank_account) VALUES
('Juan Pérez Transport', '12345678901', '45 Smith St, Sydney NSW', 'juan.perez@example.com', '0412345678', 'BSB 123-456 ACC 987654'),
('Green Farms Pty Ltd', '98765432109', '100 Farm Rd, Wagga Wagga NSW', 'info@greenfarms.com.au', '0298765432', 'BSB 111-222 ACC 333444');

-- Recipients
INSERT INTO recipients (name, abn, address, email, phone) VALUES
('ACME Pty Ltd', '55555555555', '200 George St, Sydney NSW', 'accounts@acme.com.au', '0288887777'),
('BuildRight Constructions', '66666666666', '12 King St, Melbourne VIC', 'finance@buildright.com.au', '0387654321');

-- RCTI Headers
INSERT INTO rcti (rcti_number, supplier_id, recipient_id, issue_date, due_date, subtotal, gst, total, status) VALUES
('RCTI-2025-0001', 1, 1, '2025-08-01', '2025-08-15', 1000.00, 100.00, 1100.00, 'Issued'),
('RCTI-2025-0002', 2, 2, '2025-08-05', '2025-08-20', 2500.00, 250.00, 2750.00, 'Draft');

-- RCTI Line Items
INSERT INTO rcti_items (rcti_id, description, quantity, unit_price, gst, total) VALUES
(1, 'Servicio de transporte Sydney → Melbourne', 1, 1000.00, 100.00, 1100.00),
(2, 'Suministro de heno (bultos)', 50, 50.00, 250.00, 2750.00);

-- Payments
INSERT INTO payments (rcti_id, payment_date, amount, method) VALUES
(1, '2025-08-10', 1100.00, 'Bank Transfer');

