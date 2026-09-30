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

@WebServlet("/tareas")
public class TareaServlet extends HttpServlet {

    private final TareaDAO tareaDAO = new TareaDAO();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "nueva":
                request.getRequestDispatcher("/form-tarea.jsp").forward(request, response);
                break;
            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                Tarea tareaEditar = tareaDAO.obtenerPorId(idEditar);
                request.setAttribute("tarea", tareaEditar);
                request.getRequestDispatcher("/editar-tarea.jsp").forward(request, response);
                break;
            case "completar":
                int idCompletar = Integer.parseInt(request.getParameter("id"));
                Tarea tareaCompletar = tareaDAO.obtenerPorId(idCompletar);
                if (tareaCompletar != null) {
                    tareaCompletar.setCompletada(!tareaCompletar.isCompletada());
                    tareaDAO.actualizar(tareaCompletar);
                }
                response.sendRedirect("tareas");
                break;
            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                tareaDAO.eliminar(idEliminar);
                response.sendRedirect("tareas");
                break;
            case "filtro":
                String filtro = request.getParameter("filtro");
                if ("completadas".equals(filtro)) {
                    request.setAttribute("listarTareas", tareaDAO.listarPorEstado(true));
                    request.setAttribute("filtroActual", "completadas");
                } else if ("pendientes".equals(filtro)) {
                    request.setAttribute("listarTareas", tareaDAO.listarPorEstado(false));
                    request.setAttribute("filtroActual", "pendientes");
                } else {
                    request.setAttribute("listarTareas", tareaDAO.listarTodas());
                    request.setAttribute("filtroActual", "todas");
                }
                request.setAttribute("totalTareas", tareaDAO.contarTareas());
                request.setAttribute("completadas", tareaDAO.contarCompletadas());
                request.getRequestDispatcher("/listar-tareas.jsp").forward(request, response);
                break;
            default:
                request.setAttribute("listarTareas", tareaDAO.listarTodas());
                request.setAttribute("totalTareas", tareaDAO.contarTareas());
                request.setAttribute("completadas", tareaDAO.contarCompletadas());
                request.setAttribute("filtroActual", "todas");
                request.getRequestDispatcher("/listar-tareas.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("guardar".equals(action)) {
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            String fechaVencimientoStr = request.getParameter("fechaVencimiento");

            Tarea tarea = new Tarea(titulo, descripcion);
            
            if (fechaVencimientoStr != null && !fechaVencimientoStr.isEmpty()) {
                try {
                    LocalDateTime fechaVencimiento = LocalDateTime.parse(fechaVencimientoStr, formatter);
                    tarea.setFechaVencimiento(fechaVencimiento);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            tareaDAO.guardar(tarea);
            response.sendRedirect("tareas");
            return;
        }

        if ("actualizar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String titulo = request.getParameter("titulo");
            String descripcion = request.getParameter("descripcion");
            String fechaVencimientoStr = request.getParameter("fechaVencimiento");

            Tarea tarea = tareaDAO.obtenerPorId(id);
            if (tarea != null) {
                tarea.setTitulo(titulo);
                tarea.setDescripcion(descripcion);
                
                if (fechaVencimientoStr != null && !fechaVencimientoStr.isEmpty()) {
                    try {
                        LocalDateTime fechaVencimiento = LocalDateTime.parse(fechaVencimientoStr, formatter);
                        tarea.setFechaVencimiento(fechaVencimiento);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                
                tareaDAO.actualizar(tarea);
            }

            response.sendRedirect("tareas");
        }
    }
}
