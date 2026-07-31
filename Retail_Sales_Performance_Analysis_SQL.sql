/*======================================================================
                Retail Sales Performance Analysis using SQL
=========================================================================

Project Overview
----------------
This project analyzes the Sample Superstore dataset using SQL to uncover
business insights related to sales, profit, customers, products, regions,
and time-based performance.

Objectives
----------
• Identify top-performing products and categories.
• Analyze regional and state-wise sales.
• Evaluate customer purchasing behavior.
• Detect loss-making products.
• Perform time-series sales analysis.
• Apply advanced SQL techniques for business reporting.

SQL Concepts Demonstrated
-------------------------
✓ Aggregate Functions
✓ GROUP BY & HAVING
✓ CASE Statements
✓ Common Table Expressions (CTEs)
✓ Window Functions
✓ ROW_NUMBER()
✓ RANK()
✓ Subqueries
✓ Date Functions

Dataset
-------
Sample Superstore

Author
------
Ankita Rajpurohit

=======================================================================*/

/*=======================================================================
Dataset
-------
Sample Superstore

table
-------
orders

Rows:
9,994 records

Columns:
13

Main Fields:
- Order Date
- Customer Name
- Category
- Sub Category
- Sales
- Profit
- Region
- State
- Customer Segment
=======================================================================*/

/*======================================================================
SECTION 1 : SALES PERFORMANCE ANALYSIS
======================================================================*/


/*====================================================================
Question 1. Which product categories generated the highest total sales?
====================================================================*/

SELECT 
    category,
    SUM(sales) AS total_sales
FROM orders
GROUP BY category
ORDER BY total_sales DESC;


/*
Business Insight:

This analysis identifies the strongest revenue-generating categories.

The highest-performing categories should receive priority in:
- Inventory planning
- Marketing campaigns
- Sales strategies

Lower-performing categories can be analyzed for improvement opportunities.
*/



/*====================================================================
Question 2. How many total orders are present in the dataset?
====================================================================*/

SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;


/*
Business Insight:

This provides the total number of unique orders placed.

Order volume helps understand:
- Customer activity
- Business scale
- Sales performance over time
*/



/*====================================================================
Question 3. Which 5 product categories and sub-categories generated
the highest total sales?
====================================================================*/

SELECT 
    category,
    sub_category,
    SUM(sales) AS total_sales
FROM orders
GROUP BY category, sub_category
ORDER BY total_sales DESC
LIMIT 5;


/*
Business Insight:

These sub-categories represent the major revenue drivers.

The business can focus on:
- Maintaining inventory availability
- Promoting high-performing products
- Expanding successful product lines
*/



/*====================================================================
Question 4. Which regions generated the highest sales?
====================================================================*/

SELECT 
    region,
    SUM(sales) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;


/*
Business Insight:

Regional sales analysis identifies strong and weak markets.

High-performing regions can receive more investment,
while lower-performing regions can be improved through:
- Targeted campaigns
- Customer research
- Regional promotions
*/



/*====================================================================
Question 5. Which states generated the highest sales?
====================================================================*/

SELECT 
    state,
    SUM(sales) AS total_sales
FROM orders
GROUP BY state
ORDER BY total_sales DESC;


/*
Business Insight:

State-level analysis helps identify important markets.

High-sales states represent strong customer demand
and should receive focus for:
- Inventory availability
- Customer retention
- Expansion strategies
*/



/*====================================================================
Question 6. What are the monthly sales trends?
====================================================================*/

SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS total_sales
FROM orders
GROUP BY month
ORDER BY month;


/*
Business Insight:

Monthly sales trends help identify seasonal patterns
and changes in customer demand.

This analysis helps the business:
- Plan inventory levels
- Schedule marketing campaigns
- Identify peak sales periods
- Prepare for slow-performing months
*/



/*====================================================================
Question 7. Which year generated the highest sales?
====================================================================*/

SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales) AS total_sales
FROM orders
GROUP BY year
ORDER BY total_sales DESC;


/*
Business Insight:

Yearly sales analysis helps measure business growth
and identify the strongest-performing years.

The company can investigate:
- Reasons behind growth
- Successful strategies
- Market changes affecting performance
*/


/*======================================================================
SECTION 2 : PROFIT & PRODUCT ANALYSIS
======================================================================*/


/*====================================================================
Question 8. Which product categories generated the highest profit?
====================================================================*/

SELECT 
    category,
    SUM(profit) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;


/*
Business Insight:

Sales revenue does not always indicate profitability.

This analysis identifies which categories contribute the most profit,
helping the business focus on products that generate higher returns.

High-profit categories can receive:
- More marketing investment
- Better inventory planning
- Increased promotion efforts
*/



/*====================================================================
Question 9. Which products generated the highest profit?
====================================================================*/

SELECT 
    product_name,
    SUM(profit) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


/*
Business Insight:

Identifies the most profitable products in the business.

These products can be prioritized for:
- Inventory availability
- Product promotion
- Customer recommendations

Understanding profitable products helps maximize business returns.
*/



/*====================================================================
Question 10. Which products generated the highest sales?
====================================================================*/

SELECT 
    product_name,
    SUM(sales) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


/*
Business Insight:

This identifies products that contribute the most revenue.

High-sales products should be monitored to ensure:
- Sufficient stock availability
- Effective pricing strategies
- Continuous customer demand
*/



/*====================================================================
Question 11. Which products generate high sales but low profit?
====================================================================*/

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC;


/*
Business Insight:

Products with high sales but low profit may be heavily discounted or have high costs. 
These products should be reviewed to improve profitability.

Possible reasons:
- Excessive discounts
- High shipping costs
- Low pricing margins
- Operational inefficiencies

These products should be reviewed for pricing and cost optimization.
*/


/*======================================================================
SECTION 3 : CUSTOMER ANALYSIS
======================================================================*/


/*====================================================================
Question 12. Which customers generated the highest sales?
====================================================================*/

SELECT 
    customer_name,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;


/*
Business Insight:

This identifies the most valuable customers based on revenue contribution.

The business can focus on:
- Customer retention programs
- Loyalty rewards
- Personalized offers

Retaining high-value customers can significantly impact revenue.
*/



/*====================================================================
Question 13. Rank customers based on total sales.
====================================================================*/

WITH customer_ranking AS
(
SELECT 
    customer_name,
    SUM(sales) AS total_sales,
    RANK() OVER(
        ORDER BY SUM(sales) DESC
    ) AS customer_rank
FROM orders
GROUP BY customer_name
)

SELECT *
FROM customer_ranking
WHERE customer_rank <= 10;


/*
Business Insight:

Customer ranking helps identify the highest-value customers
and compare their contribution to overall revenue.

Top-ranked customers can be targeted with:
- Premium services
- Exclusive rewards
- Personalized marketing campaigns
*/



/*====================================================================
Question 14. Which customers spend above the average customer spending?
====================================================================*/

SELECT 
    customer_name,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customer_name
HAVING SUM(sales) >
(
    SELECT AVG(total_sales)
    FROM
    (
        SELECT 
            customer_name,
            SUM(sales) AS total_sales
        FROM orders
        GROUP BY customer_name
    ) customer_total
)
ORDER BY total_sales DESC;


/*
Business Insight:

This identifies customers who spend more than the average customer.

These high-value customers can be targeted through:
- Loyalty programs
- Premium products
- Personalized promotions

They represent important revenue opportunities.
*/



/*====================================================================
Question 15. Segment customers based on total spending.
====================================================================*/

WITH customer_sales AS
(
    SELECT 
        customer_name,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_name
)

SELECT 
    customer_name,
    total_sales,
    CASE
        WHEN total_sales >= 10000 THEN 'Platinum'
        WHEN total_sales >= 5000 THEN 'Gold'
        ELSE 'Silver'
    END AS customer_segment
FROM customer_sales
ORDER BY total_sales DESC;


/*
Business Insight:

Customer segmentation helps divide customers based on their
purchasing value.

Business strategies:

Platinum:
- Exclusive rewards
- Premium services

Gold:
- Retention campaigns
- Upselling opportunities

Silver:
- Promotions to increase spending

This helps improve customer relationship management.
*/



/*======================================================================
SECTION 4 : ADVANCED PRODUCT ANALYSIS
======================================================================*/


/*====================================================================
Question 16. What is the top-selling product in each category?
====================================================================*/

WITH product_sales AS
(
    SELECT
        category,
        product_name,
        SUM(sales) AS total_sales,

        ROW_NUMBER() OVER(
            PARTITION BY category
            ORDER BY SUM(sales) DESC
        ) AS product_rank

    FROM orders
    GROUP BY category, product_name
)

SELECT
    category,
    product_name,
    total_sales
FROM product_sales
WHERE product_rank = 1;


/*
Business Insight:

This identifies the highest-selling product within each category.

The business can use this information to:

- Maintain sufficient inventory
- Promote successful products
- Understand customer preferences within categories

Top-performing products should be monitored closely
to avoid stock shortages.
*/



/*====================================================================
Question 17. What percentage of total sales does each category contribute?
====================================================================*/

SELECT
    category,
    SUM(sales) AS category_sales,

    ROUND(
        SUM(sales) * 100.0 /
        SUM(SUM(sales)) OVER(),
        2
    ) AS sales_percentage

FROM orders
GROUP BY category;


/*
Business Insight:

This analysis shows how much each category contributes
to overall revenue.

It helps the business understand:

- Which categories drive the majority of sales
- Where marketing efforts should be focused
- How dependent revenue is on specific categories

High-contribution categories should receive priority
for inventory and growth strategies.
*/



/*======================================================================
SECTION 5 : ADVANCED BUSINESS ANALYSIS
======================================================================*/


/*====================================================================
Question 18. Find the top 3 customers in each state based on total sales.
====================================================================*/

WITH customer_state_sales AS
(
    SELECT
        state,
        customer_name,
        SUM(sales) AS total_sales,

        RANK() OVER(
            PARTITION BY state
            ORDER BY SUM(sales) DESC
        ) AS customer_rank

    FROM orders
    GROUP BY state, customer_name
)

SELECT
    state,
    customer_name,
    total_sales,
    customer_rank
FROM customer_state_sales
WHERE customer_rank <= 3
ORDER BY state, customer_rank;


/*
Business Insight:

This identifies the highest-value customers in each state.

The business can use this information for:

- Regional loyalty programs
- Personalized offers
- Customer retention strategies

Understanding regional customer behavior helps improve
location-based marketing decisions.
*/



/*====================================================================
Question 19. Which month generated the highest sales in each year?
====================================================================*/

WITH monthly_sales AS
(
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales

    FROM orders
    GROUP BY year, month
),

ranked_months AS
(
    SELECT
        year,
        month,
        total_sales,

        RANK() OVER(
            PARTITION BY year
            ORDER BY total_sales DESC
        ) AS month_rank

    FROM monthly_sales
)

SELECT
    year,
    month,
    total_sales
FROM ranked_months
WHERE month_rank = 1
ORDER BY year;


/*
Business Insight:

This identifies the strongest sales month for each year.

The business can analyze these peak periods to understand:

- Seasonal demand
- Successful promotions
- Customer buying patterns

These insights can help plan future campaigns
during high-demand periods.
*/



/*====================================================================
Question 20. Calculate cumulative sales contribution by customer.
====================================================================*/

WITH customer_sales AS
(
    SELECT
        customer_name,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_name
)

SELECT
    customer_name,
    total_sales,

    SUM(total_sales) OVER(
        ORDER BY total_sales DESC
    ) AS cumulative_sales

FROM customer_sales
ORDER BY total_sales DESC;


/*
Business Insight:

This analysis shows how much revenue is contributed by customers
from highest to lowest spending.

It helps identify:

- Whether revenue depends on a small group of customers
- High-value customer concentration
- Customer retention priorities

The business can focus retention efforts on customers
contributing the majority of revenue.
*/



/*====================================================================
Question 21. Which categories have the highest profit margin?
====================================================================*/

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 / SUM(sales),
        2
    ) AS profit_margin_percentage

FROM orders
GROUP BY category
ORDER BY profit_margin_percentage DESC;

/*
Business Insight:

Profit margin analysis helps identify which categories generate
the highest returns compared to their sales revenue.

A category with high sales does not always mean it is the most
profitable. Categories with higher profit margins indicate better
cost efficiency and stronger pricing strategies.

The business can use these insights to:

- Prioritize high-margin categories for marketing and growth.
- Optimize pricing strategies for low-margin categories.
- Review discounts and operational costs affecting profitability.
- Allocate resources toward categories that generate better returns.

This helps improve overall profitability rather than focusing
only on revenue growth.
*/




/*======================================================================
PROJECT SUMMARY
======================================================================

Project: Retail Sales Performance Analysis using SQL

Dataset:
Sample Superstore Dataset


Key Analysis Performed:

1. Sales Performance Analysis
   - Analyzed category, regional, state, and yearly sales performance.
   - Identified major revenue contributors and sales trends.


2. Profit & Product Analysis
   - Evaluated profitable categories and products.
   - Identified loss-making products requiring pricing and strategy review.


3. Customer Analysis
   - Identified high-value customers.
   - Ranked customers based on revenue contribution.
   - Created customer segments based on spending behavior.


4. Advanced Business Analysis
   - Used CTEs and Window Functions for deeper insights.
   - Ranked products and customers using analytical functions.
   - Identified peak sales periods and regional customer leaders.
   - Monitored customer revenue concentration to reduce dependency
     on a small group of high-value customers.


5. Monitor customer revenue concentration to reduce dependency
   on a small group of high-value customers.

   
SQL Concepts Demonstrated:

✓ Aggregate Functions
✓ Window Functions
✓ Ranking Functions
✓ Subqueries
✓ Common Table Expressions (CTEs)
✓ CASE Statements
✓ Date Functions
✓ Business Analytics Queries


Business Recommendations:

1. Focus marketing efforts on high-performing categories
   and regions.

2. Maintain inventory availability for top-selling products.

3. Review loss-making products to optimize pricing,
   discounts, and operational costs.

4. Build loyalty programs for high-value customers.

5. Use seasonal sales patterns to plan future campaigns.


======================================================
PROJECT SUMMARY
======================================================

Key Findings

• Technology generated the highest revenue.

• California and New York were the strongest markets.

• A small number of customers contribute a significant
portion of total sales.

• Several products generated negative profit and should
be reviewed.

• Sales exhibit seasonal trends that can guide future
marketing campaigns.

======================================================