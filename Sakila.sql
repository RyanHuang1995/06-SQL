use sakila;
show columns from actor;

-- 1a.
SELECT 
    first_name, last_name
FROM
    actor;

-- 1b.
ALTER TABLE actor ADD COLUMN Actor_name VARCHAR(50);
UPDATE actor 
SET 
    Actor_name = CONCAT(first_name, ' ', last_name);

-- 2a.
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'Joe';

-- 2b.
SELECT 
    Actor_name
FROM
    actor
WHERE
    last_name LIKE '%Gen%';

-- 2c.
SELECT 
    Actor_name
FROM
    actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d.
SELECT 
    country_id, country
FROM
    country
WHERE
    country IN ('Afghanistan' , 'China', 'Bangladesh');

-- 3a.
alter table actor add column description blob;

-- 3b.
ALTER TABLE actor DROP COLUMN description;

-- 4a.
SELECT 
    last_name, COUNT(last_name)
FROM
    actor
GROUP BY last_name;

-- 4b.
SELECT 
    last_name, COUNT(last_name) AS number_of_lastname
FROM
    actor
GROUP BY last_name
HAVING number_of_lastname >= 2;

-- 4c.
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';

-- 4d.
UPDATE actor 
SET 
    first_name = 'GROUCHO'
WHERE
    first_name = 'HARPO'
        AND last_name = 'WILLIAMS';

-- 5a.
SHOW CREATE TABLE address;

-- 6a.
SELECT 
    s.first_name, s.last_name, a.address
FROM
    staff s
        JOIN
    address a ON s.address_id = a.address_id;

-- 6b.
SELECT 
    s.first_name, s.last_name, SUM(amount)
FROM
    staff s
        JOIN
    payment p ON s.staff_id = p.staff_id
WHERE
    p.payment_date LIKE '2005-08%'
GROUP BY s.staff_id;

-- 6c.
SELECT 
    f.title, COUNT(a.actor_id) AS number_of_actors
FROM
    film f
        INNER JOIN
    film_actor a ON f.film_id = a.film_id
GROUP BY a.film_id;

-- 6d.
SELECT 
    title,
    (SELECT 
            COUNT(*)
        FROM
            inventory
        WHERE
            film.film_id = inventory.film_id) AS Number_of_copies
FROM
    film
WHERE
    title = 'Hunchback Impossible';

-- 6e.
SELECT 
    c.first_name, c.last_name, SUM(p.amount)
FROM
    customer c
        JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY last_name;

-- 7a.
SELECT 
    film.title,
    (SELECT 
            name
        FROM
            language
        WHERE
            name = 'English') AS Language
FROM
    film
WHERE
    title LIKE 'Q%'
        OR title LIKE 'K%'
        AND film.language_id IN (SELECT 
            language_id
        FROM
            language
        WHERE
            name = 'English');
			
-- 7b.
SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

					
-- 7c. 
SELECT 
    first_name, last_name, email
FROM
    customer c
        INNER JOIN
    address a ON c.address_id = a.address_id
        JOIN
    city ON a.city_id = city.city_id
        JOIN
    country ON city.country_id = country.country_id
WHERE
    country = 'Canada';

-- 7d.
SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

-- 7e.
SELECT 
    f.title, f.film_id, COUNT(rental_id) AS Rental_times
FROM
    film f
        JOIN
    inventory i ON i.film_id = f.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY Rental_times DESC;

-- 7f.
SELECT 
    store.store_id, SUM(amount) AS earning
FROM
    payment p
        JOIN
    staff s ON p.staff_id = s.staff_id
        JOIN
    store ON store.store_id = s.store_id
GROUP BY store.store_id
ORDER BY earning;

-- 7g.
SELECT 
    s.store_id, c.city, country.country
FROM
    store s
        JOIN
    address a ON s.address_id = a.address_id
        JOIN
    city c ON a.city_id = c.city_id
        JOIN
    country ON country.country_id = c.country_id;
					
					
-- 7h.
SELECT 
    category.name, SUM(p.amount) AS Earning
FROM
    category
        JOIN
    film_category ON category.category_id = film_category.category_id
        JOIN
    inventory i ON i.film_id = film_category.film_id
        JOIN
    rental ON rental.inventory_id = i.inventory_id
        JOIN
    payment p ON p.rental_id = rental.rental_id
GROUP BY category.category_id
ORDER BY Earning
LIMIT 5;

-- 8a. 
CREATE VIEW Gross_Revenue_by_genres AS
    SELECT 
        category.name, SUM(p.amount) AS Earning
    FROM
        category
            JOIN
        film_category ON category.category_id = film_category.category_id
            JOIN
        inventory i ON i.film_id = film_category.film_id
            JOIN
        rental ON rental.inventory_id = i.inventory_id
            JOIN
        payment p ON p.rental_id = rental.rental_id
    GROUP BY category.category_id
    ORDER BY Earning
    LIMIT 5;

-- 8b.
SELECT 
    *
FROM
    gross_revenue_by_genres;

-- 8c.
drop view gross_revenue_by_genres; 

