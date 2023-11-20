-- Margarita Obrador Almodóvar. Promo F - DataAnalytics Adalab - 2023

USE sakila; 

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS "Título", count(title) AS "num_veces"
FROM film
GROUP by title; 

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title AS "Título", rating AS "Clasificación"
FROM film
WHERE rating = "PG-13"; 

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS "Título", description AS "Descripción"
FROM film
WHERE description LIKE "%amazing%"; 

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title AS "Título", length AS "Duración"
FROM film
WHERE length > 120;

-- 5. Recupera los nombres de todos los actores.

SELECT first_name AS "Nombre"
FROM actor; 

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor
WHERE last_name LIKE "%Gibson%";

SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor
WHERE last_name = "Gibson";


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name AS "Nombre", last_name AS "Apellido", actor_id "ID del actor"
FROM actor 
WHERE actor_id BETWEEN 10 AND 20; 

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title AS "Título", rating AS "Clasificación"
FROM film
WHERE rating <> "R" AND rating <> "PG-13";

SELECT title AS "Título", rating AS "Clasificación"
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating AS "Clasificación", count(rating)AS "Recuento"
FROM film
GROUP BY rating; 

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
	customer.customer_id AS "ID cliente", 
	CONCAT(customer.first_name, " ", customer.last_name) AS "Cliente", 
	COUNT(rental.inventory_id) AS "pelis alquiladas"
FROM customer
LEFT JOIN rental ON rental.customer_id = customer.customer_id 
GROUP BY 
	customer.customer_id, 
	CONCAT(customer.first_name, " ", customer.last_name);

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT 
    category.name AS "Categoría", 
    COUNT(rental.inventory_id) AS "Q alquileres"
FROM category 
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film.film_id
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY category.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT AVG(length) AS "Promedio", rating AS "Clasificación"
FROM film 
GROUP BY rating; 

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT film.title AS "Titulo", CONCAT(actor.first_name, " " ,actor.last_name) AS "Nombre completo"
FROM film
LEFT JOIN film_actor ON film_actor.film_id = film.film_id
LEFT JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE film.title = "Indian Love";

-- nota: no puedo usar el group by/having ya que no filtro por resultados despues de que se han agrupado. Realizo agrupación por una VAR de la tabla. REVISAR

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title AS "Título", description AS "Descripción"
FROM film
WHERE description LIKE "%dog%" OR description LIKE "%cat%"; 

-- 15. Hay algún  "actor"? que no aparecen en ninguna película en la tabla film_actor.
-- ¿Hay algun actor que esté en "actor" pero no esté en "film_actor"? 

-- 1 version: 
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id IS NULL;

-- 2 version 
SELECT *
FROM actor
WHERE actor_id NOT IN (
    SELECT actor_id
    FROM film_actor
);

-- devuelve vacío) está OK! 

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title AS "Título", release_year AS "Año estreno"
FROM film
WHERE release_year BETWEEN 2005 AND 2010; 

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT film.title AS "Nombre peli", category.name AS "Categoría"
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Family"; 


-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name AS "Nombre", actor.last_name AS "Apellido", COUNT(film_actor.film_id) AS "Recuento"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY 
	actor.actor_id
HAVING 
    COUNT(film_actor.film_id) > 10
    ORDER BY  
    COUNT(film_actor.film_id); 
    
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title AS "Titulo", rating AS "Clasificación", length AS "Duración"
FROM film
WHERE rating = "R" AND length >120
ORDER BY length; 

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT AVG(length) AS "Duración media", rating AS "Clasificación"
FROM film
GROUP BY rating
HAVING AVG(length) > 120; 

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.


SELECT CONCAT(actor.first_name, " ", actor.last_name) AS "Actor/Actriz", COUNT(film_actor.film_id) AS "Num pelis"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY 
	actor.actor_id
HAVING 
    COUNT(film_actor.film_id) > 5
    ORDER BY COUNT(film_actor.film_id); 


 -- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
 -- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
 
 -- 1er paso: seleccionar los rental_ids con más de 5 días de diferencia entre rental_date y return_date
SELECT rental_id AS "ID de alquiler"
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5;

-- 2nd paso: seleccionar las el titulo de las pelis 

SELECT DISTINCT title
FROM film; 

-- 3er paso: relacionarlas: 
-- No están directamente relacionadas. film_id no está en rental. por lo que recorro mediante JOINS hasta llegar y poder hacer la subquery. 

-- haciend joins + subquery (en esta he dejado los días para confirmar) 
SELECT DISTINCT film.title AS "Titulo", DATEDIFF(return_date, rental_date) AS "días"
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN (
    SELECT rental_id FROM rental WHERE rental_id IN 
    (SELECT rental_id
FROM rental
        WHERE DATEDIFF(return_date, rental_date) > 5
    )
);



-- haciendo todo subqueries anidadas: 

SELECT DISTINCT title AS "Nombre peli"
FROM film 
WHERE film_id IN 
	(SELECT film_id FROM inventory WHERE inventory_id IN 
		(SELECT inventory_id FROM rental WHERE rental_id IN(
			(SELECT rental_id FROM rental WHERE DATEDIFF(return_date, rental_date) > 5))));  


 -- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
 -- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
 
 SELECT first_name AS "Nombre", last_name AS "Apellido"
 FROM actor
 WHERE actor_id IN 
	(SELECT actor_id FROM film_actor WHERE film_id IN 
		(SELECT film_id FROM film_category WHERE category_id IN 
			(SELECT category_id FROM category WHERE name <> "Horror"))); 
            

 
 -- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
 
 -- 1er paso: inicio
SELECT title, length
FROM film
WHERE length > 180; 
 -- 2nd paso: final
SELECT name
FROM category
WHERE name = "Comedy"; 

 -- a recorrer: 

SELECT title AS "Titulo" FROM film WHERE film_id IN 
	(SELECT film_id FROM film_category WHERE category_id IN 
		(SELECT category_id FROM category WHERE name = "Comedy")) 

AND length > 180; 
 
 -- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
 -- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
 
-- aqui tengo que leer dos veces sobre la misma tabla. por lo que leo: 
-- el actor dos veces para separarlo por actor 1 y actor 2 y poder comparar. 
-- haho el count total de filas para recoger todas las filas que complirán mis condiciones:  
SELECT CONCAT(actor1.first_name, ' ', actor1.last_name) AS "actor_1",
       CONCAT(actor2.first_name, ' ', actor2.last_name) AS "actor_2",
       COUNT(*) AS "num_pelis_juntos"
-- leo la tabla de film actor 1 vez y la JUNTO con la segunda vez que la leo SI el film id de las dos coincide PERO el id del actor no (para evitar duplicados de combinaciones)
FROM film_actor film_actor1
JOIN film_actor film_actor2 ON film_actor1.film_id = film_actor2.film_id AND film_actor1.actor_id <> film_actor2.actor_id
-- leo el actor1 y lo JUNTO SI el id del actor 1 es igual al Id del actor 1 en la tabla de film_actor
JOIN actor actor1 ON film_actor1.actor_id = actor1.actor_id
-- lo mismo para actor 2 
JOIN actor actor2 ON film_actor2.actor_id = actor2.actor_id
-- lo agrupo por las columnas de actor_1 y actor_2 y filtro por el count que sea mayor a 1 (num de filas (combinaciones) q hay despues de que haya hecho la agrupacón de filmactor x2 y actor x2). 
GROUP BY CONCAT(actor1.first_name, ' ', actor1.last_name), CONCAT(actor2.first_name, ' ', actor2.last_name)
HAVING COUNT(*) >= 1;



-- pruebas (making off) 
SELECT concat(first_name, " ", last_name),
       COUNT(*) 
       FROM actor
       GROUP BY concat(first_name, " ", last_name); 