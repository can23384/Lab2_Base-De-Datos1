--EJERCICIO 1
CREATE OR REPLACE FUNCTION celsius_a_fahrenheit(celsius NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (celsius * 9 / 5) + 32;
END;
$$ LANGUAGE plpgsql;

SELECT celsius_a_fahrenheit(0) AS fahrenheit_zero,
       celsius_a_fahrenheit(100) AS fahrenheit_cien;


--EJERCICIO 2
 -- Tabla alumnos
CREATE TABLE alumnos (
    alumno_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla cursos
CREATE TABLE cursos (
    curso_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla matriculas (relaciona alumnos con cursos)
CREATE TABLE matriculas (
    matricula_id SERIAL PRIMARY KEY,
    alumno_id INT REFERENCES alumnos(alumno_id),
    curso_id INT REFERENCES cursos(curso_id)
);

-- Inserts alumnos
INSERT INTO alumnos (nombre) VALUES
('Juan Perez'),
('Ana Gomez'),
('Luis Martinez');

-- Inserts cursos
INSERT INTO cursos (nombre) VALUES
('Matemáticas'),
('Historia'),
('Biología');

-- Inserts matriculas
INSERT INTO matriculas (alumno_id, curso_id) VALUES
(1, 1),  -- Juan Perez en Matemáticas
(1, 3),  -- Juan Perez en Biología
(2, 2),  -- Ana Gomez en Historia
(3, 1),  -- Luis Martinez en Matemáticas
(3, 2);  -- Luis Martinez en Historia



CREATE OR REPLACE FUNCTION cursos_de_alumno(p_alumno_id INT)
RETURNS TABLE(curso_id INT, nombre_curso VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.curso_id, c.nombre
    FROM cursos c
    JOIN matriculas m ON c.curso_id = m.curso_id
    WHERE m.alumno_id = p_alumno_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM cursos_de_alumno(1);

--EJERCICIO 3
CREATE OR REPLACE FUNCTION calcular_descuento(tipo_cliente VARCHAR, monto NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    descuento NUMERIC := 0;
BEGIN
    IF tipo_cliente = 'VIP' THEN
        descuento := monto * 0.20;
    ELSIF tipo_cliente = 'Regular' THEN
        descuento := monto * 0.10;
    ELSE
        descuento := 0;
    END IF;
    RETURN descuento;
END;
$$ LANGUAGE plpgsql;

SELECT calcular_descuento('VIP', 1000) AS descuento_vip,
       calcular_descuento('Regular', 1000) AS descuento_regular,
       calcular_descuento('Otro', 1000) AS descuento_otro;

--EJERCICIO 4
CREATE OR REPLACE FUNCTION clasificar_numero(n NUMERIC)
RETURNS VARCHAR AS $$
BEGIN
    IF n > 0 THEN
        RETURN 'Positivo';
    ELSIF n < 0 THEN
        RETURN 'Negativo';
    ELSE
        RETURN 'Cero';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT clasificar_numero(10), clasificar_numero(-5), clasificar_numero(0);

--EJERCICIO 6
CREATE OR REPLACE FUNCTION calcular_comision(tipo_producto VARCHAR, monto NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    comision NUMERIC := 0;
BEGIN
    IF tipo_producto = 'A' THEN
        comision := monto * 0.10;
    ELSIF tipo_producto = 'B' THEN
        comision := monto * 0.05;
    ELSE
        comision := monto * 0.02;
    END IF;
    RETURN comision;
END;
$$ LANGUAGE plpgsql;

SELECT calcular_comision('A', 1000) AS comision_A,
       calcular_comision('B', 1000) AS comision_B,
       calcular_comision('C', 1000) AS comision_C;

--EJERCICIO 7
CREATE OR REPLACE FUNCTION es_bisiesto(anio INT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (anio % 400 = 0) OR (anio % 4 = 0 AND anio % 100 <> 0);
END;
$$ LANGUAGE plpgsql;

SELECT es_bisiesto(2020) AS bisiesto_2020,
       es_bisiesto(1900) AS bisiesto_1900,
       es_bisiesto(2000) AS bisiesto_2000,
       es_bisiesto(2023) AS bisiesto_2023;

--EJERCICIO 8
CREATE OR REPLACE FUNCTION nombre_mes(mes INT)
RETURNS VARCHAR AS $$
BEGIN
    RETURN CASE mes
        WHEN 1 THEN 'Enero'
        WHEN 2 THEN 'Febrero'
        WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Mayo'
        WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre'
        WHEN 11 THEN 'Noviembre'
        WHEN 12 THEN 'Diciembre'
        ELSE 'Número inválido'
    END;
END;
$$ LANGUAGE plpgsql;

SELECT nombre_mes(3);

--EJERCICIO 9
CREATE OR REPLACE FUNCTION es_mayor_edad(fecha_nac DATE)
RETURNS BOOLEAN AS $$
DECLARE
    edad INT;
BEGIN
    edad := EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nac));
    RETURN edad >= 18;
END;
$$ LANGUAGE plpgsql;


SELECT es_mayor_edad('2005-05-20') AS mayor_edad_2005,
       es_mayor_edad('2000-01-01') AS mayor_edad_2000;

--EJERCICIO 10
CREATE OR REPLACE FUNCTION clasificar_precio(precio NUMERIC)
RETURNS VARCHAR AS $$
BEGIN
    IF precio < 100 THEN
        RETURN 'Bajo';
    ELSIF precio BETWEEN 100 AND 500 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Alto';
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT clasificar_precio(50) AS precio_50,
       clasificar_precio(150) AS precio_150,
       clasificar_precio(700) AS precio_700;
