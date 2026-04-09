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
