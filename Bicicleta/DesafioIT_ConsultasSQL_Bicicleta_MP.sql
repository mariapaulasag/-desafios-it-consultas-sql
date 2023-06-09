/*Desafio IT : Consultas SQL - Desafio Schema Bicicleta_MP*/

Use bicicleta;

/* Revisiones de cada tabla */
SELECT * FROM categoria; /* 10 rows */
SELECT * FROM cliente; /* 60 rows */
SELECT * FROM detalle_factura; /* 199 rows */
SELECT * FROM empleado; /* 5 rows */
SELECT * FROM factura; /* 108 rows */
SELECT * FROM marca; /* 4 rows */
SELECT * FROM producto; /* 51 rows */


/* 1.Generar una lista de todas las bicicletas de tipo montaña que no pertenezcan a la marca Escoza */
SELECT p.nombre,p.precio, m.nombre as marca_bicicletas
FROM  producto p
	JOIN  categoria c
		ON c.id = p.id_categoria
			JOIN marca m
				ON p.id_marca = m.id
WHERE c.nombre='Montaña' AND m.nombre NOT LIKE 'Escoza';

/* 1.Respuesta solo hay una bicicleta tipo montaña que no pertenece a la marca Escoza */

/* 2.Generar una lista de  bicicletas con rango de precio $400 y $600 */

SELECT c.nombre as tipo_bicicleta, p.nombre,p.precio, m.nombre as marca_bicicletas
FROM categoria c
	JOIN  producto p
		ON c.id = p.id_categoria
			JOIN marca m
				ON p.id_marca = m.id
WHERE p.precio BETWEEN 400 AND 600
ORDER BY p.precio;

/* 2.Respuesta Hay 8 bicicletas que estan dentro del rango de precio de  $400 y $600 */

/* 3. Cuáles son las bicicletas que tienen un precio por encima del promedio de todas las demás.*/

SELECT c.nombre as tipo_bicicleta, p.nombre,p.precio, m.nombre as marca_bicicletas
FROM categoria c
	JOIN  producto p
		ON c.id = p.id_categoria
			JOIN marca m
				ON p.id_marca = m.id
WHERE p.precio > (SELECT AVG(p.precio) FROM producto p)
ORDER BY p.precio;

/* 3.Respuesta Hay 29 bicicletas que tienen un precio (el precio promedio es $917)por encima del promedio de todas las demás */

/* 4. Obtener una lista de clientes cuyas facturas hayan tenido un monto total igual o superior a $4500 */

SELECT f.id_cliente,f.fecha,cl.nombre,cl.apellido,cl.telefono,cl.email,SUM(dt_ft.cantidad*dt_ft.precio_unitario) as ventas
FROM factura f
JOIN  cliente cl
		ON f.id_cliente= cl.id
			JOIN detalle_factura dt_ft
					ON f.id = dt_ft.id_factura
                    GROUP BY f.id, cl.id
                    HAVING ventas >= 4500 
							ORDER BY ventas; 
						
/* 4.Respuesta Hay 11 Clientes que han comprado un monto total igual o superior a $4500 en la tienda*/

/* 5.Generar lista de bicicletas híbridas y urbanas disponibles en Bicitemp */

SELECT p.nombre,p.precio, m.nombre as marca_bicicletas, c.nombre as tipo_bicileta
FROM  producto p
	JOIN  categoria c
		ON c.id = p.id_categoria
			JOIN marca m
				ON p.id_marca = m.id
					WHERE c.nombre IN ('Urbanas', 'Híbridas');
/* 5.Respuesta Hay 15 bicicletas híbridas y urbanas disponibles en Bicitemp  */


/* 6. Etiquetar las bicicletas segun la cantidad vendida 
Indicar id bicicleta, nombre-modelo, cantidad vendida y etiqueta 
Etiqueta mas de 10: muy vendidas 
7-10 : vendidas
 menos de 7 : menos vendidas */

SELECT p.id, p.nombre, SUM(dt_ft.cantidad) as total_cantidad,
       CASE
           WHEN SUM(dt_ft.cantidad) > 10 THEN 'Muy Vendidas'
           WHEN SUM(dt_ft.cantidad) >= 7 THEN 'Vendidas'
           WHEN SUM(dt_ft.cantidad) < 7 THEN 'Menos Vendidas'
       END AS etiqueta
FROM producto p
	JOIN detalle_factura dt_ft 
		ON p.id = dt_ft.id_producto
GROUP BY p.id
ORDER BY total_cantidad DESC;

/* 6.Respuesta En la lista generada se puede ver que existen 4 tipos de bicicletas que son Muy Vendidas */

/* 7. Etiquetar todas las bicicletas de la categoría Motocross como bicicletas para competencia y todas las demás como recreativas
Mostrar ID, modelo y etiqueta */

SELECT p.id,p.nombre, c.nombre as categoria,
CASE
	WHEN c.nombre = 'Motocross' THEN 'bicicletas para competencia'
	ELSE 'bicicletas recreativas'
	END AS etiqueta
FROM producto p
			JOIN categoria c
				ON p.id_categoria = c.id;

/* 7.Respuesta Etiquetas correctamente obteniendo 51 filas */

/* 8. Generar una lista con todas las facturas que se han emitido desde el primero de mayo del 2022  */

SELECT f.id as factura ,f.fecha, cl.id as cliente,cl.nombre, cl.apellido
FROM factura f
	JOIN cliente cl
		ON f.id_cliente = cl.id
WHERE f.fecha >='2022-05-01'
ORDER BY fecha;
/* 8.Respuesta Existen 18 facturas que se emitieron desde el primero de mayo del 2022 */

/* 9. Obtener la lista de los dos vendedores que más ventas realizaron en el 2021 */

WITH topventas2021 as (
	SELECT f.id_empleado as id,SUM(cantidad * precio_unitario) as ventas
	FROM factura f 
		JOIN detalle_factura dt_ft      
			ON f.id = dt_ft.id_factura
				WHERE YEAR (f.fecha) = 2021
					GROUP BY f.id_empleado
						ORDER BY ventas DESC
							LIMIT 2
                        )
  SELECT  id,nombre,apellido,email
  FROM empleado 
	JOIN topventas2021 
		USING (id);
                   
/* 9.Respuesta Los empleados que mas vendieron en 2021 son María Mora y Gustavo Vargas */

/*10. Generar una lista con nombres y dirección de e-mail de todos los clientes y colaboradores */

SELECT DISTINCT nombre, email 
FROM empleado
UNION 
SELECT DISTINCT nombre, email 
FROM cliente;

/* 10.Respuesta Hay 5 empleados (colaboradores) y los demas son clientes  */