package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.logica.LogicController;
import com.joel.centrofisioterapeuta.logica.Paciente;
import com.joel.centrofisioterapeuta.logica.Responsable;
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
import java.util.Date;
import java.util.List;

@WebServlet(name = "PacienteServlet", value = "/PacienteServlet")
public class PacienteServlet extends HttpServlet {

    private LogicController controladora;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        controladora = new LogicController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Verificar sesión
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
                   listarPacientes(request, response);
                    break;
                case "ver":
                    verDetallePaciente(request, response);
                    break;
                case "obtener":
                    obtenerPacienteJSON(request, response);
                    break;
                case "historial":
                    verHistorialPaciente(request, response);
                    break;
                case "abrirEditar":
                    abrirModalEditar(request, response);
                    break;
                default:
                    listarPacientes(request, response);
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
                    crearPaciente(request, response);
                    break;
                case "editar":
                    editarPaciente(request, response);
                    break;
                case "eliminar":
                    eliminarPaciente(request, response);
                    break;
                default:
                    listarPacientes(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }

    private void verDetallePaciente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paciente paciente = controladora.traerPacienteLogico(id);

            if (paciente == null) {
                request.setAttribute("error", "Paciente no encontrado");
                listarPacientes(request, response);
                return;
            }

            // Obtener estadísticas del paciente
            // TODO: Implementar cuando tengas módulo de turnos
            int totalTurnos = 0;
            int turnosCompletados = 0;
            Date ultimoTurno = null;

            request.setAttribute("paciente", paciente);
            request.setAttribute("totalTurnos", totalTurnos);
            request.setAttribute("turnosCompletados", turnosCompletados);
            request.setAttribute("ultimoTurno", ultimoTurno);

            // TODO: Obtener próximos turnos
            // List<Turno> proximosTurnos = controladora.traerProximosTurnosPaciente(id);
            // request.setAttribute("proximosTurnos", proximosTurnos);

            request.getRequestDispatcher("/pages/detallePaciente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID inválido");
            listarPacientes(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar detalle");
            listarPacientes(request, response);
        }

    }

    private void obtenerPacienteJSON(HttpServletRequest request, HttpServletResponse response) {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paciente paciente = controladora.traerPacienteLogico(id);

            if (paciente == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Usar utilidad para serialización
            String json = JsonUtils.toJson(paciente);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

    }

    private void verHistorialPaciente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Paciente paciente = controladora.traerPacienteLogico(id);

            if (paciente == null) {
                request.setAttribute("error", "Paciente no encontrado");
                listarPacientes(request, response);
                return;
            }

            // TODO: Obtener historial completo de turnos
            // List<Turno> historial = controladora.traerHistorialPaciente(id);
            // request.setAttribute("historial", historial);

            request.setAttribute("paciente", paciente);
            request.getRequestDispatcher("/pages/historial.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID inválido");
            listarPacientes(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar historial");
            listarPacientes(request, response);
        }

    }

    private void crearPaciente(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            // ========== DATOS DEL PACIENTE ==========
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            String tipoTratamiento = request.getParameter("tipoTratamiento");
            String poseeSeguroStr = request.getParameter("poseeSeguro");
            String motivoConsulta = request.getParameter("motivoConsulta");

            // Validaciones del paciente
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(correo, "El correo es obligatorio");
            validarParametro(telefono, "El teléfono es obligatorio");
            validarParametro(tipoTratamiento, "El tipo de tratamiento es obligatorio");
            validarParametro(motivoConsulta, "El motivo de consulta es obligatorio");

            // Validar formato de cédula
            if (!cedula.matches("\\d{10}")) {
                throw new IllegalArgumentException("La cédula debe tener 10 dígitos");
            }

            // Validar formato de teléfono
            if (!telefono.matches("\\d{10}")) {
                throw new IllegalArgumentException("El teléfono debe tener 10 dígitos");
            }

            // Verificar cédula única
            List<Paciente> pacientes = controladora.traerPacientesLogico();
            if (pacientes != null) {
                for (Paciente p : pacientes) {
                    if (p.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un paciente con esa cédula");
                    }
                }
            }

            // Parsear fecha
            Date fechaNacimiento = null;
            if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
                try {
                    fechaNacimiento = dateFormat.parse(fechaNacimientoStr);
                } catch (ParseException e) {
                    throw new IllegalArgumentException("Formato de fecha inválido");
                }
            }

            // Parsear seguro
            boolean poseeSeguro = "true".equals(poseeSeguroStr) || "on".equals(poseeSeguroStr);

            // ========== DATOS DEL RESPONSABLE (OPCIONAL) ==========
            String responsableNombre = request.getParameter("responsableNombre");
            String responsableApellido = request.getParameter("responsableApellido");
            String responsableCedula = request.getParameter("responsableCedula");
            String responsableTelefono = request.getParameter("responsableTelefono");
            String responsableRelacion = request.getParameter("responsableRelacion");
            String responsableCorreo = request.getParameter("responsableCorreo");
            String responsableDireccion = request.getParameter("responsableDireccion");

            Responsable responsable = null;

            // Si se proporcionaron datos del responsable, crearlo
            if (responsableNombre != null && !responsableNombre.trim().isEmpty()) {
                responsable = new Responsable();
                responsable.setNombre(responsableNombre.trim());
                responsable.setApellido(responsableApellido != null ? responsableApellido.trim() : "");
                responsable.setCedula(responsableCedula != null ? responsableCedula.trim() : "");
                responsable.setTelefono(responsableTelefono != null ? responsableTelefono.trim() : "");
                responsable.setRelacionPaciente(responsableRelacion != null ? responsableRelacion : "");
                responsable.setCorreo(responsableCorreo != null ? responsableCorreo.trim() : "");
                responsable.setDirección(responsableDireccion != null ? responsableDireccion.trim() : "");

                // Validar cédula del responsable si se proporcionó
                if (responsableCedula != null && !responsableCedula.trim().isEmpty()) {
                    if (!responsableCedula.matches("\\d{10}")) {
                        throw new IllegalArgumentException("La cédula del responsable debe tener 10 dígitos");
                    }
                }

                // Guardar responsable primero
                controladora.crearResponsableLogico(responsable);
            }

            // ========== CREAR PACIENTE ==========
            Paciente nuevoPaciente = new Paciente();
            nuevoPaciente.setNombre(nombre.trim());
            nuevoPaciente.setApellido(apellido.trim());
            nuevoPaciente.setCedula(cedula.trim());
            nuevoPaciente.setCorreo(correo.trim());
            nuevoPaciente.setTelefono(telefono.trim());
            nuevoPaciente.setDirección(direccion != null ? direccion.trim() : "");
            nuevoPaciente.setFechaNacimiento(fechaNacimiento);
            nuevoPaciente.setTipoTratamiento(tipoTratamiento);
            nuevoPaciente.setPoseeSeguro(poseeSeguro);
            nuevoPaciente.setMotivoConsulta(motivoConsulta.trim());
            nuevoPaciente.setResponsable(responsable);

            // Guardar paciente
            controladora.crearPacienteLogico(nuevoPaciente);

            // Mensaje de éxito
            session.setAttribute("mensaje", "Paciente creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al crear paciente: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }

    }

    private void editarPaciente(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idPacienteAEditar = Integer.parseInt(request.getParameter("idPaciente"));
            String idResponsableStr = request.getParameter("idResponsable");

            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String tipoTratamiento = request.getParameter("tipoTratamiento");
            String poseeSeguroStr = request.getParameter("poseeSeguro");
            String motivoConsulta = request.getParameter("motivoConsulta");

            // Validaciones
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(tipoTratamiento, "El tipo de tratamiento es obligatorio");
            validarParametro(motivoConsulta, "El motivo de consulta es obligatorio");

            // Obtener paciente
            Paciente paciente = controladora.traerPacienteLogico(idPacienteAEditar);
            if (paciente == null) {
                throw new IllegalArgumentException("Paciente no encontrado");
            }

            // Verificar cédula única
            List<Paciente> pacientes = controladora.traerPacientesLogico();
            if (pacientes != null) {
                for (Paciente p : pacientes) {
                    if (p.getId() != idPacienteAEditar && p.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un paciente con esa cédula");
                    }
                }
            }

            // Actualizar datos del paciente
            paciente.setNombre(nombre.trim());
            paciente.setApellido(apellido.trim());
            paciente.setCedula(cedula.trim());
            paciente.setCorreo(correo.trim());
            paciente.setTelefono(telefono.trim());
            paciente.setDirección(direccion != null ? direccion.trim() : "");
            paciente.setTipoTratamiento(tipoTratamiento);
            paciente.setPoseeSeguro("true".equals(poseeSeguroStr) || "on".equals(poseeSeguroStr));
            paciente.setMotivoConsulta(motivoConsulta.trim());

            // ========== GESTIÓN DEL RESPONSABLE ==========
            String responsableNombre = request.getParameter("responsableNombre");
            String responsableApellido = request.getParameter("responsableApellido");
            String responsableCedula = request.getParameter("responsableCedula");
            String responsableTelefono = request.getParameter("responsableTelefono");
            String responsableRelacion = request.getParameter("responsableRelacion");
            String responsableCorreo = request.getParameter("responsableCorreo");
            String responsableDireccion = request.getParameter("responsableDireccion");

            // Si hay datos de responsable
            if (responsableNombre != null && !responsableNombre.trim().isEmpty()) {
                Responsable responsable;

                // Si ya tenía responsable, editarlo
                if (idResponsableStr != null && !idResponsableStr.trim().isEmpty()) {
                    int idResponsable = Integer.parseInt(idResponsableStr);
                    responsable = controladora.traerResponsableLogico(idResponsable);

                    if (responsable != null) {
                        // Actualizar responsable existente
                        responsable.setNombre(responsableNombre.trim());
                        responsable.setApellido(responsableApellido != null ? responsableApellido.trim() : "");
                        responsable.setCedula(responsableCedula != null ? responsableCedula.trim() : "");
                        responsable.setTelefono(responsableTelefono != null ? responsableTelefono.trim() : "");
                        responsable.setRelacionPaciente(responsableRelacion != null ? responsableRelacion : "");
                        responsable.setCorreo(responsableCorreo != null ? responsableCorreo.trim() : "");
                        responsable.setDirección(responsableDireccion != null ? responsableDireccion.trim() : "");

                        controladora.editarResponsableLogico(responsable);
                    }
                } else {
                    // Crear nuevo responsable
                    responsable = new Responsable();
                    responsable.setNombre(responsableNombre.trim());
                    responsable.setApellido(responsableApellido != null ? responsableApellido.trim() : "");
                    responsable.setCedula(responsableCedula != null ? responsableCedula.trim() : "");
                    responsable.setTelefono(responsableTelefono != null ? responsableTelefono.trim() : "");
                    responsable.setRelacionPaciente(responsableRelacion != null ? responsableRelacion : "");
                    responsable.setCorreo(responsableCorreo != null ? responsableCorreo.trim() : "");
                    responsable.setDirección(responsableDireccion != null ? responsableDireccion.trim() : "");

                    controladora.crearResponsableLogico(responsable);
                    paciente.setResponsable(responsable);
                }
            } else {
                // Si se eliminó el responsable
                if (paciente.getResponsable() != null && idResponsableStr != null) {
                    int idResponsable = Integer.parseInt(idResponsableStr);
                    controladora.eliminarResponsableLogico(idResponsable);
                    paciente.setResponsable(null);
                }
            }

            // Guardar cambios del paciente
            controladora.editarPacienteLogico(paciente);

            session.setAttribute("mensaje", "Paciente actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }
        
    }

    private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idPacienteAEliminar = Integer.parseInt(request.getParameter("idPaciente"));

            // Obtener paciente para verificar responsable
            Paciente paciente = controladora.traerPacienteLogico(idPacienteAEliminar);

            if (paciente != null && paciente.getResponsable() != null) {
                // Eliminar responsable primero
                controladora.eliminarResponsableLogico(paciente.getResponsable().getId());
            }

            // Eliminar paciente
            controladora.eliminarPacienteLogico(idPacienteAEliminar);

            session.setAttribute("mensaje", "Paciente eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/PacienteServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PacienteServlet");
        }

    }


    private void listarPacientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Paciente> pacientes = controladora.traerPacientesLogico();

            // Calcular estadísticas
            int totalPacientes = pacientes != null ? pacientes.size() : 0;
            int pacientesActivos = totalPacientes; // TODO: Implementar campo activo
            int conSeguro = 0;
            int turnosHoy = 0; // TODO: Implementar consulta de turnos

            if (pacientes != null) {
                for (Paciente p : pacientes) {
                    if (p.isPoseeSeguro()) {
                        conSeguro++;
                    }
                }
            }

            // Pasar datos a la vista
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("totalPacientes", totalPacientes);
            request.setAttribute("pacientesActivos", pacientesActivos);
            request.setAttribute("conSeguro", conSeguro);
            request.setAttribute("turnosHoy", turnosHoy);

            prepararModal(request);

            request.getRequestDispatcher("/pages/gestionPacientes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar pacientes: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionPacientes.jsp").forward(request, response);
        }

    }




    private void prepararModal(HttpServletRequest request) {
        String modal = request.getParameter("modal");
        String idPacienteModal = request.getParameter("idPaciente");

        if (modal == null) return;

        request.setAttribute("modal", modal);
        request.setAttribute("idPacienteModal", idPacienteModal);

    }

    private void abrirModalEditar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idPaciente = Integer.parseInt(request.getParameter("id"));

        response.sendRedirect(
                request.getContextPath() +
                        "/PacienteServlet?modal=editar&idPaciente=" + idPaciente
        );
    }

    private void validarParametro(String valor, String mensaje) {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(mensaje);
        }
    }

    /**
     * Maneja errores
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response,
                              Exception e, String mensajeBase)
            throws ServletException, IOException {
        e.printStackTrace();
        request.setAttribute("error", mensajeBase + ": " + e.getMessage());
        listarPacientes(request, response);
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
