--EJERCICIO 1
CREATE TABLE usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(100) UNIQUE,
    correo VARCHAR(150) UNIQUE
);

CREATE OR REPLACE PROCEDURE insertar_usuario(
    p_nombre_usuario VARCHAR,
    p_correo VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM usuarios
        WHERE nombre_usuario = p_nombre_usuario OR correo = p_correo
    ) THEN
        RAISE NOTICE 'Ya existe un usuario con ese nombre o correo.';
    ELSE
        INSERT INTO usuarios (nombre_usuario, correo)
        VALUES (p_nombre_usuario, p_correo);
        RAISE NOTICE 'Usuario insertado correctamente.';
    END IF;
END;
$$;

CALL insertar_usuario('juan123', 'juan@example.com');


--EJERCICIO 2
CREATE TABLE alumnos (
    alumno_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    numero_carnet VARCHAR(50) UNIQUE,
    estado_matricula VARCHAR(20) -- Ej: 'Activa', 'Cancelada'
);

INSERT INTO alumnos (nombre, numero_carnet, estado_matricula) VALUES
('Juan Perez', 'C12345', 'Activa'),
('Ana Gomez', 'C67890', 'Cancelada'),
('Luis Martinez', 'C54321', 'Activa');

CREATE OR REPLACE PROCEDURE cancelar_matricula(p_numero_carnet VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    estado_actual VARCHAR(20);
BEGIN
    SELECT estado_matricula INTO estado_actual
    FROM alumnos
    WHERE numero_carnet = p_numero_carnet;

    IF NOT FOUND THEN
        RAISE NOTICE 'No existe un alumno con ese número de carné.';
        RETURN;
    END IF;

    IF estado_actual = 'Cancelada' THEN
        RAISE NOTICE 'La matrícula ya está cancelada.';
    ELSIF estado_actual = 'Activa' THEN
        UPDATE alumnos
        SET estado_matricula = 'Cancelada'
        WHERE numero_carnet = p_numero_carnet;
        RAISE NOTICE 'Matrícula cancelada correctamente.';
    ELSE
        RAISE NOTICE 'Estado de matrícula desconocido.';
    END IF;
END;
$$;

CALL cancelar_matricula('C12345');
CALL cancelar_matricula('C67890'); 
CALL cancelar_matricula('C00000'); 


--Ejercicio 3
CREATE TABLE usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(100) UNIQUE,
    rol VARCHAR(50) -- 'admin', 'usuario', etc.
);

INSERT INTO usuarios (nombre_usuario, rol) VALUES
('juan_admin', 'admin'),
('maria_user', 'usuario'),
('luis_admin', 'admin');

CREATE OR REPLACE PROCEDURE borrar_usuario_si_admin(
    p_nombre_borrar VARCHAR,
    p_nombre_ejecutor VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    rol_ejecutor VARCHAR;
BEGIN
    SELECT rol INTO rol_ejecutor
    FROM usuarios
    WHERE nombre_usuario = p_nombre_ejecutor;

    IF NOT FOUND THEN
        RAISE NOTICE 'Usuario ejecutor no encontrado.';
        RETURN;
    END IF;

    IF rol_ejecutor <> 'admin' THEN
        RAISE NOTICE 'No tienes permisos para borrar usuarios.';
        RETURN;
    END IF;

    DELETE FROM usuarios WHERE nombre_usuario = p_nombre_borrar;

    IF FOUND THEN
        RAISE NOTICE 'Usuario % borrado correctamente.', p_nombre_borrar;
    ELSE
        RAISE NOTICE 'Usuario % no encontrado.', p_nombre_borrar;
    END IF;
END;
$$;


CALL borrar_usuario_si_admin('maria_user', 'juan_admin');

CALL borrar_usuario_si_admin('luis_admin', 'maria_user');

CALL borrar_usuario_si_admin('usuario_inexistente', 'juan_admin');

--Ejercicio 4
CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_ingreso DATE,
    salario NUMERIC(10,2)
);

INSERT INTO empleados (nombre, fecha_ingreso, salario) VALUES
('Carlos Perez', '2022-01-10', 1500.00),
('Laura Martinez', '2024-01-15', 1800.00),
('Juan Gomez', '2023-03-20', 1600.00);


CREATE OR REPLACE PROCEDURE actualizar_salario_si_un_ano(
    p_empleado_id INT,
    p_nuevo_salario NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    fecha_ingreso_empleado DATE;
    dias_antiguedad INT;
BEGIN
    SELECT fecha_ingreso INTO fecha_ingreso_empleado
    FROM empleados
    WHERE empleado_id = p_empleado_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Empleado no encontrado.';
        RETURN;
    END IF;

    dias_antiguedad := CURRENT_DATE - fecha_ingreso_empleado;

    IF dias_antiguedad >= 365 THEN
        UPDATE empleados
        SET salario = p_nuevo_salario
        WHERE empleado_id = p_empleado_id;
        RAISE NOTICE 'Salario actualizado correctamente.';
    ELSE
        RAISE NOTICE 'El empleado no tiene más de un año en la empresa.';
    END IF;
END;
$$;


CALL actualizar_salario_si_un_ano(1, 1700); 
CALL actualizar_salario_si_un_ano(2, 1900);
CALL actualizar_salario_si_un_ano(99, 2000); 

--EJercicio 5
CREATE TABLE cursos (
    curso_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    estado VARCHAR(20) -- 'Activo' o 'Inactivo'
);

CREATE TABLE inscripciones (
    inscripcion_id SERIAL PRIMARY KEY,
    alumno_id INT,
    curso_id INT REFERENCES cursos(curso_id),
    fecha_inscripcion DATE DEFAULT CURRENT_DATE
);

INSERT INTO cursos (nombre, estado) VALUES
('Matemáticas', 'Activo'),
('Historia', 'Inactivo');

CREATE OR REPLACE PROCEDURE insertar_inscripcion_si_activo(
    p_alumno_id INT,
    p_curso_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    estado_curso VARCHAR(20);
BEGIN
    SELECT estado INTO estado_curso
    FROM cursos
    WHERE curso_id = p_curso_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Curso no encontrado.';
        RETURN;
    END IF;

    IF estado_curso = 'Activo' THEN
        INSERT INTO inscripciones (alumno_id, curso_id)
        VALUES (p_alumno_id, p_curso_id);
        RAISE NOTICE 'Inscripción realizada correctamente.';
    ELSE
        RAISE NOTICE 'No se puede inscribir: el curso no está activo.';
    END IF;
END;
$$;

CALL insertar_inscripcion_si_activo(1, 1); 
CALL insertar_inscripcion_si_activo(1, 2); 
CALL insertar_inscripcion_si_activo(1, 99);
