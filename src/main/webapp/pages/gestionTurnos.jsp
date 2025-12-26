<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../components/layout/header.jsp" %>

<style>
  .turno-card {
    border-left: 4px solid var(--primary-color);
    transition: transform 0.2s;
  }

  .turno-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  }

  .turno-card.pendiente {
    border-left-color: #f59e0b;
  }

  .turno-card.confirmado {
    border-left-color: #3b82f6;
  }

  .turno-card.completado {
    border-left-color: #10b981;
  }

  .turno-card.cancelado {
    border-left-color: #ef4444;
  }
</style>

<div>
  <%@ include file="../components/layout/sidebar.jsp" %>

  <main class="main-content">
    <div class="page-header">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h1 class="page-title">Gestión de Turnos</h1>
          <p class="page-subtitle">Administra las citas y sesiones de fisioterapia</p>
        </div>
        <button class="btn btn-primary" onclick="FisioApp.openModal('modalNuevoTurno')">
          <i class="fas fa-calendar-plus"></i>
          Nuevo Turno
        </button>
      </div>
    </div>

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

    <div class="row g-4 mb-4">
      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
              <i class="fas fa-calendar-day"></i>
            </div>
            <div class="stat-value"><c:out value="${turnosHoy}" default="0"/></div>
            <div class="stat-label">Turnos Hoy</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
              <i class="fas fa-clock"></i>
            </div>
            <div class="stat-value"><c:out value="${turnosPendientes}" default="0"/></div>
            <div class="stat-label">Pendientes</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #059669);">
              <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-value"><c:out value="${turnosCompletados}" default="0"/></div>
            <div class="stat-label">Completados</div>
          </div>
        </div>
      </div>

      <div class="col-md-3">
        <div class="card stat-card">
          <div class="card-body">
            <div class="stat-icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
              <i class="fas fa-calendar-week"></i>
            </div>
            <div class="stat-value"><c:out value="${turnosSemana}" default="0"/></div>
            <div class="stat-label">Esta Semana</div>
          </div>
        </div>
      </div>
    </div>

    <div class="card mb-4">
      <div class="card-body">
        <div class="row g-3">
          <div class="col-md-3">
            <input type="date" class="form-control" id="filtroFecha"
                   onchange="filtrarPorFecha()" value="${fechaHoy}">
          </div>
          <div class="col-md-3">
            <select class="form-select" id="filtroEstado" onchange="filtrarPorEstado()">
              <option value="">Todos los estados</option>
              <option value="PENDIENTE">Pendiente</option>
              <option value="CONFIRMADO">Confirmado</option>
              <option value="COMPLETADO">Completado</option>
              <option value="CANCELADO">Cancelado</option>
            </select>
          </div>
          <div class="col-md-3">
            <select class="form-select" id="filtroFisioterapeuta">
              <option value="">Todos los fisioterapeutas</option>
              <c:forEach var="fisio" items="${fisioterapeutas}">
                <option value="${fisio.id}">
                  Dr(a). <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/>
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-3">
            <button class="btn btn-secondary w-100" onclick="limpiarFiltros()">
              <i class="fas fa-redo me-1"></i>Limpiar
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="row g-4 mb-4">
      <c:choose>
        <c:when test="${not empty turnos}">
          <c:forEach var="turno" items="${turnos}">
            <div class="col-md-6 col-lg-4">
              <div class="card turno-card ${fn:toLowerCase(turno.estado)}">
                <div class="card-body">
                  <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                      <h6 class="mb-1">
                        <i class="fas fa-calendar me-2"></i>
                        <c:out value="${turno.fechaTurno}"/>
                      </h6>
                      <p class="mb-0 text-muted">
                        <i class="fas fa-clock me-2"></i>
                        <c:out value="${turno.horaTurno}"/>
                      </p>
                    </div>
                    <span class="badge
                                            <c:choose>
                                                <c:when test="${turno.estado == 'PENDIENTE'}">badge-warning</c:when>
                                                <c:when test="${turno.estado == 'CONFIRMADO'}">badge-primary</c:when>
                                                <c:when test="${turno.estado == 'COMPLETADO'}">badge-success</c:when>
                                                <c:when test="${turno.estado == 'CANCELADO'}">badge-danger</c:when>
                                            </c:choose>
                                        ">
                                            <c:out value="${turno.estado}"/>
                                        </span>
                  </div>

                  <div class="mb-3">
                    <div class="d-flex align-items-center gap-2 mb-2">
                      <i class="fas fa-user-injured text-primary"></i>
                      <strong>Paciente:</strong>
                      <c:out value="${turno.pacient.nombre}"/>
                      <c:out value="${turno.pacient.apellido}"/>
                    </div>
                    <div class="d-flex align-items-center gap-2 mb-2">
                      <i class="fas fa-user-md text-success"></i>
                      <strong>Fisioterapeuta:</strong>
                      Dr(a). <c:out value="${turno.fisio.nombre}"/>
                      <c:out value="${turno.fisio.apellido}"/>
                    </div>
                    <c:if test="${not empty turno.observacion}">
                      <div class="mt-2">
                        <small class="text-muted">
                          <i class="fas fa-file-alt me-1"></i>
                          <c:out value="${turno.observacion}"/>
                        </small>
                      </div>
                    </c:if>
                  </div>

                  <div class="d-flex gap-2 justify-content-end">
                    <c:if test="${turno.estado == 'PENDIENTE'}">
                      <button class="btn btn-sm btn-success"
                              onclick="confirmarTurno(${turno.idTurno})"
                              title="Confirmar">
                        <i class="fas fa-check"></i>
                      </button>
                    </c:if>

                    <c:if test="${turno.estado == 'CONFIRMADO'}">
                      <button class="btn btn-sm btn-success"
                              onclick="completarTurno(${turno.idTurno})"
                              title="Completar">
                        <i class="fas fa-check-double"></i>
                      </button>
                    </c:if>

                    <button class="btn btn-sm btn-warning"
                            onclick="abrirModalEditar(${turno.idTurno})"
                            title="Editar">
                      <i class="fas fa-edit"></i>
                    </button>

                    <c:if test="${turno.estado != 'CANCELADO' && turno.estado != 'COMPLETADO'}">
                      <button class="btn btn-sm btn-danger"
                              onclick="cancelarTurno(${turno.idTurno})"
                              title="Cancelar">
                        <i class="fas fa-times"></i>
                      </button>
                    </c:if>
                  </div>
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
                <h4 class="mt-3">No hay turnos programados</h4>
                <p class="text-muted">Comienza creando el primer turno</p>
                <button class="btn btn-primary mt-3" onclick="FisioApp.openModal('modalNuevoTurno')">
                  <i class="fas fa-plus me-2"></i>Crear Primer Turno
                </button>
              </div>
            </div>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="card">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <span><i class="fas fa-table me-2"></i>Listado Completo</span>
          <button class="btn btn-sm btn-secondary" onclick="exportarCSV('tablaTurnos', 'turnos.csv')">
            <i class="fas fa-download me-1"></i>Exportar
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="table-container">
          <table class="table" id="tablaTurnos">
            <thead>
            <tr>
              <th>Fecha</th>
              <th>Hora</th>
              <th>Paciente</th>
              <th>Fisioterapeuta</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${not empty turnos}">
                <c:forEach var="turno" items="${turnos}">
                  <tr>
                    <td><c:out value="${turno.fechaTurno}"/></td>
                    <td><c:out value="${turno.horaTurno}"/></td>
                    <td>
                      <c:out value="${turno.pacient.nombre}"/>
                      <c:out value="${turno.pacient.apellido}"/>
                    </td>
                    <td>
                      Dr(a). <c:out value="${turno.fisio.nombre}"/>
                      <c:out value="${turno.fisio.apellido}"/>
                    </td>
                    <td>
                                                <span class="badge
                                                    <c:choose>
                                                        <c:when test="${turno.estado == 'PENDIENTE'}">badge-warning</c:when>
                                                        <c:when test="${turno.estado == 'CONFIRMADO'}">badge-primary</c:when>
                                                        <c:when test="${turno.estado == 'COMPLETADO'}">badge-success</c:when>
                                                        <c:when test="${turno.estado == 'CANCELADO'}">badge-danger</c:when>
                                                    </c:choose>
                                                ">
                                                    <c:out value="${turno.estado}"/>
                                                </span>
                    </td>
                    <td>
                      <button class="btn btn-sm btn-warning"
                              onclick="abrirModalEditar(${turno.idTurno})">
                        <i class="fas fa-edit"></i>
                      </button>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" class="text-center">
                    <p class="text-muted my-3">No hay turnos registrados</p>
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

<div class="modal-overlay" id="modalNuevoTurno">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Nuevo Turno</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalNuevoTurno')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/TurnoServlet" method="post">
      <input type="hidden" name="action" value="crear">
      <div class="modal-body">
        <div class="alert alert-info">
          <i class="fas fa-info-circle me-2"></i>
          <small>Selecciona primero el fisioterapeuta para ver su disponibilidad horaria.</small>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Paciente</label>
              <select class="form-select" name="idPaciente" required>
                <option value="">Seleccione un paciente...</option>
                <c:forEach var="paciente" items="${pacientes}">
                  <option value="${paciente.id}">
                    <c:out value="${paciente.nombre}"/> <c:out value="${paciente.apellido}"/>
                    - CI: <c:out value="${paciente.cedula}"/>
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>

          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Fisioterapeuta</label>
              <select class="form-select" name="idFisioterapeuta" id="selectFisioNuevo"
                      onchange="cargarHorariosFisio(this.value)" required>
                <option value="">Seleccione un fisioterapeuta...</option>
                <c:forEach var="fisio" items="${fisioterapeutas}">
                  <option value="${fisio.id}">
                    Dr(a). <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/>
                    - <c:out value="${fisio.especialidad}"/>
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Fecha del Turno</label>
              <input type="date" class="form-control" name="fechaTurno"
                     id="fechaTurnoNuevo" required min="${fechaHoy}">
            </div>
          </div>

          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora del Turno</label>
              <input type="time" class="form-control" name="horaTurno"
                     id="horaTurnoNuevo" required>
              <small class="text-muted" id="infoHorario">
                Seleccione un fisioterapeuta para ver horarios disponibles
              </small>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Observación</label>
          <textarea class="form-control" name="observacion" rows="3"
                    placeholder="Observaciones sobre el turno..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalNuevoTurno')">
          Cancelar
        </button>
        <button type="submit" class="btn btn-primary">
          <i class="fas fa-save me-2"></i>Guardar Turno
        </button>
      </div>
    </form>
  </div>
</div>

<div class="modal-overlay" id="modalEditarTurno">
  <div class="modal modal-lg">
    <div class="modal-header">
      <h3 class="modal-title">Editar Turno</h3>
      <button class="modal-close" onclick="FisioApp.closeModal('modalEditarTurno')">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <form action="${pageContext.request.contextPath}/TurnoServlet" method="post">
      <input type="hidden" name="action" value="editar">
      <input type="hidden" name="idTurno" id="editId">
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Paciente</label>
              <select class="form-select" name="idPaciente" id="editPaciente" required>
                <c:forEach var="paciente" items="${pacientes}">
                  <option value="${paciente.id}">
                    <c:out value="${paciente.nombre}"/> <c:out value="${paciente.apellido}"/>
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>

          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Fisioterapeuta</label>
              <select class="form-select" name="idFisioterapeuta" id="editFisioterapeuta" required>
                <c:forEach var="fisio" items="${fisioterapeutas}">
                  <option value="${fisio.id}">
                    Dr(a). <c:out value="${fisio.nombre}"/> <c:out value="${fisio.apellido}"/>
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Fecha</label>
              <input type="date" class="form-control" name="fechaTurno" id="editFecha" required>
            </div>
          </div>

          <div class="col-md-6">
            <div class="form-group">
              <label class="form-label required">Hora</label>
              <input type="time" class="form-control" name="horaTurno" id="editHora" required>
            </div>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Estado</label>
          <select class="form-select" name="estado" id="editEstado">
            <option value="PENDIENTE">Pendiente</option>
            <option value="CONFIRMADO">Confirmado</option>
            <option value="COMPLETADO">Completado</option>
            <option value="CANCELADO">Cancelado</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Observación</label>
          <textarea class="form-control" name="observacion" id="editObservacion" rows="3"></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="FisioApp.closeModal('modalEditarTurno')">
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
    fetch('${pageContext.request.contextPath}/TurnoServlet?action=obtener&id=' + id)
            .then(response => response.json())
            .then(data => {
              document.getElementById('editId').value = data.idTurno;
              document.getElementById('editPaciente').value = data.idPaciente;
              document.getElementById('editFisioterapeuta').value = data.idFisioterapeuta;
              document.getElementById('editFecha').value = data.fechaTurnoStr;
              document.getElementById('editHora').value = data.horaTurnoStr;
              document.getElementById('editEstado').value = data.estado;
              document.getElementById('editObservacion').value = data.observacion || '';

              FisioApp.openModal('modalEditarTurno');
            })
            .catch(error => {
              console.error('Error:', error);
              FisioApp.showAlert('Error al cargar los datos', 'danger');
            });
  }

  function confirmarTurno(id) {
    if (confirm('¿Confirmar este turno?')) {
      cambiarEstado(id, 'CONFIRMADO');
    }
  }

  function completarTurno(id) {
    if (confirm('¿Marcar este turno como completado?')) {
      cambiarEstado(id, 'COMPLETADO');
    }
  }

  function cancelarTurno(id) {
    if (confirm('¿Cancelar este turno?')) {
      cambiarEstado(id, 'CANCELADO');
    }
  }

  function cambiarEstado(id, estado) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/TurnoServlet';

    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'cambiarEstado';

    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'idTurno';
    idInput.value = id;

    const estadoInput = document.createElement('input');
    estadoInput.type = 'hidden';
    estadoInput.name = 'estado';
    estadoInput.value = estado;

    form.appendChild(actionInput);
    form.appendChild(idInput);
    form.appendChild(estadoInput);

    document.body.appendChild(form);
    form.submit();
  }

  function cargarHorariosFisio(idFisio) {
    if (!idFisio) {
      document.getElementById('infoHorario').textContent =
              'Seleccione un fisioterapeuta para ver horarios disponibles';
      return;
    }

    fetch('${pageContext.request.contextPath}/TurnoServlet?action=obtenerHorarioFisio&id=' + idFisio)
            .then(response => response.json())
            .then(data => {
              if (data.horario) {
                const info = `Horario: ${data.horario.diaDeSemana} ${data.horario.horaInicio} - ${data.horario.horaFin}`;
                document.getElementById('infoHorario').textContent = info;
              } else {
                document.getElementById('infoHorario').textContent =
                        'Este fisioterapeuta no tiene horario asignado';
              }
            })
            .catch(error => {
              console.error('Error:', error);
            });
  }

  function limpiarFiltros() {
    document.getElementById('filtroFecha').value = '';
    document.getElementById('filtroEstado').value = '';
    document.getElementById('filtroFisioterapeuta').value = '';
    window.location.reload();
  }

  function filtrarPorFecha() {
    const fecha = document.getElementById('filtroFecha').value;
    if (fecha) {
      window.location.href = '${pageContext.request.contextPath}/TurnoServlet?fecha=' + fecha;
    }
  }

  function filtrarPorEstado() {
    const estado = document.getElementById('filtroEstado').value;
    const tabla = document.getElementById('tablaTurnos');
    const filas = tabla.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

    for (let i = 0; i < filas.length; i++) {
      const estadoCell = filas[i].getElementsByTagName('td')[4];
      if (estadoCell) {
        const texto = estadoCell.textContent || estadoCell.innerText;
        filas[i].style.display = estado === '' || texto.includes(estado) ? '' : 'none';
      }
    }
  }
</script>

<%@ include file="../components/layout/footer.jsp" %>
