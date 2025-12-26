<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<style>
    .detail-header {
        background: linear-gradient(135deg, #2563eb, #1e40af);
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

    .activity-item {
        display: flex;
        align-items: start;
        gap: 1rem;
        padding: 1rem;
        border-left: 3px solid var(--border-color);
        margin-left: 1rem;
        position: relative;
    }

    .activity-item::before {
        content: '';
        position: absolute;
        left: -9px;
        top: 1.5rem;
        width: 12px;
        height: 12px;
        background: var(--primary-color);
        border-radius: 50%;
        border: 3px solid white;
    }

    .activity-time {
        font-size: 0.875rem;
        color: var(--text-secondary);
        white-space: nowrap;
    }

    .activity-description {
        flex: 1;
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
</style>

<div>
    <%@ include file="../components/layout/sidebar.jsp" %>

    <main class="main-content">
        <!-- Botón Volver -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/RecepcionistaServlet" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Volver al Listado
            </a>
        </div>

        <!-- Header con Avatar -->
        <div class="detail-header text-center">
            <div class="avatar-large">
                <i class="fas fa-user-tie"></i>
            </div>
            <h2 class="mb-2">
                <c:out value="${recepcionista.nombre}"/> <c:out value="${recepcionista.apellido}"/>
            </h2>
            <p class="mb-3">
                <i class="fas fa-building me-2"></i>
                <c:out value="${recepcionista.seccionAsignada}"/>
            </p>
            <div class="d-flex gap-2 justify-content-center">
                <c:choose>
                    <c:when test="${not empty recepcionista.usuario}">
                        <span class="badge badge-success" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            <i class="fas fa-check-circle me-1"></i>Usuario Asignado
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-warning" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            <i class="fas fa-exclamation-triangle me-1"></i>Sin Usuario
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
                            <div class="info-value"><c:out value="${recepcionista.cedula}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Correo Electrónico</div>
                            <div class="info-value"><c:out value="${recepcionista.correo}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Teléfono</div>
                            <div class="info-value"><c:out value="${recepcionista.telefono}"/></div>
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
                                    <c:when test="${not empty recepcionista.dirección}">
                                        <c:out value="${recepcionista.dirección}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">No especificada</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty recepcionista.fechaNacimiento}">
                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Fecha de Nacimiento</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${recepcionista.fechaNacimiento}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Información Laboral -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-briefcase"></i>
                        Información Laboral
                    </h5>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Sección Asignada</div>
                            <div class="info-value">
                                <span class="badge badge-primary" style="font-size: 1rem;">
                                    <c:out value="${recepcionista.seccionAsignada}"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Estado</div>
                            <div class="info-value">
                                <span class="badge badge-success">
                                    <i class="fas fa-check-circle me-1"></i>Activo
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Horario</div>
                            <div class="info-value">Lunes a Viernes, 08:00 - 17:00</div>
                        </div>
                    </div>
                </div>

                <!-- Cuenta de Usuario -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-user-lock"></i>
                        Cuenta de Usuario
                    </h5>

                    <c:choose>
                        <c:when test="${not empty recepcionista.usuario}">
                            <div class="info-row">
                                <div class="info-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Nombre de Usuario</div>
                                    <div class="info-value">
                                        <c:out value="${recepcionista.usuario.nombreUsuario}"/>
                                    </div>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Rol del Sistema</div>
                                    <div class="info-value">
                                        <span class="badge badge-primary">
                                            <i class="fas fa-user-tie me-1"></i>
                                            <c:out value="${recepcionista.usuario.rol}"/>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Estado de la Cuenta</div>
                                    <div class="info-value">
                                        <span class="badge badge-success">Activa</span>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/UsuarioServlet?action=ver&id=${recepcionista.usuario.idUsuario}"
                                   class="btn btn-secondary">
                                    <i class="fas fa-eye me-2"></i>Ver Detalles del Usuario
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Este recepcionista no tiene un usuario asignado.</strong>
                                <br>
                                Para que pueda acceder al sistema, debe asignarle un usuario con rol "Recepcionista".
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Columna Derecha -->
            <div class="col-lg-4">
                <!-- Acciones Rápidas -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-cog"></i>
                        Acciones
                    </h5>

                    <div class="d-grid gap-2">
                        <button class="btn btn-warning" onclick="editarRecepcionista()">
                            <i class="fas fa-edit me-2"></i>Editar Información
                        </button>

                        <a href="${pageContext.request.contextPath}/RecepcionistaServlet?action=horarios&id=${recepcionista.id}"
                           class="btn btn-info">
                            <i class="fas fa-clock me-2"></i>Gestionar Horarios
                        </a>

                        <c:if test="${not empty recepcionista.usuario}">
                            <a href="${pageContext.request.contextPath}/UsuarioServlet?action=abrirCambiarPass&id=${recepcionista.usuario.idUsuario}"
                               class="btn btn-secondary">
                                <i class="fas fa-key me-2"></i>Cambiar Contraseña
                            </a>
                        </c:if>

                        <button class="btn btn-danger" onclick="confirmarEliminacion()">
                            <i class="fas fa-trash me-2"></i>Eliminar Recepcionista
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
                                <div class="stat-box-value">245</div>
                                <div class="stat-box-label">Turnos Gestionados</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-box">
                                <div class="stat-box-value">12</div>
                                <div class="stat-box-label">Meses Activo</div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="stat-box">
                                <div class="stat-box-value">98%</div>
                                <div class="stat-box-label">Satisfacción</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Permisos y Accesos -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-lock"></i>
                        Permisos de Acceso
                    </h5>

                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-check text-success me-2"></i>Gestión de Turnos</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-check text-success me-2"></i>Registro de Pacientes</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-check text-success me-2"></i>Ver Agenda</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-times text-danger me-2"></i>Gestión de Usuarios</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-times text-danger me-2"></i>Configuración del Sistema</span>
                        </div>
                    </div>
                </div>

                <!-- Actividad Reciente -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-history"></i>
                        Actividad Reciente
                    </h5>

                    <div class="activity-item">
                        <div class="activity-time">Hoy 09:45</div>
                        <div class="activity-description">
                            <strong>Inicio de sesión</strong>
                            <p class="text-muted mb-0 small">Accedió al sistema</p>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-time">Hoy 10:20</div>
                        <div class="activity-description">
                            <strong>Turno creado</strong>
                            <p class="text-muted mb-0 small">Registró cita para Juan Pérez</p>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-time">Hoy 11:15</div>
                        <div class="activity-description">
                            <strong>Paciente actualizado</strong>
                            <p class="text-muted mb-0 small">Modificó datos de contacto</p>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-time">Ayer 16:30</div>
                        <div class="activity-description">
                            <strong>Confirmación de turnos</strong>
                            <p class="text-muted mb-0 small">Confirmó 8 citas para hoy</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Form Oculto para Eliminar -->
<form id="formEliminarRecepcionista"
      action="${pageContext.request.contextPath}/RecepcionistaServlet"
      method="post" style="display: none;">
    <input type="hidden" name="action" value="eliminar">
    <input type="hidden" name="idRecepcionista" value="${recepcionista.id}">
</form>

<script>
    function editarRecepcionista() {
        window.location.href = '${pageContext.request.contextPath}/RecepcionistaServlet?action=abrirEditar&id=${recepcionista.id}';
    }

    function confirmarEliminacion() {
        if (confirm('¿Está seguro de que desea eliminar este recepcionista?\n\nEsta acción no se puede deshacer.')) {
            if (confirm('¿Confirmar eliminación? Esta es su última oportunidad para cancelar.')) {
                document.getElementById('formEliminarRecepcionista').submit();
            }
        }
    }
</script>

<%@ include file="../components/layout/footer.jsp" %>
