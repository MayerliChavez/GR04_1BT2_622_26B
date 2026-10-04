# GR06_1BT2_622_26B - Sistema de Gestión de Tareas

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

## Instalación y ejecución

### 1. Instalar las herramientas
Instala un JDK 11 o superior, Maven 3.6+ y Apache Tomcat 10+. Para ejecutar la aplicación también necesitas SQL Server (por ejemplo, SQL Server Express) y SQL Server Management Studio (SSMS) para configurar la base de datos.

Comprueba que Java y Maven estén disponibles desde una terminal:
```bash
java -version
mvn -version
```

### 2. Descargar el proyecto
Clona el repositorio con Git o descarga el proyecto como ZIP y extrae su contenido. Abre una terminal en la carpeta que contiene `pom.xml`.

```bash
git clone https://github.com/MayerliChavez/GR04_1BT2_622_26B.git GR06_1BT2_622_26B
cd GR06_1BT2_622_26B
```

### 3. Preparar SQL Server
Inicia SQL Server y, desde SSMS, abre y ejecuta `database/schema.sql`. El script crea la base de datos `gestion_tareas`, la tabla `tareas` y registros de ejemplo. Ejecútalo solo en una instancia donde todavía no exista esa base de datos.

La configuración incluida usa SQL Server en la misma computadora (`localhost`), puerto `1433` y autenticación de SQL Server. Si tu instalación usa otro servidor, puerto o usuario, edita `src/main/resources/hibernate.cfg.xml` y actualiza estas propiedades con tus propios valores:

```xml
<property name="hibernate.connection.url">jdbc:sqlserver://localhost:1433;databaseName=gestion_tareas;encrypt=false;trustServerCertificate=true;loginTimeout=30</property>
<property name="hibernate.connection.username">TU_USUARIO</property>
<property name="hibernate.connection.password">TU_CONTRASEÑA</property>
```

Si la base de datos está en otra computadora, sustituye `localhost` por el nombre o la dirección IP de esa computadora y confirma que SQL Server permita conexiones TCP/IP y conexiones entrantes por el puerto configurado. No publiques contraseñas reales en el repositorio.

### 4. Compilar el proyecto
Desde la carpeta del proyecto, ejecuta:
```bash
mvn clean package
```

Maven descargará las dependencias y generará el WAR en `target/gr04-1bt2-622-26b-tareas-1.0.0.war`. La compilación no requiere que SQL Server esté iniciado; la base de datos sí debe estar configurada para ejecutar la aplicación.

### 5. Desplegar en Tomcat
Copia el WAR generado a la carpeta `webapps` de Tomcat e inicia o reinicia Tomcat. Luego abre:

```text
http://localhost:8080/gr04-1bt2-622-26b-tareas-1.0.0/
```

Si Tomcat se ejecuta en otra computadora, reemplaza `localhost` en el navegador por la IP de la computadora donde está Tomcat. Asegúrate de que el firewall permita el puerto de Tomcat (por defecto, `8080`).

## Tecnologías Utilizadas
- **Backend:** Java, Servlets, JSP
- **ORM:** Hibernate (versión 6.4.0)
- **Base de datos:** SQL Server
- **Build:** Maven
- **Frontend:** HTML5, CSS3, JavaScript

## Estructura del Proyecto

```
GR06_1BT2_622_26B/
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
GR06_1BT2_622_26B

## Licencia
MIT License
