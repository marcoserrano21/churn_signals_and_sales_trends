use meal_subscription;

SELECT * FROM customers LIMIT 10;

SELECT * FROM subscriptions LIMIT 10;

SELECT * FROM orders LIMIT 10;

-- 1. Total # of customers, active vs. churned
SELECT
	COUNT(*) AS total_customers,
    SUM(churned = 0) AS active_customers,
    SUM(churned = 1) AS churned_customers
FROM customers;

-- 2. Churn rate by region
SELECT
	region,
    COUNT(*) AS total_customers,
    SUM(churned) as churned,
    ROUND(SUM(churned) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY region
ORDER BY churn_rate_pct DESC;

-- 3. Which plan types generate the most revenue
SELECT
	s.plan_type,
    ROUND(AVG(o.amount_spent), 2) AS total_revenue
FROM subscriptions s
JOIN orders o ON s.subscription_id = o.subscription_id
GROUP BY s.plan_type
ORDER BY total_revenue DESC;

-- 4. Revenue trends monthly
SELECT
	DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(amount_spent), 2) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY monthly_revenue DESC;

-- 5. Average order value by plan
SELECT 
  s.plan_type,
  ROUND(AVG(o.amount_spent), 2) AS avg_order_value
FROM subscriptions s
JOIN orders o ON s.subscription_id = o.subscription_id
GROUP BY s.plan_type;

-- 6. What days of the week are busiest for orders
SELECT
	DAYNAME(order_date) as day_of_week,
    COUNT(*) AS num_orders
FROM orders
GROUP BY day_of_week
ORDER BY num_orders DESC;

-- 7. Which acquisition channels drive the highest customer lifetime value (LTV)
SELECT
	acquisition_channel,
    ROUND(AVG(lifetime_value), 2) AS avg_ltv
FROM customers
GROUP BY acquisition_channel
ORDER BY avg_ltv DESC;

-- 8. Which churned customers had the lowest order frequency
SELECT 
  c.customer_id,
  COUNT(o.order_id) AS total_orders,
  DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS active_days,
  ROUND(COUNT(o.order_id) / GREATEST(DATEDIFF(MAX(o.order_date), MIN(o.order_date)), 1), 2) AS orders_per_day
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN orders o ON s.subscription_id = o.subscription_id
WHERE c.churned = 1
GROUP BY c.customer_id
ORDER BY orders_per_day ASC
LIMIT 10;

-- 9. What are our most popular meal types
SELECT
	meal_type,
    COUNT(*) AS total_orders
FROM orders
GROUP by meal_type
ORDER BY total_orders DESC
LIMIT 5;

-- 10. What's our weekly order and spend trend?
SELECT
	YEAR(order_date) AS year,
    WEEK(order_date) AS week,
    COUNT(order_id) as num_orders,
    ROUND(SUM(amount_spent), 2) AS total_spend
FROM orders
GROUP BY year, week
ORDER BY year, week;

-- 11. Which payment methods are most preferred?
SELECT
	payment_method,
    ROUND(SUM(o.amount_spent), 2) AS revenue
FROM subscriptions s
JOIN orders o ON s.subscription_id = o.subscription_id
GROUP BY payment_method
ORDER BY revenue DESC;

-- 12. Are auto-renewing subscriptions more profitable?
SELECT 
  s.auto_renewal,
  ROUND(SUM(o.amount_spent), 2) AS total_revenue,
  COUNT(DISTINCT s.subscription_id) AS num_subscriptions
FROM subscriptions s
JOIN orders o ON s.subscription_id = o.subscription_id
GROUP BY s.auto_renewal;

-- 13. Which customers are at risk of churning?
SELECT 
  c.customer_id,
  MAX(o.order_date) AS last_order_date,
  DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order,
  s.plan_type,
  s.is_active
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN orders o ON s.subscription_id = o.subscription_id
WHERE s.is_active = 1 AND c.churned = 0
GROUP BY c.customer_id, s.plan_type, s.is_active
HAVING days_since_last_order > 30
ORDER BY days_since_last_order ASC;

-- 14. What's the customer lifetime value segmented by churn status and plan?
SELECT 
  s.plan_type,
  c.churned,
  COUNT(c.customer_id) AS num_customers,
  ROUND(AVG(c.lifetime_value), 2) AS avg_ltv,
  ROUND(SUM(c.lifetime_value), 2) AS total_ltv
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
GROUP BY s.plan_type, c.churned
ORDER BY s.plan_type, c.churned;

-- 15. How long does a typical subscription last by plan?
SELECT 
  plan_type,
  ROUND(AVG(DATEDIFF(end_date, start_date) / 7), 1) AS avg_duration_weeks,
  COUNT(subscription_id) AS total_subs
FROM subscriptions
GROUP BY plan_type
ORDER BY avg_duration_weeks DESC;

-- 16. What percentage of revenue comes from auto-renewed subscriptions?
SELECT 
  auto_renewal,
  ROUND(SUM(o.amount_spent), 2) AS revenue,
  ROUND(SUM(o.amount_spent) / (SELECT SUM(amount_spent) FROM orders) * 100, 2) AS revenue_pct
FROM subscriptions s
JOIN orders o ON s.subscription_id = o.subscription_id
GROUP BY auto_renewal;

