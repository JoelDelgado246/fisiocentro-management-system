<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/components/layout/header.jsp" %>

<div class="d-flex">
    <%@ include file="/components/layout/sidebar.jsp" %>

    <main class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">
                    <i class="fas fa-home me-2"></i>
                    Dashboard
                </h1>
                <p class="page-subtitle">Bienvenido al Sistema de Gestión FisioCenter</p>
            </div>
        </div>

        <!-- Tarjeta de Bienvenida -->
        <div class="card mb-4" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
            <div class="card-body" style="padding: 2rem;">
                <div class="d-flex align-items-center gap-3">
                    <div style="font-size: 4rem;">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <div>
                        <h2 style="margin: 0; font-size: 2rem;">¡Bienvenido, <c:out value="${sessionScope.nombreUsuario}"/>!</h2>
                        <p style="margin: 0.5rem 0 0 0; font-size: 1.1rem; opacity: 0.9;">
                            Rol: <strong><c:out value="${sessionScope.rol}"/></strong>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas Rápidas -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty totalPacientes}">
                                    <c:out value="${totalPacientes}"/>
                                </c:when>
                                <c:otherwise>--</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Total Pacientes</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty totalFisioterapeutas}">
                                    <c:out value="${totalFisioterapeutas}"/>
                                </c:when>
                                <c:otherwise>--</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Fisioterapeutas</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty turnosHoy}">
                                    <c:out value="${turnosHoy}"/>
                                </c:when>
                                <c:otherwise>--</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Turnos Hoy</div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${not empty turnosPendientes}">
                                    <c:out value="${turnosPendientes}"/>
                                </c:when>
                                <c:otherwise>--</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Turnos Pendientes</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Accesos Rápidos -->
        <div class="row g-4 mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title">
                            <i class="fas fa-bolt me-2"></i>
                            Accesos Rápidos
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <!-- Mostrar opciones según el rol -->
                            <c:choose>
                                <c:when test="${sessionScope.rol == 'Administrador'}">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/UsuarioServlet" class="quick-access-card">
                                            <i class="fas fa-users-cog"></i>
                                            <div>
                                                <h6>Gestión de Usuarios</h6>
                                                <p>Administrar usuarios del sistema</p>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/FisioterapeutaServlet" class="quick-access-card">
                                            <i class="fas fa-user-md"></i>
                                            <div>
                                                <h6>Fisioterapeutas</h6>
                                                <p>Gestionar fisioterapeutas</p>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/HorarioServlet" class="quick-access-card">
                                            <i class="fas fa-calendar-alt"></i>
                                            <div>
                                                <h6>Horarios</h6>
                                                <p>Configurar horarios de trabajo</p>
                                            </div>
                                        </a>
                                    </div>
                                </c:when>
                            </c:choose>

                            <!-- Accesos comunes para todos los roles -->
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/PacienteServlet" class="quick-access-card">
                                    <i class="fas fa-user-injured"></i>
                                    <div>
                                        <h6>Pacientes</h6>
                                        <p>Gestionar pacientes</p>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/TurnoServlet" class="quick-access-card">
                                    <i class="fas fa-calendar-check"></i>
                                    <div>
                                        <h6>Turnos</h6>
                                        <p>Gestionar citas y turnos</p>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/RecepcionistaServlet" class="quick-access-card">
                                    <i class="fas fa-user-tie"></i>
                                    <div>
                                        <h6>Recepcionistas</h6>
                                        <p>Gestionar recepcionistas</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Información del Sistema -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title">
                            <i class="fas fa-info-circle me-2"></i>
                            Información del Sistema
                        </h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tbody>
                            <tr>
                                <td><strong>Sistema:</strong></td>
                                <td>FisioCenter v1.0</td>
                            </tr>
                            <tr>
                                <td><strong>Usuario:</strong></td>
                                <td><c:out value="${sessionScope.nombreUsuario}"/></td>
                            </tr>
                            <tr>
                                <td><strong>Rol:</strong></td>
                                <td>
                                        <span class="badge badge-primary">
                                            <c:out value="${sessionScope.rol}"/>
                                        </span>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Última conexión:</strong></td>
                                <td>Ahora</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title">
                            <i class="fas fa-lightbulb me-2"></i>
                            Atajos de Teclado
                        </h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless">
                            <tbody>
                            <tr>
                                <td><kbd>Ctrl</kbd> + <kbd>N</kbd></td>
                                <td>Nuevo registro</td>
                            </tr>
                            <tr>
                                <td><kbd>Ctrl</kbd> + <kbd>S</kbd></td>
                                <td>Guardar</td>
                            </tr>
                            <tr>
                                <td><kbd>Esc</kbd></td>
                                <td>Cerrar modal</td>
                            </tr>
                            <tr>
                                <td><kbd>Ctrl</kbd> + <kbd>F</kbd></td>
                                <td>Buscar</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<style>
    .quick-access-card {
        display: flex;
        align-items: center;
        gap: 1rem;
        padding: 1.5rem;
        background: var(--white);
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        text-decoration: none;
        color: var(--text-primary);
        transition: all 0.3s;
    }

    .quick-access-card:hover {
        border-color: var(--primary-color);
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    }

    .quick-access-card i {
        font-size: 2.5rem;
        color: var(--primary-color);
    }

    .quick-access-card h6 {
        margin: 0 0 0.25rem 0;
        font-size: 1.1rem;
        font-weight: 600;
    }

    .quick-access-card p {
        margin: 0;
        font-size: 0.875rem;
        color: var(--text-secondary);
    }

    kbd {
        background-color: #f3f4f6;
        border: 1px solid #d1d5db;
        border-radius: 4px;
        padding: 2px 6px;
        font-family: monospace;
        font-size: 0.875rem;
    }
</style>

<%@ include file="/components/layout/footer.jsp" %>
