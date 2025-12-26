package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.enums.DiaDeSemana;
import com.joel.centrofisioterapeuta.logica.Fisioterapeuta;
import com.joel.centrofisioterapeuta.logica.Horario;
import com.joel.centrofisioterapeuta.logica.LogicController;
import com.joel.centrofisioterapeuta.utils.JsonUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;


@WebServlet(name = "HorarioServlet", value = "/HorarioServlet")
public class HorarioServlet extends HttpServlet {

    private LogicController controladora;
    private DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    public void init() throws ServletException {
        super.init();
        controladora = new LogicController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (!verificarSesion(request, response)) {
            return;
        }

        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "listar";
            }

            switch (action) {
                case "listar":
                    listarHorarios(request, response);
                    break;
                case "obtener":
                    obtenerHorarioJSON(request, response);
                    break;
                default:
                    listarHorarios(request, response);
                    break;
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Verificar sesión
        if (!verificarSesion(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "crear":
                    crearHorario(request, response);
                    break;
                case "editar":
                    editarHorario(request, response);
                    break;
                case "eliminar":
                    eliminarHorario(request, response);
                    break;
                default:
                    listarHorarios(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }
    }


    private void obtenerHorarioJSON(HttpServletRequest request, HttpServletResponse response) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Horario horario = controladora.traerHorarioLogico(id);

            if (horario == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Crear un mapa personalizado con las horas en formato String
            Map<String, Object> horarioMap = new HashMap<>();
            horarioMap.put("idHorario", horario.getIdHorario());
            horarioMap.put("diaDeSemana", horario.getDiaDeSemana().name());
            horarioMap.put("horaInicioStr", horario.getHoraInicio().format(timeFormatter));
            horarioMap.put("horaFinStr", horario.getHoraFin().format(timeFormatter));

            String json = JsonUtils.toJson(horarioMap);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void crearHorario(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            // Obtener parámetros
            String diaSemanaStr = request.getParameter("diaSemana");
            String horaInicioStr = request.getParameter("horaInicio");
            String horaFinStr = request.getParameter("horaFin");

            // Validaciones
            validarParametro(diaSemanaStr, "Debe seleccionar un día de la semana");
            validarParametro(horaInicioStr, "La hora de inicio es obligatoria");
            validarParametro(horaFinStr, "La hora de fin es obligatoria");

            // Convertir día a enum
            DiaDeSemana diaSemana;
            try {
                diaSemana = DiaDeSemana.valueOf(diaSemanaStr);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Día de semana inválido");
            }

            // Parsear horas
            LocalTime horaInicio = LocalTime.parse(horaInicioStr, timeFormatter);
            LocalTime horaFin = LocalTime.parse(horaFinStr, timeFormatter);

            // Validar que hora fin sea mayor que hora inicio
            if (horaFin.isBefore(horaInicio) || horaFin.equals(horaInicio)) {
                throw new IllegalArgumentException("La hora de fin debe ser posterior a la hora de inicio");
            }

            // Crear horario
            Horario nuevoHorario = new Horario();
            nuevoHorario.setDiaDeSemana(diaSemana);
            nuevoHorario.setHoraInicio(horaInicio);
            nuevoHorario.setHoraFin(horaFin);

            // Guardar
            controladora.crearHorarioLogico(nuevoHorario);

            session.setAttribute("mensaje", "Horario creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/HorarioServlet");

        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al crear horario: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        }

    }

    private void editarHorario(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idHorario = Integer.parseInt(request.getParameter("idHorario"));
            String diaSemanaStr = request.getParameter("diaSemana");
            String horaInicioStr = request.getParameter("horaInicio");
            String horaFinStr = request.getParameter("horaFin");

            // Validaciones
            validarParametro(diaSemanaStr, "Debe seleccionar un día");
            validarParametro(horaInicioStr, "La hora de inicio es obligatoria");
            validarParametro(horaFinStr, "La hora de fin es obligatoria");

            // Obtener horario
            Horario horario = controladora.traerHorarioLogico(idHorario);
            if (horario == null) {
                throw new IllegalArgumentException("Horario no encontrado");
            }

            // Convertir día a enum
            DiaDeSemana diaSemana = DiaDeSemana.valueOf(diaSemanaStr);

            // Parsear horas
            LocalTime horaInicio = LocalTime.parse(horaInicioStr, timeFormatter);
            LocalTime horaFin = LocalTime.parse(horaFinStr, timeFormatter);

            if (horaFin.isBefore(horaInicio) || horaFin.equals(horaInicio)) {
                throw new IllegalArgumentException("La hora de fin debe ser posterior a la hora de inicio");
            }

            // Actualizar
            horario.setDiaDeSemana(diaSemana);
            horario.setHoraInicio(horaInicio);
            horario.setHoraFin(horaFin);

            controladora.editarHorarioLogico(horario);

            session.setAttribute("mensaje", "Horario actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/HorarioServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        }

    }

    private void eliminarHorario(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idHorario = Integer.parseInt(request.getParameter("idHorario"));

            // Verificar si tiene fisioterapeutas asignados
            Horario horario = controladora.traerHorarioLogico(idHorario);
            if (horario != null && horario.getFisioterapeutaAsociado() != null
                    && !horario.getFisioterapeutaAsociado().isEmpty()) {
                session.setAttribute("mensaje",
                        "No se puede eliminar. Este horario tiene fisioterapeutas asignados. " +
                                "Primero debe reasignar los fisioterapeutas a otro horario.");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/HorarioServlet");
                return;
            }

            controladora.eliminarHorarioLogico(idHorario);

            session.setAttribute("mensaje", "Horario eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/HorarioServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/HorarioServlet");
        }

    }

    private void listarHorarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener horarios
            List<Horario> horarios = controladora.traerHorariosLogico();

            // Calcular estadísticas
            int totalHorarios = horarios != null ? horarios.size() : 0;

            // Fisioterapeutas únicos con horario
            Set<Integer> fisiosConHorario = new HashSet<>();
            if (horarios != null) {
                for (Horario h : horarios) {
                    if (h.getFisioterapeutaAsociado() != null) {
                        for (Object fisio : h.getFisioterapeutaAsociado()) {
                            com.joel.centrofisioterapeuta.logica.Fisioterapeuta f =
                                    (com.joel.centrofisioterapeuta.logica.Fisioterapeuta) fisio;
                            fisiosConHorario.add(f.getId());
                        }
                    }
                }
            }
            int fisioterapeutasConHorario = fisiosConHorario.size();

            // Horas semanales totales
            int horasSemanales = 0;
            Set<DiaDeSemana> diasUnicos = new HashSet<>();

            if (horarios != null) {
                for (Horario h : horarios) {
                    // Calcular horas del horario
                    if (h.getHoraInicio() != null && h.getHoraFin() != null) {
                        long horas = java.time.Duration.between(
                                h.getHoraInicio(),
                                h.getHoraFin()
                        ).toHours();
                        horasSemanales += horas;
                    }

                    // Días únicos
                    if (h.getDiaDeSemana() != null) {
                        diasUnicos.add(h.getDiaDeSemana());
                    }
                }
            }
            int diasActivos = diasUnicos.size();

            // Agrupar horarios por día
            Map<String, List<Horario>> horariosPorDia = new HashMap<>();
            String[] diasSemana = {"LUNES", "MARTES", "MIERCOLES", "JUEVES", "VIERNES", "SABADO", "DOMINGO"};

            for (String dia : diasSemana) {
                horariosPorDia.put(dia, new ArrayList<>());
            }

            if (horarios != null) {
                for (Horario h : horarios) {
                    if (h.getDiaDeSemana() != null) {
                        String diaKey = h.getDiaDeSemana().name();
                        if (horariosPorDia.containsKey(diaKey)) {
                            horariosPorDia.get(diaKey).add(h);
                        }
                    }
                }
            }

            // Pasar datos a la vista
            request.setAttribute("horarios", horarios);
            request.setAttribute("totalHorarios", totalHorarios);
            request.setAttribute("fisioterapeutasConHorario", fisioterapeutasConHorario);
            request.setAttribute("horasSemanales", horasSemanales);
            request.setAttribute("diasActivos", diasActivos);
            request.setAttribute("horariosPorDia", horariosPorDia);

            request.getRequestDispatcher("/pages/gestionHorarios.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar horarios: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionHorarios.jsp").forward(request, response);
        }
    }


    private boolean verificarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    private void validarParametro(String valor, String mensaje) {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(mensaje);
        }
    }


    private void manejarError(HttpServletRequest request, HttpServletResponse response,
                              Exception e, String mensajeBase)
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("error", mensajeBase + ": " + e.getMessage());
        listarHorarios(request, response);
    }

}
