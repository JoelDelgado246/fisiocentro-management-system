package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.logica.LogicController;
import com.joel.centrofisioterapeuta.logica.Recepcionista;
import com.joel.centrofisioterapeuta.logica.Usuario;
import com.google.gson.Gson;

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
import java.util.*;

@WebServlet(name = "RecepcionistaServlet", value = "/RecepcionistaServlet")
public class RecepcionistaServlet extends HttpServlet {

    private LogicController controladora;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        controladora = new LogicController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        // Verificar sesión
        if (!verificarSesion(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        try {

            // Accion por defecto
            if (action == null) {
                action = "listar";
            }

            switch (action) {
                case "listar":
                    listarRecepcionistas(request, response);
                    break;
                case "ver":
                    verDetalleRecepcionista(request, response);
                    break;
                case "obtener":
                    obtenerRecepcionistaJSON(request, response);
                    break;
                case "abrirEditar":
                    abrirModalEditar(request, response);
                    break;
                default:
                    listarRecepcionistas(request, response);
                    break;
            }

        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        // Verificar sesión
        if (!verificarSesion(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "crear":
                    crearRecepcionista(request, response);
                    break;
                case "editar":
                    editarRecepcionista(request, response);
                    break;
                case "eliminar":
                    eliminarRecepcionista(request, response);
                    break;
                default:
                    listarRecepcionistas(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }

    private void crearRecepcionista(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            // Obtener parámetros
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            String seccionAsignada = request.getParameter("seccionAsignada");
            String idUsuarioStr = request.getParameter("idUsuario");

            // Validaciones
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(correo, "El correo es obligatorio");
            validarParametro(telefono, "El teléfono es obligatorio");
            validarParametro(seccionAsignada, "La sección asignada es obligatoria");
            validarParametro(idUsuarioStr, "Debe seleccionar un usuario");

            // Validar formato de cédula (10 dígitos)
            if (!cedula.matches("\\d{10}")) {
                throw new IllegalArgumentException("La cédula debe tener 10 dígitos");
            }

            // Validar formato de teléfono
            if (!telefono.matches("\\d{10}")) {
                throw new IllegalArgumentException("El teléfono debe tener 10 dígitos");
            }

            // Verificar que la cédula no exista
            List<Recepcionista> recepcionistas = controladora.traerRecepcionistasLogico();
            if (recepcionistas != null) {
                for (Recepcionista r : recepcionistas) {
                    if (r.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un recepcionista con esa cédula");
                    }
                }
            }

            // Obtener y validar usuario
            int idUsuario = Integer.parseInt(idUsuarioStr);
            Usuario usuario = controladora.traerUsuarioLogico(idUsuario);

            if (usuario == null) {
                throw new IllegalArgumentException("Usuario no encontrado");
            }

            if (!"Recepcionista".equals(usuario.getRol())) {
                throw new IllegalArgumentException("El usuario seleccionado no tiene rol de Recepcionista");
            }

            // Verificar que el usuario no esté asignado
            if (recepcionistas != null) {
                for (Recepcionista r : recepcionistas) {
                    if (r.getUsuario() != null && r.getUsuario().getIdUsuario() == idUsuario) {
                        throw new IllegalArgumentException("Este usuario ya está asignado a otro recepcionista");
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

            // Crear recepcionista
            Recepcionista nuevoRecepcionista = new Recepcionista();
            nuevoRecepcionista.setNombre(nombre.trim());
            nuevoRecepcionista.setApellido(apellido.trim());
            nuevoRecepcionista.setCedula(cedula.trim());
            nuevoRecepcionista.setCorreo(correo.trim());
            nuevoRecepcionista.setTelefono(telefono.trim());
            nuevoRecepcionista.setDirección(direccion != null ? direccion.trim() : "");
            nuevoRecepcionista.setFechaNacimiento(fechaNacimiento);
            nuevoRecepcionista.setSeccionAsignada(seccionAsignada);
            nuevoRecepcionista.setUsuario(usuario);

            // Guardar
            controladora.crearRecepcionistaLogico(nuevoRecepcionista);

            // Mensaje de éxito
            session.setAttribute("mensaje", "Recepcionista creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");

        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al crear recepcionista: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        }

    }

    private void editarRecepcionista(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idRecepcionista = Integer.parseInt(request.getParameter("idRecepcionista"));
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String seccionAsignada = request.getParameter("seccionAsignada");
            String idUsuarioStr = request.getParameter("idUsuario");

            // Validaciones
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(seccionAsignada, "La sección es obligatoria");

            // Obtener recepcionista
            Recepcionista recepcionista = controladora.traerRecepcionistaLogico(idRecepcionista);
            if (recepcionista == null) {
                throw new IllegalArgumentException("Recepcionista no encontrado");
            }

            // Verificar cédula única
            List<Recepcionista> recepcionistas = controladora.traerRecepcionistasLogico();
            if (recepcionistas != null) {
                for (Recepcionista r : recepcionistas) {
                    if (r.getId() != idRecepcionista && r.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un recepcionista con esa cédula");
                    }
                }
            }

            // Actualizar datos
            recepcionista.setNombre(nombre.trim());
            recepcionista.setApellido(apellido.trim());
            recepcionista.setCedula(cedula.trim());
            recepcionista.setCorreo(correo.trim());
            recepcionista.setTelefono(telefono.trim());
            recepcionista.setDirección(direccion != null ? direccion.trim() : "");
            recepcionista.setSeccionAsignada(seccionAsignada);

            // Actualizar usuario si se proporcionó
            if (idUsuarioStr != null && !idUsuarioStr.trim().isEmpty()) {
                int idUsuario = Integer.parseInt(idUsuarioStr);
                Usuario usuario = controladora.traerUsuarioLogico(idUsuario);

                if (usuario != null) {
                    if (!"Recepcionista".equals(usuario.getRol())) {
                        throw new IllegalArgumentException("El usuario debe tener rol Recepcionista");
                    }
                    recepcionista.setUsuario(usuario);
                }
            } else {
                recepcionista.setUsuario(null);
            }

            // Guardar
            controladora.editarRecepcionistaLogico(recepcionista);

            session.setAttribute("mensaje", "Recepcionista actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        }
    }

    private void eliminarRecepcionista(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {

            int idRecepcionistaAEliminar = Integer.parseInt(request.getParameter("idRecepcionista"));

            controladora.eliminarRecepcionistaLogico(idRecepcionistaAEliminar);

            session.setAttribute("mensaje", "Recepcionista eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/RecepcionistaServlet");
        }

    }

    private void listarRecepcionistas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            // Obtener recepcionistas
            List<Recepcionista> recepcionistas = controladora.traerRecepcionistasLogico();

            // Calcular estadísticas
            int totalRecepcionistas = recepcionistas != null ? recepcionistas.size() : 0;
            int recepcionistasActivos = totalRecepcionistas;

            // Contar secciones únicas
            Set<String> seccionesUnicas = new HashSet<>();
            if (recepcionistas != null) {
                for (Recepcionista r : recepcionistas) {
                    if (r.getSeccionAsignada() != null) {
                        seccionesUnicas.add(r.getSeccionAsignada());
                    }
                }
            }
            int secciones = seccionesUnicas.size();

            // Obtener usuarios disponibles (rol Recepcionista sin asignar)
            List<Usuario> usuariosDisponibles = obtenerUsuariosDisponibles(recepcionistas);

            // Obtener todos los usuarios con rol Recepcionista (para edición)
            List<Usuario> todosLosUsuarios = controladora.traerUsuariosLogico();

            // Pasar datos a la vista
            request.setAttribute("recepcionistas", recepcionistas);
            request.setAttribute("totalRecepcionistas", totalRecepcionistas);
            request.setAttribute("recepcionistasActivos", recepcionistasActivos);
            request.setAttribute("secciones", secciones);
            request.setAttribute("usuariosDisponibles", usuariosDisponibles);
            request.setAttribute("todosLosUsuarios", todosLosUsuarios);

            prepararModal(request);

            request.getRequestDispatcher("/pages/gestionRecepcionistas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar recepcionistas: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionRecepcionistas.jsp").forward(request, response);
        }

    }

    private void verDetalleRecepcionista(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));
            Recepcionista recepcionistaConsultado = controladora.traerRecepcionistaLogico(id);

            if (recepcionistaConsultado == null) {
                request.setAttribute("error", "Recepcionista no encontrado");
                listarRecepcionistas(request, response);
                return;
            }

            request.setAttribute("recepcionista", recepcionistaConsultado);
            request.getRequestDispatcher("/pages/detalleRecepcionista.jsp").forward(request,response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID inválido");
            listarRecepcionistas(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar detalle");
            listarRecepcionistas(request, response);
        }

    }




    private void prepararModal(HttpServletRequest request) {
        String modal = request.getParameter("modal");
        String idRecepcionistaModal = request.getParameter("idRecepcionista");

        if (modal == null) return;

        request.setAttribute("modal", modal);
        request.setAttribute("idRecepcionistaModal", idRecepcionistaModal);

    }

    private void abrirModalEditar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idRecepcionista = Integer.parseInt(request.getParameter("id"));

        response.sendRedirect(
                request.getContextPath() +
                        "/RecepcionistaServlet?modal=editar&idRecepcionista=" + idRecepcionista
        );
    }

    /**
     * Obtiene un recepcionista en formato JSON (para AJAX)
     */
    private void obtenerRecepcionistaJSON(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Recepcionista recepcionista = controladora.traerRecepcionistaLogico(id);

            if (recepcionista == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Usar utilidad para serialización
            String json = JsonUtils.toJson(recepcionista);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private List<Usuario> obtenerUsuariosDisponibles(List<Recepcionista> recepcionistas) {
        List<Usuario> disponibles = new ArrayList<>();

        try {
            List<Usuario> todosLosUsuarios = controladora.traerUsuariosLogico();

            if (todosLosUsuarios != null) {
                for (Usuario u : todosLosUsuarios) {
                    if ("Recepcionista".equals(u.getRol())) {
                        boolean estaAsignado = false;

                        if (recepcionistas != null) {
                            for (Recepcionista r : recepcionistas) {
                                if (r.getUsuario() != null &&
                                        r.getUsuario().getIdUsuario() == u.getIdUsuario()) {
                                    estaAsignado = true;
                                    break;
                                }
                            }
                        }

                        if (!estaAsignado) {
                            disponibles.add(u);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return disponibles;
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
        listarRecepcionistas(request, response);
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
