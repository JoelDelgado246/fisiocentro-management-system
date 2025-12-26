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
                    <h1 class="page-title">Gestión de Pacientes</h1>
                    <p class="page-subtitle">Administra el historial clínico y datos de los pacientes</p>
                </div>
                <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoPaciente')">
                    <i class="fas fa-user-plus"></i>
                    Nuevo Paciente
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
                        <div class="stat-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value"><c:out value="${totalPacientes}" default="0"/></div>
                        <div class="stat-label">Total Pacientes</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-value"><c:out value="${pacientesActivos}" default="0"/></div>
                        <div class="stat-label">Activos</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="stat-value"><c:out value="${conSeguro}" default="0"/></div>
                        <div class="stat-label">Con Seguro</div>
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
                               onkeyup="filtrarTabla('buscarPaciente', 'tablaPacientes')" id="buscarPaciente">
                    </div>
                    <div class="col-md-2">
                        <select class="form-select" id="filtroSeguro" onchange="filtrarPorSeguro()">
                            <option value="">Todos</option>
                            <option value="si">Con Seguro</option>
                            <option value="no">Sin Seguro</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="filtroTratamiento">
                            <option value="">Todos los tratamientos</option>
                            <option value="Fisioterapia General">Fisioterapia General</option>
                            <option value="Rehabilitación">Rehabilitación</option>
                            <option value="Deportiva">Deportiva</option>
                            <option value="Neurológica">Neurológica</option>
                            <option value="Pediátrica">Pediátrica</option>
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

        <!-- Tabla -->
        <div class="card">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-table me-2"></i>Listado de Pacientes</span>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-info" onclick="window.print()">
                            <i class="fas fa-print me-1"></i>Imprimir
                        </button>
                        <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaPacientes', 'pacientes.csv')">
                            <i class="fas fa-download me-1"></i>Exportar
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-container">
                    <table class="table" id="tablaPacientes">
                        <thead>
                        <tr>
                            <th>Cédula</th>
                            <th>Paciente</th>
                            <th>Email</th>
                            <th>Teléfono</th>
                            <th>Tratamiento</th>
                            <th>Seguro</th>
                            <th>Responsable</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty pacientes}">
                                <c:forEach var="paciente" items="${pacientes}">
                                    <tr>
                                        <td><c:out value="${paciente.cedula}"/></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div style="width: 40px; height: 40px; border-radius: 50%;
                                                         background: linear-gradient(135deg, #3b82f6, #2563eb);
                                                         display: flex; align-items: center; justify-content: center;
                                                         color: white; font-weight: bold;">
                                                        ${fn:substring(paciente.nombre, 0, 1)}${fn:substring(paciente.apellido, 0, 1)}
                                                </div>
                                                <div>
                                                    <strong>
                                                        <c:out value="${paciente.nombre}"/>
                                                        <c:out value="${paciente.apellido}"/>
                                                    </strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td><c:out value="${paciente.correo}"/></td>
                                        <td><c:out value="${paciente.telefono}"/></td>
                                        <td>
                                                <span class="badge badge-info">
                                                    <c:out value="${paciente.tipoTratamiento}"/>
                                                </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${paciente.poseeSeguro}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-check-circle"></i> Sí
                                                        </span>
                                                </c:when>
                                                <c:otherwise>
                                                        <span class="badge badge-warning">
                                                            <i class="fas fa-times-circle"></i> No
                                                        </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty paciente.responsable}">
                                                    <div class="d-flex align-items-center gap-1">
                                                        <i class="fas fa-user-friends text-primary"></i>
                                                        <small>
                                                            <c:out value="${paciente.responsable.nombre}"/>
                                                            <c:out value="${paciente.responsable.apellido}"/>
                                                        </small>
                                                    </div>
                                                    <small class="text-muted">
                                                        (<c:out value="${paciente.responsable.relacionPaciente}"/>)
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning">Sin responsable</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-2">
                                                <button class="btn btn-sm btn-primary"
                                                        onclick="verDetalle(${paciente.id})"
                                                        title="Ver detalles">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-warning"
                                                        onclick="abrirModalEditar(${paciente.id})"
                                                        title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-info"
                                                        onclick="verHistorial(${paciente.id})"
                                                        title="Historial">
                                                    <i class="fas fa-history"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger"
                                                        onclick="confirmarEliminacion('¿Eliminar paciente?', 'formEliminar${paciente.id}')"
                                                        title="Eliminar">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                            <form id="formEliminar${paciente.id}"
                                                  action="${pageContext.request.contextPath}/PacienteServlet"
                                                  method="post" style="display: none;">
                                                <input type="hidden" name="action" value="eliminar">
                                                <input type="hidden" name="idPaciente" value="${paciente.id}">
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
                                            <p class="mt-3 text-muted">No hay pacientes registrados</p>
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

<!-- Modal Nuevo Paciente -->
<div class="modal-overlay" id="modalNuevoPaciente">
    <div class="modal modal-xl">
        <div class="modal-header">
            <h3 class="modal-title">Nuevo Paciente</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoPaciente')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/PacienteServlet" method="post">
            <input type="hidden" name="action" value="crear">
            <div class="modal-body">
                <!-- Datos Personales -->
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Datos Personales del Paciente</h5>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Nombre</label>
                            <input type="text" class="form-control" name="nombre" required
                                   placeholder="Ingrese el nombre">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Apellido</label>
                            <input type="text" class="form-control" name="apellido" required
                                   placeholder="Ingrese el apellido">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Cédula</label>
                            <input type="text" class="form-control" name="cedula" required
                                   placeholder="1234567890" maxlength="10">
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Email</label>
                            <input type="email" class="form-control" name="correo" required
                                   placeholder="ejemplo@email.com">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Teléfono</label>
                            <input type="tel" class="form-control" name="telefono" required
                                   placeholder="0987654321" maxlength="10">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Fecha de Nacimiento</label>
                            <input type="date" class="form-control" name="fechaNacimiento" required>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Dirección</label>
                    <input type="text" class="form-control" name="direccion"
                           placeholder="Dirección completa">
                </div>

                <hr class="my-4">

                <!-- Información Médica -->
                <h5 class="mb-3"><i class="fas fa-notes-medical me-2"></i>Información Médica</h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Tipo de Tratamiento</label>
                            <select class="form-select" name="tipoTratamiento" required>
                                <option value="">Seleccione...</option>
                                <option value="Fisioterapia General">Fisioterapia General</option>
                                <option value="Rehabilitación">Rehabilitación</option>
                                <option value="Deportiva">Deportiva</option>
                                <option value="Neurológica">Neurológica</option>
                                <option value="Pediátrica">Pediátrica</option>
                                <option value="Geriátrica">Geriátrica</option>
                                <option value="Traumatología">Traumatología</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Posee Seguro Médico</label>
                            <div class="form-check form-switch" style="padding-top: 0.5rem;">
                                <input class="form-check-input" type="checkbox" name="poseeSeguro"
                                       id="poseeSeguroNuevo" value="true">
                                <label class="form-check-label" for="poseeSeguroNuevo">
                                    Sí, tiene seguro médico
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label required">Motivo de Consulta</label>
                    <textarea class="form-control" name="motivoConsulta" rows="3" required
                              placeholder="Describa el motivo de la consulta o síntomas..."></textarea>
                </div>

                <hr class="my-4">

                <!-- Datos del Responsable -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="fas fa-user-friends me-2"></i>Datos del Responsable</h5>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="tieneResponsableNuevo"
                               onchange="toggleResponsableNuevo()">
                        <label class="form-check-label" for="tieneResponsableNuevo">
                            Tiene responsable
                        </label>
                    </div>
                </div>

                <div id="seccionResponsableNuevo" style="display: none;">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <small>Complete estos datos si el paciente es menor de edad o requiere un responsable legal.</small>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Nombre del Responsable</label>
                                <input type="text" class="form-control" name="responsableNombre"
                                       id="responsableNombreNuevo" placeholder="Nombre completo">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Apellido del Responsable</label>
                                <input type="text" class="form-control" name="responsableApellido"
                                       id="responsableApellidoNuevo" placeholder="Apellido">
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Cédula</label>
                                <input type="text" class="form-control" name="responsableCedula"
                                       id="responsableCedulaNuevo" placeholder="1234567890" maxlength="10">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Teléfono</label>
                                <input type="tel" class="form-control" name="responsableTelefono"
                                       id="responsableTelefonoNuevo" placeholder="0987654321" maxlength="10">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Relación</label>
                                <select class="form-select" name="responsableRelacion" id="responsableRelacionNuevo">
                                    <option value="">Seleccione...</option>
                                    <option value="Padre">Padre</option>
                                    <option value="Madre">Madre</option>
                                    <option value="Tutor Legal">Tutor Legal</option>
                                    <option value="Hermano/a">Hermano/a</option>
                                    <option value="Abuelo/a">Abuelo/a</option>
                                    <option value="Otro">Otro</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="responsableCorreo"
                                       id="responsableCorreoNuevo" placeholder="email@ejemplo.com">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Dirección</label>
                                <input type="text" class="form-control" name="responsableDireccion"
                                       id="responsableDireccionNuevo" placeholder="Dirección completa">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoPaciente')">
                    Cancelar
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i>Guardar Paciente
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Editar (estructura similar, se llena con AJAX) -->
<div class="modal-overlay" id="modalEditarPaciente">
    <div class="modal modal-xl">
        <div class="modal-header">
            <h3 class="modal-title">Editar Paciente</h3>
            <button class="modal-close" onclick="FisioApp.closeModal('modalEditarPaciente')">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <form action="${pageContext.request.contextPath}/PacienteServlet" method="post">
            <input type="hidden" name="action" value="editar">
            <input type="hidden" name="idPaciente" id="editId">
            <input type="hidden" name="idResponsable" id="editIdResponsable">
            <div class="modal-body">
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Datos Personales</h5>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Nombre</label>
                            <input type="text" class="form-control" name="nombre" id="editNombre" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Apellido</label>
                            <input type="text" class="form-control" name="apellido" id="editApellido" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Cédula</label>
                            <input type="text" class="form-control" name="cedula" id="editCedula" required maxlength="10">
                        </div>
                    </div>
                </div>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Email</label>
                            <input type="email" class="form-control" name="correo" id="editCorreo" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label required">Teléfono</label>
                            <input type="tel" class="form-control" name="telefono" id="editTelefono" required maxlength="10">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">Dirección</label>
                            <input type="text" class="form-control" name="direccion" id="editDireccion">
                        </div>
                    </div>
                </div>

                <hr class="my-4">

                <h5 class="mb-3"><i class="fas fa-notes-medical me-2"></i>Información Médica</h5>

                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Tipo de Tratamiento</label>
                            <select class="form-select" name="tipoTratamiento" id="editTratamiento" required>
                                <option value="">Seleccione...</option>
                                <option value="Fisioterapia General">Fisioterapia General</option>
                                <option value="Rehabilitación">Rehabilitación</option>
                                <option value="Deportiva">Deportiva</option>
                                <option value="Neurológica">Neurológica</option>
                                <option value="Pediátrica">Pediátrica</option>
                                <option value="Geriátrica">Geriátrica</option>
                                <option value="Traumatología">Traumatología</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Posee Seguro Médico</label>
                            <div class="form-check form-switch" style="padding-top: 0.5rem;">
                                <input class="form-check-input" type="checkbox" name="poseeSeguro"
                                       id="editSeguro" value="true">
                                <label class="form-check-label" for="editSeguro">
                                    Sí, tiene seguro médico
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label required">Motivo de Consulta</label>
                    <textarea class="form-control" name="motivoConsulta" id="editMotivo" rows="3" required></textarea>
                </div>

                <hr class="my-4">

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="fas fa-user-friends me-2"></i>Datos del Responsable</h5>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="tieneResponsableEdit"
                               onchange="toggleResponsableEdit()">
                        <label class="form-check-label" for="tieneResponsableEdit">
                            Tiene responsable
                        </label>
                    </div>
                </div>

                <div id="seccionResponsableEdit" style="display: none;">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Nombre</label>
                                <input type="text" class="form-control" name="responsableNombre" id="editRespNombre">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Apellido</label>
                                <input type="text" class="form-control" name="responsableApellido" id="editRespApellido">
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Cédula</label>
                                <input type="text" class="form-control" name="responsableCedula" id="editRespCedula" maxlength="10">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Teléfono</label>
                                <input type="tel" class="form-control" name="responsableTelefono" id="editRespTelefono" maxlength="10">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="form-label">Relación</label>
                                <select class="form-select" name="responsableRelacion" id="editRespRelacion">
                                    <option value="">Seleccione...</option>
                                    <option value="Padre">Padre</option>
                                    <option value="Madre">Madre</option>
                                    <option value="Tutor Legal">Tutor Legal</option>
                                    <option value="Hermano/a">Hermano/a</option>
                                    <option value="Abuelo/a">Abuelo/a</option>
                                    <option value="Otro">Otro</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="responsableCorreo" id="editRespCorreo">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Dirección</label>
                                <input type="text" class="form-control" name="responsableDireccion" id="editRespDireccion">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarPaciente')">
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
    function toggleResponsableNuevo() {
        const checkbox = document.getElementById('tieneResponsableNuevo');
        const seccion = document.getElementById('seccionResponsableNuevo');
        seccion.style.display = checkbox.checked ? 'block' : 'none';

        if (!checkbox.checked) {
            document.getElementById('responsableNombreNuevo').value = '';
            document.getElementById('responsableApellidoNuevo').value = '';
            document.getElementById('responsableCedulaNuevo').value = '';
            document.getElementById('responsableTelefonoNuevo').value = '';
            document.getElementById('responsableRelacionNuevo').value = '';
            document.getElementById('responsableCorreoNuevo').value = '';
            document.getElementById('responsableDireccionNuevo').value = '';
        }
    }

    function toggleResponsableEdit() {
        const checkbox = document.getElementById('tieneResponsableEdit');
        const seccion = document.getElementById('seccionResponsableEdit');
        seccion.style.display = checkbox.checked ? 'block' : 'none';
    }

    function abrirModalEditar(id) {
        fetch('${pageContext.request.contextPath}/PacienteServlet?action=obtener&id=' + id)
            .then(response => response.json())
            .then(data => {
                document.getElementById('editId').value = data.id;
                document.getElementById('editNombre').value = data.nombre;
                document.getElementById('editApellido').value = data.apellido;
                document.getElementById('editCedula').value = data.cedula;
                document.getElementById('editCorreo').value = data.correo;
                document.getElementById('editTelefono').value = data.telefono;
                document.getElementById('editDireccion').value = data.dirección || '';
                document.getElementById('editTratamiento').value = data.tipoTratamiento;
                document.getElementById('editSeguro').checked = data.poseeSeguro;
                document.getElementById('editMotivo').value = data.motivoConsulta;

                if (data.responsable) {
                    document.getElementById('tieneResponsableEdit').checked = true;
                    toggleResponsableEdit();
                    document.getElementById('editIdResponsable').value = data.responsable.id;
                    document.getElementById('editRespNombre').value = data.responsable.nombre;
                    document.getElementById('editRespApellido').value = data.responsable.apellido;
                    document.getElementById('editRespCedula').value = data.responsable.cedula;
                    document.getElementById('editRespTelefono').value = data.responsable.telefono;
                    document.getElementById('editRespRelacion').value = data.responsable.relacionPaciente;
                    document.getElementById('editRespCorreo').value = data.responsable.correo || '';
                    document.getElementById('editRespDireccion').value = data.responsable.direccion || '';
                } else {
                    document.getElementById('tieneResponsableEdit').checked = false;
                    toggleResponsableEdit();
                }

                FisioApp.openModal('modalEditarPaciente');
            })
            .catch(error => {
                console.error('Error:', error);
                FisioApp.showAlert('Error al cargar los datos', 'danger');
            });
    }

    function verDetalle(id) {
        window.location.href = '${pageContext.request.contextPath}/PacienteServlet?action=ver&id=' + id;
    }

    function verHistorial(id) {
        window.location.href = '${pageContext.request.contextPath}/PacienteServlet?action=historial&id=' + id;
    }

    function limpiarFiltros() {
        document.getElementById('buscarPaciente').value = '';
        document.getElementById('filtroSeguro').value = '';
        document.getElementById('filtroTratamiento').value = '';
        filtrarTabla('buscarPaciente', 'tablaPacientes');
    }

    function filtrarPorSeguro() {
        const filtro = document.getElementById('filtroSeguro').value;
        const tabla = document.getElementById('tablaPacientes');
        const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

        for (let i = 0; i < filas.length; i++) {
            const seguroCell = filas[i].getElementsByTagName('td')[5];
            if (seguroCell) {
                const texto = seguroCell.textContent || seguroCell.innerText;
                if (filtro === '' ||
                    (filtro === 'si' && texto.includes('Sí')) ||
                    (filtro === 'no' && texto.includes('No'))) {
                    filas[i].style.display = '';
                } else {
                    filas[i].style.display = 'none';
                }
            }
        }
    }
</script>

<c:if test="${not empty modal}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const idPaciente = "${idPacienteModal}";
            abrirModalEditar(idPaciente)
        });
    </script>
</c:if>

<%@ include file="../components/layout/footer.jsp" %>
