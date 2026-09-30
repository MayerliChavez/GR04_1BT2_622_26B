# GR04_1BT2_622_26B - Sistema de Gestión de Tareas

## Descripción
Aplicación web desarrollada en Java con JSP, Servlets y Hibernate ORM para gestionar tareas. La aplicación permite crear, editar, eliminar y marcar tareas como completadas, con almacenamiento en SQL Server.

## Características
- ✅ Ver todas las tareas registradas
- ✅ Crear nuevas tareas
- ✅ Editar tareas existentes
- ✅ Eliminar tareas
- ✅ Marcar tareas como completadas/pendientes
- ✅ Filtrar por estado (Todas, Pendientes, Completadas)
- ✅ Fecha de creación y vencimiento
- ✅ Estadísticas de tareas
- ✅ Interfaz responsive y moderna

## Requisitos del Sistema
- Java JDK 11 o superior
- Maven 3.6+
- SQL Server 2019 o superior
- Tomcat 10 o servidor compatible con Jakarta EE

## Tecnologías Utilizadas
- **Backend:** Java, Servlets, JSP
- **ORM:** Hibernate (versión 6.4.0)
- **Base de datos:** SQL Server
- **Build:** Maven
- **Frontend:** HTML5, CSS3, JavaScript

## Configuración

### 1. Crear la base de datos SQL Server
Ejecutar el script SQL:
```sql
CREATE DATABASE gestion_tareas;
```

### 2. Configurar Hibernate
Editar el archivo `src/main/resources/hibernate.cfg.xml`:

```xml
<property name="hibernate.connection.url">jdbc:sqlserver://localhost:1433;databaseName=gestion_tareas</property>
<property name="hibernate.connection.username">sa</property>
<property name="hibernate.connection.password">YourPassword123</property>
```

**Parámetros importantes:**
- **hostname:** La dirección del servidor SQL Server (ej: localhost, 192.168.1.10, etc.)
- **puerto:** Puerto de SQL Server (predeterminado: 1433)
- **database:** Nombre de la base de datos (gestion_tareas)
- **usuario:** Usuario de SQL Server (sa o tu usuario personalizado)
- **contraseña:** Contraseña del usuario

### 3. Compilar la aplicación
```bash
mvn clean package
```

### 4. Desplegar en Tomcat
1. Copiar el archivo WAR generado en `target/gr04-1bt2-622-26b-tareas.war` a la carpeta `webapps` de Tomcat
2. Iniciar Tomcat
3. Acceder a: `http://localhost:8080/gr04-1bt2-622-26b-tareas/`

## Estructura del Proyecto

```
GR04_1BT2_622_26B/
├── src/
│   ├── main/
│   │   ├── java/com/grupo04/app/
│   │   │   ├── model/
│   │   │   │   └── Tarea.java
│   │   │   ├── dao/
│   │   │   │   └── TareaDAO.java
│   │   │   ├── servlet/
│   │   │   │   └── TareaServlet.java
│   │   │   └── util/
│   │   │       └── HibernateUtil.java
│   │   ├── resources/
│   │   │   └── hibernate.cfg.xml
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       ├── index.jsp
│   │       ├── listar-tareas.jsp
│   │       ├── form-tarea.jsp
│   │       ├── editar-tarea.jsp
│   │       └── css/
│   │           └── estilo.css
│   └── test/
├── database/
│   └── schema.sql
├── pom.xml
└── README.md
```

## Uso de la Aplicación

### Página Principal
- Accede a `http://localhost:8080/gr04-1bt2-622-26b-tareas/`
- Haz clic en "Ir al Gestor de Tareas"

### Crear una Tarea
1. Haz clic en "+ Nueva Tarea"
2. Completa el formulario:
   - Título (requerido)
   - Descripción (opcional)
   - Fecha de vencimiento (opcional)
3. Haz clic en "Guardar Tarea"

### Editar una Tarea
1. En la lista, haz clic en "✎ Editar" en la tarea que desees
2. Modifica los campos
3. Haz clic en "Actualizar Tarea"

### Completar/Desmarcar una Tarea
1. Haz clic en "☑ Completar" o "◇ Desmarcar" en la tarea
2. La tarea se actualizará al instante

### Eliminar una Tarea
1. Haz clic en "✕ Eliminar" en la tarea
2. Confirma la eliminación

### Filtrar Tareas
- **Todas:** Muestra todas las tareas
- **Pendientes:** Solo tareas sin completar
- **Completadas:** Solo tareas completadas

## Entidad Tarea

```java
@Entity
@Table(name = "tareas")
public class Tarea {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(nullable = false, length = 200)
    private String titulo;
    
    @Column(columnDefinition = "TEXT")
    private String descripcion;
    
    @Column(nullable = false)
    private boolean completada = false;
    
    @Column(name = "fecha_creacion", nullable = false)
    private LocalDateTime fechaCreacion;
    
    @Column(name = "fecha_vencimiento")
    private LocalDateTime fechaVencimiento;
}
```

## GitHub Copilot en el Desarrollo

GitHub Copilot fue utilizado para:
- Generar la estructura del proyecto Maven
- Crear las clases de entidad con anotaciones JPA
- Desarrollar el DAO con operaciones CRUD
- Generar el Servlet con lógica de negocio
- Crear las páginas JSP con formularios y tablas
- Diseñar los estilos CSS
- Escribir configuraciones de Hibernate

### Prompts útiles para Copilot:
```
"Crea un CRUD completo con Hibernate para una entidad Tarea"
"Genera un Servlet en Java que maneje operaciones CRUD"
"Crea una página JSP con tabla responsiva para listar tareas"
"Diseña un CSS moderno para una aplicación de tareas"
```

## Solución de Problemas

### Error: "Cannot connect to database"
- Verificar que SQL Server esté corriendo
- Verificar usuario y contraseña en `hibernate.cfg.xml`
- Verificar que la base de datos existe
- Verificar conectividad de red si es en otro servidor

### Error: "ClassNotFoundException: com.microsoft.sqlserver.jdbc.SQLServerDriver"
- Verificar que el driver SQL Server está en las dependencias de Maven
- Ejecutar `mvn clean install`

### Error: "The specified module could not be found"
- Limpiar y recompilar: `mvn clean package`
- Borrar carpeta `target` y compilar nuevamente

## Enlace del Repositorio
https://github.com/MayerliChavez/GR04_1BT2_622_26B

## Autor
GR04_1BT2_622_26B

## Licencia
MIT License
