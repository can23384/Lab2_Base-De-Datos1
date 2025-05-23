--EJercicio 1
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100)
);

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio NUMERIC(10,2),
    categoria_id INT REFERENCES categorias(categoria_id)
);

INSERT INTO categorias (nombre_categoria) VALUES
('Electrónica'),
('Ropa'),
('Alimentos');

INSERT INTO productos (nombre_producto, precio, categoria_id) VALUES
('Televisor', 500.00, 1),
('Camisa', 20.00, 2),
('Manzana', 1.50, 3);

CREATE OR REPLACE VIEW vista_productos AS
SELECT p.nombre_producto, c.nombre_categoria, p.precio
FROM productos p
JOIN categorias c ON p.categoria_id = c.categoria_id;


SELECT * FROM vista_productos;

--Ejercicio 2
CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    estado VARCHAR(20) 
);

INSERT INTO empleados (nombre, estado) VALUES
('Carlos Pérez', 'Activo'),
('Laura Gómez', 'Inactivo'),
('Juan Rodríguez', 'Activo'),
('Ana Martínez', 'Inactivo');

CREATE OR REPLACE VIEW vista_empleados_activos AS
SELECT empleado_id, nombre
FROM empleados
WHERE estado = 'Activo';

SELECT * FROM vista_empleados_activos;

--Ejercicio 3
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio NUMERIC(10,2)
);


INSERT INTO productos (nombre_producto, precio) VALUES
('Televisor', 500.00),
('Laptop', 800.00),
('Smartphone', 300.00);

CREATE OR REPLACE VIEW vista_productos_con_iva AS
SELECT nombre_producto,
       precio,
       precio * 1.12 AS precio_con_iva
FROM productos;

SELECT * FROM vista_productos_con_iva;


--Ejercicio 4
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre_cliente VARCHAR(100)
);

CREATE TABLE compras (
    compra_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    monto NUMERIC(10,2)
);

INSERT INTO clientes (nombre_cliente) VALUES
('Juan Pérez'),
('Ana Gómez'),
('Luis Martínez');

INSERT INTO compras (cliente_id, monto) VALUES
(1, 100.00),
(1, 50.00),
(2, 200.00),
(2, 150.00),
(3, 300.00);

CREATE OR REPLACE VIEW vista_compras_clientes AS
SELECT c.nombre_cliente,
       COUNT(co.compra_id) AS cantidad_compras,
       SUM(co.monto) AS monto_total_acumulado
FROM clientes c
JOIN compras co ON c.cliente_id = co.cliente_id
GROUP BY c.nombre_cliente;

SELECT * FROM vista_compras_clientes;


--Ejercicio 5
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100)
);

CREATE TABLE cursos (
    curso_id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    categoria_id INT REFERENCES categorias(categoria_id)
);

INSERT INTO categorias (nombre_categoria) VALUES
('Tecnología'),
('Arte'),
('Ciencias');

INSERT INTO cursos (titulo, categoria_id) VALUES
('Curso de Python', 1),
('Curso de JavaScript', 1),
('Dibujo y Pintura', 2),
('Historia del Arte', 2),
('Física Cuántica', 3),
('Biología Molecular', 3);

CREATE OR REPLACE VIEW vista_cursos_ordenados AS
SELECT c.titulo,
       cat.nombre_categoria
FROM cursos c
JOIN categorias cat ON c.categoria_id = cat.categoria_id
ORDER BY cat.nombre_categoria, c.titulo;

SELECT * FROM vista_cursos_ordenados;

