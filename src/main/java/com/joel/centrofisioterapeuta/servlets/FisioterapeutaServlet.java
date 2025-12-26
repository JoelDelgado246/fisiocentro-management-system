package com.joel.centrofisioterapeuta.servlets;

import com.joel.centrofisioterapeuta.DTO.FisioterapeutaDTO;
import com.joel.centrofisioterapeuta.logica.Fisioterapeuta;
import com.joel.centrofisioterapeuta.logica.Horario;
import com.joel.centrofisioterapeuta.logica.LogicController;
import com.joel.centrofisioterapeuta.logica.Usuario;
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

@WebServlet(name = "FisioterapeutaServlet", value = "/FisioterapeutaServlet")
public class FisioterapeutaServlet extends HttpServlet {

    private LogicController controladora;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

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
                    listarFisioterapeutas(request, response);
                    break;
                case "ver":
                    verDetalleFisioterapeuta(request, response);
                    break;
                case "obtener":
                    obtenerFisioterapeutaJSON(request, response);
                    break;
                case "abrirEditar":
                    abrirModalEditar(request, response);
                    break;
                default:
                    listarFisioterapeutas(request, response);
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
                    crearFisioterapeuta(request, response);
                    break;
                case "editar":
                    editarFisioterapeuta(request, response);
                    break;
                case "eliminar":
                    eliminarFisioterapeuta(request, response);
                    break;
                default:
                    listarFisioterapeutas(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, e, "Error al procesar la solicitud");
        }

    }

    private void crearFisioterapeuta(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            // Datos personales
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");

            // Datos profesionales
            String especialidad = request.getParameter("especialidad");
            String idUsuarioStr = request.getParameter("idUsuario");
            String idHorarioStr = request.getParameter("idHorario");

            // Validaciones
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(correo, "El correo es obligatorio");
            validarParametro(telefono, "El teléfono es obligatorio");
            validarParametro(especialidad, "La especialidad es obligatoria");
            validarParametro(idUsuarioStr, "Debe asignar un usuario");

            // Validar formato de cédula
            if (!cedula.matches("\\d{10}")) {
                throw new IllegalArgumentException("La cédula debe tener 10 dígitos");
            }

            // Validar formato de teléfono
            if (!telefono.matches("\\d{10}")) {
                throw new IllegalArgumentException("El teléfono debe tener 10 dígitos");
            }

            // Verificar cédula única
            List<Fisioterapeuta> fisioterapeutas = controladora.traerFisioterapeutasLogico();
            if (fisioterapeutas != null) {
                for (Fisioterapeuta f : fisioterapeutas) {
                    if (f.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un fisioterapeuta con esa cédula");
                    }
                }
            }

            int idUsuario = Integer.parseInt(idUsuarioStr);

            // Obtener y validar usuario
            Usuario usuario = controladora.traerUsuarioLogico(idUsuario);
            if (usuario == null) {
                throw new IllegalArgumentException("Usuario no encontrado");
            }

            // Verificar que el usuario tenga rol "Fisioterapeuta"
            if (!"Fisioterapeuta".equals(usuario.getRol())) {
                throw new IllegalArgumentException("El usuario debe tener rol 'Fisioterapeuta'");
            }

            // Verificar que el usuario no esté ya asignado
            if (fisioterapeutas != null) {
                for (Fisioterapeuta f : fisioterapeutas) {
                    if (f.getUsuario() != null && f.getUsuario().getIdUsuario() == idUsuario) {
                        throw new IllegalArgumentException("Este usuario ya está asignado a otro fisioterapeuta");
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

            // Obtener horario si se seleccionó
            Horario horario = null;
            if (idHorarioStr != null && !idHorarioStr.trim().isEmpty()) {
                int idHorario = Integer.parseInt(idHorarioStr);
                horario = controladora.traerHorarioLogico(idHorario);
                if (horario == null) {
                    throw new IllegalArgumentException("Horario no encontrado");
                }
            }

            // Crear fisioterapeuta
            Fisioterapeuta nuevoFisioterapeuta = new Fisioterapeuta();
            nuevoFisioterapeuta.setNombre(nombre.trim());
            nuevoFisioterapeuta.setApellido(apellido.trim());
            nuevoFisioterapeuta.setCedula(cedula.trim());
            nuevoFisioterapeuta.setCorreo(correo.trim());
            nuevoFisioterapeuta.setTelefono(telefono.trim());
            nuevoFisioterapeuta.setDirección(direccion != null ? direccion.trim() : "");
            nuevoFisioterapeuta.setFechaNacimiento(fechaNacimiento);
            nuevoFisioterapeuta.setEspecialidad(especialidad.trim());
            nuevoFisioterapeuta.setUsuario(usuario);
            nuevoFisioterapeuta.setHorario(horario);

            // Guardar
            controladora.crearFisioterapeutaLogico(nuevoFisioterapeuta);

            session.setAttribute("mensaje", "Fisioterapeuta creado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");

        } catch (IllegalArgumentException e) {
            session.setAttribute("mensaje", e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al crear fisioterapeuta: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        }

    }

    private void editarFisioterapeuta(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idFisioterapeuta = Integer.parseInt(request.getParameter("idFisioterapeuta"));

            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String cedula = request.getParameter("cedula");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String especialidad = request.getParameter("especialidad");
            String idUsuarioStr = request.getParameter("idUsuario");
            String idHorarioStr = request.getParameter("idHorario");

            // Validaciones
            validarParametro(nombre, "El nombre es obligatorio");
            validarParametro(apellido, "El apellido es obligatorio");
            validarParametro(cedula, "La cédula es obligatoria");
            validarParametro(especialidad, "La especialidad es obligatoria");

            // Obtener fisioterapeuta
            Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaLogico(idFisioterapeuta);
            if (fisioterapeuta == null) {
                throw new IllegalArgumentException("Fisioterapeuta no encontrado");
            }

            // Verificar cédula única (excluyendo el fisioterapeuta actual)
            List<Fisioterapeuta> fisioterapeutas = controladora.traerFisioterapeutasLogico();
            if (fisioterapeutas != null) {
                for (Fisioterapeuta f : fisioterapeutas) {
                    if (f.getId() != idFisioterapeuta && f.getCedula().equals(cedula)) {
                        throw new IllegalArgumentException("Ya existe un fisioterapeuta con esa cédula");
                    }
                }
            }

            // Actualizar datos personales
            fisioterapeuta.setNombre(nombre.trim());
            fisioterapeuta.setApellido(apellido.trim());
            fisioterapeuta.setCedula(cedula.trim());
            fisioterapeuta.setCorreo(correo.trim());
            fisioterapeuta.setTelefono(telefono.trim());
            fisioterapeuta.setDirección(direccion != null ? direccion.trim() : "");
            fisioterapeuta.setEspecialidad(especialidad.trim());

            // Gestión del usuario
            if (idUsuarioStr != null && !idUsuarioStr.trim().isEmpty()) {
                int idUsuario = Integer.parseInt(idUsuarioStr);
                Usuario usuario = controladora.traerUsuarioLogico(idUsuario);

                if (usuario == null) {
                    throw new IllegalArgumentException("Usuario no encontrado");
                }

                // Verificar que no esté asignado a otro fisioterapeuta
                if (fisioterapeutas != null) {
                    for (Fisioterapeuta f : fisioterapeutas) {
                        if (f.getId() != idFisioterapeuta &&
                                f.getUsuario() != null &&
                                f.getUsuario().getIdUsuario() == idUsuario) {
                            throw new IllegalArgumentException("Este usuario ya está asignado a otro fisioterapeuta");
                        }
                    }
                }

                fisioterapeuta.setUsuario(usuario);
            } else {
                fisioterapeuta.setUsuario(null);
            }

            // Gestión del horario
            if (idHorarioStr != null && !idHorarioStr.trim().isEmpty()) {
                int idHorario = Integer.parseInt(idHorarioStr);
                Horario horario = controladora.traerHorarioLogico(idHorario);

                if (horario == null) {
                    throw new IllegalArgumentException("Horario no encontrado");
                }

                fisioterapeuta.setHorario(horario);
            } else {
                fisioterapeuta.setHorario(null);
            }

            // Guardar cambios
            controladora.editarFisioterapeutaLogico(fisioterapeuta);

            session.setAttribute("mensaje", "Fisioterapeuta actualizado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al actualizar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        }

    }

    private void eliminarFisioterapeuta(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession();

        try {
            int idFisioterapeuta = Integer.parseInt(request.getParameter("idFisioterapeuta"));

            // TODO: Verificar que no tenga turnos asignados
            // Si tiene turnos, no permitir eliminación o preguntar si eliminar en cascada

            controladora.eliminarFisioterapeutaLogico(idFisioterapeuta);

            session.setAttribute("mensaje", "Fisioterapeuta eliminado exitosamente");
            session.setAttribute("tipoMensaje", "success");

            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");

        } catch (NumberFormatException e) {
            session.setAttribute("mensaje", "ID inválido");
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al eliminar: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/FisioterapeutaServlet");
        }

    }

    private void listarFisioterapeutas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            List<Fisioterapeuta> fisioterapeutas = controladora.traerFisioterapeutasLogico();

            List<Usuario> todosLosUsuarios = controladora.traerUsuariosLogico();

            // Obtener todos los horarios disponibles
            List<Horario> horariosDisponibles = controladora.traerHorariosLogico();

            // Obtener usuarios disponibles (rol Fisioterapeuta sin asignar)
            List<Usuario> usuariosDisponibles = obtenerUsuariosDisponibles(fisioterapeutas);

            // Calcular estadísticas
            int totalFisioterapeutas = fisioterapeutas != null ? fisioterapeutas.size() : 0;
            int fisiosActivos = totalFisioterapeutas; // TODO: Implementar campo activo

            // Contar especialidades únicas
            Set<String> especialidadesUnicas = new HashSet<>();
            if (fisioterapeutas != null) {
                for (Fisioterapeuta f : fisioterapeutas) {
                    if (f.getEspecialidad() != null && !f.getEspecialidad().trim().isEmpty()) {
                        especialidadesUnicas.add(f.getEspecialidad());
                    }
                }
            }
            int especialidades = especialidadesUnicas.size();

            int turnosHoy = 0;

            // Pasar datos a la vista
            request.setAttribute("fisioterapeutas", fisioterapeutas);
            request.setAttribute("usuariosDisponibles", usuariosDisponibles);
            request.setAttribute("todosLosUsuarios", todosLosUsuarios);
            request.setAttribute("horariosDisponibles", horariosDisponibles);
            request.setAttribute("totalFisioterapeutas", totalFisioterapeutas);
            request.setAttribute("fisiosActivos", fisiosActivos);
            request.setAttribute("especialidades", especialidades);
            request.setAttribute("turnosHoy", turnosHoy);

            request.getRequestDispatcher("/pages/gestionFisioterapeutas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar fisioterapeutas: " + e.getMessage());
            request.getRequestDispatcher("/pages/gestionFisioterapeutas.jsp").forward(request, response);
        }

    }


    private void verDetalleFisioterapeuta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaLogico(id);

            if (fisioterapeuta == null) {
                request.setAttribute("error", "Fisioterapeuta no encontrado");
                listarFisioterapeutas(request, response);
                return;
            }

            // TODO: Obtener estadísticas del fisioterapeuta
            // int totalTurnos = controladora.contarTurnosFisioterapeuta(id);
            // int turnosCompletados = controladora.contarTurnosCompletadosFisioterapeuta(id);

            request.setAttribute("fisioterapeuta", fisioterapeuta);
            request.getRequestDispatcher("/pages/detalleFisioterapeuta.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID inválido");
            listarFisioterapeutas(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar detalle");
            listarFisioterapeutas(request, response);
        }
    }



    private void obtenerFisioterapeutaJSON(HttpServletRequest request, HttpServletResponse response) {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Fisioterapeuta fisioterapeuta = controladora.traerFisioterapeutaLogico(id);
            if (fisioterapeuta == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // ====== DTO ======
            FisioterapeutaDTO dto = new FisioterapeutaDTO();
            dto.setId(fisioterapeuta.getId());
            dto.setNombre(fisioterapeuta.getNombre());
            dto.setApellido(fisioterapeuta.getApellido());
            dto.setCedula(fisioterapeuta.getCedula());
            dto.setCorreo(fisioterapeuta.getCorreo());
            dto.setTelefono(fisioterapeuta.getTelefono());
            dto.setDireccion(fisioterapeuta.getDirección());
            dto.setEspecialidad(fisioterapeuta.getEspecialidad());

            // Relaciones → solo IDs
            dto.setIdUsuario(
                    fisioterapeuta.getUsuario() != null
                            ? fisioterapeuta.getUsuario().getIdUsuario()
                            : null
            );

            dto.setIdHorario(
                    fisioterapeuta.getHorario() != null
                            ? fisioterapeuta.getHorario().getIdHorario()
                            : null
            );
            System.out.println("id de usuario a pasar: " + dto.getDireccion());

            // ====== Respuesta JSON ======
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String json = JsonUtils.toJson(dto);
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void abrirModalEditar(HttpServletRequest request, HttpServletResponse response) {



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

    private List<Usuario> obtenerUsuariosDisponibles(List<Fisioterapeuta> fisioterapeutas) {
        List<Usuario> todosUsuarios = controladora.traerUsuariosLogico();
        List<Usuario> disponibles = new ArrayList<>();

        if (todosUsuarios == null) {
            return disponibles;
        }

        // IDs de usuarios ya asignados a fisioterapeutas
        Set<Integer> usuariosAsignados = new HashSet<>();
        if (fisioterapeutas != null) {
            for (Fisioterapeuta f : fisioterapeutas) {
                if (f.getUsuario() != null) {
                    usuariosAsignados.add(f.getUsuario().getIdUsuario());
                }
            }
        }

        // Filtrar usuarios con rol "Fisioterapeuta" que no estén asignados
        for (Usuario u : todosUsuarios) {
            if ("Fisioterapeuta".equals(u.getRol()) && !usuariosAsignados.contains(u.getIdUsuario())) {
                disponibles.add(u);
            }
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
        listarFisioterapeutas(request, response);
    }

}
