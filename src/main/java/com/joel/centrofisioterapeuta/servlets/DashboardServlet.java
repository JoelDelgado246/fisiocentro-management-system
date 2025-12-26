package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.enums.EstadoTurno;
import com.joel.centrofisioterapeuta.logica.Fisioterapeuta;
import com.joel.centrofisioterapeuta.logica.LogicController;

import com.joel.centrofisioterapeuta.logica.Paciente;
import com.joel.centrofisioterapeuta.logica.Turno;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "DashboardServlet", value = "/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    private LogicController controladora;

    @Override
    public void init() throws ServletException {
        super.init();
        controladora = new LogicController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar sesión
        if (!verificarSesion(request, response)) {
            return;
        }

        try {
            // Obtener estadísticas
            int totalPacientes = 0;
            int totalFisioterapeutas = 0;
            int turnosHoy = 0;
            int turnosPendientes = 0;

            // Total de pacientes
            List<Paciente> pacientes = controladora.traerPacientesLogico();
            if (pacientes != null) {
                totalPacientes = pacientes.size();
            }

            // Total de fisioterapeutas
            List<Fisioterapeuta> fisioterapeutas = controladora.traerFisioterapeutasLogico();
            if (fisioterapeutas != null) {
                totalFisioterapeutas = fisioterapeutas.size();
            }

            // Turnos de hoy y pendientes
            List<Turno> turnos = controladora.traerTurnosLogico();
            if (turnos != null) {
                LocalDate hoy = LocalDate.now();

                for (Turno t : turnos) {
                    // Turnos de hoy
                    if (t.getFechaTurno() != null && t.getFechaTurno().equals(hoy)) {
                        turnosHoy++;
                    }

                    // Turnos pendientes o confirmados
                    if (t.getEstado() == EstadoTurno.PENDIENTE ||
                            t.getEstado() == EstadoTurno.CONFIRMADO) {
                        turnosPendientes++;
                    }
                }
            }

            // Pasar datos a la vista
            request.setAttribute("totalPacientes", totalPacientes);
            request.setAttribute("totalFisioterapeutas", totalFisioterapeutas);
            request.setAttribute("turnosHoy", turnosHoy);
            request.setAttribute("turnosPendientes", turnosPendientes);

            // Forward al index
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar estadísticas: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
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

}
