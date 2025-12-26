<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<div>
    <%@ include file="../components/layout/sidebar.jsp" %>

    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="page-title">Gestión de Fisioterapeutas</h1>
                    <p class="page-subtitle">Administra el personal médico especializado del centro</p>
                </div>
                <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoFisioterapeuta')">
                    <i class="fas fa-user-md"></i>
                    Nuevo Fisioterapeuta
                </button>
            </div>
        </div>

        <!-- Mensajes -->
        <c:if test="${not empty sessionScope.mensaje}">
            <div class="alert alert-${sessionScope.tipoMensaje}">
                <i class="fas
                    <c:choose>
                        <c:when test="${sessionScope.tipoMensaje == 'success'}">fa-check-circle</c:when>
                        <c:when test="${sessionScope.tipoMensaje == 'danger'}">fa-exclamation-circle</c:when>
                        <c:otherwise>fa-info-circle</c:otherwise>
                    </c:choose>
                "></i>
                <span><c:out value="${sessionScope.mensaje}"/></span>
            </div>
            <c:remove var="mensaje" scope="session"/>
            <c:remove var="tipoMensaje" scope="session"/>
        </c:if>

        <!-- Statistics -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-value"><c:out value="${totalFisioterapeutas}" default="0"/></div>
                        <div class="stat-label">Total Fisioterapeutas</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-value"><c:out value="${fisiosActivos}" default="0"/></div>
                        <div class="stat-label">Activos</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="fas fa-certificate"></i>
                        </div>
                        <div class="stat-value"><c:out value="${especialidades}" default="0"/></div>
                        <div class="stat-label">Especialidades</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-value"><c:out value="${turnosHoy}" default="0"/></div>
                        <div class="stat-label">Turnos Hoy</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search and Filters -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-5">
                        <input type="text" class="form-control" placeholder="Buscar por nombre, cédula o email..."
                               onkeyup="filtrarTabla('buscarFisio', 'tablaFisioterapeutas')" id="buscarFisio">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroEspecialidad" onchange="filtrarPorEspecialidad()">
                            <option value="">Todas las especialidades</option>
                            <option value="Rehabilitación">Rehabilitación</option>
                            <option value="Deportiva">Deportiva</option>
                            <option value="Neurológica">Neurológica</option>
                            <option value="Pediátrica">Pediátrica</option>
                            <option value="Geriátrica">Geriátrica</option>
                            <option value="Traumatología">Traumatología</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" id="filtroUsuario" onchange="filtrarPorUsuario()">
                            <option value="">Todos</option>
                            <option value="con">Con Usuario</option>
                            <option value="sin">Sin Usuario</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-secondary w-100" onclick="limpiarFiltros()">
                            <i class="fas fa-redo me-1"></i>Limpiar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cards -->
        <c:if test="${not empty fisioterapeutas}">
            <div class="row g-4 mb-4">
                <c:forEach var="fisio" items="${fisioterapeutas}" begin="0" end="5">
                    <div class="col-md-6 col-lg-4">
                        <div class="card">
                            <div class="card-body text-center">
                                <div style="width: 80px; height: 80px; margin: 0 auto 1rem;
                                     background: linear-gradient(135deg, #10b981, #059669);
                                     border-radius: 50%; display: flex; align-items: center; justify-content: center;
                                     color: white; font-size: 2rem;">
                                    <i class="fas fa-user-md"></i>
                                </div>
                                <h5 class="fw-bold mb-1">
                                    Dr(a). <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/>
                                </h5>
                                <p class="text-muted mb-2">
                                    <i class="fas fa-certificate me-1"></i>
                                    <c:out value="${fisio.especialidad}"/>
                                </p>
                                <div class="mb-3">
                                    <c:choose>
                                        <c:when test="${not empty fisio.usuario}">
                                            <span class="badge badge-success">
                                                <i class="fas fa-check-circle"></i> Usuario Asignado
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">
                                                <i class="fas fa-exclamation-triangle"></i> Sin Usuario
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <p class="mb-2 small">
                                    <i class="fas fa-id-card me-2 text-primary"></i>
                                    <c:out value="${fisio.cedula}"/>
                                </p>
                                <p class="mb-2 small">
                                    <i class="fas fa-envelope me-2 text-primary"></i>
                                    <c:out value="${fisio.correo}"/>
                                </p>
                                <p class="mb-3 small">
                                    <i class="fas fa-phone me-2 text-primary"></i>
                                    <c:out value="${fisio.telefono}"/>
                                </p>
                                <div class="d-flex gap-2 justify-content-center">
                                    <button class="btn btn-sm btn-primary"
                                            onclick="verDetalle(${fisio.id})"
                                            title="Ver detalles">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-warning"
                                            onclick="abrirModalEditar(${fisio.id})"
                                            title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger"
                                            onclick="confirmarEliminacion('¿Eliminar este fisioterapeuta?', 'formEliminar${fisio.id}')"
                                            title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                                <form id="formEliminar${fisio.id}"
                                      action="${pageContext.request.contextPath}/FisioterapeutaServlet"
                                      method="post" style="display: none;">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="idFisioterapeuta" value="${fisio.id}">
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Tabla -->
        <div class="card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-table me-2"></i>Listado Completo</span>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-info" onclick="window.print()">
                            <i class="fas fa-print me-1"></i>Imprimir
                        </button>
                        <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaFisioterapeutas', 'fisioterapeutas.csv')">
                            <i class="fas fa-download me-1"></i>Exportar
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-container">
                    <table class="table" id="tablaFisioterapeutas">
                        <thead>
                        <tr>
                            <th>Cédula</th>
                            <th>Fisioterapeuta</th>
                            <th>Especialidad</th>
                            <th>Email</th>
                            <th>Teléfono</th>
                            <th>Usuario</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty fisioterapeutas}">
                                <c:forEach var="fisio" items="${fisioterapeutas}">
                                    <tr>
                                        <td><c:out value="${fisio.cedula}"/></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="fas fa-user-md text-success" style="font-size: 1.5rem;"></i>
                                                <strong>
                                                    Dr(a). <c:out value="${fisio.nombre}"/>
                                                    <c:out value="${fisio.apellido}"/>
                                                </strong>
                                            </div>
                                        </td>
                                        <td>
                                                <span class="badge badge-info">
                                                    <c:out value="${fisio.especialidad}"/>
                                                </span>
                                        </td>
                                        <td><c:out value="${fisio.correo}"/></td>
                                        <td><c:out value="${fisio.telefono}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty fisio.usuario}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-user me-1"></i>
                                                            <c:out value="${fisio.usuario.nombreUsuario}"/>
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning">Sin asignar</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check-circle"></i> Activo
                                                </span>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-warning" title="Editar"
                                                        onclick="abrirModalEditar(${fisio.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger" title="Eliminar"
                                                        onclick="confirmarEliminacion('¿Eliminar?', 'formEliminarTabla${fisio.id}')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <form id="formEliminarTabla${fisio.id}"
                                                  action="${pageContext.request.contextPath}/FisioterapeutaServlet"
                                                  method="post" style="display: none;">
                                                <input type="hidden" name="action" value="eliminar">
                                                <input type="hidden" name="idFisioterapeuta" value="${fisio.id}">
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="text-center">
                                        <div class="py-4">
                                            <i class="fas fa-user-slash" style="font-size: 3rem; color: var(--text-secondary);"></i>
                                            <p class="mt-3 text-muted">No hay fisioterapeutas registrados</p>
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

<!-- Modal Nuevo -->
<div class="modal-overlay" id="modalNuevoFisioterapeuta">
    <div class="modal modal-lg">
        <div class="modal-header">
            <h3 class="modal-title">Nuevo Fisioterapeuta</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoFisioterapeuta')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/FisioterapeutaServlet" method="post">
            <input type="hidden" name="action" value="crear">
            <div class="modal-body">
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Datos Personales</h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Nombre</label>
                            <input type="text" class="form-control" name="nombre" required
                                   placeholder="Ingrese el nombre">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Apellido</label>
                            <input type="text" class="form-control" name="apellido" required
                                   placeholder="Ingrese el apellido">
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Cédula</label>
                            <input type="text" class="form-control" name="cedula" required
                                   placeholder="1234567890" maxlength="10">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Fecha de Nacimiento</label>
                            <input type="date" class="form-control" name="fechaNacimiento" required>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Email</label>
                            <input type="email" class="form-control" name="correo" required
                                   placeholder="ejemplo@email.com">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Teléfono</label>
                            <input type="tel" class="form-control" name="telefono" required
                                   placeholder="0987654321" maxlength="10">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Dirección</label>
                    <input type="text" class="form-control" name="direccion"
                           placeholder="Dirección completa">
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-certificate me-2"></i>Información Profesional</h5>

                <div class="form-group">
                    <label class="form-label required">Especialidad</label>
                    <select class="form-select" name="especialidad" required>
                        <option value="">Seleccione...</option>
                        <option value="Rehabilitación">Rehabilitación</option>
                        <option value="Deportiva">Deportiva</option>
                        <option value="Neurológica">Neurológica</option>
                        <option value="Pediátrica">Pediátrica</option>
                        <option value="Geriátrica">Geriátrica</option>
                        <option value="Traumatología">Traumatología</option>
                        <option value="Respiratoria">Respiratoria</option>
                        <option value="Cardíaca">Cardíaca</option>
                    </select>
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-clock me-2"></i>Horario de Trabajo</h5>

                <div class="form-group">
                    <label class="form-label">Horario Asignado</label>
                    <select class="form-select" name="idHorario">
                        <option value="">Sin horario asignado</option>
                        <c:forEach var="horario" items="${horariosDisponibles}">
                            <option value="${horario.idHorario}">
                                    ${horario.diaDeSemana} - ${horario.horaInicio} a ${horario.horaFin}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-user-lock me-2"></i>Asignación de Usuario</h5>

                <div class="form-group">
                    <label class="form-label required">Usuario del Sistema</label>
                    <select class="form-select" name="idUsuario" id="selectUsuarioNuevo" required>
                        <option value="">Seleccione un usuario...</option>
                        <c:forEach var="usuario" items="${usuariosDisponibles}">
                            <option value="${usuario.idUsuario}">
                                <c:out value="${usuario.nombreUsuario}"/>
                                (Rol: ${usuario.rol})
                            </option>
                        </c:forEach>
                    </select>
                    <small class="text-muted">
                        Solo se muestran usuarios con rol "Fisioterapeuta" sin asignar
                    </small>
                </div>

                <c:if test="${empty usuariosDisponibles}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>No hay usuarios disponibles.</strong>
                        Primero debe crear un usuario con rol "Fisioterapeuta" en el módulo de Usuarios.
                        <a href="${pageContext.request.contextPath}/UsuarioServlet" class="alert-link">
                            Ir a Usuarios
                        </a>
                    </div>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoFisioterapeuta')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary" ${empty usuariosDisponibles ? 'disabled' : ''}>
                    <i class="fas fa-save me-2"></i>Guardar Fisioterapeuta
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Editar -->
<div class="modal-overlay" id="modalEditarFisioterapeuta">
    <div class="modal modal-lg">
        <div class="modal-header">
            <h3 class="modal-title">Editar Fisioterapeuta</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalEditarFisioterapeuta')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/FisioterapeutaServlet" method="post">
            <input type="hidden" name="action" value="editar">
            <input type="hidden" name="idFisioterapeuta" id="editId">
            <div class="modal-body">
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Datos Personales</h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Nombre</label>
                            <input type="text" class="form-control" name="nombre" id="editNombre" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Apellido</label>
                            <input type="text" class="form-control" name="apellido" id="editApellido" required>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Cédula</label>
                            <input type="text" class="form-control" name="cedula" id="editCedula" required maxlength="10">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Email</label>
                            <input type="email" class="form-control" name="correo" id="editCorreo" required>
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Teléfono</label>
                            <input type="tel" class="form-control" name="telefono" id="editTelefono" required maxlength="10">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Dirección</label>
                            <input type="text" class="form-control" name="direccion" id="editDireccion">
                        </div>
                    </div>
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-certificate me-2"></i>Información Profesional</h5>

                <div class="form-group">
                    <label class="form-label required">Especialidad</label>
                    <select class="form-select" name="especialidad" id="editEspecialidad" required>
                        <option value="">Seleccione...</option>
                        <option value="Rehabilitación">Rehabilitación</option>
                        <option value="Deportiva">Deportiva</option>
                        <option value="Neurológica">Neurológica</option>
                        <option value="Pediátrica">Pediátrica</option>
                        <option value="Geriátrica">Geriátrica</option>
                        <option value="Traumatología">Traumatología</option>
                        <option value="Respiratoria">Respiratoria</option>
                        <option value="Cardíaca">Cardíaca</option>
                    </select>
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-user-lock me-2"></i>Usuario Asignado</h5>

                <div class="form-group">
                    <label class="form-label">Usuario del Sistema</label>
                    <select class="form-select" name="idUsuario" id="editUsuario">
                        <option value="">Sin asignar</option>
                        <c:forEach var="usuario" items="${todosLosUsuarios}">
                            <c:if test="${usuario.rol == 'Fisioterapeuta'}">
                                <option value="${usuario.idUsuario}">
                                    <c:out value="${usuario.nombreUsuario}"/>
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>

                <h5 class="mb-3 mt-4"><i class="fas fa-clock me-2"></i>Horario de Trabajo</h5>

                <div class="form-group">
                    <label class="form-label">Horario Asignado</label>
                    <select class="form-select" name="idHorario" id="editHorario">
                        <option value="">Sin horario asignado</option>
                        <c:forEach var="horario" items="${horariosDisponibles}">
                            <option value="${horario.idHorario}">
                                    ${horario.diaDeSemana} - ${horario.horaInicio} a ${horario.horaFin}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarFisioterapeuta')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>Guardar Cambios
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function abrirModalEditar(id) {
        fetch('${pageContext.request.contextPath}/FisioterapeutaServlet?action=obtener&id=' + id)
            .then(response => response.json())
            .then(data => {
                document.getElementById('editId').value = data.id;
                document.getElementById('editNombre').value = data.nombre;
                document.getElementById('editApellido').value = data.apellido;
                document.getElementById('editCedula').value = data.cedula;
                document.getElementById('editCorreo').value = data.correo;
                document.getElementById('editTelefono').value = data.telefono;
                document.getElementById('editDireccion').value = data.direccion || '';
                document.getElementById('editEspecialidad').value = data.especialidad;
                document.getElementById('editUsuario').value = data.idUsuario ?? '';
                document.getElementById('editHorario').value = data.idHorario ?? '';

                FisioApp.openModal('modalEditarFisioterapeuta');
            })
            .catch(error => {
                console.error('Error:', error);
                FisioApp.showAlert('Error al cargar los datos', 'danger');
            });
    }

    function verDetalle(id) {
        window.location.href = '${pageContext.request.contextPath}/FisioterapeutaServlet?action=ver&id=' + id;
    }

    function limpiarFiltros() {
        document.getElementById('buscarFisio').value = '';
        document.getElementById('filtroEspecialidad').value = '';
        document.getElementById('filtroUsuario').value = '';
        filtrarTabla('buscarFisio', 'tablaFisioterapeutas');
    }

    function filtrarPorEspecialidad() {
        const filtro = document.getElementById('filtroEspecialidad').value;
        const tabla = document.getElementById('tablaFisioterapeutas');
        const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

        for (let i = 0; i < filas.length; i++) {
            const especialidadCell = filas[i].getElementsByTagName('td')[2];
            if (especialidadCell) {
                const texto = especialidadCell.textContent || especialidadCell.innerText;
                if (filtro === '' || texto.includes(filtro)) {
                    filas[i].style.display = '';
                } else {
                    filas[i].style.display = 'none';
                }
            }
        }
    }

    function filtrarPorUsuario() {
        const filtro = document.getElementById('filtroUsuario').value;
        const tabla = document.getElementById('tablaFisioterapeutas');
        const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

        for (let i = 0; i < filas.length; i++) {
            const usuarioCell = filas[i].getElementsByTagName('td')[5];
            if (usuarioCell) {
                const texto = usuarioCell.textContent || usuarioCell.innerText;
                if (filtro === '' ||
                    (filtro === 'con' && !texto.includes('Sin asignar')) ||
                    (filtro === 'sin' && texto.includes('Sin asignar'))) {
                    filas[i].style.display = '';
                } else {
                    filas[i].style.display = 'none';
                }
            }
        }
    }
</script>

<%@ include file="../components/layout/footer.jsp" %>
