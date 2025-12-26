<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<style>
    .detail-header {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        padding: 2rem;
        border-radius: 1rem;
        margin-bottom: 2rem;
    }

    .avatar-large {
        width: 120px;
        height: 120px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 3rem;
        margin: 0 auto 1rem;
        border: 4px solid rgba(255, 255, 255, 0.3);
        font-weight: bold;
    }

    .info-card {
        background: white;
        border-radius: 0.75rem;
        padding: 1.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
    }

    .info-row {
        display: flex;
        align-items: center;
        padding: 1rem;
        border-bottom: 1px solid var(--border-color);
    }

    .info-row:last-child {
        border-bottom: none;
    }

    .info-icon {
        width: 40px;
        height: 40px;
        background: var(--light-bg);
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--primary-color);
        margin-right: 1rem;
        flex-shrink: 0;
    }

    .info-content {
        flex: 1;
    }

    .info-label {
        font-size: 0.875rem;
        color: var(--text-secondary);
        margin-bottom: 0.25rem;
    }

    .info-value {
        font-size: 1rem;
        font-weight: 600;
        color: var(--text-primary);
    }

    .section-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-primary);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .stat-box {
        text-align: center;
        padding: 1.5rem;
        background: var(--light-bg);
        border-radius: 0.75rem;
    }

    .stat-box-value {
        font-size: 2rem;
        font-weight: 700;
        color: var(--primary-color);
    }

    .stat-box-label {
        font-size: 0.875rem;
        color: var(--text-secondary);
        margin-top: 0.5rem;
    }

    .turno-item {
        padding: 1rem;
        border-left: 3px solid var(--primary-color);
        background: var(--light-bg);
        border-radius: 0.5rem;
        margin-bottom: 0.75rem;
    }
</style>

<div>
    <%@ include file="../components/layout/sidebar.jsp" %>

    <main class="main-content">
        <!-- Botón Volver -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/PacienteServlet" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Volver al Listado
            </a>
        </div>

        <!-- Header -->
        <div class="detail-header text-center">
            <div class="avatar-large">
                ${fn:substring(paciente.nombre, 0, 1)}${fn:substring(paciente.apellido, 0, 1)}
            </div>
            <h2 class="mb-2">
                <c:out value="${paciente.nombre}"/> <c:out value="${paciente.apellido}"/>
            </h2>
            <p class="mb-3">
                <i class="fas fa-notes-medical me-2"></i>
                <c:out value="${paciente.tipoTratamiento}"/>
            </p>
            <div class="d-flex gap-2 justify-content-center">
                <c:choose>
                    <c:when test="${paciente.poseeSeguro}">
                        <span class="badge badge-success" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            <i class="fas fa-shield-alt me-1"></i>Con Seguro
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-secondary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            <i class="fas fa-shield-alt me-1"></i>Sin Seguro
                        </span>
                    </c:otherwise>
                </c:choose>
                <span class="badge badge-success" style="font-size: 1rem; padding: 0.5rem 1rem;">
                    <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i>Activo
                </span>
            </div>
        </div>

        <div class="row g-4">
            <!-- Columna Izquierda -->
            <div class="col-lg-8">
                <!-- Información Personal -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-user"></i>
                        Información Personal
                    </h5>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-id-card"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Cédula de Identidad</div>
                            <div class="info-value"><c:out value="${paciente.cedula}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Correo Electrónico</div>
                            <div class="info-value"><c:out value="${paciente.correo}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Teléfono</div>
                            <div class="info-value"><c:out value="${paciente.telefono}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Dirección</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty paciente.dirección}">
                                        <c:out value="${paciente.dirección}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">No especificada</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty paciente.fechaNacimiento}">
                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Fecha de Nacimiento</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${paciente.fechaNacimiento}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Información Médica -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-notes-medical"></i>
                        Información Médica
                    </h5>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-procedures"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Tipo de Tratamiento</div>
                            <div class="info-value">
                                <span class="badge badge-info" style="font-size: 1rem;">
                                    <c:out value="${paciente.tipoTratamiento}"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Seguro Médico</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${paciente.poseeSeguro}">
                                        <span class="badge badge-success">
                                            <i class="fas fa-check-circle me-1"></i>Sí posee
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">
                                            <i class="fas fa-times-circle me-1"></i>No posee
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Motivo de Consulta</div>
                            <div class="info-value"><c:out value="${paciente.motivoConsulta}"/></div>
                        </div>
                    </div>
                </div>

                <!-- Responsable -->
                <c:if test="${not empty paciente.responsable}">
                    <div class="info-card">
                        <h5 class="section-title">
                            <i class="fas fa-user-friends"></i>
                            Responsable del Paciente
                        </h5>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Nombre Completo</div>
                                <div class="info-value">
                                    <c:out value="${paciente.responsable.nombre}"/>
                                    <c:out value="${paciente.responsable.apellido}"/>
                                </div>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-link"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Relación con el Paciente</div>
                                <div class="info-value">
                                    <span class="badge badge-primary">
                                        <c:out value="${paciente.responsable.relacionPaciente}"/>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Cédula</div>
                                <div class="info-value"><c:out value="${paciente.responsable.cedula}"/></div>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Teléfono</div>
                                <div class="info-value"><c:out value="${paciente.responsable.telefono}"/></div>
                            </div>
                        </div>

                        <c:if test="${not empty paciente.responsable.correo}">
                            <div class="info-row">
                                <div class="info-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Email</div>
                                    <div class="info-value"><c:out value="${paciente.responsable.correo}"/></div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <!-- Columna Derecha -->
            <div class="col-lg-4">
                <!-- Acciones -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-cog"></i>
                        Acciones
                    </h5>

                    <div class="d-grid gap-2">
                        <button class="btn btn-warning" onclick="editarPaciente()">
                            <i class="fas fa-edit me-2"></i>Editar Información
                        </button>

                        <a href="${pageContext.request.contextPath}/TurnoServlet?pacienteId=${paciente.id}"
                           class="btn btn-primary">
                            <i class="fas fa-calendar-plus me-2"></i>Nuevo Turno
                        </a>

                        <a href="${pageContext.request.contextPath}/PacienteServlet?action=historial&id=${paciente.id}"
                           class="btn btn-info">
                            <i class="fas fa-history me-2"></i>Ver Historial
                        </a>

                        <button class="btn btn-danger" onclick="confirmarEliminacion()">
                            <i class="fas fa-trash me-2"></i>Eliminar Paciente
                        </button>
                    </div>
                </div>

                <!-- Estadísticas -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-chart-bar"></i>
                        Estadísticas
                    </h5>

                    <div class="row g-3">
                        <div class="col-6">
                            <div class="stat-box">
                                <div class="stat-box-value">${totalTurnos != null ? totalTurnos : 0}</div>
                                <div class="stat-box-label">Turnos Total</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-box">
                                <div class="stat-box-value">${turnosCompletados != null ? turnosCompletados : 0}</div>
                                <div class="stat-box-label">Completados</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="stat-box">
                                <div class="stat-box-value">
                                    <c:choose>
                                        <c:when test="${not empty ultimoTurno}">
                                            <fmt:formatDate value="${ultimoTurno}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-box-label">Última Visita</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Próximos Turnos -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-calendar-alt"></i>
                        Próximos Turnos
                    </h5>

                    <c:choose>
                        <c:when test="${not empty proximosTurnos}">
                            <c:forEach var="turno" items="${proximosTurnos}">
                                <div class="turno-item">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <strong>
                                            <fmt:formatDate value="${turno.fechaTurno}" pattern="dd/MM/yyyy"/>
                                        </strong>
                                        <span class="badge badge-primary">
                                            <fmt:formatDate value="${turno.horaTurno}" pattern="HH:mm"/>
                                        </span>
                                    </div>
                                    <div class="text-muted small">
                                        <i class="fas fa-user-md me-1"></i>
                                        <c:out value="${turno.fisio.nombre}"/>
                                        <c:out value="${turno.fisio.apellido}"/>
                                    </div>
                                    <c:if test="${not empty turno.observacion}">
                                        <div class="text-muted small mt-1">
                                            <i class="fas fa-comment me-1"></i>
                                            <c:out value="${turno.observacion}"/>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                No hay turnos programados
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Form Oculto -->
<form id="formEliminarPaciente"
      action="${pageContext.request.contextPath}/PacienteServlet"
      method="post" style="display: none;">
    <input type="hidden" name="action" value="eliminar">
    <input type="hidden" name="idPaciente" value="${paciente.id}">
</form>

<script>
    function editarPaciente() {
        window.location.href = '${pageContext.request.contextPath}/PacienteServlet?action=abrirEditar&id=${paciente.id}';
    }

    function confirmarEliminacion() {
        if (confirm('¿Está seguro de eliminar este paciente?\n\nEsto eliminará todos sus turnos y datos asociados.')) {
            if (confirm('¿Confirmar eliminación? Esta acción no se puede deshacer.')) {
                document.getElementById('formEliminarPaciente').submit();
            }
        }
    }
</script>

<%@ include file="../components/layout/footer.jsp" %>
