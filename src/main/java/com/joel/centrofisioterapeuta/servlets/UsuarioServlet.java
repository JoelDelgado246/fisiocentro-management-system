package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.logica.LogicController;
import com.joel.centrofisioterapeuta.logica.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UsuarioServlet", value = "/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private LogicController controladora;

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

        String action = request.getParameter("action");

        try {

            // Accion por defecto
            if (action == null) {
                action = "listar";
            }

            switch (action) {
                case "listar":
                    listarUsuarios(request, response);
                    break;
                case "ver":
                    verDetalleUsuario(request, response);
                    break;
                case "abrirEditar":
                    abrirModalEditar(request, response);
                    break;
                case "abrirCambiarPass":
                    abrirModalCambiarPass(request, response);
                    break;
                default:
                    listarUsuarios(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            listarUsuarios(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Verificar sesión
//        if (!verificarSesion(request, response)) {
//            return;
//        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "crear":
                    crearUsuario(request, response);
                    break;
                case "editar":
                    editarUsuario(request, response);
                    break;
                case "eliminar":
                    eliminarUsuario(request, response);
                    break;
                case "cambiarContrasenia":
                    cambiarContrasenia(request, response);
                    break;
                default:
                    listarUsuarios(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al procesar la solicitud: " + e.getMessage());
            listarUsuarios(request, response);
        }
    }


    private void verDetalleUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {

            int idUsuarioConsultar = Integer.parseInt(request.getParameter("id"));
            Usuario usuarioConsultado = controladora.traerUsuarioLogico(idUsuarioConsultar);

            if (usuarioConsultado == null) {
                throw new IllegalArgumentException("Usuario no encontrado");
            }

            request.setAttribute("usuario", usuarioConsultado);
            request.getRequestDispatcher("/pages/detalleUsuario.jsp").forward(request,response);


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los usuarios: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionUsuarios.jsp").forward(request, response);
        }

    }

    private void editarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {

            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String nombreUsuario = request.getParameter("nombreUsuario");
            String rol = request.getParameter("rol");

            //Validar parámetros
            validarParametro(nombreUsuario, "El nombre de usuario es obligatorio");
            validarParametro(rol, "El rol es obligatorio");
            if (nombreUsuario.trim().length() < 3 || nombreUsuario.trim().length() > 20) {
                throw new IllegalArgumentException(
                        "El nombre de usuario debe tener entre 3 y 20 caracteres");
            }

            // Obtener el usuario existente
            Usuario usuarioAEditar = controladora.traerUsuarioLogico(idUsuario);
            if (usuarioAEditar == null) {
                throw new IllegalArgumentException("Usuario no encontrado");
            }

            // Verificar nombre único
            List<Usuario> usuarios = controladora.traerUsuariosLogico();
            if (usuarios != null) {
                for (Usuario u : usuarios) {
                    if (u.getIdUsuario() != idUsuario &&
                            u.getNombreUsuario().equalsIgnoreCase(nombreUsuario.trim())) {
                        throw new IllegalArgumentException(
                                "Ya existe un usuario con ese nombre");
                    }
                }
            }

            usuarioAEditar.setNombreUsuario(nombreUsuario);
            usuarioAEditar.setRol(rol);

            controladora.editarUsuarioLogico(usuarioAEditar);

            // Mensaje de éxito
            session.setAttribute("mensaje", "Usuario actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID de usuario inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }

    }

    private void cambiarContrasenia(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String nuevaContrasenia = request.getParameter("nuevaContrasenia");
            String confirmarContrasenia = request.getParameter("confirmarContrasenia");

            // Validaciones
            validarParametro(nuevaContrasenia, "La contraseña es obligatoria");

            if (nuevaContrasenia.length() < 6) {
                throw new IllegalArgumentException(
                        "La contraseña debe tener al menos 6 caracteres");
            }

            if (!nuevaContrasenia.equals(confirmarContrasenia)) {
                throw new IllegalArgumentException("Las contraseñas no coinciden");
            }

            // Obtener usuario
            Usuario usuarioAEditar = controladora.traerUsuarioLogico(idUsuario);
            if (usuarioAEditar == null) {
                throw new IllegalArgumentException("Usuario no encontrado");
            }

            // Actualizar contraseña
            usuarioAEditar.setContrasenia(nuevaContrasenia); // TODO: Implementar BCrypt
            controladora.editarUsuarioLogico(usuarioAEditar);

            // Mensaje de éxito
            session.setAttribute("mensaje", "Contraseña actualizada exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID de usuario inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al cambiar contraseña: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }

    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        try {

            int idUsuarioAEliminar = Integer.parseInt(request.getParameter("idUsuarion"));

            // Verificar que no sea el último administrador
            List<Usuario> usuarios = controladora.traerUsuariosLogico();
            Usuario usuarioAEliminar = controladora.traerUsuarioLogico(idUsuarioAEliminar);

            if (usuarioAEliminar != null && "Administrador".equals(usuarioAEliminar.getRol())) {
                int contadorAdmins = 0;
                if (usuarios != null) {
                    for (Usuario u : usuarios) {
                        if ("Administrador".equals(u.getRol())) {
                            contadorAdmins++;
                        }
                    }
                }

                if (contadorAdmins <= 1) {
                    throw new IllegalArgumentException(
                            "No se puede eliminar el último administrador del sistema");
                }
            }

            // Verificar que no sea el usuario actual
            Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
            if (usuarioActual != null && usuarioActual.getIdUsuario() == idUsuarioAEliminar) {
                throw new IllegalArgumentException(
                        "No puede eliminar su propio usuario mientras está en sesión");
            }

            //Eliminamos usuario
            controladora.eliminarUsuarioLogico(idUsuarioAEliminar);

            session.setAttribute("mensaje", "Usuario eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID de usuario inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }

    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener todos los usuarios
            List<Usuario> usuarios = controladora.traerUsuariosLogico();

            // Calcular estadísticas
            int totalUsuarios = usuarios != null ? usuarios.size() : 0;
            int usuariosActivos = totalUsuarios; // Asumiendo que todos están activos por ahora
            int administradores = 0;

            if (usuarios != null) {
                for (Usuario usuario : usuarios) {
                    if ("Administrador".equals(usuario.getRol())) {
                        administradores++;
                    }
                }
            }

            // Pasar datos a la vista
            request.setAttribute("usuarios", usuarios);
            request.setAttribute("totalUsuarios", totalUsuarios);
            request.setAttribute("usuariosActivos", usuariosActivos);
            request.setAttribute("administradores", administradores);

            prepararModal(request);



            // Forward a la página JSP
            request.getRequestDispatcher("/pages/gestionUsuarios.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar los usuarios: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionUsuarios.jsp").forward(request, response);
        }


    }

    private void crearUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String nombreDeUsuario = request.getParameter("nombreUsuario");
            String contrasenia = request.getParameter("contrasenia");
            String confirmarContrasenia = request.getParameter("confirmarContrasenia");
            String rol = request.getParameter("rol");

            // Validaciones
            if (nombreDeUsuario == null || nombreDeUsuario.trim().isEmpty()) {
                throw new IllegalArgumentException("El nombre de usuario es obligatorio");
            }

            if (contrasenia == null || contrasenia.trim().isEmpty()) {
                throw new IllegalArgumentException("La contraseña es obligatoria");
            }

            if (contrasenia.length() < 6) {
                throw new IllegalArgumentException("La contraseña debe tener al menos 6 caracteres");
            }

            if (!contrasenia.equals(confirmarContrasenia)) {
                throw new IllegalArgumentException("Las contraseñas no coinciden");
            }

            if (rol == null || rol.trim().isEmpty()) {
                throw new IllegalArgumentException("El rol es obligatorio");
            }
            // Verificar si el usuario ya existe
            List<Usuario> usuarios = controladora.traerUsuariosLogico();
            if (usuarios != null) {
                for (Usuario u : usuarios) {
                    if (u.getNombreUsuario().equalsIgnoreCase(nombreDeUsuario)) {
                        throw new IllegalArgumentException("Ya existe un usuario con ese nombre");
                    }
                }
            }

            // Crear nuevo usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombreUsuario(nombreDeUsuario.trim());
            nuevoUsuario.setContrasenia(contrasenia); // En producción, usar BCrypt aquí
            nuevoUsuario.setRol(rol);

            // Guardar en la base de datos
            controladora.crearUsuarioLogico(nuevoUsuario);

            // Mensaje de éxito
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Usuario creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            // Redireccionar a la lista
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        } catch (IllegalArgumentException e) {
            // Error de validación
            request.setAttribute("error", e.getMessage());
            //listarUsuarios(request, response);
        } catch (Exception e) {
            // Error del sistema
            e.printStackTrace();
            request.setAttribute("error", "Error al crear el usuario: " + e.getMessage());
            listarUsuarios(request, response);
        }

    }

    private void abrirModalEditar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("id"));

        response.sendRedirect(
                request.getContextPath() +
                        "/UsuarioServlet?modal=editar&idUsuario=" + idUsuario
        );
    }

    private void abrirModalCambiarPass(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int idUsuario = Integer.parseInt(request.getParameter("id"));

        response.sendRedirect(
                request.getContextPath() +
                        "/UsuarioServlet?modal=cambiarPass&idUsuario=" + idUsuario
        );
    }

    private void prepararModal(HttpServletRequest request) {
        String modal = request.getParameter("modal");
        String idUsuarioModal = request.getParameter("idUsuario");

        if (modal == null) return;

        request.setAttribute("modal", modal);

        if ("editar".equals(modal) && idUsuarioModal != null) {
            int id = Integer.parseInt(idUsuarioModal);
            Usuario usuarioModal = controladora.traerUsuarioLogico(id);
            request.setAttribute("usuarioModal", usuarioModal);
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


    /**
     * Valida parámetro
     */
    private void validarParametro(String valor, String mensaje) {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException(mensaje);
        }
    }

}
