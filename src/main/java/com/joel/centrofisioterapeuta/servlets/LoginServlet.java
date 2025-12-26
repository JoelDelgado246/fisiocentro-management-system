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
import java.util.List;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {

    private LogicController controladora;

    @Override
    public void init() throws ServletException {
        super.init();
        controladora = new LogicController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        String path = request.getServletPath();

        if ("logout".equals(action) || "/logout".equals(path)) {
            cerrarSesion(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String nombreUsuario = request.getParameter("nombreUsuario");
        String contrasenia = request.getParameter("contraseña");

        try {
            if (nombreUsuario == null || nombreUsuario.trim().isEmpty() ||
                    contrasenia == null || contrasenia.trim().isEmpty()) {
                request.setAttribute("error", "Por favor complete todos los campos");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            Usuario usuario = buscarUsuario(nombreUsuario.trim(), contrasenia.trim());

            if (usuario != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("nombreUsuario", usuario.getNombreUsuario());
                session.setAttribute("rol", usuario.getRol());
                session.setAttribute("idUsuario", usuario.getIdUsuario());

                session.setMaxInactiveInterval(30 * 60);

                String destino = determinarDestinoPorRol(usuario.getRol());
                response.sendRedirect(request.getContextPath() + destino);

            } else {
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el sistema. Intente nuevamente.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }

    }

    private String determinarDestinoPorRol(String rol) {
        switch (rol) {
            case "Administrador":
                return "/UsuarioServlet";
            case "Recepcionista":
                return "/TurnoServlet";
            case "Fisioterapeuta":
                return "/TurnoServlet";
            default:
                return "/index.jsp";
        }
    }

    private Usuario buscarUsuario(String nombreUsuario, String contrasenia) {
        try {
            List<Usuario> usuarios = controladora.traerUsuariosLogico();

            if (usuarios != null) {
                for (Usuario u : usuarios) {
                    if (u.getNombreUsuario().equals(nombreUsuario) &&
                            u.getContrasenia().equals(contrasenia)) {
                        return u;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

}
