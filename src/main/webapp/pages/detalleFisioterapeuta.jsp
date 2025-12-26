<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<style>
    .detail-header {
        background: linear-gradient(135deg, #10b981, #495057);
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
        color: #10b981;
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
        color: #10b981;
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
            <a href="${pageContext.request.contextPath}/FisioterapeutaServlet" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Volver al Listado
            </a>
        </div>

        <!-- Header -->
        <div class="detail-header text-center">
            <div class="avatar-large">
                <i class="fas fa-user-md"></i>
            </div>
            <h2 class="mb-2">
                Dr(a). <c:out value="${fisioterapeuta.nombre}"/> <c:out value="${fisioterapeuta.apellido}"/>
            </h2>
            <p class="mb-3">
                <i class="fas fa-certificate me-2"></i>
                <c:out value="${fisioterapeuta.especialidad}"/>
            </p>
            <div class="d-flex gap-2 justify-content-center">
                <c:choose>
                    <c:when test="${not empty fisioterapeuta.usuario}">
                        <span class="badge badge-success" style="font-size: 1rem; padding: 0.5rem 1rem;">
                            <i class="fas fa-user-check me-1"></i>Usuario Asignado
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
                            <div class="info-value"><c:out value="${fisioterapeuta.cedula}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Correo Electrónico</div>
                            <div class="info-value"><c:out value="${fisioterapeuta.correo}"/></div>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Teléfono</div>
                            <div class="info-value"><c:out value="${fisioterapeuta.telefono}"/></div>
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
                                    <c:when test="${not empty fisioterapeuta.dirección}">
                                        <c:out value="${fisioterapeuta.dirección}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">No especificada</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty fisioterapeuta.fechaNacimiento}">
                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Fecha de Nacimiento</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${fisioterapeuta.fechaNacimiento}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Información Profesional -->
                <div class="info-card">
                    <h5 class="section-title">
                        <i class="fas fa-certificate"></i>
                        Información Profesional
                    </h5>

                    <div class="info-row">
                        <div class="info-icon">
                            <i class="fas fa-stethoscope"></i>
                        </div>
                        <div class="info-content">
                            <div class="info-label">Especialidad</div>
                            <div class="info-value">
                                <span class="badge badge-info" style="font-size: 1rem;">
                                    <c:out value="${fisioterapeuta.especialidad}"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty fisioterapeuta.horario}">
                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Horario Asignado</div>
                                <div class="info-value">
                                    <c:out value="${fisioterapeuta.horario.diaDeSemana}"/>:
                                    <c:out value="${fisioterapeuta.horario.horaInicio}"/> -
                                    <c:out value="${fisioterapeuta.horario.horaFin}" />
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Usuario del Sistema -->
                <c:if test="${not empty fisioterapeuta.usuario}">
                    <div class="info-card">
                        <h5 class="section-title">
                            <i class="fas fa-user-lock"></i>
                            Usuario del Sistema
                        </h5>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Nombre de Usuario</div>
                                <div class="info-value">
                                    <c:out value="${fisioterapeuta.usuario.nombreUsuario}"/>
                                </div>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Rol en el Sistema</div>
                                <div class="info-value">
                                    <span class="badge badge-primary">
                                        <c:out value="${fisioterapeuta.usuario.rol}"/>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="info-row">
                            <div class="info-icon">
                                <i class="fas fa-toggle-on"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Estado de la Cuenta</div>
                                <div class="info-value">
                                    <span class="badge badge-success">Activa</span>
                                </div>
                            </div>
                        </div>

                        <div class="mt-3 text-center">
                            <a href="${pageContext.request.contextPath}/UsuarioServlet?action=ver&id=${fisioterapeuta.usuario.idUsuario}"
                               class="btn btn-outline-primary">
                                <i class="fas fa-external-link-alt me-2"></i>Ver Detalles del Usuario
                            </a>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty fisioterapeuta.usuario}">
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Este fisioterapeuta no tiene usuario asignado.</strong>
                        No podrá acceder al sistema hasta que se le asigne una cuenta de usuario.
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
                        <button class="btn btn-warning" onclick="editarFisioterapeuta()">
                            <i class="fas fa-edit me-2"></i>Editar Información
                        </button>

                        <a href="${pageContext.request.contextPath}/HorarioServlet?fisioterapeutaId=${fisioterapeuta.id}"
                           class="btn btn-info">
                            <i class="fas fa-clock me-2"></i>Gestionar Horarios
                        </a>

                        <a href="${pageContext.request.contextPath}/TurnoServlet?fisioterapeutaId=${fisioterapeuta.id}"
                           class="btn btn-primary">
                            <i class="fas fa-calendar-alt me-2"></i>Ver Turnos
                        </a>

                        <c:if test="${not empty fisioterapeuta.usuario}">
                            <a href="${pageContext.request.contextPath}/UsuarioServlet?action=cambiarPassword&id=${fisioterapeuta.usuario.idUsuario}"
                               class="btn btn-secondary">
                                <i class="fas fa-key me-2"></i>Cambiar Contraseña
                            </a>
                        </c:if>

                        <button class="btn btn-danger" onclick="confirmarEliminacion()">
                            <i class="fas fa-trash me-2"></i>Eliminar Fisioterapeuta
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
                                <div class="stat-box-label">Última Atención</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Form Oculto -->
<form id="formEliminarFisioterapeuta"
      action="${pageContext.request.contextPath}/FisioterapeutaServlet"
      method="post" style="display: none;">
    <input type="hidden" name="action" value="eliminar">
    <input type="hidden" name="idFisioterapeuta" value="${fisioterapeuta.id}">
</form>

<script>
    function editarFisioterapeuta() {
        window.location.href = '${pageContext.request.contextPath}/FisioterapeutaServlet?action=listar';
        setTimeout(function() {
            if (typeof abrirModalEditar === 'function') {
                abrirModalEditar(${fisioterapeuta.id});
            }
        }, 500);
    }

    function confirmarEliminacion() {
        if (confirm('¿Está seguro de eliminar este fisioterapeuta?\n\nEsto eliminará todos sus turnos y horarios asociados.')) {
            if (confirm('¿Confirmar eliminación? Esta acción no se puede deshacer.')) {
                document.getElementById('formEliminarFisioterapeuta').submit();
            }
        }
    }
</script>

<%@ include file="../components/layout/footer.jsp" %>
