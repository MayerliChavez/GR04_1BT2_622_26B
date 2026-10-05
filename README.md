# GR06_1BT2_622_26B - Sistema de Gestión de Tareas

Aplicación web Java para crear, consultar, editar y eliminar tareas. Usa JSP, Servlets, Hibernate y SQL Server.

## Requisitos

- Windows 10/11 con Windows PowerShell.
- Windows Package Manager (winget), incluido en App Installer.
- SQL Server instalado y en ejecución en la misma computadora, escuchando por TCP en 127.0.0.1:1433.
- Una cuenta de SQL Server con permisos para crear la base de datos si todavía no existe. El instalador solicita las credenciales; por defecto propone el usuario sa.
- Para acceso del equipo por Radmin VPN: Radmin VPN instalado y conectado a la misma red virtual que los demás integrantes.

El script instala Eclipse Temurin JDK 25, Maven y Apache Tomcat 10.1.60 cuando no los encuentra. No es necesario instalar Tomcat manualmente.

## Instalación automática

1. Descarga o clona el repositorio y abre Windows PowerShell en la carpeta del proyecto, donde están setup.ps1 y pom.xml.
2. Confirma que SQL Server esté iniciado y configurado para aceptar conexiones TCP/IP por el puerto 1433. La autenticación de SQL Server debe estar habilitada para usar sa u otra cuenta SQL.
3. Ejecuta el instalador:

~~~powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup.ps1
~~~

El cambio de política se limita a esa ventana de PowerShell. Si Windows solicita permisos para instalar herramientas, acepta el aviso de winget.

El instalador realiza estas etapas:

1. Comprueba Java, Maven y Tomcat; instala los componentes que falten.
2. Comprueba SQL Server, solicita las credenciales y crea la base gestion_tareas desde database/schema.sql si no existe. Si la base ya existe, crea la tabla tareas solo cuando falta.
3. Genera la configuración local de Hibernate en src/main/resources/hibernate.local.properties, compila el proyecto, copia el WAR a Tomcat e inicia el servidor.

La configuración local de Hibernate contiene las credenciales de esa computadora y está excluida de Git. No agregues contraseñas reales a hibernate.cfg.xml ni las compartas en el repositorio.

### Regla de Firewall

Al final, el instalador busca una interfaz de Radmin VPN activa y una dirección IPv4 26.x.x.x. Si encuentra una, crea la regla de entrada TCP para el puerto 8080 solo si todavía no existe una regla llamada Tomcat 8080 - Radmin VPN. La regla nueva se limita a la dirección y a la interfaz detectadas.

Para crear la regla, ejecuta PowerShell como administrador. Si no tienes permisos elevados, el resto de la instalación puede completarse y el instalador mostrará una advertencia; puedes volver a ejecutar el script como administrador para crear la regla. Si Radmin no está conectado, el instalador omitirá la regla y podrás ejecutar el script cuando la VPN esté activa.

## Acceso a la aplicación

Al terminar, el instalador muestra la URL local y, cuando detecta Radmin, la URL para los integrantes conectados a la misma red VPN. El contexto se obtiene del nombre del WAR generado; normalmente será:

~~~text
http://localhost:8080/gr06-1bt2-622-26b-tareas-1.0.0/
http://IP_RADMIN:8080/gr06-1bt2-622-26b-tareas-1.0.0/
~~~

Usa las direcciones que imprima el instalador, porque el nombre del WAR o la IP de Radmin pueden cambiar. Mantén la computadora anfitriona encendida y Tomcat en ejecución mientras los demás usan la aplicación. Los demás integrantes no necesitan instalar Maven, Tomcat ni SQL Server para acceder desde el navegador.

## Instalación manual (alternativa)

Si no vas a usar setup.ps1, instala Java 11 o superior, Maven 3.6+, Tomcat 10+ y SQL Server. Ejecuta database/schema.sql en SQL Server, configura las credenciales locales para Hibernate, compila con mvn clean package y despliega el WAR resultante en Tomcat. El instalador automático es el método recomendado para este proyecto porque prepara esas configuraciones locales por ti.

## Tecnologías

- Java, JSP y Jakarta Servlets
- Hibernate ORM 6.4
- Microsoft SQL Server
- Maven
- Apache Tomcat 10.1

## Funcionalidades

- Consultar tareas y filtrarlas por estado.
- Crear, editar y eliminar tareas.
- Marcar tareas como completadas o pendientes.
- Registrar fechas de creación y vencimiento.

## Estructura principal

~~~text
GR06_1BT2_622_26B/
├── database/
│   └── schema.sql
├── src/main/
│   ├── java/com/grupo06/app/
│   ├── resources/
│   └── webapp/
├── setup.ps1
├── pom.xml
└── README.md
~~~

## Solución de problemas

### El instalador informa que no encuentra winget

Instala o actualiza App Installer desde Microsoft Store, cierra PowerShell, abre una ventana nueva y vuelve a ejecutar setup.ps1.

### No conecta con SQL Server en 127.0.0.1:1433

Verifica que el servicio de SQL Server esté iniciado, que TCP/IP esté habilitado para la instancia y que esta escuche en el puerto 1433. Comprueba también que la autenticación de SQL Server esté habilitada y que las credenciales ingresadas sean correctas.

### No se crea la regla del Firewall

Abre Windows PowerShell como administrador y vuelve a ejecutar setup.ps1 con Radmin conectado. El script informa el error si Windows rechaza la creación de la regla.

### Radmin no aparece o no se muestra la URL VPN

Conecta Radmin VPN y confirma que su adaptador esté activo y tenga una dirección IPv4 26.x.x.x. Ejecuta de nuevo setup.ps1; la URL VPN se imprimirá cuando el adaptador sea detectado.

### La aplicación no responde en el puerto 8080

Revisa que Tomcat esté iniciado y consulta los registros en la carpeta logs de Tomcat, bajo %LOCALAPPDATA%\GR06_1BT2_622_26B\apache-tomcat-10.1.60. Para acceso por Radmin, confirma que el equipo cliente esté conectado a la misma red virtual y que la regla del Firewall exista.

## Licencia

MIT License.
