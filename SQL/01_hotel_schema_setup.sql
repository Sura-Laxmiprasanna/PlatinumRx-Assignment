CREATE DATABASE platinumrx;
USE platinumrx;
CREATE TABLE users (
    user_id VARCHAR(50),
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
DROP TABLE users;
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);
CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);
CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,2),

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);
INSERT INTO users VALUES
('u1', 'John Doe', '9876543210', 'john@example.com', 'Hyderabad'),
('u2', 'Alice Smith', '9123456780', 'alice@example.com', 'Bangalore'),
('u3', 'Bob Johnson', '9012345678', 'bob@example.com', 'Chennai');
INSERT INTO items VALUES
('itm1', 'Tawa Paratha', 20),
('itm2', 'Mix Veg', 100),
('itm3', 'Paneer Butter Masala', 200),
('itm4', 'Dal Fry', 80);
INSERT INTO bookings VALUES
('bk1', '2021-10-05 08:30:00', 'rm101', 'u1'),
('bk2', '2021-11-10 10:00:00', 'rm102', 'u1'),
('bk3', '2021-11-15 12:15:00', 'rm201', 'u2'),
('bk4', '2021-12-01 09:45:00', 'rm202', 'u3'),
('bk5', '2021-10-20 14:20:00', 'rm301', 'u2');
INSERT INTO booking_commercials VALUES
-- October Bills
('bc1', 'bk1', 'bill1', '2021-10-05 12:00:00', 'itm1', 10),  -- 200
('bc2', 'bk1', 'bill1', '2021-10-05 12:00:00', 'itm2', 5),   -- 500 → total = 700

('bc3', 'bk5', 'bill2', '2021-10-20 15:00:00', 'itm3', 6),   -- 1200
('bc4', 'bk5', 'bill2', '2021-10-20 15:00:00', 'itm4', 5),   -- 400 → total = 1600 ✅ (>1000)

-- November Bills
('bc5', 'bk2', 'bill3', '2021-11-10 13:00:00', 'itm1', 20),  -- 400
('bc6', 'bk2', 'bill3', '2021-11-10 13:00:00', 'itm2', 10),  -- 1000 → total = 1400

('bc7', 'bk3', 'bill4', '2021-11-15 14:00:00', 'itm3', 2),   -- 400
('bc8', 'bk3', 'bill4', '2021-11-15 14:00:00', 'itm4', 3),   -- 240 → total = 640

-- December Bills
('bc9', 'bk4', 'bill5', '2021-12-01 11:00:00', 'itm2', 8),   -- 800



SELECT * FROM booking_commercials;
SELECT * FROM users
SELECT * FROM bookings;
SELECT * FROM items;
SELECT * FROM booking_commercials;

-- 1.For every user in the system, get the user_id and last booked room_no
SELECT user_id, MAX(booking_date) AS last_booking
FROM bookings
GROUP BY user_id;

-- Now use Join 

SELECT 
    b.user_id,
    b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) latest
ON b.user_id = latest.user_id
AND b.booking_date = latest.last_booking;

-- 2.Get booking_id and total billing amount of every booking created in November, 2021

SELECT * 
FROM bookings
WHERE MONTH(booking_date) = 11 
AND YEAR(booking_date) = 2021;

-- Join all tables

SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 
AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

-- 3.Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 
AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

-- 4.Determine the most ordered and least ordered item of each month of year 2021
WITH item_counts AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date) 
            ORDER BY SUM(bc.item_quantity) DESC
        ) AS rnk_desc,
        
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date) 
            ORDER BY SUM(bc.item_quantity) ASC
        ) AS rnk_asc
        
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
)

SELECT *
FROM item_counts
WHERE rnk_desc = 1 OR rnk_asc = 1;

-- 5.Find the customers with the second highest bill value of each month of year 2021
WITH monthly_bills AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate) AS total_bill,
        
        DENSE_RANK() OVER (
            PARTITION BY MONTH(bc.bill_date)
            ORDER BY SUM(bc.item_quantity * i.item_rate) DESC
        ) AS rnk
        
    FROM booking_commercials bc
    JOIN bookings b 
        ON bc.booking_id = b.booking_id
    JOIN items i 
        ON bc.item_id = i.item_id
        
    WHERE YEAR(bc.bill_date) = 2021
    
    GROUP BY 
        MONTH(bc.bill_date), 
        b.user_id, 
        bc.bill_id
)

SELECT *
FROM monthly_bills
WHERE rnk = 2;







