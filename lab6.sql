USE sakila;

SELECT * FROM rental;
SELECT * FROM customer;
SELECT * FROM payment;


CREATE VIEW view_rental_count AS
SELECT customer.customer_id, first_name, last_name, email, COUNT(rental_id) as rental_count
FROM customer
JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, first_name, last_name, email;

CREATE TEMPORARY TABLE temp_total_paid
SELECT v.customer_id, first_name, last_name, email, SUM(amount) as total_paid
FROM view_rental_count v
JOIN payment p
ON v.customer_id = p.customer_id
GROUP BY v.customer_id, first_name, last_name, email;

# Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
# The CTE should include the customer's name, email address, rental count, and total amount paid.


WITH cte_summary_report AS (
SELECT v.customer_id, v.first_name, v.last_name, v.email, rental_count, total_paid
FROM view_rental_count as v
JOIN temp_total_paid as t
ON v.customer_id = t.customer_id)
SELECT 
    customer_id, first_name, last_name, email, rental_count, total_paid, 
    AVG(total_paid) OVER (PARTITION BY rental_count) AS average_payment_per_rental
FROM 
    cte_summary_report;



