package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.enums.EstadoTurno;
import com.joel.centrofisioterapeuta.logica.*;
import com.joel.centrofisioterapeuta.utils.JsonUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "TurnoServlet", value = "/TurnoServlet")
public class TurnoServlet extends HttpServlet {

    private LogicController controladora;
    private DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    public void init() throws ServletException {
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
                    listarTurnos(request, response);
                    break;
                case "obtener":
                    obtenerTurnoJSON(request, response);
                    break;
                case "obtenerHorarioFisio":
                    obtenerHorarioFisioJSON(request, response);
                    break;
                default:
                    listarTurnos(request, response);
                    break;
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if (!verificarSesion(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "crear":
                    crearTurno(request, response);
                    break;
                case "editar":
                    editarTurno(request, response);
                    break;
                case "cambiarEstado":
                    cambiarEstadoTurno(request, response);
                    break;
                case "eliminar":
                    eliminarTurno(request, response);
                    break;
                default:
                    listarTurnos(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }

    private void crearTurno(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            // Obtener parámetros
            String idPacienteStr = request.getParameter("idPaciente");
            String idFisioterapeutaStr = request.getParameter("idFisioterapeuta");
            String fechaTurnoStr = request.getParameter("fechaTurno");
            String horaTurnoStr = request.getParameter("horaTurno");
            String observacion = request.getParameter("observacion");

            // Validaciones
            validarParametro(idPacienteStr, "Debe seleccionar un paciente");
            validarParametro(idFisioterapeutaStr, "Debe seleccionar un fisioterapeuta");
            validarParametro(fechaTurnoStr, "La fecha del turno es obligatoria");
            validarParametro(horaTurnoStr, "La hora del turno es obligatoria");

            int idPaciente = Integer.parseInt(idPacienteStr);
            int idFisioterapeuta = Integer.parseInt(idFisioterapeutaStr);

            // Obtener paciente y fisioterapeuta
            Paciente paciente = controladora.traerPacienteLogico(idPaciente);
            if (paciente == null) {
                throw new IllegalArgumentException("Paciente no encontrado");
            }

            Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaLogico(idFisioterapeuta);
            if (fisioterapeuta == null) {
                throw new IllegalArgumentException("Fisioterapeuta no encontrado");
            }

            // Parsear fecha y hora
            LocalDate fechaTurno = LocalDate.parse(fechaTurnoStr, dateFormatter);
            LocalTime horaTurno = LocalTime.parse(horaTurnoStr, timeFormatter);


            // Validar fecha no sea pasada
            if (fechaTurno.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("No se pueden crear turnos en fechas pasadas");
            }

            // Validar horario del fisioterapeuta
            if (fisioterapeuta.getHorario() != null) {
                Horario horarioFisio = fisioterapeuta.getHorario();

                // Validar que la hora esté dentro del horario
                if (horaTurno.isBefore(horarioFisio.getHoraInicio()) ||
                        horaTurno.isAfter(horarioFisio.getHoraFin())) {
                    throw new IllegalArgumentException(
                            "La hora seleccionada está fuera del horario del fisioterapeuta (" +
                                    horarioFisio.getHoraInicio() + " - " + horarioFisio.getHoraFin() + ")"
                    );
                }

                // Validar día de la semana
                java.time.DayOfWeek diaSemana = fechaTurno.getDayOfWeek();
                String diaStr = convertirDiaSemana(diaSemana);

                if (!horarioFisio.getDiaDeSemana().name().equals(diaStr)) {
                    throw new IllegalArgumentException(
                            "El fisioterapeuta no trabaja los " + obtenerNombreDia(diaSemana) +
                                    ". Su horario es: " + horarioFisio.getDiaDeSemana()
                    );
                }
            }

            // Validar disponibilidad (no hay otro turno a la misma hora)
            List<Turno> turnosFisio = controladora.traerTurnosPorFisioterapeutaLogico(idFisioterapeuta);
            if (turnosFisio != null) {
                for (Turno t : turnosFisio) {
                    if (t.getEstado() != EstadoTurno.CANCELADO) {
                        if (t.getFechaTurno().equals(fechaTurno) &&
                                t.getHoraTurno().equals(horaTurno)) {
                            throw new IllegalArgumentException(
                                    "El fisioterapeuta ya tiene un turno programado a esta hora"
                            );
                        }
                    }
                }
            }

            // Crear turno
            Turno nuevoTurno = new Turno();
            nuevoTurno.setPacient(paciente);
            nuevoTurno.setFisio(fisioterapeuta);
            nuevoTurno.setFechaTurno(fechaTurno);
            nuevoTurno.setHoraTurno(horaTurno);
            nuevoTurno.setEstado(EstadoTurno.PENDIENTE);
            nuevoTurno.setObservacion(observacion != null ? observacion.trim() : "");


            // Guardar
            controladora.crearTurnoLogico(nuevoTurno);

            session.setAttribute("mensaje", "Turno creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/TurnoServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al crear turno: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/TurnoServlet");
        }

    }

    private void editarTurno(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idTurno = Integer.parseInt(request.getParameter("idTurno"));
            String idPacienteStr = request.getParameter("idPaciente");
            String idFisioterapeutaStr = request.getParameter("idFisioterapeuta");
            String fechaTurnoStr = request.getParameter("fechaTurno");
            String horaTurnoStr = request.getParameter("horaTurno");
            String estadoStr = request.getParameter("estado");
            String observacion = request.getParameter("observacion");

            // Obtener turno
            Turno turno = controladora.traerTurnoLogico(idTurno);
            if (turno == null) {
                throw new IllegalArgumentException("Turno no encontrado");
            }

            // Actualizar datos
            int idPaciente = Integer.parseInt(idPacienteStr);
            int idFisioterapeuta = Integer.parseInt(idFisioterapeutaStr);

            Paciente paciente = controladora.traerPacienteLogico(idPaciente);
            Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaLogico(idFisioterapeuta);

            if (paciente == null || fisioterapeuta == null) {
                throw new IllegalArgumentException("Paciente o fisioterapeuta no encontrado");
            }

            turno.setPacient(paciente);
            turno.setFisio(fisioterapeuta);
            turno.setFechaTurno(LocalDate.parse(fechaTurnoStr, dateFormatter));
            turno.setHoraTurno(LocalTime.parse(horaTurnoStr, timeFormatter));
            turno.setEstado(EstadoTurno.valueOf(estadoStr));
            turno.setObservacion(observacion != null ? observacion.trim() : "");

            // Guardar cambios
            controladora.editarTurnoLogico(turno);

            session.setAttribute("mensaje", "Turno actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/TurnoServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/TurnoServlet");
        }

    }

    private void cambiarEstadoTurno(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idTurno = Integer.parseInt(request.getParameter("idTurno"));
            String estadoStr = request.getParameter("estado");

            Turno turno = controladora.traerTurnoLogico(idTurno);
            if (turno == null) {
                throw new IllegalArgumentException("Turno no encontrado");
            }

            EstadoTurno nuevoEstado = EstadoTurno.valueOf(estadoStr);
            turno.setEstado(nuevoEstado);

            controladora.editarTurnoLogico(turno);

            String mensaje = "";
            switch (nuevoEstado) {
                case CONFIRMADO:
                    mensaje = "Turno confirmado";
                    break;
                case COMPLETADO:
                    mensaje = "Turno marcado como completado";
                    break;
                case CANCELADO:
                    mensaje = "Turno cancelado";
                    break;
                default:
                    mensaje = "Estado actualizado";
            }

            session.setAttribute("mensaje", mensaje);
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/TurnoServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al cambiar estado: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/TurnoServlet");
        }

    }

    private void eliminarTurno(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idTurno = Integer.parseInt(request.getParameter("idTurno"));

            controladora.eliminarTurnoLogico(idTurno);

            session.setAttribute("mensaje", "Turno eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/TurnoServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/TurnoServlet");
        }

    }

    private void listarTurnos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            String rol = (String) session.getAttribute("rol");
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            // Obtener turnos según el rol
            List<Turno> turnos;

            if ("Fisioterapeuta".equals(rol)) {
                // Fisioterapeuta: solo ve SUS turnos
                Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaPorUsuarioLogico(usuario.getIdUsuario());
                if (fisioterapeuta != null) {
                    turnos = controladora.traerTurnosPorFisioterapeutaLogico(fisioterapeuta.getId());
                } else {
                    turnos = new ArrayList<>();
                }
            } else {
                // Administrador y Recepcionista: ven TODOS los turnos
                turnos = controladora.traerTurnosLogico();
            }

            // Obtener listas para dropdowns
            List<Paciente> pacientes = controladora.traerPacientesLogico();
            List<Fisioterapeuta> fisioterapeutas = controladora.traerFisioterapeutasLogico();

            // Ordenar turnos por fecha DESC
            if (turnos != null) {
                turnos.sort((t1, t2) -> {
                    if (t2.getFechaTurno() == null) return -1;
                    if (t1.getFechaTurno() == null) return 1;
                    return t2.getFechaTurno().compareTo(t1.getFechaTurno());
                });
            }

            // Calcular estadísticas
            LocalDate hoy = LocalDate.now();
            LocalDate inicioSemana = hoy.minusDays(hoy.getDayOfWeek().getValue() - 1);
            LocalDate finSemana = inicioSemana.plusDays(6);

            int turnosHoy = 0;
            int turnosPendientes = 0;
            int turnosCompletados = 0;
            int turnosSemana = 0;

            if (turnos != null) {
                for (Turno t : turnos) {
                    // Turnos hoy
                    if (t.getFechaTurno() != null && t.getFechaTurno().equals(hoy)) {
                        turnosHoy++;
                    }

                    // Turnos esta semana
                    if (t.getFechaTurno() != null &&
                            !t.getFechaTurno().isBefore(inicioSemana) &&
                            !t.getFechaTurno().isAfter(finSemana)) {
                        turnosSemana++;
                    }

                    // Estados
                    if (t.getEstado() == EstadoTurno.PENDIENTE || t.getEstado() == EstadoTurno.CONFIRMADO) {
                        turnosPendientes++;
                    }
                    if (t.getEstado() == EstadoTurno.COMPLETADO) {
                        turnosCompletados++;
                    }
                }
            }

            // Fecha de hoy para el input date
            String fechaHoy = LocalDate.now().format(dateFormatter);

            // Pasar datos a la vista
            request.setAttribute("turnos", turnos);
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("fisioterapeutas", fisioterapeutas);
            request.setAttribute("turnosHoy", turnosHoy);
            request.setAttribute("turnosPendientes", turnosPendientes);
            request.setAttribute("turnosCompletados", turnosCompletados);
            request.setAttribute("turnosSemana", turnosSemana);
            request.setAttribute("fechaHoy", fechaHoy);

            request.getRequestDispatcher("/pages/gestionTurnos.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar turnos: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionTurnos.jsp").forward(request, response);
        }

    }

    private void obtenerTurnoJSON(HttpServletRequest request, HttpServletResponse response) {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Turno turno = controladora.traerTurnoLogico(id);

            if (turno == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Crear DTO para evitar referencias circulares
            Map<String, Object> turnoMap = new HashMap<>();
            turnoMap.put("idTurno", turno.getIdTurno());
            turnoMap.put("idPaciente", turno.getPacient().getId());
            turnoMap.put("idFisioterapeuta", turno.getFisio().getId());
            turnoMap.put("fechaTurnoStr", turno.getFechaTurno().format(dateFormatter));
            turnoMap.put("horaTurnoStr", turno.getHoraTurno().format(timeFormatter));
            turnoMap.put("estado", turno.getEstado().name());
            turnoMap.put("observacion", turno.getObservacion());

            String json = JsonUtils.toJson(turnoMap);
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }

    private void obtenerHorarioFisioJSON(HttpServletRequest request, HttpServletResponse response) {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Fisioterapeuta fisio = controladora.traerFisioterapeutaLogico(id);

            if (fisio == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            Map<String, Object> resultado = new HashMap<>();

            if (fisio.getHorario() != null) {
                Horario h = fisio.getHorario();
                Map<String, Object> horarioMap = new HashMap<>();
                horarioMap.put("diaDeSemana", obtenerNombreDia(h.getDiaDeSemana().name()));
                horarioMap.put("horaInicio", h.getHoraInicio().format(timeFormatter));
                horarioMap.put("horaFin", h.getHoraFin().format(timeFormatter));
                resultado.put("horario", horarioMap);
            } else {
                resultado.put("horario", null);
            }

            String json = JsonUtils.toJson(resultado);
            response.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }



    //Métodos adicionales
    private String convertirDiaSemana(java.time.DayOfWeek dia) {
        switch (dia) {
            case MONDAY: return "LUNES";
            case TUESDAY: return "MARTES";
            case WEDNESDAY: return "MIERCOLES";
            case THURSDAY: return "JUEVES";
            case FRIDAY: return "VIERNES";
            case SATURDAY: return "SABADO";
            case SUNDAY: return "DOMINGO";
            default: return "";
        }
    }

    private String obtenerNombreDia(java.time.DayOfWeek dia) {
        switch (dia) {
            case MONDAY: return "Lunes";
            case TUESDAY: return "Martes";
            case WEDNESDAY: return "Miércoles";
            case THURSDAY: return "Jueves";
            case FRIDAY: return "Viernes";
            case SATURDAY: return "Sábado";
            case SUNDAY: return "Domingo";
            default: return "";
        }
    }

    private String obtenerNombreDia(String diaEnum) {
        switch (diaEnum) {
            case "LUNES": return "Lunes";
            case "MARTES": return "Martes";
            case "MIERCOLES": return "Miércoles";
            case "JUEVES": return "Jueves";
            case "VIERNES": return "Viernes";
            case "SABADO": return "Sábado";
            case "DOMINGO": return "Domingo";
            default: return "";
        }
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
        listarTurnos(request, response);
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

}
