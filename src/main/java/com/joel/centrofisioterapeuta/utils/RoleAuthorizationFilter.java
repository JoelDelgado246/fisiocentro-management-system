package com.joel.centrofisioterapeuta.utils;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


@WebFilter("/*")
public class RoleAuthorizationFilter implements Filter {

    // Mapa de servlets y los roles que pueden acceder
    private static final Map<String, String[]> PERMISOS = new HashMap<>();

    static {
        // ADMINISTRADOR: Acceso total
        PERMISOS.put("/UsuarioServlet", new String[]{"Administrador"});

        // RECEPCIONISTA: Puede gestionar pacientes, fisioterapeutas y turnos
        PERMISOS.put("/PacienteServlet", new String[]{"Administrador", "Recepcionista"});
        PERMISOS.put("/RecepcionistaServlet", new String[]{"Administrador", "Recepcionista"});
        PERMISOS.put("/FisioterapeutaServlet", new String[]{"Administrador", "Recepcionista"});
        PERMISOS.put("/TurnoServlet", new String[]{"Administrador", "Recepcionista", "Fisioterapeuta"});
        PERMISOS.put("/HorarioServlet", new String[]{"Administrador", "Recepcionista"});

        // FISIOTERAPEUTA: Solo puede ver sus turnos (control adicional en el servlet)
        // El acceso a TurnoServlet ya está permitido arriba

        // Dashboard accesible para todos
        PERMISOS.put("/DashboardServlet", new String[]{"Administrador", "Recepcionista", "Fisioterapeuta"});
    }



    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Rutas públicas que no requieren autenticación ni autorización
        boolean esRutaPublica = uri.endsWith("login.jsp") ||
                uri.endsWith("/LoginServlet") ||
                uri.endsWith("/login") ||
                uri.contains("/css/") ||
                uri.contains("/js/") ||
                uri.contains("/images/") ||
                uri.contains("/assets/") ||
                uri.contains("/fonts/") ||
                uri.equals(contextPath + "/") ||
                uri.equals(contextPath);

        if (esRutaPublica) {
            chain.doFilter(request, response);
            return;
        }

        // 1. AUTENTICACIÓN: Verificar que hay sesión activa
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // 2. AUTORIZACIÓN: Verificar permisos por rol
        String rol = (String) session.getAttribute("rol");
        String servletPath = httpRequest.getServletPath();

        if (verificarAcceso(servletPath, rol)) {
            chain.doFilter(request, response);
        } else {
            // Acceso denegado
            session.setAttribute("mensaje", "No tienes permisos para acceder a esta sección");
            session.setAttribute("tipoMensaje", "danger");
            httpResponse.sendRedirect(contextPath + "/DashboardServlet");
        }
    }


    private boolean verificarAcceso(String servletPath, String rol) {
        // Si no está en el mapa de permisos, permitir acceso (por defecto)
        if (!PERMISOS.containsKey(servletPath)) {
            return true;
        }

        String[] rolesPermitidos = PERMISOS.get(servletPath);
        for (String rolPermitido : rolesPermitidos) {
            if (rolPermitido.equals(rol)) {
                return true;
            }
        }

        return false;
    }

    @Override
    public void destroy() {
    }

}
