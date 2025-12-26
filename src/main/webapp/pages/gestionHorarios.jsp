<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<style>
  .horario-card {
    border-left: 4px solid var(--primary-color);
    transition: transform 0.2s;
  }

  .horario-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  }

  .dia-badge {
    padding: 0.5rem 1rem;
    border-radius: 2rem;
    font-weight: 600;
    display: inline-block;
    margin: 0.25rem;
  }

  .calendario-semanal {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 0.5rem;
    margin-bottom: 2rem;
  }

  .dia-columna {
    background: var(--light-bg);
    border-radius: 0.5rem;
    padding: 1rem;
    text-align: center;
  }

  .dia-columna.activo {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    color: white;
  }

  .dia-columna h6 {
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
  }
</style>

<div>
  <%@ include file="../components/layout/sidebar.jsp" %>

  <main class="main-content">
    <!-- Page Header -->
    <div class="page-header">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h1 class="page-title">Gestión de Horarios</h1>
          <p class="page-subtitle">Administra los horarios de disponibilidad de los fisioterapeutas</p>
        </div>
        <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoHorario')">
          <i class="fas fa-clock"></i>
          Nuevo Horario
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
              <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="stat-value"><c:out value="${totalHorarios}" default="0"/></div>
            <div class="stat-label">Total Horarios</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
              <i class="fas fa-user-md"></i>
            </div>
            <div class="stat-value"><c:out value="${fisioterapeutasConHorario}" default="0"/></div>
            <div class="stat-label">Fisioterapeutas</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
              <i class="fas fa-clock"></i>
            </div>
            <div class="stat-value"><c:out value="${horasSemanales}" default="0"/></div>
            <div class="stat-label">Horas Semanales</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
              <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-value"><c:out value="${diasActivos}" default="0"/></div>
            <div class="stat-label">Días Activos</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Vista de Calendario Semanal -->
    <div class="card mb-4">
      <div class="card-header">
        <h5 class="mb-0"><i class="fas fa-calendar-week me-2"></i>Vista Semanal</h5>
      </div>
      <div class="card-body">
        <div class="calendario-semanal">
          <c:forEach var="dia" items="${['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO']}">
            <div class="dia-columna ${horariosPorDia[dia] != null && not empty horariosPorDia[dia] ? 'activo' : ''}">
              <h6>
                <c:choose>
                  <c:when test="${dia == 'LUNES'}">Lunes</c:when>
                  <c:when test="${dia == 'MARTES'}">Martes</c:when>
                  <c:when test="${dia == 'MIERCOLES'}">Miércoles</c:when>
                  <c:when test="${dia == 'JUEVES'}">Jueves</c:when>
                  <c:when test="${dia == 'VIERNES'}">Viernes</c:when>
                  <c:when test="${dia == 'SABADO'}">Sábado</c:when>
                  <c:when test="${dia == 'DOMINGO'}">Domingo</c:when>
                </c:choose>
              </h6>
              <div class="badge badge-light">
                  ${horariosPorDia[dia] != null ? fn:length(horariosPorDia[dia]) : 0} horarios
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>

    <!-- Lista de Horarios en Cards -->
    <div class="row g-4 mb-4">
      <c:choose>
        <c:when test="${not empty horarios}">
          <c:forEach var="horario" items="${horarios}">
            <div class="col-md-6 col-lg-4">
              <div class="card horario-card">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start mb-3">
                                        <span class="dia-badge" style="background: linear-gradient(135deg, #3b82f6, #2563eb); color: white;">
                                            <c:choose>
                                              <c:when test="${horario.diaDeSemana == 'LUNES'}">Lunes</c:when>
                                              <c:when test="${horario.diaDeSemana == 'MARTES'}">Martes</c:when>
                                              <c:when test="${horario.diaDeSemana == 'MIERCOLES'}">Miércoles</c:when>
                                              <c:when test="${horario.diaDeSemana == 'JUEVES'}">Jueves</c:when>
                                              <c:when test="${horario.diaDeSemana == 'VIERNES'}">Viernes</c:when>
                                              <c:when test="${horario.diaDeSemana == 'SABADO'}">Sábado</c:when>
                                              <c:when test="${horario.diaDeSemana == 'DOMINGO'}">Domingo</c:when>
                                            </c:choose>
                                        </span>
                  </div>

                  <div class="mb-3">
                    <div class="d-flex align-items-center gap-3">
                      <div>
                        <i class="fas fa-clock text-primary me-2"></i>
                        <strong>Inicio:</strong>
                        <c:out value="${horario.horaInicio}"/>
                      </div>
                      <div>
                        <i class="fas fa-clock text-danger me-2"></i>
                        <strong>Fin:</strong>
                        <c:out value="${horario.horaFin}"/>
                      </div>
                    </div>
                  </div>

                  <div class="mb-3">
                    <small class="text-muted">Fisioterapeutas asignados:</small>
                    <div class="mt-2">
                      <c:choose>
                        <c:when test="${not empty horario.fisioterapeutaAsociado}">
                          <c:forEach var="fisio" items="${horario.fisioterapeutaAsociado}">
                                                        <span class="badge badge-success me-1 mb-1">
                                                            <i class="fas fa-user-md me-1"></i>
                                                            Dr(a). <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/>
                                                        </span>
                          </c:forEach>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-warning">Sin fisioterapeutas asignados</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>

                  <div class="d-flex gap-2 justify-content-end">
                    <button class="btn btn-sm btn-warning"
                            onclick="abrirModalEditar(${horario.idHorario})"
                            title="Editar">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger"
                            onclick="confirmarEliminacion('¿Eliminar este horario?', 'formEliminar${horario.idHorario}')"
                            title="Eliminar">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                  <form id="formEliminar${horario.idHorario}"
                        action="${pageContext.request.contextPath}/HorarioServlet"
                        method="post" style="display: none;">
                    <input type="hidden" name="action" value="eliminar">
                    <input type="hidden" name="idHorario" value="${horario.idHorario}">
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="col-12">
            <div class="card">
              <div class="card-body text-center py-5">
                <i class="fas fa-calendar-times" style="font-size: 4rem; color: var(--text-secondary);"></i>
                <h4 class="mt-3">No hay horarios registrados</h4>
                <p class="text-muted">Comienza agregando el primer horario de disponibilidad</p>
                <button class="btn btn-primary mt-3" onclick="FisioApp.openModal('modalNuevoHorario')">
                  <i class="fas fa-plus me-2"></i>Crear Primer Horario
                </button>
              </div>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Filtros -->
    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-5">
            <input type="text" class="form-control" placeholder="Buscar horario..."
                   onkeyup="filtrarTabla('buscarHorario', 'tablaHorarios')" id="buscarHorario">
          </div>
          <div class="col-md-3">
            <select class="form-select" id="filtroDia" onchange="filtrarPorDia()">
              <option value="">Todos los días</option>
              <option value="LUNES">Lunes</option>
              <option value="MARTES">Martes</option>
              <option value="MIERCOLES">Miércoles</option>
              <option value="JUEVES">Jueves</option>
              <option value="VIERNES">Viernes</option>
              <option value="SABADO">Sábado</option>
              <option value="DOMINGO">Domingo</option>
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

    <!-- Tabla Completa -->
    <div class="card">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <span><i class="fas fa-table me-2"></i>Listado Completo</span>
          <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaHorarios', 'horarios.csv')">
            <i class="fas fa-download me-1"></i>Exportar
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="table-container">
          <table class="table" id="tablaHorarios">
            <thead>
            <tr>
              <th>Día</th>
              <th>Hora Inicio</th>
              <th>Hora Fin</th>
              <th>Fisioterapeutas</th>
              <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty horarios}">
                <c:forEach var="horario" items="${horarios}">
                  <tr>
                    <td>
                      <strong>
                        <c:choose>
                          <c:when test="${horario.diaDeSemana == 'LUNES'}">Lunes</c:when>
                          <c:when test="${horario.diaDeSemana == 'MARTES'}">Martes</c:when>
                          <c:when test="${horario.diaDeSemana == 'MIERCOLES'}">Miércoles</c:when>
                          <c:when test="${horario.diaDeSemana == 'JUEVES'}">Jueves</c:when>
                          <c:when test="${horario.diaDeSemana == 'VIERNES'}">Viernes</c:when>
                          <c:when test="${horario.diaDeSemana == 'SABADO'}">Sábado</c:when>
                          <c:when test="${horario.diaDeSemana == 'DOMINGO'}">Domingo</c:when>
                        </c:choose>
                      </strong>
                    </td>
                    <td><c:out value="${horario.horaInicio}"/></td>
                    <td><c:out value="${horario.horaFin}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty horario.fisioterapeutaAsociado}">
                          <c:forEach var="fisio" items="${horario.fisioterapeutaAsociado}" varStatus="status">
                            <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/><c:if test="${!status.last}">, </c:if>
                          </c:forEach>
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">Sin asignar</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-warning"
                                onclick="abrirModalEditar(${horario.idHorario})"
                                title="Editar">
                          <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-danger"
                                onclick="confirmarEliminacion('¿Eliminar?', 'formEliminarTabla${horario.idHorario}')"
                                title="Eliminar">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                      <form id="formEliminarTabla${horario.idHorario}"
                            action="${pageContext.request.contextPath}/HorarioServlet"
                            method="post" style="display: none;">
                        <input type="hidden" name="action" value="eliminar">
                        <input type="hidden" name="idHorario" value="${horario.idHorario}">
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="5" class="text-center">
                    <p class="text-muted my-3">No hay horarios registrados</p>
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

<!-- Modal Nuevo Horario -->
<div class="modal-overlay" id="modalNuevoHorario">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Nuevo Horario de Disponibilidad</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoHorario')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/HorarioServlet" method="post">
      <input type="hidden" name="action" value="crear">
      <div class="modal-body">
        <div class="alert alert-info">
          <i class="fas fa-info-circle me-2"></i>
          <small>Define un bloque horario. Los fisioterapeutas se asignan al horario desde su perfil.</small>
        </div>

        <div class="form-group">
          <label class="form-label required">Día de la Semana</label>
          <select class="form-select" name="diaSemana" required>
            <option value="">Seleccione un día...</option>
            <option value="LUNES">Lunes</option>
            <option value="MARTES">Martes</option>
            <option value="MIERCOLES">Miércoles</option>
            <option value="JUEVES">Jueves</option>
            <option value="VIERNES">Viernes</option>
            <option value="SABADO">Sábado</option>
            <option value="DOMINGO">Domingo</option>
          </select>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora de Inicio</label>
              <input type="time" class="form-control" name="horaInicio" required>
              <small class="text-muted">Hora de inicio de atención</small>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora de Fin</label>
              <input type="time" class="form-control" name="horaFin" required>
              <small class="text-muted">Hora de finalización de atención</small>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoHorario')">
          Cancelar
        </button>
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-save me-2"></i>Guardar Horario
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Editar Horario -->
<div class="modal-overlay" id="modalEditarHorario">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Editar Horario</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalEditarHorario')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/HorarioServlet" method="post">
      <input type="hidden" name="action" value="editar">
      <input type="hidden" name="idHorario" id="editId">
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label required">Día de la Semana</label>
          <select class="form-select" name="diaSemana" id="editDia" required>
            <option value="">Seleccione...</option>
            <option value="LUNES">Lunes</option>
            <option value="MARTES">Martes</option>
            <option value="MIERCOLES">Miércoles</option>
            <option value="JUEVES">Jueves</option>
            <option value="VIERNES">Viernes</option>
            <option value="SABADO">Sábado</option>
            <option value="DOMINGO">Domingo</option>
          </select>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora de Inicio</label>
              <input type="time" class="form-control" name="horaInicio" id="editHoraInicio" required>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora de Fin</label>
              <input type="time" class="form-control" name="horaFin" id="editHoraFin" required>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarHorario')">
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
    fetch('${pageContext.request.contextPath}/HorarioServlet?action=obtener&id=' + id)
            .then(response => response.json())
            .then(data => {
              document.getElementById('editId').value = data.idHorario;
              document.getElementById('editDia').value = data.diaDeSemana;
              document.getElementById('editHoraInicio').value = data.horaInicioStr;
              document.getElementById('editHoraFin').value = data.horaFinStr;

              FisioApp.openModal('modalEditarHorario');
            })
            .catch(error => {
              console.error('Error:', error);
              FisioApp.showAlert('Error al cargar los datos', 'danger');
            });
  }

  function limpiarFiltros() {
    document.getElementById('buscarHorario').value = '';
    document.getElementById('filtroDia').value = '';
    filtrarTabla('buscarHorario', 'tablaHorarios');
  }

  function filtrarPorDia() {
    const filtro = document.getElementById('filtroDia').value;
    const tabla = document.getElementById('tablaHorarios');
    const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

    for (let i = 0; i < filas.length; i++) {
      const diaCell = filas[i].getElementsByTagName('td')[0];
      if (diaCell) {
        const texto = diaCell.textContent || diaCell.innerText;

        let mostrar = false;
        if (filtro === '') {
          mostrar = true;
        } else {
          const diaMap = {
            'LUNES': 'Lunes',
            'MARTES': 'Martes',
            'MIERCOLES': 'Miércoles',
            'JUEVES': 'Jueves',
            'VIERNES': 'Viernes',
            'SABADO': 'Sábado',
            'DOMINGO': 'Domingo'
          };
          mostrar = texto.includes(diaMap[filtro]);
        }

        filas[i].style.display = mostrar ? '' : 'none';
      }
    }
  }
</script>

<%@ include file="../components/layout/footer.jsp" %>
