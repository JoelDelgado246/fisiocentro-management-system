<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../components/layout/header.jsp" %>

<div>
  <%@ include file="../components/layout/sidebar.jsp" %>

  <main class="main-content">
    <!-- Page Header -->
    <div class="page-header">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h1 class="page-title">Detalle del Usuario</h1>
          <p class="page-subtitle">Información completa del usuario del sistema</p>
        </div>
        <div class="d-flex gap-2">
          <button class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/UsuarioServlet'">
            <i class="fas fa-arrow-left me-2"></i>
            Volver
          </button>
          <button class="btn btn-warning" onclick="editarUsuario()">
            <i class="fas fa-edit me-2"></i>
            Editar
          </button>
        </div>
      </div>
    </div>

    <c:choose>
      <c:when test="${not empty usuario}">
        <div class="row g-4">
          <!-- Información Principal -->
          <div class="col-md-4">
            <div class="card">
              <div class="card-body text-center">
                <div style="width: 120px; height: 120px; margin: 0 auto 1.5rem;
                                     background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                                     border-radius: 50%; display: flex; align-items: center; justify-content: center;
                                     color: white; font-size: 3rem; box-shadow: var(--shadow-lg);">
                  <i class="fas fa-user-circle"></i>
                </div>

                <h3 class="mb-1"><c:out value="${usuario.nombreUsuario}"/></h3>

                <c:choose>
                  <c:when test="${usuario.rol == 'Administrador'}">
                                        <span class="badge badge-danger mb-3" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                            <i class="fas fa-user-shield me-1"></i>
                                            ${usuario.rol}
                                        </span>
                  </c:when>
                  <c:when test="${usuario.rol == 'Recepcionista'}">
                                        <span class="badge badge-primary mb-3" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                            <i class="fas fa-user-tie me-1"></i>
                                            ${usuario.rol}
                                        </span>
                  </c:when>
                  <c:when test="${usuario.rol == 'Fisioterapeuta'}">
                                        <span class="badge badge-success mb-3" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                            <i class="fas fa-user-md me-1"></i>
                                            ${usuario.rol}
                                        </span>
                  </c:when>
                  <c:otherwise>
                                        <span class="badge badge-secondary mb-3" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                            <i class="fas fa-user me-1"></i>
                                            ${usuario.rol}
                                        </span>
                  </c:otherwise>
                </c:choose>

                <div class="mb-3">
                                    <span class="badge badge-success">
                                        <i class="fas fa-check-circle"></i> Activo
                                    </span>
                </div>

                <div class="d-grid gap-2">
                  <button class="btn btn-secondary" onclick="cambiarContrasenia()">
                    <i class="fas fa-key me-2"></i>
                    Cambiar Contraseña
                  </button>
                </div>
              </div>
            </div>

            <!-- Estadísticas -->
            <div class="card mt-4">
              <div class="card-header">
                <i class="fas fa-chart-bar me-2"></i>Estadísticas
              </div>
              <div class="card-body">
                <div class="mb-3">
                  <small class="text-muted">Sesiones Totales</small>
                  <h4 class="mb-0">
                    <c:out value="${estadisticas.totalSesiones}" default="0"/>
                  </h4>
                </div>
                <div class="mb-3">
                  <small class="text-muted">Última Sesión</small>
                  <h6 class="mb-0">
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/>
                  </h6>
                </div>
                <div>
                  <small class="text-muted">Fecha de Registro</small>
                  <h6 class="mb-0">
                    <fmt:formatDate value="${now}" pattern="dd/MM/yyyy"/>
                  </h6>
                </div>
              </div>
            </div>
          </div>

          <!-- Detalles e Información -->
          <div class="col-md-8">
            <!-- Información del Usuario -->
            <div class="card mb-4">
              <div class="card-header">
                <i class="fas fa-info-circle me-2"></i>Información del Usuario
              </div>
              <div class="card-body">
                <div class="row g-3">
                  <div class="col-md-6">
                    <div class="info-group">
                      <label class="info-label">
                        <i class="fas fa-id-badge text-primary me-2"></i>
                        ID de Usuario
                      </label>
                      <p class="info-value">#${usuario.idUsuario}</p>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="info-group">
                      <label class="info-label">
                        <i class="fas fa-user text-primary me-2"></i>
                        Nombre de Usuario
                      </label>
                      <p class="info-value"><c:out value="${usuario.nombreUsuario}"/></p>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="info-group">
                      <label class="info-label">
                        <i class="fas fa-user-tag text-primary me-2"></i>
                        Rol del Sistema
                      </label>
                      <p class="info-value"><c:out value="${usuario.rol}"/></p>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="info-group">
                      <label class="info-label">
                        <i class="fas fa-circle text-success me-2"></i>
                        Estado
                      </label>
                      <p class="info-value">Activo</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Permisos y Accesos -->
            <div class="card mb-4">
              <div class="card-header">
                <i class="fas fa-shield-alt me-2"></i>Permisos y Accesos
              </div>
              <div class="card-body">
                <c:choose>
                  <c:when test="${usuario.rol == 'Administrador'}">
                    <div class="alert alert-danger">
                      <i class="fas fa-crown me-2"></i>
                      <strong>Acceso Total</strong>
                      <ul class="mb-0 mt-2">
                        <li>Gestión completa de usuarios</li>
                        <li>Configuración del sistema</li>
                        <li>Acceso a todos los módulos</li>
                        <li>Visualización de reportes</li>
                        <li>Gestión de datos sensibles</li>
                      </ul>
                    </div>
                  </c:when>
                  <c:when test="${usuario.rol == 'Recepcionista'}">
                    <div class="alert alert-primary">
                      <i class="fas fa-clipboard-list me-2"></i>
                      <strong>Acceso de Recepción</strong>
                      <ul class="mb-0 mt-2">
                        <li>Gestión de pacientes</li>
                        <li>Agendamiento de turnos</li>
                        <li>Gestión de responsables</li>
                        <li>Consulta de información</li>
                        <li>Sin acceso a configuración</li>
                      </ul>
                    </div>
                  </c:when>
                  <c:when test="${usuario.rol == 'Fisioterapeuta'}">
                    <div class="alert alert-success">
                      <i class="fas fa-user-md me-2"></i>
                      <strong>Acceso Profesional</strong>
                      <ul class="mb-0 mt-2">
                        <li>Visualización de sus turnos</li>
                        <li>Registro de observaciones</li>
                        <li>Actualización de estados de sesiones</li>
                        <li>Consulta de pacientes asignados</li>
                        <li>Sin acceso administrativo</li>
                      </ul>
                    </div>
                  </c:when>
                </c:choose>
              </div>
            </div>

            <!-- Historial de Actividad (Simulado) -->
            <div class="card">
              <div class="card-header">
                <i class="fas fa-history me-2"></i>Actividad Reciente
              </div>
              <div class="card-body">
                <div class="timeline">
                  <div class="timeline-item">
                    <div class="timeline-marker bg-success"></div>
                    <div class="timeline-content">
                      <div class="d-flex justify-content-between">
                        <strong>Inicio de sesión exitoso</strong>
                        <small class="text-muted">Hace 5 minutos</small>
                      </div>
                      <p class="mb-0 text-muted">
                        <i class="fas fa-map-marker-alt me-1"></i>
                        Desde: 192.168.1.100
                      </p>
                    </div>
                  </div>
                  <div class="timeline-item">
                    <div class="timeline-marker bg-primary"></div>
                    <div class="timeline-content">
                      <div class="d-flex justify-content-between">
                        <strong>Creación de turno</strong>
                        <small class="text-muted">Hace 2 horas</small>
                      </div>
                      <p class="mb-0 text-muted">Agendó turno para Juan Pérez</p>
                    </div>
                  </div>
                  <div class="timeline-item">
                    <div class="timeline-marker bg-info"></div>
                    <div class="timeline-content">
                      <div class="d-flex justify-content-between">
                        <strong>Actualización de paciente</strong>
                        <small class="text-muted">Hace 1 día</small>
                      </div>
                      <p class="mb-0 text-muted">Modificó información de María González</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card">
          <div class="card-body text-center py-5">
            <i class="fas fa-user-slash" style="font-size: 4rem; color: var(--text-secondary);"></i>
            <h4 class="mt-3">Usuario no encontrado</h4>
            <p class="text-muted">El usuario solicitado no existe o fue eliminado</p>
            <button class="btn btn-primary mt-3" onclick="window.location.href='${pageContext.request.contextPath}/UsuarioServlet'">
              <i class="fas fa-arrow-left me-2"></i>
              Volver al Listado
            </button>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </main>
</div>

<script>
  function editarUsuario() {
    window.location.href='${pageContext.request.contextPath}/UsuarioServlet?action=abrirEditar&id=${usuario.idUsuario}';
  }

  function cambiarContrasenia() {
    // Redireccionar a la pantalla de cambio de contraseña
    window.location.href='${pageContext.request.contextPath}/UsuarioServlet?action=abrirCambiarPass&id=${usuario.idUsuario}';
  }
</script>

<style>
  .info-group {
    padding: 0.75rem;
    background: var(--light-bg);
    border-radius: 0.5rem;
  }

  .info-label {
    display: block;
    font-size: 0.85rem;
    font-weight: 500;
    color: var(--text-secondary);
    margin-bottom: 0.25rem;
  }

  .info-value {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
  }

  .timeline {
    position: relative;
    padding-left: 2rem;
  }

  .timeline-item {
    position: relative;
    padding-bottom: 1.5rem;
  }

  .timeline-item:last-child {
    padding-bottom: 0;
  }

  .timeline-marker {
    position: absolute;
    left: -2rem;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    border: 3px solid white;
    box-shadow: 0 0 0 2px var(--border-color);
  }

  .timeline-item:not(:last-child)::before {
    content: '';
    position: absolute;
    left: -1.69rem;
    top: 12px;
    width: 2px;
    height: calc(100% - 12px);
    background: var(--border-color);
  }

  .timeline-content {
    padding-left: 0.5rem;
  }
</style>

<%@ include file="../components/layout/footer.jsp" %>
