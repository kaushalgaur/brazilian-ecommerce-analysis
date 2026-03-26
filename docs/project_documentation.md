# 📘 Project Documentation — Brazilian E-Commerce Analytics

## 📌 1. Project Objective

The goal of this project is to analyze a real-world e-commerce dataset to understand:

* Customer behavior
* Revenue drivers
* Product performance
* Business growth opportunities

---

## 📂 2. Dataset Description

Source: Kaggle (Brazilian E-Commerce Dataset)

The dataset contains ~100k orders with the following key tables:

* customers
* orders
* order_items
* order_payments
* order_reviews
* products
* sellers
* geolocation

---

## 🧹 3. Data Cleaning (SQL)

Performed using SQL:

* Removed duplicates
* Handled NULL values
* Fixed incorrect data types
* Standardized columns
* Created cleaned tables for analysis

Example:

```sql
SELECT *
FROM orders
WHERE order_purchase_timestamp IS NOT NULL;
```

---

## 🔄 4. Data Transformation (SQL)

Created business-focused tables:

* customer_summary
* product_summary
* category_summary
* delivery_summary

Purpose:

* Simplify analysis
* Improve query performance
* Enable dashboard integration

---

## 📊 5. Data Analysis (Python)

Performed exploratory data analysis using:

* Pandas
* NumPy
* Matplotlib

Analysis includes:

* Revenue trends
* Top customers
* Product/category performance
* Delivery insights
* Order distribution

---

## 💡 6. Key Insights

* Revenue is highly dependent on one-time customers
* A small group of customers drives a large portion of revenue
* Certain product categories contribute most revenue
* Delivery delays impact customer satisfaction

---

## 📈 7. Dashboard (Power BI)

Built an interactive dashboard including:

* KPI cards (Revenue, Orders, Customers, AOV)
* Monthly trends
* Customer segmentation
* Revenue breakdown
* Top customers analysis

---

## 🎯 8. Business Recommendations

* Improve customer retention strategies
* Focus on high-performing product categories
* Optimize delivery performance
* Target high-value customers for marketing

---

## 🧠 9. Learnings

* End-to-end analytics workflow
* SQL-based data modeling
* Python for EDA
* Dashboard storytelling

---

## 👤 Author

Kaushal Gaur

