
/*Desafio IT : Consultas SQL - Desafio Schema Cine_MP*/


Use cine;
/* Revisiones de cada tabla */
SELECT * FROM cartelera;
SELECT * FROM cine;
SELECT * FROM pelicula;
/*1.¿Qué películas se están proyectando? */
SELECT DISTINCT c.id_pelicula, p.nombre 
FROM cartelera c 
	JOIN pelicula p 
		ON c.id_pelicula = p.id;
/* 1. Respuesta se estan proyectando 57 peliculas */ 

/* Actualizar las películas que no tengan clasificación de edad */

UPDATE pelicula
SET clasificacion_edad=0
WHERE clasificacion_edad IS NULL;

/* 2. ¿Qué películas son para todos los públicos?
Buscar peliculas con clasificacion_edad = 0 */

SELECT DISTINCT c.id_pelicula, p.nombre, p.clasificacion_edad
FROM cartelera c
	JOIN pelicula p 
		ON c.id_pelicula = p.id
WHERE clasificacion_edad= 0
ORDER BY nombre;
/* 2. Respuesta hay 17 películas que son para todos los públicos*/ 

/* Crear una lista con los cines disponibles en el momento */
SELECT DISTINCT cn.*
FROM cine cn
JOIN cartelera ct
		ON ct.id_cine = cn.id;
        
/* Hay 16 cines presentando películas*/ 

/* ¿Qué película se esta proyectando en cada cine y decidir a que cine ir? */

SELECT DISTINCT cn.id,cn.nombre, cn.estado,cn.pais,ct.id_pelicula, p.nombre, p.clasificacion_edad
FROM cine cn
	JOIN cartelera ct
		ON ct.id_cine = cn.id
			JOIN pelicula p
				ON ct.id_pelicula = p.id
					ORDER BY p.nombre;
                    
/* Actualizar la base de datos, eliminando los cines no disponibles - no estan proyectando ninguna pelicula*/

DELETE 
FROM cine
WHERE id IN(
	SELECT id
    FROM (
	SELECT cn.id
	FROM cine cn
		LEFT JOIN cartelera ct
			ON ct.id_cine = cn.id
				WHERE ct.id_cine IS NULL)AS cine_delete);	
                   
                   
/* 3.¿Que películas se estan presentando en Dublín?Generar una lista de cines en Dublín,Irlanda */
            
SELECT DISTINCT cn.nombre, cn.estado,cn.pais, p.nombre, p.clasificacion_edad
FROM cine cn
	JOIN cartelera ct
		ON ct.id_cine = cn.id
			JOIN pelicula p
				ON ct.id_pelicula = p.id
					WHERE estado = 'Dublín';

/* 3.Respuesta en Dublín se estan presentando 23 películas con distintas clasificaciones de edad */

/* Incluir la tabla género de las películas */

DROP TABLE IF EXISTS genero;
CREATE TABLE genero (
  id INTEGER NOT NULL auto_increment,
  genero_pelicula VARCHAR(100),
  primary key (id)
);

INSERT INTO genero
  (genero_pelicula)
VALUES
  ('Acción'),
  ('Aventura'),
  ('Ciencia Ficción'),
  ('Comedia'),
  ('Drama'),
  ('Fantasía'),
  ('Suspenso'),
  ('Terror');

select * from genero; /* verificar */

/* Asociar el género a cada una de las películas de la base de datos -agregar campo_id a la tabla de películas*/

ALTER TABLE pelicula ADD id_genero INTEGER NULL;

SELECT * from pelicula; /* verificar */

ALTER TABLE pelicula 
ADD constraint fk_pelicula_genero 
foreign key (id_genero)
references genero(id);


UPDATE pelicula 
SET id_genero = 
CASE 
    WHEN id BETWEEN 1 AND 10 THEN (SELECT id FROM genero WHERE genero_pelicula = 'Terror')
    WHEN id BETWEEN 11 AND 20 THEN (SELECT id FROM genero WHERE genero_pelicula = 'Ciencia Ficción')
    WHEN id BETWEEN 20 AND 45 THEN (SELECT id FROM genero WHERE genero_pelicula = 'Comedia')
    WHEN id BETWEEN 46 AND 55 THEN (SELECT id FROM genero WHERE genero_pelicula = 'Suspenso')
    WHEN id > 55 THEN (SELECT id FROM genero WHERE genero_pelicula = 'Acción')
END;

/* 4. ¿Qué películas se están proyectando de Suspenso con clasificacion edad de 18, en la ciudad de Madrid ? */

SELECT cn.nombre, cn.estado,cn.pais, p.nombre, p.clasificacion_edad, g.genero_pelicula
FROM cine cn
	JOIN cartelera ct
		ON ct.id_cine = cn.id
			JOIN pelicula p
				ON ct.id_pelicula = p.id
					JOIN genero g
						ON p.id_genero = g.id
				WHERE cn.estado = 'Madrid' and cn.pais='España'
                and p.clasificacion_edad=18 and g.genero_pelicula ='Suspenso';

/* 4. Respuesta: Las películas que se están proyectando de Suspenso,con clasificacion edad de 18, en la ciudad de Madrid son 3 películas: Corrompido Por El Final,
Encantamiento De Mi Futuro y Maldición De Las Cuevas */


