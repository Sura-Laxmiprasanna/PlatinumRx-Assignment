-- 1. Find the revenue we got from each sales channel in a given year
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

-- 2.Find top 10 the most valuable customers for a given year
SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year
WITH revenue AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expenses_cte AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)

SELECT 
    r.month,
    r.total_revenue,
    e.total_expense,
    (r.total_revenue - e.total_expense) AS profit,
    CASE 
        WHEN (r.total_revenue - e.total_expense) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
JOIN expenses_cte e 
ON r.month = e.month;

-- 4. For each city find the most profitable clinic for a given month
WITH clinic_profit AS (
    SELECT 
        c.city,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        
        RANK() OVER (
            PARTITION BY c.city 
            ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) DESC
        ) AS rnk
        
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    
    WHERE MONTH(cs.datetime) = 2
    AND YEAR(cs.datetime) = 2021
    
    GROUP BY c.city, cs.cid
)

SELECT *
FROM clinic_profit
WHERE rnk = 1;

-- 5.For each state find the second least profitable clinic for a given month
WITH clinic_profit AS (
    SELECT 
        c.state,
        cs.cid,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit,
        
        DENSE_RANK() OVER (
            PARTITION BY c.state 
            ORDER BY (SUM(cs.amount) - COALESCE(SUM(e.amount),0)) ASC
        ) AS rnk
        
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    
    WHERE MONTH(cs.datetime) = 2
    AND YEAR(cs.datetime) = 2021
    
    GROUP BY c.state, cs.cid
)

SELECT *
FROM clinic_profit
WHERE rnk = 2;

