<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Tarea</title>
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
<div class="container">
    <h1>+ Nueva Tarea</h1>
    
    <div class="form-container">
        <form method="POST" action="tareas">
            <input type="hidden" name="action" value="guardar">
            
            <div class="form-group">
                <label for="titulo">Título *</label>
                <input type="text" id="titulo" name="titulo" placeholder="Ingresa el título de la tarea" required maxlength="200">
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea id="descripcion" name="descripcion" placeholder="Ingresa una descripción detallada (opcional)" rows="5"></textarea>
            </div>
            
            <div class="form-group">
                <label for="fechaVencimiento">Fecha de Vencimiento</label>
                <input type="datetime-local" id="fechaVencimiento" name="fechaVencimiento">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Guardar Tarea</button>
                <a href="tareas" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
