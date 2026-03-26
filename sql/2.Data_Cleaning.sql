-- ============================================
-- DATA CLEANING & VALIDATION
-- Project: Olist E-Commerce Analytics
-- Purpose: Identify data quality issues before analysis
-- ============================================


-- 1. CHECK NULL VALUES IN ORDERS (DELIVERY IMPACT)
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivery_dates,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved_dates
FROM orders;


-- 2. CHECK DUPLICATE ORDERS (PRIMARY KEY VALIDATION)
SELECT 
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 3. CHECK MULTIPLE PAYMENTS PER ORDER
SELECT 
    order_id,
    COUNT(*) AS payment_count
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 4. CHECK INVALID PRICE VALUES (REVENUE IMPACT)
SELECT *
FROM order_items
WHERE price <= 0 OR freight_value < 0;


-- 5. CHECK MISSING PRODUCT CATEGORIES
SELECT *
FROM products
WHERE product_category_name IS NULL;


-- 6. CHECK REVIEW DUPLICATES (MULTIPLE REVIEWS PER ORDER)
SELECT 
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1;


