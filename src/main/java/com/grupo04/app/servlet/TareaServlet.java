package com.grupo04.app.servlet;

import com.grupo04.app.dao.TareaDAO;
import com.grupo04.app.model.Tarea;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet("/tareas")
public class TareaServlet extends HttpServlet {

    private final TareaDAO tareaDAO = new TareaDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || "listar".equals(action)) {
            mostrarTareas(request, response, "todas");
        } else switch (action) {
            case "nueva":
                request.getRequestDispatcher("/form-tarea.jsp").forward(request, response);
                break;
            case "editar":
                Tarea tarea = obtenerTarea(request, response);
                if (tarea == null) {
                    return;
                }
                request.setAttribute("tarea", tarea);
                request.getRequestDispatcher("/editar-tarea.jsp").forward(request, response);
                break;
            case "filtro":
                String filtro = request.getParameter("filtro");
                if (!"completadas".equals(filtro) && !"pendientes".equals(filtro)) {
                    filtro = "todas";
                }
                mostrarTareas(request, response, filtro);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("guardar".equals(action)) {
            String titulo = obtenerTitulo(request, response);
            if (titulo == null) {
                return;
            }

            Tarea tarea = new Tarea(titulo, request.getParameter("descripcion"));
            tarea.setFechaVencimiento(obtenerFechaVencimiento(request, response));
            if (response.getStatus() >= HttpServletResponse.SC_BAD_REQUEST) {
                return;
            }
            tareaDAO.guardar(tarea);
            response.sendRedirect(request.getContextPath() + "/tareas");
            return;
        }

        if ("actualizar".equals(action)) {
            Tarea tarea = obtenerTarea(request, response);
            if (tarea == null) {
                return;
            }

            String titulo = obtenerTitulo(request, response);
            if (titulo == null) {
                return;
            }
            LocalDateTime fechaVencimiento = obtenerFechaVencimiento(request, response);
            if (response.getStatus() >= HttpServletResponse.SC_BAD_REQUEST) {
                return;
            }

            tarea.setTitulo(titulo);
            tarea.setDescripcion(request.getParameter("descripcion"));
            tarea.setFechaVencimiento(fechaVencimiento);
            tareaDAO.actualizar(tarea);
            response.sendRedirect(request.getContextPath() + "/tareas");
            return;
        }

        if ("completar".equals(action) || "eliminar".equals(action)) {
            Tarea tarea = obtenerTarea(request, response);
            if (tarea == null) {
                return;
            }
            if ("completar".equals(action)) {
                tarea.setCompletada(!tarea.isCompletada());
                tareaDAO.actualizar(tarea);
            } else {
                tareaDAO.eliminar(tarea.getId());
            }
            response.sendRedirect(request.getContextPath() + "/tareas");
            return;
        }

        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
    }

    private void mostrarTareas(HttpServletRequest request, HttpServletResponse response, String filtro)
            throws ServletException, IOException {
        if ("completadas".equals(filtro)) {
            request.setAttribute("listarTareas", tareaDAO.listarPorEstado(true));
        } else if ("pendientes".equals(filtro)) {
            request.setAttribute("listarTareas", tareaDAO.listarPorEstado(false));
        } else {
            request.setAttribute("listarTareas", tareaDAO.listarTodas());
            filtro = "todas";
        }
        request.setAttribute("totalTareas", tareaDAO.contarTareas());
        request.setAttribute("completadas", tareaDAO.contarCompletadas());
        request.setAttribute("filtroActual", filtro);
        request.getRequestDispatcher("/listar-tareas.jsp").forward(request, response);
    }

    private Tarea obtenerTarea(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParametro = request.getParameter("id");
        try {
            int id = Integer.parseInt(idParametro);
            if (id <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El id debe ser positivo");
                return null;
            }
            Tarea tarea = tareaDAO.obtenerPorId(id);
            if (tarea == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tarea no encontrada");
            }
            return tarea;
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El id no es válido");
            return null;
        }
    }

    private String obtenerTitulo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String titulo = request.getParameter("titulo");
        if (titulo == null || titulo.trim().isEmpty() || titulo.trim().length() > 200) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El título es obligatorio y no debe superar 200 caracteres");
            return null;
        }
        return titulo.trim();
    }

    private LocalDateTime obtenerFechaVencimiento(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String valor = request.getParameter("fechaVencimiento");
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(valor, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "La fecha de vencimiento no es válida");
            return null;
        }
    }
}
