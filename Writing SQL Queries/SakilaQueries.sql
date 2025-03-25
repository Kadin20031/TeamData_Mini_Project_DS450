-- loading data
USE sakila;
-- show all tables in the dataset
SHOW tables;

-- Single Table Queries

-- 1. Get a list of all film �tles alphabe�zed by �tle.

-- 2. Find the descrip�on, release year, length, and ra�ng for the movie “KENTUCKIAN GIANT”.

-- 3. Find the first name and last name of each employee (staff table). Your query should include the
-- last name first, and then the first name.

-- 4. Repeat the query above, but this �me, the results should include only one column with the
-- format last name, first name. The output column should be named “name”

-- 5. Get the number of customers. The output should be a single number. Name the column
-- “num_customers”

-- 6. Get the number of customers who are ac�ve vs inac�ve in the system.

-- 7. Get the average amount a customer spends on a rental.

-- 8. Get maximum amount any customer has spent on a rental.

-- 9. Get a list of the actors. The results should include only one column with the format last
-- name, first name. The column should be named “actor_name” The results should be
-- sorted be sorted alphabe�cally by the last name (ascending).

-- 10. Repeat this query above, but the results should be in reverse order.

-- 11. Repeat the query again, this �me get only actors whose last names start with ‘M’ or ‘V’. Order
-- the results alphabe�cally by last name (ascending).

-- 12. Repeat the query again, this �me get only actors whose last names start with leters between
-- ‘M’ and ‘V’ inclusive. Order the results alphabe�cally by last name (ascending).



-- Multi-Table Queries

-- 1. Get a list of category names and a count of movies that fall into that category. Name the
-- category column “category” the count column “num_films”. Order the results alphabetically
-- (ascending). Use the WHERE clause to join the tables.

SELECT c.name AS category, COUNT(f.film_id) AS num_films
FROM category c, film_category fc, film f
WHERE c.category_id = fc.category_id 
AND fc.film_id = f.film_id
GROUP BY c.name
ORDER BY c.name ASC;


-- 2. Repeat the query above using a JOIN clause instead of the WHERE clause.

SELECT c.name AS category, COUNT(f.film_id) AS num_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY c.name ASC;


-- 3. Get a list of country names and a count of the cites that are in that country. Name the count
-- column “num_cites”. Order the results alphabetically (ascending). Use the WHERE clause to join
-- the tables.

SELECT co.country AS country, COUNT(ci.city_id) AS num_cities
FROM country co, city ci
WHERE co.country_id = ci.country_id
GROUP BY co.country
ORDER BY co.country ASC;


-- 4. Repeat the query above using a JOIN clause instead of the WHERE clause.

SELECT co.country AS country, COUNT(ci.city_id) AS num_cities
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
ORDER BY co.country ASC;


-- 5. Get a list of each customer’s last name and first name and the number of rentals they have.
-- Name the count column “num_rentals”. Order the result by the number of rentals in descending
-- order. The highest number of rentals should be at the top. Sort any �es (same number of rentals)
-- by last name (ascending). Use the WHERE clause to join the tables.

SELECT cu.last_name, cu.first_name, COUNT(r.rental_id) AS num_rentals
FROM customer cu, rental r
WHERE cu.customer_id = r.customer_id
GROUP BY cu.last_name, cu.first_name
ORDER BY num_rentals DESC, cu.last_name ASC;


-- 6. Repeat the query above using a JOIN clause instead of the WHERE clause.

SELECT cu.last_name, cu.first_name, COUNT(r.rental_id) AS num_rentals
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
GROUP BY cu.last_name, cu.first_name
ORDER BY num_rentals DESC, cu.last_name ASC;


-- 7. Get a list of each customer’s last name and first name and the amount of money they have spent
-- on rentals. Name the sum column “total_spent”. Order the result by the amount in descending
-- order. The highest amount of money spent should be at the top. Sort any ties (amount of money
-- spent) by last name (ascending). Use the JOIN clause for this query.

SELECT cu.last_name, cu.first_name, SUM(p.amount) AS total_spent
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cu.last_name, cu.first_name
ORDER BY total_spent DESC, cu.last_name ASC;


-- 8. Get the number of actors in each film. Order the results (ascending) by the film title and name
-- the column with the actor count “num_actors”.

SELECT f.title AS film_title, COUNT(fa.actor_id) AS num_actors
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.title
ORDER BY f.title ASC;


-- 9. Get the number of films each manager holds. Use only the manager staff id to identify the
-- manager. Name the column with the number of films “num_films”.

SELECT s.staff_id AS manager_id, COUNT(i.film_id) AS num_films
FROM staff s
JOIN store st ON s.store_id = st.store_id
JOIN inventory i ON st.store_id = i.store_id
GROUP BY s.staff_id;


-- 10. Get the number of customers per manager. Use only the manager staff id to identify the
-- manager. Name the column with the number of films “num_customers”. Order by store id
-- (ascending).

SELECT s.staff_id AS manager_id, COUNT(c.customer_id) AS num_customers
FROM staff s
JOIN store st ON s.store_id = st.store_id
JOIN customer c ON st.store_id = c.store_id
GROUP BY s.staff_id, st.store_id
ORDER BY st.store_id ASC;


-- 11. Get the title and film category of each film. Order the results by category name. Rename the
-- “name” column so it says “category”. This query will involve joining three tables using the JOIN
-- syntax.

SELECT f.title AS film_title, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY c.name ASC;


-- 12. Get a list of each customer’s first and last name (individually, not concatenated) and their full
-- address including city and country. Order the results by the customer’s last name. This will
-- involve joining four tables using the JOIN syntax.

SELECT cu.first_name, cu.last_name, a.address, a.district, ci.city, co.country
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY cu.last_name ASC;


-- 13. Repeat the query above except this time include only inactive customers from China.

SELECT cu.first_name, cu.last_name, a.address, a.district, ci.city, co.country
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE cu.active = 0 AND co.country = 'China'
ORDER BY cu.last_name ASC;


-- 14. Get a list of the titles of every film each customer has rented. Order the results by customer last
-- name (ascending) and title (ascending).

SELECT cu.last_name, cu.first_name, f.title AS film_title
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY cu.last_name ASC, f.title ASC;


-- 15. Repeat the query above, but this time, include the category of each title in the results. Name the
-- category column “category”. Order the results by the same columns (name and title).

SELECT cu.last_name, cu.first_name, f.title AS film_title, c.name AS category
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY cu.last_name ASC, f.title ASC;


-- 16. Get a list of each customer that includes their first and last name, the number of rentals
-- (num_rentals) they have had and the total amount (total_spent) of money they have spent on
-- rentals. Order the results by last name (ascending).

SELECT cu.first_name, cu.last_name, 
       COUNT(r.rental_id) AS num_rentals, 
       SUM(p.amount) AS total_spent
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cu.first_name, cu.last_name
ORDER BY cu.last_name ASC;


-- 17. Repeat the query above, but this time add the customer’s country to the output. The order of
-- the columns should be last_name, first_name, country, num_rentals, total_spent. Order rows by
-- last name (ascending)

SELECT cu.last_name, cu.first_name, co.country, 
       COUNT(r.rental_id) AS num_rentals, 
       SUM(p.amount) AS total_spent
FROM customer cu
JOIN rental r ON cu.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY cu.last_name, cu.first_name, co.country
ORDER BY cu.last_name ASC;

