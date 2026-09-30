-- Script para crear la base de datos en SQL Server
-- Ejecutar en SQL Server Management Studio

CREATE DATABASE gestion_tareas;
GO

USE gestion_tareas;
GO

CREATE TABLE tareas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT NULL,
    completada BIT NOT NULL DEFAULT 0,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_vencimiento DATETIME NULL
);
GO

-- Crear índices
CREATE INDEX idx_completada ON tareas(completada);
CREATE INDEX idx_fecha_vencimiento ON tareas(fecha_vencimiento);
GO

-- Insertar datos de ejemplo
INSERT INTO tareas (titulo, descripcion, completada, fecha_vencimiento) VALUES 
('Estudiar Hibernate', 'Aprender ORM y mapeo de entidades', 0, DATEADD(DAY, 3, GETDATE())),
('Crear aplicación web', 'Desarrollar sistema de tareas con Java', 0, DATEADD(DAY, 7, GETDATE())),
('Subir a GitHub', 'Publicar el proyecto en GitHub como público', 0, DATEADD(DAY, 5, GETDATE()));
GO
