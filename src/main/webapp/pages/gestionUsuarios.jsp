<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../components/layout/header.jsp" %>

<%--<div class="d-flex">--%>
<div>
    <%@ include file="../components/layout/sidebar.jsp" %>

    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Gestión de Usuarios</h1>
                    <p class="page-subtitle">Administra los usuarios y permisos del sistema</p>
                </div>
                <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoUsuario')">
                    <i class="fas fa-user-plus"></i>
                    Nuevo Usuario
                </button>
            </div>
        </div>

        <!-- Mensajes de alerta -->
        <c:if test="${not empty sessionScope.mensaje}">
            <div class="alert alert-${sessionScope.tipoMensaje}">
                <i class="fas
                    <c:choose>
                        <c:when test="${sessionScope.tipoMensaje == 'success'}">fa-check-circle</c:when>
                        <c:when test="${sessionScope.tipoMensaje == 'danger'}">fa-exclamation-circle</c:when>
                        <c:when test="${sessionScope.tipoMensaje == 'warning'}">fa-exclamation-triangle</c:when>
                        <c:otherwise>fa-info-circle</c:otherwise>
                    </c:choose>
                "></i>
                <span><c:out value="${sessionScope.mensaje}"/></span>
            </div>
            <c:remove var="mensaje" scope="session"/>
            <c:remove var="tipoMensaje" scope="session"/>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span><c:out value="${error}"/></span>
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value"><c:out value="${totalUsuarios}" default="0"/></div>
                        <div class="stat-label">Total Usuarios</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-value"><c:out value="${usuariosActivos}" default="0"/></div>
                        <div class="stat-label">Usuarios Activos</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <div class="stat-value"><c:out value="${administradores}" default="0"/></div>
                        <div class="stat-label">Administradores</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filter -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <input type="text" class="form-control" id="buscarUsuario"
                                   placeholder="Buscar por nombre de usuario..."
                                   onkeyup="filtrarTabla('buscarUsuario', 'tablaUsuarios')">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroRol" onchange="filtrarPorRol()">
                            <option value="">Todos los roles</option>
                            <option value="Administrador">Administrador</option>
                            <option value="Recepcionista">Recepcionista</option>
                            <option value="Fisioterapeuta">Fisioterapeuta</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroEstado" onchange="filtrarPorEstado()">
                            <option value="">Todos los estados</option>
                            <option value="activo">Activos</option>
                            <option value="inactivo">Inactivos</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-list me-2"></i>Lista de Usuarios</span>
                    <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaUsuarios', 'usuarios.csv')">
                        <i class="fas fa-download me-1"></i>
                        Exportar
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div class="table-container">
                    <table class="table" id="tablaUsuarios">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre de Usuario</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th>Fecha Creación</th>
                            <th>Último Acceso</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty usuarios}">
                                <c:forEach var="usuario" items="${usuarios}">
                                    <tr>
                                        <td><strong>#${usuario.idUsuario}</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fas fa-user-circle text-primary" style="font-size: 1.5rem;"></i>
                                                <div>
                                                    <strong><c:out value="${usuario.nombreUsuario}"/></strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${usuario.rol == 'Administrador'}">
                                                        <span class="badge badge-danger">
                                                            <i class="fas fa-user-shield me-1"></i>${usuario.rol}
                                                        </span>
                                                </c:when>
                                                <c:when test="${usuario.rol == 'Recepcionista'}">
                                                        <span class="badge badge-primary">
                                                            <i class="fas fa-user-tie me-1"></i>${usuario.rol}
                                                        </span>
                                                </c:when>
                                                <c:when test="${usuario.rol == 'Fisioterapeuta'}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-user-md me-1"></i>${usuario.rol}
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="badge badge-secondary">
                                                            <i class="fas fa-user me-1"></i>${usuario.rol}
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                                <span class="badge badge-success">
                                                    <i class="fas fa-uncheck-circle"></i> Activo
                                                </span>
                                        </td>
                                        <td>
                                            <jsp:useBean id="now" class="java.util.Date"/>
                                            <fmt:formatDate value="${now}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-primary"
                                                        title="Ver detalles"
                                                        onclick="verDetalleUsuario(${usuario.idUsuario})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-warning"
                                                        title="Editar"
                                                        onclick="editarUsuario(${usuario.idUsuario}, '${usuario.nombreUsuario}', '${usuario.rol}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-secondary"
                                                        title="Cambiar contraseña"
                                                        onclick="cambiarContrasenia(${usuario.idUsuario})">
                                                    <i class="fas fa-key"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger"
                                                        title="Eliminar"
                                                        onclick="confirmarEliminacion('¿Está seguro de eliminar este usuario?', 'formEliminar${usuario.idUsuario}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <form id="formEliminar${usuario.idUsuario}"
                                                  action="${pageContext.request.contextPath}/UsuarioServlet"
                                                  method="post" style="display: none;">
                                                <input type="hidden" name="action" value="eliminar">
                                                <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <div class="py-4">
                                            <i class="fas fa-users-slash" style="font-size: 3rem; color: var(--text-secondary);"></i>
                                            <p class="mt-3 text-muted">No hay usuarios registrados</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Modal Nuevo Usuario -->
<div class="modal-overlay" id="modalNuevoUsuario">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">Nuevo Usuario</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoUsuario')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form id="formNuevoUsuario" action="${pageContext.request.contextPath}/UsuarioServlet" method="post">
            <input type="hidden" name="action" value="crear">
            <div class="modal-body">
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Información del Usuario</h5>

                <div class="form-group">
                    <label class="form-label required">Nombre de Usuario</label>
                    <input type="text" class="form-control" name="nombreUsuario" required
                           placeholder="Ingrese el nombre de usuario"
                           pattern="[a-zA-Z0-9_]{3,20}"
                           title="3-20 caracteres, solo letras, números y guiones bajos">
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Contraseña</label>
                            <input type="password" class="form-control" name="contrasenia"
                                   id="password" required
                                   placeholder="Mínimo 6 caracteres"
                                   minlength="6">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Confirmar Contraseña</label>
                            <input type="password" class="form-control" name="confirmarContrasenia"
                                   id="confirmPassword" required
                                   placeholder="Repita la contraseña">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label required">Rol</label>
                    <select class="form-select" name="rol" required>
                        <option value="">Seleccione un rol...</option>
                        <option value="Administrador">
                            <i class="fas fa-user-shield"></i> Administrador
                        </option>
                        <option value="Recepcionista">
                            <i class="fas fa-user-tie"></i> Recepcionista
                        </option>
                        <option value="Fisioterapeuta">
                            <i class="fas fa-user-md"></i> Fisioterapeuta
                        </option>
                    </select>
                </div>

                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong>Roles y Permisos:</strong>
                        <ul class="mb-0 mt-2" style="font-size: 0.875rem;">
                            <li><strong>Administrador:</strong> Acceso total al sistema</li>
                            <li><strong>Recepcionista:</strong> Gestión de pacientes y turnos</li>
                            <li><strong>Fisioterapeuta:</strong> Ver turnos y registrar observaciones</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoUsuario')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>Crear Usuario
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Editar Usuario -->
<div class="modal-overlay" id="modalEditarUsuario">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">Editar Usuario</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalEditarUsuario')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form id="formEditarUsuario" action="${pageContext.request.contextPath}/UsuarioServlet" method="post">
            <input type="hidden" name="action" value="editar">
            <input type="hidden" name="idUsuario" id="editIdUsuario">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label required">Nombre de Usuario</label>
                    <input type="text" class="form-control" name="nombreUsuario"
                           id="editNombreUsuario" required>
                </div>

                <div class="form-group">
                    <label class="form-label required">Rol</label>
                    <select class="form-select" name="rol" id="editRol" required>
                        <option value="">Seleccione un rol...</option>
                        <option value="Administrador">Administrador</option>
                        <option value="Recepcionista">Recepcionista</option>
                        <option value="Fisioterapeuta">Fisioterapeuta</option>
                    </select>
                </div>

                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    Para cambiar la contraseña, use la opción "Cambiar Contraseña"
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarUsuario')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>Guardar Cambios
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Cambiar Contraseña -->
<div class="modal-overlay" id="modalCambiarContrasenia">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">Cambiar Contraseña</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalCambiarContrasenia')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form id="formCambiarContrasenia" action="${pageContext.request.contextPath}/UsuarioServlet" method="post">
            <input type="hidden" name="action" value="cambiarContrasenia">
            <input type="hidden" name="idUsuario" id="cambiarPassIdUsuario">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label required">Nueva Contraseña</label>
                    <input type="password" class="form-control" name="nuevaContrasenia"
                           id="nuevaPassword" required minlength="6"
                           placeholder="Mínimo 6 caracteres">
                </div>

                <div class="form-group">
                    <label class="form-label required">Confirmar Nueva Contraseña</label>
                    <input type="password" class="form-control" name="confirmarContrasenia"
                           id="confirmNuevaPassword" required
                           placeholder="Repita la contraseña">
                </div>

                <div class="alert alert-info">
                    <i class="fas fa-shield-alt"></i>
                    Asegúrese de usar una contraseña segura con al menos 6 caracteres
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalCambiarContrasenia')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-key me-2"></i>Cambiar Contraseña
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Validar que las contraseñas coincidan al crear usuario
    document.getElementById('formNuevoUsuario').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            FisioApp.showAlert('Las contraseñas no coinciden', 'danger');
        }
    });

    // Validar que las contraseñas coincidan al cambiar contraseña
    document.getElementById('formCambiarContrasenia').addEventListener('submit', function(e) {
        const nuevaPassword = document.getElementById('nuevaPassword').value;
        const confirmNuevaPassword = document.getElementById('confirmNuevaPassword').value;

        if (nuevaPassword !== confirmNuevaPassword) {
            e.preventDefault();
            FisioApp.showAlert('Las contraseñas no coinciden', 'danger');
        }
    });

    function editarUsuario(idUsuario, nombreUsuario, rol) {
        FisioApp.openModal('modalEditarUsuario');
        document.getElementById('editIdUsuario').value = idUsuario;
        document.getElementById('editNombreUsuario').value = nombreUsuario;
        document.getElementById('editRol').value = rol;
    }

    function cambiarContrasenia(idUsuario) {
        FisioApp.openModal('modalCambiarContrasenia');
        document.getElementById('cambiarPassIdUsuario').value = idUsuario;
    }

    function verDetalleUsuario(idUsuario) {
        window.location.href = '${pageContext.request.contextPath}/UsuarioServlet?action=ver&id=' + idUsuario;
    }

    function filtrarPorRol() {
        const filtro = document.getElementById('filtroRol').value;
        const tabla = document.getElementById('tablaUsuarios');
        const filas = tabla.getElementsByTagName('tr');

        for (let i = 1; i < filas.length; i++) {
            const rol = filas[i].cells[2].textContent.trim();
            if (filtro === '' || rol.includes(filtro)) {
                filas[i].style.display = '';
            } else {
                filas[i].style.display = 'none';
            }
        }
    }

    function filtrarPorEstado() {
        const filtro = document.getElementById('filtroEstado').value;
        const tabla = document.getElementById('tablaUsuarios');
        const filas = tabla.getElementsByTagName('tr');

        for (let i = 1; i < filas.length; i++) {
            const estado = filas[i].cells[3].textContent.toLowerCase();
            if (filtro === '' || estado.includes(filtro)) {
                filas[i].style.display = '';
            } else {
                filas[i].style.display = 'none';
            }
        }
    }
</script>

<c:if test="${not empty modal}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const modal = "${modal}";
            const idUsuario = "${usuarioModal.idUsuario}";

            if (modal === "editar") {
                editarUsuario(idUsuario, '${usuarioModal.nombreUsuario}', '${usuarioModal.rol}');
            }

            if (modal === "cambiarPass") {
                cambiarContrasenia(idUsuario);
            }
        });
    </script>
</c:if>


<%@ include file="../components/layout/footer.jsp" %>
