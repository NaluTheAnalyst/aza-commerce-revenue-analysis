-- ============================================================
--  Aza Commerce  |  Revenue & Growth Analysis
--  SQL Server 2019
-- ============================================================

USE AzaCommerce;
GO


-- QUESTION 1: Revenue by Country
SELECT
    o.country,
    SUM(oi.total_price) AS total_revenue,
    CAST(SUM(oi.total_price) * 100.0 / SUM(SUM(oi.total_price)) OVER() AS DECIMAL(5,2)) AS revenue_share_pct
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY o.country
ORDER BY total_revenue DESC

-- Results:
-- Ghana           14,312,000    30.36%
-- Nigeria         12,612,500    26.75%
-- Kenya           11,230,500    23.82%
-- South Africa     8,989,500    19.07%

-- Finding:
-- Ghana is the top revenue market at 30.36% despite not being the
-- largest country by population. Revenue is fairly well distributed
-- across all four markets. South Africa is the weakest at 19.07%
-- and may represent either an untapped growth opportunity or a
-- market that needs a strategic review.


-- QUESTION 2: Revenue by Product Category
SELECT
    p.category,
    SUM(oi.total_price) AS total_revenue,
    CAST(SUM(oi.total_price) * 100.0 / SUM(SUM(oi.total_price)) OVER() AS DECIMAL(5,2)) AS revenue_share_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC

-- Results:
-- Fashion             11,121,000    23.59%
-- Home & Living        9,784,000    20.75%
-- Electronics          9,174,500    19.46%
-- Sports               7,026,000    14.90%
-- Beauty & Health      6,294,000    13.35%
-- Books & Education    3,745,000     7.94%

-- Finding:
-- Fashion leads at 23.59%. The top three categories — Fashion,
-- Home & Living, and Electronics — account for 63.8% of all revenue.
-- Books & Education at 7.94% is the weakest and its inventory
-- investment should be reviewed. Aza Commerce should prioritise
-- expanding the Fashion range given its dominant revenue position.


-- QUESTION 3: Order Delivery Performance
SELECT
    delivery_status,
    COUNT(*) AS total_orders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS pct_of_orders
FROM orders
GROUP BY delivery_status
ORDER BY total_orders DESC

-- Results:
-- delivered    372    68.76%
-- cancelled     85    15.71%
-- pending       84    15.53%

-- Finding:
-- Only 68.76% of orders were successfully delivered. The 15.71%
-- cancellation rate is alarmingly high — a healthy e-commerce business
-- should be below 5%. Combined with 15.53% still pending, nearly 1 in
-- 3 orders is not reaching the customer. Fixing fulfilment operations
-- should be an immediate priority before investing in acquisition.


-- QUESTION 4: Monthly Revenue Trend
SELECT
    MONTH(o.order_date) AS month_number,
    DATENAME(MONTH, o.order_date) AS month_name,
    SUM(oi.total_price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY MONTH(o.order_date), DATENAME(MONTH, o.order_date)
ORDER BY month_number

-- Results:
-- January        218,000
-- February       714,500
-- March        1,180,500
-- April        1,524,000
-- May          2,246,000
-- June         1,307,000
-- July         2,382,500
-- August       3,437,000
-- September    5,205,000
-- October      9,781,500
-- November     8,568,500
-- December    10,580,000

-- Finding:
-- Revenue grew almost every month across 2023. December at NGN 10.58
-- million was 49x January's NGN 218,000. The only notable dip was
-- June before a strong recovery. Q4 was exceptionally strong driven
-- by festive season shopping. Aza Commerce should plan inventory and
-- logistics capacity well ahead of Q4.


-- QUESTION 5: Most Profitable Products
SELECT TOP 10
    p.product_name,
    p.category,
    SUM(oi.total_price) AS total_revenue,
    SUM(oi.quantity * p.cost_price) AS total_cost,
    SUM(oi.total_price) - SUM(oi.quantity * p.cost_price) AS gross_profit,
    CAST((SUM(oi.total_price) - SUM(oi.quantity * p.cost_price)) * 100.0
        / SUM(oi.total_price) AS DECIMAL(5,2)) AS margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY gross_profit DESC

-- Results:
-- Air Fryer 4L             Home & Living    4,675,000    2,380,000    2,295,000    49.09%
-- Leather Crossbody Bag    Fashion          3,220,000    1,288,000    1,932,000    60.00%
-- Running Shoes            Sports           3,002,000    1,264,000    1,738,000    57.89%
-- Wireless Earbuds Pro     Electronics      3,195,000    1,562,000    1,633,000    51.11%
-- Women's Ankara Dress     Fashion          2,464,000      952,000    1,512,000    61.36%
-- Bluetooth Speaker        Electronics      2,656,000    1,162,000    1,494,000    56.25%
-- Men's Casual Sneakers    Fashion          2,352,000      924,000    1,428,000    60.71%
-- Yoga Mat Premium         Sports           2,145,000      845,000    1,300,000    60.61%
-- Electric Face Massager   Beauty & Health  2,112,000      864,000    1,248,000    59.09%
-- Men's Slim Fit Chinos    Fashion          1,710,000      665,000    1,045,000    61.11%

-- Finding:
-- Fashion products consistently deliver the strongest margins above 60%.
-- The Air Fryer 4L generates the highest gross profit at NGN 2.29 million
-- but has the lowest margin in the top 10 at 49.09%. Aza Commerce should
-- expand its Fashion range and renegotiate cost prices on the Air Fryer
-- to improve its margin efficiency.


-- QUESTION 6: Customer Segment Performance
SELECT
    c.segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_price) AS total_revenue,
    CAST(SUM(oi.total_price) / COUNT(DISTINCT o.order_id) AS DECIMAL(12,2)) AS avg_order_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC

-- Results:
-- Regular    224    20,227,500    90,301.34
-- Premium    210    18,731,500    89,197.62
-- VIP        107     8,185,500    76,500.00

-- Finding:
-- Counter-intuitively, VIP customers have the lowest average order
-- value at NGN 76,500 — less than Regular customers at NGN 90,301.
-- VIP customers are expected to spend more, not less. This suggests
-- the VIP programme is not driving higher basket sizes and needs a
-- complete redesign to incentivise higher spend per order.


-- QUESTION 7: Month-on-Month Revenue Growth
WITH monthly_revenue AS (
    SELECT
        MONTH(o.order_date) AS month_number,
        DATENAME(MONTH, o.order_date) AS month_name,
        SUM(oi.total_price) AS total_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY MONTH(o.order_date), DATENAME(MONTH, o.order_date)
)
SELECT
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month_number) AS prev_month_revenue,
    CAST((total_revenue - LAG(total_revenue) OVER (ORDER BY month_number))
        * 100.0 / LAG(total_revenue) OVER (ORDER BY month_number) AS DECIMAL(5,2)) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month_number

-- Results:
-- January       218,000     NULL       NULL
-- February      714,500     218,000    +227.75%
-- March       1,180,500     714,500     +65.22%
-- April       1,524,000   1,180,500     +29.10%
-- May         2,246,000   1,524,000     +47.38%
-- June        1,307,000   2,246,000     -41.81%
-- July        2,382,500   1,307,000     +82.29%
-- August      3,437,000   2,382,500     +44.26%
-- September   5,205,000   3,437,000     +51.44%
-- October     9,781,500   5,205,000     +87.93%
-- November    8,568,500   9,781,500     -12.40%
-- December   10,580,000   8,568,500     +23.48%

-- Finding:
-- June recorded the biggest single month drop at -41.81%. October
-- was the strongest month at +87.93%. Despite two dips in June and
-- November, the overall trajectory is strongly positive. Aza Commerce
-- should run a mid-year promotional campaign in June to smooth out
-- that predictable dip and capitalise on October with upsell activity.


-- QUESTION 8: Customer Retention Analysis
WITH q1_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE MONTH(order_date) BETWEEN 1 AND 3
),
returning_customers AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE MONTH(order_date) > 3
)
SELECT
    COUNT(*) AS q1_customers,
    SUM(CASE WHEN r.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS came_back,
    CAST(SUM(CASE WHEN r.customer_id IS NOT NULL THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS DECIMAL(5,2)) AS retention_rate_pct
FROM q1_customers q
LEFT JOIN returning_customers r ON q.customer_id = r.customer_id

-- Results:
-- q1_customers: 23
-- came_back: 20
-- retention_rate_pct: 86.96%

-- Finding:
-- 20 of 23 Q1 customers returned to order again — a retention rate of
-- 86.96%. The industry benchmark for e-commerce is 25-40%, meaning Aza
-- Commerce is significantly outperforming the market. Customers who order
-- once are very likely to order again. Aza should focus on converting new
-- customers into first-time buyers as quickly as possible.


-- QUESTION 9: Return Rate by Country and Category

-- By Country
SELECT
    o.country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.return_id) AS total_returns,
    CAST(COUNT(DISTINCT r.return_id) * 100.0 / COUNT(DISTINCT o.order_id) AS DECIMAL(5,2)) AS return_rate_pct
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY o.country
ORDER BY return_rate_pct DESC

-- Results:
-- Ghana           172    14    8.14%
-- South Africa    101     7    6.93%
-- Kenya           126     8    6.35%
-- Nigeria         142     5    3.52%

-- By Category
SELECT
    p.category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT r.return_id) AS total_returns,
    CAST(COUNT(DISTINCT r.return_id) * 100.0 / COUNT(DISTINCT oi.order_id) AS DECIMAL(5,2)) AS return_rate_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN returns r ON oi.order_id = r.order_id
GROUP BY p.category
ORDER BY return_rate_pct DESC

-- Results:
-- Electronics         177    15    8.47%
-- Beauty & Health     203    17    8.37%
-- Sports              213    17    7.98%
-- Home & Living       208    15    7.21%
-- Fashion             208    14    6.73%
-- Books & Education   210    12    5.71%

-- Finding:
-- Ghana has the highest return rate at 8.14% — more than double
-- Nigeria's 3.52%. Electronics and Beauty & Health have the highest
-- category return rates above 8%. Aza Commerce should improve product
-- descriptions for these categories and investigate Ghana's delivery
-- partners to understand why that market returns so much more.
