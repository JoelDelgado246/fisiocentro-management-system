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
          <h1 class="page-title">Gestión de Recepcionistas</h1>
          <p class="page-subtitle">Administra el personal de recepción del centro</p>
        </div>
        <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoRecepcionista')">
          <i class="fas fa-user-plus"></i>
          Nuevo Recepcionista
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
      <div class="col-md-4">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #2563eb, #1e40af);">
              <i class="fas fa-user-tie"></i>
            </div>
            <div class="stat-value"><c:out value="${totalRecepcionistas}" default="0"/></div>
            <div class="stat-label">Total Recepcionistas</div>
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
              <i class="fas fa-user-check"></i>
            </div>
            <div class="stat-value"><c:out value="${recepcionistasActivos}" default="0"/></div>
            <div class="stat-label">Recepcionistas Activos</div>
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
              <i class="fas fa-building"></i>
            </div>
            <div class="stat-value"><c:out value="${secciones}" default="0"/></div>
            <div class="stat-label">Secciones</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Cards -->
    <c:if test="${not empty recepcionistas}">
      <div class="row g-4 mb-4">
        <c:forEach var="recep" items="${recepcionistas}" begin="0" end="5">
          <div class="col-md-6 col-lg-4">
            <div class="card">
              <div class="card-body text-center">
                <div style="width: 80px; height: 80px; margin: 0 auto 1rem;
                                     background: linear-gradient(135deg, #2563eb, #1e40af);
                                     border-radius: 50%; display: flex; align-items: center; justify-content: center;
                                     color: white; font-size: 2rem;">
                  <i class="fas fa-user-tie"></i>
                </div>
                <h5 class="fw-bold mb-1">
                  <c:out value="${recep.nombre}"/> <c:out value="${recep.apellido}"/>
                </h5>
                <p class="text-muted mb-2">
                  <i class="fas fa-building me-1"></i>
                  <c:out value="${recep.seccionAsignada}"/>
                </p>
                <div class="mb-3">
                  <c:choose>
                    <c:when test="${not empty recep.usuario}">
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
                  <c:out value="${recep.cedula}"/>
                </p>
                <p class="mb-2 small">
                  <i class="fas fa-envelope me-2 text-primary"></i>
                  <c:out value="${recep.correo}"/>
                </p>
                <p class="mb-3 small">
                  <i class="fas fa-phone me-2 text-primary"></i>
                  <c:out value="${recep.telefono}"/>
                </p>
                <div class="d-flex gap-2 justify-content-center">
                  <button class="btn btn-sm btn-primary"
                          onclick="verDetalle(${recep.id})"
                          title="Ver detalles">
                    <i class="fas fa-eye"></i>
                  </button>
                  <button class="btn btn-sm btn-warning"
                          onclick="abrirModalEditar(${recep.id})"
                          title="Editar">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button class="btn btn-sm btn-danger"
                          onclick="confirmarEliminacion('¿Eliminar este recepcionista?', 'formEliminar${recep.id}')"
                          title="Eliminar">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
                <form id="formEliminar${recep.id}"
                      action="${pageContext.request.contextPath}/RecepcionistaServlet"
                      method="post" style="display: none;">
                  <input type="hidden" name="action" value="eliminar">
                  <input type="hidden" name="idRecepcionista" value="${recep.id}">
                </form>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <!-- Search -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-6">
            <input type="text" class="form-control" placeholder="Buscar por nombre, cédula o correo..."
                   onkeyup="filtrarTabla('buscarRecep', 'tablaRecepcionistas')" id="buscarRecep">
          </div>
          <div class="col-md-3">
            <select class="form-select" id="filtroSeccion" onchange="aplicarFiltros()">
              <option value="">Todas las secciones</option>
              <option value="Recepción Principal">Recepción Principal</option>
              <option value="Admisión">Admisión</option>
              <option value="Caja">Caja</option>
              <option value="Archivo">Archivo</option>
              <option value="Información">Información</option>
            </select>
          </div>
          <div class="col-md-3">
            <select class="form-select" id="filtroEstado" onchange="aplicarFiltros()">
              <option value="">Todos</option>
              <option value="activo">Activos</option>
              <option value="inactivo">Inactivos</option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- Tabla -->
    <div class="card">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <span><i class="fas fa-table me-2"></i>Listado Completo</span>
          <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaRecepcionistas', 'recepcionistas.csv')">
            <i class="fas fa-download me-1"></i>Exportar
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="table-container">
          <table class="table" id="tablaRecepcionistas">
            <thead>
            <tr>
              <th>Cédula</th>
              <th>Nombre</th>
              <th>Sección</th>
              <th>Email</th>
              <th>Teléfono</th>
              <th>Usuario</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty recepcionistas}">
                <c:forEach var="recep" items="${recepcionistas}">
                  <tr>
                    <td><c:out value="${recep.cedula}"/></td>
                    <td>
                      <div class="d-flex align-items-center gap-2">
                        <i class="fas fa-user-tie text-primary" style="font-size: 1.5rem;"></i>
                        <strong>
                          <c:out value="${recep.nombre}"/>
                          <c:out value="${recep.apellido}"/>
                        </strong>
                      </div>
                    </td>
                    <td>
                                                <span class="badge badge-primary">
                                                    <c:out value="${recep.seccionAsignada}"/>
                                                </span>
                    </td>
                    <td><c:out value="${recep.correo}"/></td>
                    <td><c:out value="${recep.telefono}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty recep.usuario}">
                                                        <span class="badge badge-success">
                                                            <i class="fas fa-user me-1"></i>
                                                            <c:out value="${recep.usuario.nombreUsuario}"/>
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
                                onclick="abrirModalEditar(${recep.id})">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" title="Eliminar"
                                onclick="confirmarEliminacion('¿Eliminar?', 'formEliminarTabla${recep.id}')">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                      <form id="formEliminarTabla${recep.id}"
                            action="${pageContext.request.contextPath}/RecepcionistaServlet"
                            method="post" style="display: none;">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idRecepcionista" value="${recep.id}">
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
                      <p class="mt-3 text-muted">No hay recepcionistas registrados</p>
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
<div class="modal-overlay" id="modalNuevoRecepcionista">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Nuevo Recepcionista</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoRecepcionista')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/RecepcionistaServlet" method="post">
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

        <h5 class="mb-3 mt-4"><i class="fas fa-briefcase me-2"></i>Información Laboral</h5>

        <div class="form-group">
          <label class="form-label required">Sección Asignada</label>
          <select class="form-select" name="seccionAsignada" required>
            <option value="">Seleccione...</option>
            <option value="Recepción Principal">Recepción Principal</option>
            <option value="Admisión">Admisión</option>
            <option value="Caja">Caja</option>
            <option value="Archivo">Archivo</option>
            <option value="Información">Información</option>
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
            Solo se muestran usuarios con rol "Recepcionista" sin asignar
          </small>
        </div>

        <c:if test="${empty usuariosDisponibles}">
          <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>No hay usuarios disponibles.</strong>
            Primero debe crear un usuario con rol "Recepcionista" en el módulo de Usuarios.
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="alert-link">
              Ir a Usuarios
            </a>
          </div>
        </c:if>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoRecepcionista')">
          Cancelar
        </button>
        <button type="submit" class="btn btn-primary" ${empty usuariosDisponibles ? 'disabled' : ''}>
          <i class="fas fa-save me-2"></i>Guardar Recepcionista
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Editar -->
<div class="modal-overlay" id="modalEditarRecepcionista">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Editar Recepcionista</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalEditarRecepcionista')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/RecepcionistaServlet" method="post">
      <input type="hidden" name="action" value="editar">
      <input type="hidden" name="idRecepcionista" id="editId">
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

        <div class="form-group">
          <label class="form-label required">Sección Asignada</label>
          <select class="form-select" name="seccionAsignada" id="editSeccion" required>
            <option value="">Seleccione...</option>
            <option value="Recepción Principal">Recepción Principal</option>
            <option value="Admisión">Admisión</option>
            <option value="Caja">Caja</option>
            <option value="Archivo">Archivo</option>
            <option value="Información">Información</option>
          </select>
        </div>

        <h5 class="mb-3 mt-4"><i class="fas fa-user-lock me-2"></i>Usuario Asignado</h5>

        <div class="form-group">
          <label class="form-label">Usuario del Sistema</label>
          <select class="form-select" name="idUsuario" id="editUsuario">
            <option value="">Sin asignar</option>
            <c:forEach var="usuario" items="${todosLosUsuarios}">
              <c:if test="${usuario.rol == 'Recepcionista'}">
                <option value="${usuario.idUsuario}">
                  <c:out value="${usuario.nombreUsuario}"/>
                </option>
              </c:if>
            </c:forEach>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarRecepcionista')">
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
    // Hacer petición AJAX para obtener datos
    fetch('${pageContext.request.contextPath}/RecepcionistaServlet?action=obtener&id=' + id)
            .then(response => response.json())
            .then(data => {
              document.getElementById('editId').value = data.id;
              document.getElementById('editNombre').value = data.nombre;
              document.getElementById('editApellido').value = data.apellido;
              document.getElementById('editCedula').value = data.cedula;
              document.getElementById('editCorreo').value = data.correo;
              document.getElementById('editTelefono').value = data.telefono;
              document.getElementById('editDireccion').value = data.dirección || "";
              document.getElementById('editSeccion').value = data.seccionAsignada;
              document.getElementById('editUsuario').value = data.usuario ? data.usuario.idUsuario : '';

              FisioApp.openModal('modalEditarRecepcionista');
            })
            .catch(error => {
              console.error('Error:', error);
              FisioApp.showAlert('Error al cargar los datos', 'danger');
            });
  }

  function verDetalle(id) {
    window.location.href = '${pageContext.request.contextPath}/RecepcionistaServlet?action=ver&id=' + id;
  }

  function aplicarFiltros() {
    const texto = document.getElementById('buscarRecep').value.toLowerCase();
    const seccion = document.getElementById('filtroSeccion').value.toLowerCase();
    const estado = document.getElementById('filtroEstado').value.toLowerCase();

    const tabla = document.getElementById('tablaRecepcionistas');
    const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

    for (let i = 0; i < filas.length; i++) {
      const fila = filas[i];

      const cedula = fila.cells[0].textContent.toLowerCase();
      const nombre = fila.cells[1].textContent.toLowerCase();
      const seccionFila = fila.cells[2].textContent.toLowerCase();
      const correo = fila.cells[3].textContent.toLowerCase();
      const estadoFila = fila.cells[6].textContent.toLowerCase();

      const coincideTexto =
              texto === '' ||
              cedula.includes(texto) ||
              nombre.includes(texto) ||
              correo.includes(texto);

      const coincideSeccion =
              seccion === '' || seccionFila.includes(seccion);

      const coincideEstado =
              estado === '' || estadoFila.includes(estado);

      fila.style.display =
              coincideTexto && coincideSeccion && coincideEstado
                      ? ''
                      : 'none';
    }
  }
</script>

<c:if test="${not empty modal}">
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const idRecepcionista = "${idRecepcionistaModal}";
      abrirModalEditar(idRecepcionista)
    });
  </script>
</c:if>

<%@ include file="../components/layout/footer.jsp" %>
