--CREACION DE TABLAS
-- Tabla de pilotos
CREATE TABLE pilotos (
    piloto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de carreras
CREATE TABLE carreras (
    carrera_id SERIAL PRIMARY KEY,
    nombre_carrera VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL
);

-- Tabla de resultados
CREATE TABLE resultados (
    resultado_id SERIAL PRIMARY KEY,
    piloto_id INT REFERENCES pilotos(piloto_id),
    carrera_id INT REFERENCES carreras(carrera_id),
    puntos INT NOT NULL
);

--INSERTS DE DATOS DE PRUEBA
-- Pilotos
INSERT INTO pilotos (nombre) VALUES
('Lewis Hamilton'),
('Max Verstappen'),
('Sebastian Vettel'),
('Fernando Alonso');

-- Carreras
INSERT INTO carreras (nombre_carrera, fecha) VALUES
('GP Australia', '2025-03-15'),
('GP Mónaco', '2025-05-25'),
('GP España', '2025-06-10'),
('GP Canadá', '2025-06-22'),
('GP Francia', '2025-07-12');

-- Resultados (puntos que ganó cada piloto en cada carrera)
INSERT INTO resultados (piloto_id, carrera_id, puntos) VALUES
(1, 1, 25),
(1, 2, 18),
(1, 3, 15),
(1, 4, 12),
(1, 5, 10),

(2, 1, 18),
(2, 2, 25),
(2, 3, 12),
(2, 4, 15),
(2, 5, 18),

(3, 1, 12),
(3, 2, 10),
(3, 3, 18),
(3, 4, 25),
(3, 5, 15),

(4, 1, 10),
(4, 2, 12),
(4, 3, 25),
(4, 4, 18),
(4, 5, 12);


--	Total, de puntos por piloto (con GROUP BY)
SELECT p.nombre, SUM(r.puntos) AS total_puntos
FROM pilotos p
JOIN resultados r ON p.piloto_id = r.piloto_id
GROUP BY p.nombre
ORDER BY total_puntos DESC;

-- Suma total de puntos de todos los pilotos
SELECT SUM(puntos) AS total_puntos
FROM resultados;

-- Total, de puntos por piloto con OVER + PARTITION BY
SELECT p.nombre, 
       r.puntos,
       SUM(r.puntos) OVER (PARTITION BY p.piloto_id) AS total_puntos_por_piloto
FROM pilotos p
JOIN resultados r ON p.piloto_id = r.piloto_id
ORDER BY p.nombre;

-- Subconsulta para sumar solo los 4 mejores resultados por piloto
SELECT piloto_id, nombre, SUM(puntos) AS puntos_top_4
FROM (
    SELECT p.piloto_id, p.nombre, r.puntos,
           ROW_NUMBER() OVER (PARTITION BY p.piloto_id ORDER BY r.puntos DESC) AS rn
    FROM pilotos p
    JOIN resultados r ON p.piloto_id = r.piloto_id
) sub
WHERE rn <= 4
GROUP BY piloto_id, nombre
ORDER BY puntos_top_4 DESC;
