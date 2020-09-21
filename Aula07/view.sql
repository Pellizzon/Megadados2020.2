USE sakila;

DROP VIEW IF EXISTS movie_count;

CREATE VIEW movie_count AS
    SELECT 
        title, COUNT(rental_id) as cnt
    FROM
        film
        LEFT OUTER JOIN inventory USING (film_id)
        LEFT OUTER JOIN rental USING (inventory_id)
    GROUP BY
        film_id
    ORDER BY
        cnt ASC;