-- ============================================
-- ORDER REVENUE SUMMARY TABLE
-- Purpose: Calculate total revenue per order
-- Used for revenue analysis, AOV, and customer insights
-- ============================================

DROP TABLE IF EXISTS order_revenue_summary;

CREATE TABLE order_revenue_summary AS
SELECT 
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    COALESCE(SUM(p.payment_value), 0) AS total_order_value
FROM orders o
LEFT JOIN order_payments p 
    ON o.order_id = p.order_id
GROUP BY 
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp;
    
-- ============================================
-- CUSTOMER SUMMARY TABLE
-- Purpose: Analyze customer behavior, spending, and engagement
-- This table helps identify high-value customers, repeat buyers, and CLV
-- ============================================

DROP TABLE IF EXISTS customer_summary;

CREATE TABLE customer_summary AS
SELECT 
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(r.total_order_value) AS total_spent,
    ROUND(SUM(r.total_order_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value,
    MIN(o.order_purchase_timestamp) AS first_purchase_date,
    MAX(o.order_purchase_timestamp) AS last_purchase_date
FROM orders o
JOIN order_revenue_summary r 
    ON o.order_id = r.order_id
GROUP BY o.customer_id;


-- ============================================
-- CATEGORY SUMMARY TABLE
-- Purpose: Analyze product category performance and revenue contribution
-- Helps identify top-performing categories and key revenue drivers
-- ============================================

DROP TABLE IF EXISTS category_summary;

CREATE TABLE category_summary AS
SELECT 
    COALESCE(ct.product_category_name_english, p.product_category_name) AS category_name,
    COUNT(oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category_name;

SELECT *
FROM category_summary
ORDER BY total_revenue DESC
LIMIT 5;

-- ============================================
-- DELIVERY SUMMARY TABLE
-- Purpose: Analyze delivery performance and delays
-- Helps understand operational efficiency and its impact on customer experience
-- ============================================

DROP TABLE IF EXISTS delivery_summary;

CREATE TABLE delivery_summary AS
SELECT 
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days,
    
    CASE 
        WHEN order_delivered_customer_date IS NULL THEN 'Not Delivered'
        WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) <= 7 THEN 'Fast Delivery'
        WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) <= 14 THEN 'Medium Delivery'
        ELSE 'Delayed'
    END AS delivery_status

FROM orders;

SELECT *
FROM delivery_summary
LIMIT 5;



-- ============================================
-- BUSINESS ANALYSIS QUERIES
-- ============================================

-- 1. MONTHLY REVENUE TREND
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    SUM(total_order_value) AS revenue
FROM order_revenue_summary
GROUP BY month
ORDER BY month;


-- 2. TOP 10 CUSTOMERS (HIGH VALUE)
SELECT 
    customer_id,
    total_spent,
    total_orders
FROM customer_summary
ORDER BY total_spent DESC
LIMIT 10;


-- 3. REPEAT CUSTOMERS
SELECT COUNT(*) AS repeat_customers
FROM customer_summary
WHERE total_orders > 1;


-- 4. CHURN BASE (CUSTOMERS WITH ONLY 1 ORDER)
SELECT COUNT(*) AS churned_customers
FROM customer_summary
WHERE total_orders = 1;


-- 5. TOP 5 CATEGORIES BY REVENUE
SELECT *
FROM category_summary
ORDER BY total_revenue DESC
LIMIT 5;


-- 6. DELIVERY PERFORMANCE DISTRIBUTION
SELECT 
    delivery_status,
    COUNT(*) AS total_orders
FROM delivery_summary
GROUP BY delivery_status;


-- ============================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ============================================


CREATE INDEX idx_orders_customer_id ON orders(customer_id(50));
CREATE INDEX idx_orders_order_id ON orders(order_id(50));
CREATE INDEX idx_order_items_order_id ON order_items(order_id(50));
CREATE INDEX idx_order_items_product_id ON order_items(product_id(50));
CREATE INDEX idx_payments_order_id ON order_payments(order_id(50));
CREATE INDEX idx_products_product_id ON products(product_id(50));
CREATE INDEX idx_orders_purchase_date ON orders(order_purchase_timestamp);

