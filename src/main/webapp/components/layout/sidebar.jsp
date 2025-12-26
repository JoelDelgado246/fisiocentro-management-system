<aside class="sidebar">
    <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/DashboardServlet" class="sidebar-logo">
            <i class="fas fa-heartbeat"></i>
            <span>FisioCenter</span>
        </a>
    </div>

    <!-- USER INFO -->
    <div class="sidebar-user">
        <div class="user-avatar">
            <i class="fas fa-user-circle"></i>
        </div>
        <div class="user-info">
            <span class="user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <c:out value="${sessionScope.usuario.nombreUsuario}"/>
                    </c:when>
                    <c:otherwise>
                        Usuario
                    </c:otherwise>
                </c:choose>
            </span>
            <span class="user-role">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuario}">
                        <c:out value="${sessionScope.usuario.rol}"/>
                    </c:when>
                    <c:otherwise>
                        Sin rol
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/DashboardServlet">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <!-- ADMINISTRADOR Y RECEPCIONISTA -->
            <c:if test="${sessionScope.usuario.rol == 'Administrador' || sessionScope.usuario.rol == 'Recepcionista'}">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/PacienteServlet">
                        <i class="fas fa-users"></i>
                        <span>Pacientes</span>
                    </a>
                </li>
            </c:if>


            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/TurnoServlet">
                    <i class="fas fa-calendar-alt"></i>
                    <c:choose>
                        <c:when test="${sessionScope.usuario.rol == 'Fisioterapeuta'}">
                            Mis Turnos
                        </c:when>
                        <c:otherwise>
                            Turnos
                        </c:otherwise>
                    </c:choose>
                </a>
            </li>

            <!-- ADMINISTRADOR Y RECEPCIONISTA -->
            <c:if test="${sessionScope.usuario.rol == 'Administrador' || sessionScope.usuario.rol == 'Recepcionista'}">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/FisioterapeutaServlet">
                        <i class="fas fa-user-md"></i>
                        <span>Fisioterapeutas</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/HorarioServlet">
                        <i class="fas fa-clock"></i>
                        <span>Horarios</span>|
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/RecepcionistaServlet">
                        <i class="fas fa-user-nurse"></i>
                        <span>Recepcionistas</span>
                    </a>
                </li>
            </c:if>

            <c:if test="${sessionScope.rol == 'Administrador'}">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/UsuarioServlet">
                        <i class="fas fa-user-cog"></i>
                        <span>Usuarios</span>
                    </a>
                </li>
            </c:if>

            <li class="nav-item">
                <hr style="border-color: rgba(255,255,255,0.2); margin: 1rem 0;">
            </li>

            <li class="nav-item">
                <a class="nav-link logout" href="${pageContext.request.contextPath}/LoginServlet?action=logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Cerrar Sesión</span>
                </a>
            </li>
        </ul>
    </nav>
</aside>