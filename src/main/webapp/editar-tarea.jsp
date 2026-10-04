<%@ page import="com.grupo06.app.model.Tarea" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Tarea</title>
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
<div class="container">
    <h1>✎ Editar Tarea</h1>
    
    <% Tarea tarea = (Tarea) request.getAttribute("tarea"); %>
    
    <div class="form-container">
        <form method="POST" action="tareas">
            <input type="hidden" name="action" value="actualizar">
            <input type="hidden" name="id" value="<%= tarea.getId() %>">
            
            <div class="form-group">
                <label for="titulo">Título *</label>
                <input type="text" id="titulo" name="titulo" value="<%= tarea.getTitulo() %>" required maxlength="200">
            </div>
            
            <div class="form-group">
                <label for="descripcion">Descripción</label>
                <textarea id="descripcion" name="descripcion" rows="5"><%= tarea.getDescripcion() != null ? tarea.getDescripcion() : "" %></textarea>
            </div>
            
            <div class="form-group">
                <label for="fechaVencimiento">Fecha de Vencimiento</label>
                <% 
                    String fechaVencimiento = "";
                    if (tarea.getFechaVencimiento() != null) {
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                        fechaVencimiento = tarea.getFechaVencimiento().format(formatter);
                    }
                %>
                <input type="datetime-local" id="fechaVencimiento" name="fechaVencimiento" value="<%= fechaVencimiento %>">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Actualizar Tarea</button>
                <a href="tareas" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
