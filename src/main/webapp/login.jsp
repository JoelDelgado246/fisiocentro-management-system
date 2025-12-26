<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FisioCenter - Iniciar Sesión</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #10b981;
            --primary-dark: #059669;
            --secondary-color: #3b82f6;
            --danger-color: #ef4444;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --bg-light: #f9fafb;
            --white: #ffffff;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #c3c8ff 0%, #e6e8ff 55%, #ffffff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            display: flex;
            max-width: 1000px;
            width: 100%;
            background: var(--white);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .login-image {
            flex: 1;
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.9), rgba(5, 150, 105, 0.9)),
            url('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800') center/cover;
            padding: 60px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            color: var(--white);
        }

        .login-image h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .login-image p {
            font-size: 1.1rem;
            opacity: 0.95;
            line-height: 1.6;
        }

        .login-image .features {
            margin-top: 3rem;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .feature-item i {
            font-size: 1.5rem;
            background: rgba(255, 255, 255, 0.2);
            padding: 12px;
            border-radius: 10px;
        }

        .login-form-container {
            flex: 1;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            margin-bottom: 2rem;
        }

        .login-header h2 {
            font-size: 2rem;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid var(--danger-color);
        }

        .alert i {
            font-size: 1.25rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .form-control {
            width: 100%;
            padding: 0.875rem 1rem;
            padding-left: 3rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: var(--bg-light);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 1.1rem;
            padding: 0.5rem;
        }

        .password-toggle:hover {
            color: var(--primary-color);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .checkbox-wrapper {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .checkbox-wrapper input[type="checkbox"] {
            width: 1.1rem;
            height: 1.1rem;
            cursor: pointer;
        }

        .checkbox-wrapper label {
            font-size: 0.9rem;
            color: var(--text-secondary);
            cursor: pointer;
        }

        .forgot-password {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .forgot-password:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .btn {
            width: 100%;
            padding: 1rem;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: var(--white);
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.5);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .demo-credentials {
            background: #f0f9ff;
            border: 1px solid #bfdbfe;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1.5rem;
        }

        .demo-credentials h4 {
            color: var(--secondary-color);
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .demo-credentials p {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin: 0.25rem 0;
        }

        .demo-credentials strong {
            color: var(--text-primary);
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }

            .login-image {
                padding: 40px 30px;
            }

            .login-image h1 {
                font-size: 2rem;
            }

            .login-image .features {
                display: none;
            }

            .login-form-container {
                padding: 40px 30px;
            }
        }

        .loading {
            pointer-events: none;
            opacity: 0.7;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-image">
        <div>
            <h1><i class="fas fa-heartbeat"></i> FisioCenter</h1>
            <p>Sistema de Gestión Integral para Centros de Fisioterapia</p>
        </div>

        <div class="features">
            <div class="feature-item">
                <i class="fas fa-calendar-check"></i>
                <div>
                    <strong>Gestión de Turnos</strong>
                    <p style="font-size: 0.9rem; margin-top: 0.25rem;">Agenda inteligente y recordatorios</p>
                </div>
            </div>
            <div class="feature-item">
                <i class="fas fa-users"></i>
                <div>
                    <strong>Control de Pacientes</strong>
                    <p style="font-size: 0.9rem; margin-top: 0.25rem;">Historial clínico completo</p>
                </div>
            </div>
            <div class="feature-item">
                <i class="fas fa-chart-line"></i>
                <div>
                    <strong>Estadísticas en Tiempo Real</strong>
                    <p style="font-size: 0.9rem; margin-top: 0.25rem;">Reportes y análisis detallados</p>
                </div>
            </div>
        </div>
    </div>

    <div class="login-form-container">
        <div class="login-header">
            <h2>¡Bienvenido de nuevo!</h2>
            <p>Ingresa tus credenciales para acceder al sistema</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span><c:out value="${error}"/></span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post" id="loginForm">
            <div class="form-group">
                <label class="form-label" for="nombreUsuario">Usuario</label>
                <div class="input-group">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text"
                           class="form-control"
                           id="nombreUsuario"
                           name="nombreUsuario"
                           placeholder="Ingresa tu usuario"
                           required
                           autofocus>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="contraseña">Contraseña</label>
                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password"
                           class="form-control"
                           id="contraseña"
                           name="contraseña"
                           placeholder="Ingresa tu contraseña"
                           required>
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i class="fas fa-eye" id="toggleIcon"></i>
                    </button>
                </div>
            </div>

            <div class="form-options">
                <div class="checkbox-wrapper">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Recordarme</label>
                </div>
                <a href="#" class="forgot-password">¿Olvidaste tu contraseña?</a>
            </div>

            <button type="submit" class="btn btn-primary" id="loginBtn">
                <i class="fas fa-sign-in-alt"></i>
                Iniciar Sesión
            </button>
        </form>

        <div class="demo-credentials">
            <h4><i class="fas fa-info-circle"></i> Credenciales de Prueba</h4>
            <p><strong>Administrador:</strong> admin / admin123</p>
            <p><strong>Recepcionista:</strong> recepcion1 / recep123</p>
            <p><strong>Fisioterapeuta:</strong> fisio1 / fisio123</p>
        </div>
    </div>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('contraseña');
        const toggleIcon = document.getElementById('toggleIcon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('loginBtn');
        btn.classList.add('loading');
        btn.disabled = true;
    });

    window.addEventListener('load', function() {
        const alert = document.querySelector('.alert-danger');
        if (alert) {
            setTimeout(() => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            }, 5000);
        }
    });
</script>
</body>
</html>
