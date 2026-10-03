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


INSERT INTO tareas (titulo, descripcion, completada, fecha_vencimiento) VALUES
('Configurar Servidor Tomcat', 'Instalar y configurar Apache Tomcat para ejecutar la aplicación web', 0, DATEADD(DAY, 2, GETDATE())),
('Diseñar interfaz JSP', 'Crear las páginas JSP para mostrar y gestionar las tareas', 0, DATEADD(DAY, 4, GETDATE())),
('Implementar Servlet', 'Desarrollar los Servlets para procesar las solicitudes del usuario', 0, DATEADD(DAY, 6, GETDATE())),
('Conectar base de datos', 'Configurar la conexión entre Java y SQL Server mediante JDBC', 0, DATEADD(DAY, 3, GETDATE())),
('Crear entidades JPA', 'Definir las entidades y relaciones utilizando ORM', 0, DATEADD(DAY, 8, GETDATE())),
('Implementar CRUD', 'Desarrollar las funciones para crear, consultar, modificar y eliminar tareas', 0, DATEADD(DAY, 10, GETDATE())),
('Probar aplicación', 'Realizar pruebas funcionales de las principales operaciones', 0, DATEADD(DAY, 12, GETDATE())),
('Corregir errores', 'Solucionar los problemas encontrados durante las pruebas', 0, DATEADD(DAY, 14, GETDATE())),
('Documentar proyecto', 'Elaborar la documentación técnica de la aplicación', 0, DATEADD(DAY, 16, GETDATE())),
('Preparar presentación', 'Preparar las diapositivas y demostración del proyecto', 0, DATEADD(DAY, 18, GETDATE())),
('Revisar código', 'Analizar el código y mejorar su estructura y legibilidad', 1, DATEADD(DAY, -2, GETDATE())),
('Configurar GitHub', 'Crear el repositorio y configurar el control de versiones', 1, DATEADD(DAY, -1, GETDATE())),
('Investigar Servlets', 'Revisar el funcionamiento de los Servlets en aplicaciones Java', 1, DATEADD(DAY, -4, GETDATE())),
('Investigar JSP', 'Estudiar el uso de JSP para generar contenido dinámico', 1, DATEADD(DAY, -5, GETDATE())),
('Probar GitHub Copilot', 'Utilizar Copilot para generar y mejorar código Java', 0, DATEADD(DAY, 9, GETDATE()));
GO