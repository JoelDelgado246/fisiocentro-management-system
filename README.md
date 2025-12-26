# 🏥 FisioCenter - Sistema de Gestión para Centros de Fisioterapia

<div align="center">

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-007396?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)

### 💚 Sistema completo de gestión clínica con control de acceso por roles

[🚀 Demo](#demo) • [📋 Características](#características) • [🛠️ Instalación](#instalación) • [📸 Screenshots](#screenshots)

</div>

---

## 📖 Descripción

**FisioCenter** es un sistema web robusto y escalable diseñado para la gestión integral de centros de fisioterapia. Permite administrar pacientes, fisioterapeutas, turnos y usuarios con un sistema de autenticación y autorización basado en roles (RBAC).

### 🎯 Problema que Resuelve

Los centros de fisioterapia enfrentan desafíos en:
- 📅 Gestión manual de citas y turnos
- 📋 Control disperso de historiales clínicos
- 👥 Coordinación entre recepcionistas y fisioterapeutas
- 🔐 Falta de control de acceso a información sensible

**FisioCenter** centraliza toda la operativa en una plataforma segura y eficiente.

---

## ✨ Características

### 🔐 Sistema de Autenticación y Autorización
- Login seguro con gestión de sesiones
- Control de acceso basado en roles (RBAC)
- Tres niveles de usuarios: **Administrador**, **Recepcionista**, **Fisioterapeuta**

### 👥 Gestión de Pacientes
- Registro completo de pacientes con datos personales
- Vinculación con responsables (tutores/familiares)
- Historial de turnos y observaciones clínicas
- Búsqueda y filtrado avanzado

### 🩺 Gestión de Fisioterapeutas
- Perfil profesional con especialidades
- Asignación de horarios de trabajo
- Vista personalizada de turnos asignados
- Registro de observaciones post-sesión

### 📅 Gestión de Turnos
- Creación de citas con validaciones inteligentes
- Estados: Pendiente, Confirmado, Completado, Cancelado
- Validación automática de horarios y disponibilidad
- Estadísticas en tiempo real (turnos del día, pendientes, completados)
- Filtros por fecha, estado y fisioterapeuta

### ⏰ Gestión de Horarios
- Configuración de días y horas de trabajo
- Validación de turnos según disponibilidad
- Prevención de solapamiento de citas

### 📊 Dashboard Interactivo
- Estadísticas visuales en tiempo real
- Accesos rápidos a módulos principales
- Panel adaptativo según rol del usuario

---

## 🏗️ Arquitectura

### Tecnologías Utilizadas

**Backend:**
- ☕ **Java 11+** (Jakarta EE)
- 🗄️ **JPA/Hibernate** - ORM para persistencia
- 🎯 **Servlets** - Controladores
- 🏛️ **Arquitectura en capas** (Presentation → Logic → Persistence)

**Frontend:**
- 🎨 **JSP** con **JSTL**
- 💅 **CSS3** personalizado
- ⚡ **JavaScript vanilla** + AJAX
- 📱 **Responsive Design**

**Base de Datos:**
- 🐬 **MySQL 8.0+**
- 📐 Diseño normalizado (3FN)
- 🔗 Relaciones OneToOne, OneToMany, ManyToOne

**Servidor:**
- 🚀 **Apache Tomcat 10+**
- 🔧 Maven para gestión de dependencias

### Patrón de Diseño

```
┌─────────────────────────────────────┐
│         PRESENTATION LAYER          │
│    (Servlets + JSP + JavaScript)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           LOGIC LAYER               │
│      (LogicController)              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│        PERSISTENCE LAYER            │
│  (PersistenceController + JPA)      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          DATABASE LAYER             │
│            (MySQL)                  │
└─────────────────────────────────────┘
```

---

## 🎭 Roles y Permisos

| Módulo | Administrador | Recepcionista | Fisioterapeuta |
|--------|:-------------:|:-------------:|:--------------:|
| Dashboard | ✅ | ✅ | ✅ |
| Usuarios | ✅ | ❌ | ❌ |
| Pacientes | ✅ | ✅ | ❌ |
| Fisioterapeutas | ✅ | ✅ | ❌ |
| Recepcionistas | ✅ | ✅ | ❌ |
| Horarios | ✅ | ✅ | ❌ |
| Todos los Turnos | ✅ | ✅ | ❌ |
| Mis Turnos | ✅ | ❌ | ✅ |

### 🔑 Credenciales de Prueba

```
👨‍💼 Administrador
   Usuario: admin
   Contraseña: admin123

👩‍💻 Recepcionista  
   Usuario: recepcion1
   Contraseña: recep123

👨‍⚕️ Fisioterapeuta
   Usuario: fisio1
   Contraseña: fisio123
```

---

## 🛠️ Instalación

### Requisitos Previos

- ☕ **JDK 11** o superior
- 🐬 **MySQL 8.0+**
- 🚀 **Apache Tomcat 10+**
- 📦 **Maven 3.6+**
- 💻 **IDE recomendado:** IntelliJ IDEA, Eclipse, NetBeans

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/fisiocentro-management-system.git
cd fisiocentro-management-system
```

### Paso 2: Configurar Base de Datos

```sql
-- Crear base de datos
CREATE DATABASE fisiocentro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE fisiocentro;

-- Ejecutar el script de creación de tablas
SOURCE database/schema.sql;

-- Insertar datos de prueba (opcional)
SOURCE database/data.sql;
```

### Paso 3: Configurar persistence.xml

Edita `src/main/resources/META-INF/persistence.xml`:

```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/fisiocentro"/>
<property name="javax.persistence.jdbc.user" value="root"/>
<property name="javax.persistence.jdbc.password" value="tu_contraseña"/>
```

### Paso 4: Compilar y Desplegar

```bash
# Compilar el proyecto
mvn clean install

# El archivo .war se generará en target/
# Copiar a la carpeta webapps de Tomcat o desplegar desde el IDE
```

### Paso 5: Acceder a la Aplicación

```
http://localhost:8080/fisiocentro/
```

---

## 📸 Screenshots

### 🔐 Login
<img src="docs/screenshots/login.png" alt="Login" width="600"/>

*Sistema de autenticación con diseño moderno y credenciales de prueba visibles*

### 📊 Dashboard
<img src="docs/screenshots/dashboard.png" alt="Dashboard" width="600"/>

*Panel principal con estadísticas en tiempo real y accesos rápidos*

### 👥 Gestión de Pacientes
<img src="docs/screenshots/pacientes.png" alt="Pacientes" width="600"/>

*Lista de pacientes con búsqueda y filtros avanzados*

### 📅 Gestión de Turnos
<img src="docs/screenshots/turnos.png" alt="Turnos" width="600"/>

*Sistema de turnos con validaciones inteligentes y estados*

### 🩺 Vista de Fisioterapeuta
<img src="docs/screenshots/fisioterapeuta.png" alt="Fisioterapeuta" width="600"/>

*Panel personalizado mostrando solo turnos asignados*

---

## 📂 Estructura del Proyecto

```
fisiocentro-management-system/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/joel/centrofisioterapeuta/
│   │   │       ├── enums/           # Enumeraciones (EstadoTurno, DiaDeSemana, etc.)
│   │   │       ├── filters/         # Filtros de autenticación y autorización
│   │   │       ├── logica/          # Entidades JPA y lógica de negocio
│   │   │       ├── persistence/     # Controladores JPA
│   │   │       ├── servlets/        # Controladores web
│   │   │       └── utils/           # Utilidades (JsonUtils, etc.)
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   │       └── persistence.xml  # Configuración JPA
│   │   └── webapp/
│   │       ├── pages/
│   │       │   ├── components/      # Componentes reutilizables (header, sidebar)
│   │       │   ├── pacientes/       # Vistas de pacientes
│   │       │   ├── turnos/          # Vistas de turnos
│   │       │   ├── fisioterapeutas/ # Vistas de fisioterapeutas
│   │       │   └── usuarios/        # Vistas de usuarios
│   │       ├── css/                 # Estilos personalizados
│   │       ├── js/                  # Scripts JavaScript
│   │       ├── index.jsp            # Dashboard principal
│   │       ├── login.jsp            # Página de login
│   │       └── WEB-INF/
│   │           └── web.xml          # Descriptor de despliegue
├── database/
│   ├── schema.sql                   # Estructura de base de datos
│   └── data.sql                     # Datos de prueba
├── docs/
│   ├── screenshots/                 # Capturas de pantalla
│   └── guides/                      # Guías de implementación
├── pom.xml                          # Configuración Maven
└── README.md                        # Este archivo
```

---

## 🔄 Flujo de Trabajo

### Caso de Uso: Agendar un Turno

```
1. Recepcionista inicia sesión → Dashboard
2. Click en "Turnos" → Vista de gestión de turnos
3. Click en "Nuevo Turno"
4. Seleccionar paciente y fisioterapeuta
5. Sistema muestra horario disponible del fisioterapeuta
6. Seleccionar fecha y hora
7. Sistema valida:
   ✅ Fecha no sea pasada
   ✅ Hora dentro del horario del fisioterapeuta
   ✅ Día coincide con día de trabajo
   ✅ No hay otro turno a la misma hora
8. Guardar turno → Estado: PENDIENTE
9. Fisioterapeuta ve el turno en "Mis Turnos"
10. Después de la sesión → Agregar observaciones
11. Marcar turno como COMPLETADO
```

---

## 🚀 Roadmap

### Versión 1.0 (Actual)
- ✅ Sistema de autenticación y autorización
- ✅ Gestión completa de CRUD (Pacientes, Turnos, etc.)
- ✅ Dashboard con estadísticas
- ✅ Control de acceso por roles

### Versión 1.1 (Próximas Funcionalidades)
- 🔔 **Notificaciones:** Recordatorios de turnos por email/SMS
- 📊 **Reportes:** Exportación a PDF/Excel
- 📈 **Estadísticas Avanzadas:** Gráficos de ocupación, ingresos
- 🗓️ **Calendario Visual:** Vista de agenda tipo Google Calendar
- 💳 **Facturación:** Módulo de cobros y pagos

### Versión 2.0 (Futuro)
- 📱 **App Móvil:** Versión nativa para pacientes
- 🤖 **IA:** Sugerencias de disponibilidad
- 🌐 **Multi-idioma:** Soporte para varios idiomas
- ☁️ **Cloud:** Migración a arquitectura de microservicios

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request

---

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor

**Joel Alexander Delgado Esquivel**

- GitHub: [@JoelDelgado246](https://github.com/JoelDelgado246)
- LinkedIn: [Tu Nombre](https://linkedin.com/in/tu-perfil)
- Email: joelalexanderdel123456@gmail.com


<div align="center">

### ⭐ Si te gusta este proyecto, dale una estrella en GitHub!

**FisioCenter** - *Gestión profesional para centros de fisioterapia* 💚

</div>
