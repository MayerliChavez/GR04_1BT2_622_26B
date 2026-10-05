# ============================================================
# GR06_1BT2_622_26B
# Configuración automática del entorno
# ETAPA 1 - Java + Maven + Tomcat
# ETAPA 2 - SQL Server + Hibernate
# ETAPA 3 - Maven + WAR + Tomcat
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   GR06_1BT2_622_26B" -ForegroundColor Cyan
Write-Host "   CONFIGURACION DEL ENTORNO" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# CONFIGURACION GENERAL
# ============================================================

$TomcatVersion = "10.1.60"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

$ToolsDir = Join-Path `
    $env:LOCALAPPDATA `
    "GR06_1BT2_622_26B"

$TomcatDir = Join-Path `
    $ToolsDir `
    "apache-tomcat-$TomcatVersion"

$WebappsDir = Join-Path `
    $TomcatDir `
    "webapps"

$HibernateLocalPath = Join-Path `
    $ProjectRoot `
    "src\main\resources\hibernate.local.properties"

# ============================================================
# FUNCIONES
# ============================================================

function Test-CommandExists {
    param (
        [string]$Command
    )

    return $null -ne (
        Get-Command $Command -ErrorAction SilentlyContinue
    )
}

function Add-ToCurrentPath {
    param (
        [string]$Directory
    )

    if ((Test-Path $Directory) -and ($env:Path -notlike "*$Directory*")) {
        $env:Path = "$Directory;$env:Path"
    }
}

function Write-Section {
    param (
        [string]$Title
    )

    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   $Title" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
}

# ============================================================
# ETAPA 1 - JAVA + MAVEN + TOMCAT
# ============================================================

Write-Section "ETAPA 1 - JAVA + MAVEN + TOMCAT"

# ------------------------------------------------------------
# 1. WINGET
# ------------------------------------------------------------

Write-Host "[1/4] Comprobando winget..." -ForegroundColor Yellow

if (-not (Test-CommandExists "winget")) {
    Write-Host ""
    Write-Host "ERROR: winget no esta disponible." -ForegroundColor Red
    Write-Host "Instala/actualiza Windows App Installer y vuelve a ejecutar el script."
    exit 1
}

Write-Host "OK - winget disponible." -ForegroundColor Green

# ------------------------------------------------------------
# 2. JAVA 25
# ------------------------------------------------------------

Write-Host ""
Write-Host "[2/4] Comprobando Java..." -ForegroundColor Yellow

$JavaHome = $null

$JavaCandidates = Get-ChildItem `
    "C:\Program Files\Eclipse Adoptium" `
    -Directory `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "jdk-25*" } |
    Sort-Object Name -Descending

if ($JavaCandidates.Count -gt 0) {
    $JavaHome = $JavaCandidates[0].FullName
}

if (-not $JavaHome -and $env:JAVA_HOME) {
    if (
        (Test-Path $env:JAVA_HOME) -and
        (Test-Path (Join-Path $env:JAVA_HOME "bin\java.exe"))
    ) {
        $JavaHome = $env:JAVA_HOME
    }
}

if (-not $JavaHome) {

    Write-Host "JDK 25 no encontrado." -ForegroundColor Yellow
    Write-Host "Instalando Eclipse Temurin JDK 25..." -ForegroundColor Yellow

    winget install `
        --id EclipseAdoptium.Temurin.25.JDK `
        --exact `
        --accept-source-agreements `
        --accept-package-agreements

    Write-Host ""
    Write-Host "JDK 25 instalado." -ForegroundColor Green
    Write-Host "Cierra esta terminal, abre una nueva y ejecuta nuevamente:" -ForegroundColor Cyan
    Write-Host ".\setup.ps1"
    exit 0
}

$env:JAVA_HOME = $JavaHome
Add-ToCurrentPath (Join-Path $JavaHome "bin")

Write-Host "JAVA_HOME:" -ForegroundColor Green
Write-Host $env:JAVA_HOME

Write-Host ""
Write-Host "Version de Java:" -ForegroundColor Green
java -version

# ------------------------------------------------------------
# 3. MAVEN
# ------------------------------------------------------------

Write-Host ""
Write-Host "[3/4] Comprobando Maven..." -ForegroundColor Yellow

if (-not (Test-CommandExists "mvn")) {

    Write-Host "Maven no encontrado. Instalando Maven..." -ForegroundColor Yellow

    winget install `
        --id Apache.Maven `
        --exact `
        --accept-source-agreements `
        --accept-package-agreements

    Write-Host ""
    Write-Host "Maven instalado." -ForegroundColor Green
    Write-Host "Cierra esta terminal, abre una nueva y ejecuta nuevamente:" -ForegroundColor Cyan
    Write-Host ".\setup.ps1"
    exit 0
}

Write-Host "OK - Maven encontrado." -ForegroundColor Green

# ------------------------------------------------------------
# 4. TOMCAT
# ------------------------------------------------------------

Write-Host ""
Write-Host "[4/4] Comprobando Apache Tomcat..." -ForegroundColor Yellow

if (-not (Test-Path $TomcatDir)) {

    Write-Host "Tomcat no encontrado." -ForegroundColor Yellow
    Write-Host "Descargando Apache Tomcat $TomcatVersion..." -ForegroundColor Yellow

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $ToolsDir | Out-Null

    $TomcatZip = Join-Path `
        $ToolsDir `
        "tomcat.zip"

    $TomcatUrl = `
        "https://dlcdn.apache.org/tomcat/tomcat-10/" +
        "v$TomcatVersion/bin/" +
        "apache-tomcat-$TomcatVersion-windows-x64.zip"

    Invoke-WebRequest `
        -Uri $TomcatUrl `
        -OutFile $TomcatZip

    Write-Host "Extrayendo Tomcat..." -ForegroundColor Yellow

    Expand-Archive `
        -Path $TomcatZip `
        -DestinationPath $ToolsDir `
        -Force

    Remove-Item `
        $TomcatZip `
        -Force

    Write-Host "OK - Tomcat instalado." -ForegroundColor Green

}
else {

    Write-Host "OK - Tomcat ya esta instalado." -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   ETAPA 1 COMPLETADA" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

Write-Host "Java:" -ForegroundColor Cyan
java -version

Write-Host ""
Write-Host "Maven:" -ForegroundColor Cyan
mvn -version | Select-Object -First 1

Write-Host ""
Write-Host "Tomcat:" -ForegroundColor Cyan
Write-Host $TomcatDir

Write-Host ""
Write-Host "El entorno base esta listo." -ForegroundColor Green

# ============================================================
# ETAPA 2 - SQL SERVER + BASE DE DATOS + HIBERNATE
# ============================================================

Write-Section "ETAPA 2 - BASE DE DATOS"

# ------------------------------------------------------------
# 5. SQLCMD
# ------------------------------------------------------------

Write-Host "[5/9] Comprobando sqlcmd..." -ForegroundColor Yellow

if (-not (Test-CommandExists "sqlcmd")) {

    Write-Host "sqlcmd no encontrado. Instalando sqlcmd..." -ForegroundColor Yellow

    winget install `
        sqlcmd `
        --accept-source-agreements `
        --accept-package-agreements

    # Ubicacion habitual de sqlcmd (Go)
    Add-ToCurrentPath "C:\Program Files\sqlcmd"

    if (-not (Test-CommandExists "sqlcmd")) {

        Write-Host ""
        Write-Host "sqlcmd fue instalado, pero esta terminal todavia no reconoce el comando." -ForegroundColor Yellow
        Write-Host "Cierra esta terminal, abre una nueva y ejecuta nuevamente .\setup.ps1"
        exit 0
    }
}

Write-Host "OK - sqlcmd disponible." -ForegroundColor Green

# ------------------------------------------------------------
# 6. COMPROBAR PUERTO SQL SERVER
# ------------------------------------------------------------

Write-Host ""
Write-Host "[6/9] Comprobando SQL Server en 127.0.0.1:1433..." -ForegroundColor Yellow

$SqlConnection = Test-NetConnection `
    -ComputerName "127.0.0.1" `
    -Port 1433 `
    -InformationLevel Quiet

if (-not $SqlConnection) {

    Write-Host ""
    Write-Host "ERROR: No se puede acceder a SQL Server en el puerto 1433." -ForegroundColor Red
    Write-Host "Verifica que SQL Server este iniciado y configurado para TCP/IP."
    exit 1
}

Write-Host "OK - SQL Server responde en el puerto 1433." -ForegroundColor Green

# ------------------------------------------------------------
# 7. CREDENCIALES
# ------------------------------------------------------------

Write-Host ""
Write-Host "[7/9] Configuracion de credenciales SQL Server..." -ForegroundColor Yellow
Write-Host ""

$SqlCredential = Get-Credential `
    -UserName "sa" `
    -Message "Ingrese las credenciales de SQL Server"

$SqlUsername = $SqlCredential.UserName

$SqlPasswordPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
    $SqlCredential.Password
)

$SqlPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
    $SqlPasswordPtr
)

[Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
    $SqlPasswordPtr
)

if (
    [string]::IsNullOrWhiteSpace($SqlUsername) -or
    [string]::IsNullOrWhiteSpace($SqlPassword)
) {

    Write-Host ""
    Write-Host "ERROR: Las credenciales no pueden estar vacias." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Comprobando credenciales..." -ForegroundColor Yellow

$CredentialTest = & sqlcmd `
    -S "127.0.0.1,1433" `
    -U $SqlUsername `
    -P $SqlPassword `
    -d "master" `
    -C `
    -h -1 `
    -W `
    -Q "SET NOCOUNT ON; SELECT 1;" `
    2>&1

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERROR: Las credenciales de SQL Server no son validas." -ForegroundColor Red
    Write-Host $CredentialTest
    exit 1
}

Write-Host "OK - Credenciales validas." -ForegroundColor Green

# ------------------------------------------------------------
# 8. BASE DE DATOS Y TABLA
# ------------------------------------------------------------

Write-Host ""
Write-Host "[8/9] Comprobando base de datos gestion_tareas..." -ForegroundColor Yellow

$DatabaseCheck = & sqlcmd `
    -S "127.0.0.1,1433" `
    -U $SqlUsername `
    -P $SqlPassword `
    -d "master" `
    -C `
    -h -1 `
    -W `
    -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = 'gestion_tareas';" `
    2>&1

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERROR: No se pudo consultar SQL Server." -ForegroundColor Red
    Write-Host $DatabaseCheck
    exit 1
}

$DatabaseExists = ($DatabaseCheck | Out-String).Trim()

# ------------------------------------------------------------
# BASE DE DATOS NO EXISTE
# ------------------------------------------------------------

if ($DatabaseExists -eq "0") {

    Write-Host "La base de datos gestion_tareas no existe." -ForegroundColor Yellow

    $SchemaPath = Join-Path `
        $ProjectRoot `
        "database\schema.sql"

    if (-not (Test-Path $SchemaPath)) {

        Write-Host ""
        Write-Host "ERROR: No se encontro el archivo:" -ForegroundColor Red
        Write-Host $SchemaPath
        exit 1
    }

    Write-Host "Ejecutando schema.sql completo..." -ForegroundColor Yellow

    & sqlcmd `
        -S "127.0.0.1,1433" `
        -U $SqlUsername `
        -P $SqlPassword `
        -d "master" `
        -C `
        -b `
        -i $SchemaPath

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "ERROR: No se pudo ejecutar schema.sql." -ForegroundColor Red
        exit 1
    }

    Write-Host "OK - Base de datos y estructura creadas." -ForegroundColor Green
}

# ------------------------------------------------------------
# BASE DE DATOS YA EXISTE
# ------------------------------------------------------------

else {

    Write-Host "La base de datos gestion_tareas ya existe." -ForegroundColor Green

    Write-Host "Comprobando tabla tareas..." -ForegroundColor Yellow

    # IMPORTANTE:
    # Esta consulta devuelve el nombre "tareas", no el numero 1.
    # Asi evitamos la contradiccion que tenia el script anterior.
    $TableCheck = & sqlcmd `
        -S "127.0.0.1,1433" `
        -U $SqlUsername `
        -P $SqlPassword `
        -d "gestion_tareas" `
        -C `
        -h -1 `
        -W `
        -Q "SET NOCOUNT ON; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tareas';" `
        2>&1

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "ERROR: No se pudo consultar la tabla tareas." -ForegroundColor Red
        Write-Host $TableCheck
        exit 1
    }

    $TableExists = ($TableCheck | Out-String).Trim()

    # --------------------------------------------------------
    # TABLA YA EXISTE
    # --------------------------------------------------------

    if ($TableExists -eq "tareas") {

        Write-Host "OK - La tabla tareas ya existe." -ForegroundColor Green
        Write-Host "No se ejecutara nuevamente schema.sql." -ForegroundColor DarkGray
    }

    # --------------------------------------------------------
    # TABLA NO EXISTE
    # --------------------------------------------------------

    else {

        Write-Host "La tabla tareas no existe." -ForegroundColor Yellow
        Write-Host "Creando estructura de la base de datos..." -ForegroundColor Yellow

        $SchemaPath = Join-Path `
            $ProjectRoot `
            "database\schema.sql"

        if (-not (Test-Path $SchemaPath)) {

            Write-Host ""
            Write-Host "ERROR: No se encontro el archivo:" -ForegroundColor Red
            Write-Host $SchemaPath
            exit 1
        }

        # Leer schema.sql
        $SchemaContent = Get-Content `
            -Path $SchemaPath `
            -Raw

        # Eliminar CREATE DATABASE ... GO
        $SchemaContent = [regex]::Replace(
            $SchemaContent,
            '(?is)CREATE\s+DATABASE\s+.*?GO\s*',
            ''
        )

        # Eliminar USE gestion_tareas ... GO
        $SchemaContent = [regex]::Replace(
            $SchemaContent,
            '(?im)^\s*USE\s+gestion_tareas\s*;?\s*GO\s*',
            ''
        )

        $TempSchemaPath = Join-Path `
            $env:TEMP `
            "GR06_schema_temp.sql"

        Set-Content `
            -Path $TempSchemaPath `
            -Value $SchemaContent `
            -Encoding UTF8

        & sqlcmd `
            -S "127.0.0.1,1433" `
            -U $SqlUsername `
            -P $SqlPassword `
            -d "gestion_tareas" `
            -C `
            -b `
            -i $TempSchemaPath

        $SchemaResult = $LASTEXITCODE

        Remove-Item `
            $TempSchemaPath `
            -Force `
            -ErrorAction SilentlyContinue

        if ($SchemaResult -ne 0) {

            Write-Host ""
            Write-Host "ERROR: No se pudo crear la estructura de la base de datos." -ForegroundColor Red
            exit 1
        }

        Write-Host "OK - Tabla y estructura creadas correctamente." -ForegroundColor Green
    }
}

# ------------------------------------------------------------
# CONFIGURACION LOCAL DE HIBERNATE
# ------------------------------------------------------------

Write-Host ""
Write-Host "[9/9] Generando configuracion local de Hibernate..." -ForegroundColor Yellow

$HibernateProperties = @"
hibernate.connection.url=jdbc:sqlserver://127.0.0.1:1433;databaseName=gestion_tareas;encrypt=false;trustServerCertificate=true;loginTimeout=30
hibernate.connection.username=$SqlUsername
hibernate.connection.password=$SqlPassword
"@

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

[System.IO.File]::WriteAllText(
    $HibernateLocalPath,
    $HibernateProperties,
    $Utf8NoBom
)

Write-Host "OK - Configuracion local de Hibernate creada sin BOM." -ForegroundColor Green

# ------------------------------------------------------------
# ASEGURAR QUE LA CONFIGURACION LOCAL NO ENTRE A GIT
# ------------------------------------------------------------

$GitIgnorePath = Join-Path `
    $ProjectRoot `
    ".gitignore"

if (Test-Path $GitIgnorePath) {

    $GitIgnoreContent = Get-Content `
        -Path $GitIgnorePath `
        -Raw

    if ($GitIgnoreContent -notmatch '(?m)^\s*hibernate\.local\.properties\s*$') {

        Add-Content `
            -Path $GitIgnorePath `
            -Value "`r`nhibernate.local.properties"

        Write-Host "OK - hibernate.local.properties agregado a .gitignore." -ForegroundColor Green
    }
}

# ------------------------------------------------------------
# VERIFICACION FINAL DE TABLA
# ------------------------------------------------------------

Write-Host ""
Write-Host "Verificando acceso a gestion_tareas..." -ForegroundColor Yellow

$FinalTest = & sqlcmd `
    -S "127.0.0.1,1433" `
    -U $SqlUsername `
    -P $SqlPassword `
    -d "gestion_tareas" `
    -C `
    -h -1 `
    -W `
    -Q "SET NOCOUNT ON; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tareas';" `
    2>&1

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERROR: No se pudo verificar la tabla tareas." -ForegroundColor Red
    Write-Host $FinalTest
    exit 1
}

$FinalTable = ($FinalTest | Out-String).Trim()

if ($FinalTable -eq "tareas") {

    Write-Host "OK - Tabla tareas encontrada." -ForegroundColor Green
}
else {

    Write-Host ""
    Write-Host "ERROR: La tabla tareas no fue encontrada." -ForegroundColor Red
    Write-Host "Resultado recibido:"
    Write-Host $FinalTable
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   ETAPA 2 COMPLETADA" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

Write-Host "Base de datos:" -ForegroundColor Cyan
Write-Host "gestion_tareas"

Write-Host ""
Write-Host "Servidor:" -ForegroundColor Cyan
Write-Host "127.0.0.1:1433"

Write-Host ""
Write-Host "Configuracion local:" -ForegroundColor Cyan
Write-Host $HibernateLocalPath

Write-Host ""
Write-Host "La contrasena NO se almacena en Git." -ForegroundColor Green

# ============================================================
# ETAPA 3 - COMPILACION + WAR + TOMCAT
# ============================================================

Write-Section "ETAPA 3 - APLICACION WEB"

# ------------------------------------------------------------
# 10. COMPILAR PROYECTO
# ------------------------------------------------------------

Write-Host "[10/13] Compilando proyecto con Maven..." -ForegroundColor Yellow

Set-Location $ProjectRoot

mvn clean package

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERROR: Maven no pudo compilar el proyecto." -ForegroundColor Red
    exit 1
}

Write-Host "OK - Proyecto compilado correctamente." -ForegroundColor Green

# ------------------------------------------------------------
# 11. LOCALIZAR WAR
# ------------------------------------------------------------

Write-Host ""
Write-Host "[11/13] Buscando archivo WAR..." -ForegroundColor Yellow

$TargetDir = Join-Path `
    $ProjectRoot `
    "target"

$WarFiles = Get-ChildItem `
    -Path $TargetDir `
    -Filter "*.war" `
    -File `
    -ErrorAction SilentlyContinue

if (-not $WarFiles -or $WarFiles.Count -eq 0) {

    Write-Host ""
    Write-Host "ERROR: Maven no genero ningun archivo WAR." -ForegroundColor Red
    exit 1
}

# Si hay varios WAR, tomar el primero que no sea sources/javadoc
$WarFile = $WarFiles |
    Where-Object {
        $_.Name -notmatch "-sources\.war$" -and
        $_.Name -notmatch "-javadoc\.war$"
    } |
    Select-Object -First 1

if (-not $WarFile) {
    $WarFile = $WarFiles[0]
}

$AppName = [System.IO.Path]::GetFileNameWithoutExtension(
    $WarFile.Name
)

Write-Host "OK - WAR encontrado:" -ForegroundColor Green
Write-Host $WarFile.FullName

# ------------------------------------------------------------
# 12. DETENER TOMCAT ANTERIOR Y COPIAR WAR
# ------------------------------------------------------------

Write-Host ""
Write-Host "[12/13] Preparando despliegue en Tomcat..." -ForegroundColor Yellow

if (-not (Test-Path $WebappsDir)) {

    Write-Host ""
    Write-Host "ERROR: No se encontro la carpeta webapps de Tomcat." -ForegroundColor Red
    Write-Host $WebappsDir
    exit 1
}

$ShutdownBat = Join-Path `
    $TomcatDir `
    "bin\shutdown.bat"

$StartupBat = Join-Path `
    $TomcatDir `
    "bin\startup.bat"

if (Test-Path $ShutdownBat) {

    Write-Host "Deteniendo Tomcat si estaba ejecutandose..."

    try {
        & $ShutdownBat 2>$null
    }
    catch {
        # No hacer nada si Tomcat no estaba iniciado.
    }

    Start-Sleep -Seconds 4
}

# Eliminar WAR anterior
Get-ChildItem `
    -Path $WebappsDir `
    -Filter "*.war" `
    -File `
    -ErrorAction SilentlyContinue |
    Remove-Item `
        -Force `
        -ErrorAction SilentlyContinue

# Eliminar carpeta desplegada anteriormente
$PreviousAppDir = Join-Path `
    $WebappsDir `
    $AppName

if (Test-Path $PreviousAppDir) {

    Remove-Item `
        $PreviousAppDir `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue
}

Copy-Item `
    -Path $WarFile.FullName `
    -Destination $WebappsDir `
    -Force

Write-Host "OK - WAR copiado a Tomcat." -ForegroundColor Green

# ------------------------------------------------------------
# 13. INICIAR TOMCAT
# ------------------------------------------------------------

Write-Host ""
Write-Host "[13/13] Iniciando Apache Tomcat..." -ForegroundColor Yellow

if (-not (Test-Path $StartupBat)) {

    Write-Host ""
    Write-Host "ERROR: No se encontro:" -ForegroundColor Red
    Write-Host $StartupBat
    exit 1
}

Start-Process `
    -FilePath $StartupBat `
    -WorkingDirectory (Join-Path $TomcatDir "bin")

Write-Host "Esperando a que Tomcat inicie..." -ForegroundColor Yellow

$TomcatReady = $false

for ($i = 1; $i -le 12; $i++) {

    Start-Sleep -Seconds 2

    $TomcatReady = Test-NetConnection `
        -ComputerName "127.0.0.1" `
        -Port 8080 `
        -InformationLevel Quiet

    if ($TomcatReady) {
        break
    }
}

$ContextPath = "/" + $AppName

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   ETAPA 3 COMPLETADA" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

if ($TomcatReady) {

    Write-Host "OK - Tomcat responde en el puerto 8080." -ForegroundColor Green
}
else {

    Write-Host "ADVERTENCIA - Tomcat no respondio en 8080 despues de la espera." -ForegroundColor Yellow
    Write-Host "Revisa los archivos de log en:"
    Write-Host (Join-Path $TomcatDir "logs")
}

Write-Host ""
Write-Host "Aplicacion:" -ForegroundColor Cyan
Write-Host "http://localhost:8080$ContextPath/"

Write-Host ""
Write-Host "WAR:" -ForegroundColor Cyan
Write-Host $WarFile.Name

Write-Host ""
Write-Host "Tomcat:" -ForegroundColor Cyan
Write-Host $TomcatDir

Write-Host ""
Write-Host "Base de datos:" -ForegroundColor Cyan
Write-Host "gestion_tareas"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   CONFIGURACION COMPLETADA" -ForegroundColor Green
Write-Host "   PROYECTO LISTO PARA USAR" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Limpiar la contraseña de memoria después de terminar.
$SqlPassword = $null
