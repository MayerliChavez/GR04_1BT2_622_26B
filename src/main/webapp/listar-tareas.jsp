<%@ page import="java.util.List" %>
<%@ page import="com.grupo04.app.model.Tarea" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Tareas</title>
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
<div class="container">
    <h1>📋 Mis Tareas</h1>
    
    <div class="stats">
        <div class="stat-card">
            <h3>Total</h3>
            <p class="stat-number"><%= request.getAttribute("totalTareas") %></p>
        </div>
        <div class="stat-card completed">
            <h3>Completadas</h3>
            <p class="stat-number"><%= request.getAttribute("completadas") %></p>
        </div>
        <div class="stat-card pending">
            <h3>Pendientes</h3>
            <p class="stat-number"><%= (Long)request.getAttribute("totalTareas") - (Long)request.getAttribute("completadas") %></p>
        </div>
    </div>
    
    <div class="filters">
        <a class="filter-btn <%= "todas".equals(request.getAttribute("filtroActual")) ? "active" : "" %>" href="tareas?action=filtro&filtro=todas">Todas</a>
        <a class="filter-btn <%= "pendientes".equals(request.getAttribute("filtroActual")) ? "active" : "" %>" href="tareas?action=filtro&filtro=pendientes">Pendientes</a>
        <a class="filter-btn <%= "completadas".equals(request.getAttribute("filtroActual")) ? "active" : "" %>" href="tareas?action=filtro&filtro=completadas">Completadas</a>
        <a class="btn btn-primary" href="tareas?action=nueva">+ Nueva Tarea</a>
    </div>
    
    <div class="tareas-container">
        <% 
            List<Tarea> tareas = (List<Tarea>) request.getAttribute("listarTareas");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            
            if (tareas != null && !tareas.isEmpty()) {
                for (Tarea t : tareas) {
        %>
        <div class="tarea-card <%= t.isCompletada() ? "completada" : "" %>">
            <div class="tarea-header">
                <h3><%= t.getTitulo() %></h3>
                <span class="estado <%= t.isCompletada() ? "completada" : "pendiente" %>">
                    <%= t.isCompletada() ? "✓ Completada" : "● Pendiente" %>
                </span>
            </div>
            
            <% if (t.getDescripcion() != null && !t.getDescripcion().isEmpty()) { %>
                <p class="descripcion"><%= t.getDescripcion() %></p>
            <% } %>
            
            <div class="tarea-meta">
                <small>Creada: <%= t.getFechaCreacion().format(formatter) %></small>
                <% if (t.getFechaVencimiento() != null) { %>
                    <small>Vencimiento: <%= t.getFechaVencimiento().format(formatter) %></small>
                <% } %>
            </div>
            
            <div class="tarea-acciones">
                <form method="POST" action="tareas" style="display:inline;">
                    <input type="hidden" name="action" value="completar">
                    <input type="hidden" name="id" value="<%= t.getId() %>">
                    <button type="submit" class="btn btn-small btn-check">
                        <%= t.isCompletada() ? "◇ Desmarcar" : "☑ Completar" %>
                    </button>
                </form>
                <a href="tareas?action=editar&id=<%= t.getId() %>" class="btn btn-small btn-edit">✎ Editar</a>
                <form method="POST" action="tareas" style="display:inline;" onsubmit="return confirm('¿Deseas eliminar esta tarea?');">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="id" value="<%= t.getId() %>">
                    <button type="submit" class="btn btn-small btn-delete">✕ Eliminar</button>
                </form>
            </div>
        </div>
        <% 
                }
            } else {
        %>
        <div class="empty-state">
            <p>No hay tareas. <a href="tareas?action=nueva">Crea tu primera tarea</a></p>
        </div>
        <% } %>
    </div>
    
    <a href="index.jsp" class="btn btn-secondary">Volver al Inicio</a>
</div>
</body>
</html>
