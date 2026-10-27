<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Session security check & data extraction
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("currentUser") == null) {
        response.sendRedirect("login_jsp.jsp");
        return;
    }
    String userName = (String) userSession.getAttribute("currentUser");
    String userRole = (String) userSession.getAttribute("currentRole");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Administrativo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --bg-cream: #F9F3EC;
            --ochre-primary: #C69251;
            --ochre-dark: #8C5830;
            --ochre-hover: #A8783D;
            --text-brown: #4A3525;
            --card-white: #FFFFFF;
        }

        body {
            background-color: var(--bg-cream);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-brown);
        }

        .navbar-ochre {
            background-color: var(--card-white);
            box-shadow: 0 2px 10px rgba(140, 88, 48, 0.1);
        }

        .text-ochre { color: var(--ochre-dark); }
        .btn-ochre {
            background-color: var(--ochre-primary);
            border-color: var(--ochre-primary);
            color: #FFFFFF;
            font-weight: 600;
        }
        .btn-ochre:hover {
            background-color: var(--ochre-hover);
            border-color: var(--ochre-hover);
            color: #FFFFFF;
        }

        .nav-tabs .nav-link {
            color: var(--ochre-dark);
            font-weight: 600;
            border: none;
            padding: 12px 20px;
        }
        .nav-tabs .nav-link.active {
            background-color: var(--ochre-primary) !important;
            color: #FFFFFF !important;
            border-radius: 8px 8px 0 0;
        }

        .card-metric, .content-box {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(140, 88, 48, 0.08);
            background-color: var(--card-white);
        }

        .content-box {
            border-radius: 0 0 12px 12px;
            padding: 30px;
        }

        /* Estilo para el gráfico de secuencia de procedimientos (Timeline horizontal/vertical puro CSS) */
        .procedure-timeline {
            border-left: 3px solid var(--ochre-primary);
            padding-left: 20px;
            margin-left: 10px;
        }
        .timeline-step {
            position: relative;
            margin-bottom: 20px;
        }
        .timeline-step::before {
            content: '';
            position: absolute;
            left: -26px;
            top: 4px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: var(--ochre-dark);
        }
    </style>
    <script>
        // Función nativa ligera en JS para alternar el modo de edición y descartar cambios si se re-clica
        function toggleEditMode(procId) {
            var displayDiv = document.getElementById('display-' + procId);
            var editDiv = document.getElementById('edit-' + procId);
            var btnIcon = document.getElementById('btn-icon-' + procId);
            var btnText = document.getElementById('btn-text-' + procId);
            
            if (editDiv.style.display === 'none') {
                displayDiv.style.display = 'none';
                editDiv.style.display = 'block';
                btnIcon.className = 'bi bi-x-lg';
                btnText.innerText = 'Cancelar';
            } else {
                displayDiv.style.display = 'block';
                editDiv.style.display = 'none';
                btnIcon.className = 'bi bi-gear-fill';
                btnText.innerText = 'Configurar';
            }
        }
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var configModal = document.getElementById('configMaquinariaModal');
            configModal.addEventListener('show.bs.modal', function (event) {
                // Botón que disparó el modal
                var button = event.relatedTarget;

                // Extraer la información de los atributos data-*
                var name = button.getAttribute('data-name');
                var desc = button.getAttribute('data-desc');
                var status = button.getAttribute('data-status');

                // Inyectar los valores en los campos del formulario del modal
                var inputName = configModal.querySelector('#modalMaqName');
                var inputDesc = configModal.querySelector('#modalMaqDesc');
                var selectStatus = configModal.querySelector('#modalMaqStatus');

                inputName.value = name;
                inputDesc.value = desc;
                selectStatus.value = status;
            });
        });
    </script>
</head>
<body>

    <!-- 1. BARRA DE NAVEGACIÓN SUPERIOR CON ICONO DE PERFIL -->
    <nav class="navbar navbar-expand-lg navbar-ochre px-4 mb-4">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold text-ochre" href="#">
                <i class="bi bi-shop"></i> Madific <span class="text-muted fs-6 fw-normal">| Panel Administrativo</span>
            </a>
            
            <!-- Menú Desplegable de Perfil -->
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle text-ochre fw-semibold" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="bg-light border border-secondary rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
                        <i class="bi bi-person-fill fs-5"></i>
                    </div>
                    <span th:text="${usuario.username}">Administrador</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="profileDropdown">
                    <li><a class="dropdown-item" href="/perfil_servlet"><i class="bi bi-gear me-2"></i> Configuración de Perfil</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="logout_servlet"><i class="bi bi-box-arrow-right me-2"></i> Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- CONTENEDOR PRINCIPAL CON PESTAÑAS -->
    <div class="container pb-5">
        
        <!-- Pestañas Principales -->
        <ul class="nav nav-tabs" id="adminTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="general-tab" data-bs-toggle="tab" data-bs-target="#general-pane" type="button" role="tab"><i class="bi bi-speedometer2"></i> Información General</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="procedimientos-tab" data-bs-toggle="tab" data-bs-target="#procedimientos-pane" type="button" role="tab"><i class="bi bi-diagram-3"></i> Procedimientos</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="maquinas-tab" data-bs-toggle="tab" data-bs-target="#maquinas-pane" type="button" role="tab"><i class="bi bi-cpu"></i> Máquinas</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="usuarios-tab" data-bs-toggle="tab" data-bs-target="#usuarios-pane" type="button" role="tab"><i class="bi bi-people"></i> Usuarios</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="reportes-tab" data-bs-toggle="tab" data-bs-target="#reportes-pane" type="button" role="tab"><i class="bi bi-file-earmark-text"></i> Reportes</button>
            </li>
        </ul>

        <!-- CONTENIDO DE LAS PESTAÑAS -->
        <div class="tab-content content-box" id="adminTabsContent">
            
            <!-- ================= TAB 1: INFORMACIÓN GENERAL ================= -->
            <div class="tab-pane fade show active" id="general-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-4">Panel de Métricas y Resumen General</h4>
                <div class="row g-4">
                    <div class="col-md-3">
                        <div class="card card-metric p-3 border-start border-4 border-warning">
                            <span class="text-muted small">Total de Usuarios</span>
                            <h2 class="text-lab-blue fw-bold mt-2">${not empty totalUsuarios ? totalUsuarios : '-'}</h2>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-metric p-3 border-start border-4 border-success">
                            <span class="text-muted small">Máquinas Activas</span>
                            <h2 class="text-lab-blue fw-bold mt-2">${not empty maquinasActivas ? maquinasActivas : '-'}</h2> 
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-metric p-3 border-start border-4 border-primary">
                            <span class="text-muted small">Procedimientos Registrados</span>
                            <h2 class="text-lab-blue fw-bold mt-2">${not empty totalProcedimientos ? totalProcedimientos : '-'}</h2>  
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-metric p-3 border-start border-4 border-danger">
                            <span class="text-muted small">Conectados (Últimas 24h)</span>
                            <h2 class="text-lab-blue fw-bold mt-2">${not empty usuariosConectados24h ? usuariosConectados24h : '-'}</h2> 
                        </div>
                    </div>
                </div>
            </div>

            <!-- ================= TAB 2: GESTIÓN DE PROCEDIMIENTOS ================= -->
            <div class="tab-pane fade" id="procedimientos-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-3">Gestión de Procedimientos Panaderos y Científicos</h4>
                <p class="text-muted small">Administre la secuencia combinada de máquinas y acciones paralelas.</p>
                
                <!-- Botón para desplegar formulario de creación -->
                <button class="btn btn-ochre mb-4" type="button" data-bs-toggle="collapse" data-bs-target="#formNuevoProcedimiento">
                    <i class="bi bi-plus-circle me-1"></i> Crear Nuevo Procedimiento
                </button>

                <!-- Formulario de Creación (Colapsable) -->
                <div class="collapse mb-4" id="formNuevoProcedimiento">
                    <div class="card card-body bg-light border-0">
                        <h5 class="text-ochre mb-3">Nuevo Procedimiento</h5>
                        <form action="registrar_procedimiento_servlet" method="POST">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Nombre</label>
                                    <input type="text" class="form-control" name="nombre" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">Tipo de Procedimiento</label>
                                    <input type="text" class="form-control" name="tipoProcedimiento" placeholder="Ej. Horneado Masivo" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label small fw-semibold">Descripción</label>
                                    <textarea class="form-control" name="descripcion" rows="2" required></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">IDs de Máquinas (Separados por coma)</label>
                                    <input type="text" class="form-control" name="listaMaquinas" placeholder="Ej. M-01, M-03">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-semibold">IDs de Acciones (Separados por coma)</label>
                                    <input type="text" class="form-control" name="listaAcciones" placeholder="Ej. A-101, A-102">
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-ochre btn-sm">Guardar Procedimiento</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Iteración Dinámica con JSTL de los Procedimientos provistos por el Servlet -->
                <div class="accordion" id="accordionProcedimientos">
                    <c:forEach var="proc" items="${listaProcedimientos}" varStatus="status">
                        <div class="accordion-item border mb-2">
                            <h2 class="accordion-header" id="headingProc${proc.id}">
                                <button class="accordion-button fw-semibold text-lab-blue collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProc${proc.id}">
                                    [ID: ${proc.id}] ${proc.name} &nbsp;<span class="badge bg-secondary ms-2">${proc.tipo}</span>
                                </button>
                            </h2>
                            <div id="collapseProc${proc.id}" class="accordion-collapse collapse" data-bs-parent="#accordionProcedimientos">
                                <div class="accordion-body">
                                    
                                    <!-- MODO VISTA / LECTURA -->
                                    <div id="display-${proc.id}">
                                        <p class="text-muted small"><strong>Descripción:</strong> ${proc.desc}</p>
                                        
                                        <div class="mb-2">
                                            <span class="small fw-bold text-dark">Secuencia de Ejecución:</span> 
                                            <code>${proc.secuencia}</code>
                                        </div>
                                        <div class="mb-3">
                                            <span class="small fw-bold text-dark">Acciones (1 a 1):</span> 
                                            <span class="badge bg-light text-dark border">${proc.acciones}</span>
                                        </div>
                                    </div>

                                    <!-- MODO EDICIÓN (Oculto inicialmente; se activa con el botón de configuración) -->
                                    <div id="edit-${proc.id}" style="display: none;" class="bg-light p-3 border rounded mb-3">
                                        <form action="actualizar_procedimiento_servlet" method="POST">
                                            <input type="hidden" name="id" value="${proc.id}">
                                            <div class="row g-3 mb-3">
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold">Nombre</label>
                                                    <input type="text" class="form-control form-control-sm" name="nombre" value="${proc.name}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold">Tipo</label>
                                                    <input type="text" class="form-control form-control-sm" name="tipo" value="${proc.tipo}" required>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label small fw-semibold">Descripción</label>
                                                    <textarea class="form-control form-control-sm" name="descripcion" rows="2" required>${proc.desc}</textarea>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold">Secuencia</label>
                                                    <input type="text" class="form-control form-control-sm" name="secuencia" value="${proc.secuencia}" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label small fw-semibold">Acciones</label>
                                                    <input type="text" class="form-control form-control-sm" name="acciones" value="${proc.acciones}" required>
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-end gap-2">
                                                <button type="submit" class="btn btn-sm btn-lab">Actualizar en BD</button>
                                            </div>
                                        </form>
                                    </div>

                                    <!-- Botones de Control (Configurar y Borrar) -->
                                    <div class="d-flex justify-content-between align-items-center mt-3 pt-2 border-top">
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleEditMode('${proc.id}')">
                                            <i id="btn-icon-${proc.id}" class="bi bi-gear-fill"></i> <span id="btn-text-${proc.id}">Configurar</span>
                                        </button>
                                        
                                        <form action="/procedimientos/borrar" method="POST" class="d-inline">
                                            <input type="hidden" name="id" value="${proc.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i> Borrar</button>
                                        </form>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- ================= TAB 3: GESTIÓN DE MAQUINARIAS ================= -->
             <div class="tab-pane fade" id="maquinas-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-4">Gestión de Maquinaria</h4>

                <div class="table-responsive">
                    <table class="table table-dark table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Descripción</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="maq" items="${ListaMaquinarias}">
                                <tr>
                                    <td>${not empty maq.name ? maq.name : '-'}</td>
                                    <td>${not empty maq.dir ? maq.dir : '-'}</td>
                                    <td>${not empty maq.status ? maq.status : '-'}</td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-warning" 
                                                data-bs-toggle="modal" data-bs-target="#configMaquinariaModal"
                                                data-name="${maq.name}" data-desc="${maq.dir}" data-status="${maq.status}">
                                            <i class="bi bi-gear-fill"></i> Configurar
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <div class="modal fade" id="configMaquinariaModal" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content bg-dark text-white border-secondary">
                                        <form action="actualizar_maquinaria_servlet" method="POST">
                                            <div class="modal-header border-bottom border-secondary">
                                                <h5 class="modal-title text-ochre fw-bold">Configurar Maquinaria</h5>
                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Nombre de la Máquina</label>
                                                    <input type="text" class="form-control bg-secondary text-white border-0" id="modalMaqName" name="maquina_name" readonly>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Descripción</label>
                                                    <input type="text" class="form-control" id="modalMaqDesc" name="maquina_desc" required>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Estado</label>
                                                    <select class="form-select" id="modalMaqStatus" name="maquina_estado" required>
                                                        <option value="Activo">Activo</option>
                                                        <option value="Mantenimiento">Mantenimiento</option>
                                                        <option value="Inactivo">Inactivo</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="modal-footer border-top border-secondary">
                                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                <button type="submit" class="btn btn-warning fw-bold">Guardar Cambios</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- ================= TAB 4: GESTIÓN DE USUARIOS ================= -->
            <div class="tab-pane fade" id="usuarios-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-3">Gestión Restringida de Cuentas de Acceso Científico</h4>
                <p class="text-muted small">Panel exclusivo de administración directa de personal autorizado.</p>

                <!-- Formulario de Creación de Usuario -->
                <div class="card bg-light border-0 p-3 mb-4">
                    <h5 class="text-ochre mb-3">Crear Nuevo Usuario Directamente</h5>
                    <form action="crear_usuario_ad_servlet" method="POST">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Primer Nombre</label>
                                <input type="text" class="form-control" name="primerNombre" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Apellido</label>
                                <input type="text" class="form-control" name="apellido" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">DNI</label>
                                <input type="text" class="form-control" name="dni" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Email</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Username</label>
                                <input type="text" class="form-control" name="username" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">Password</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Nivel de Acceso</label>
                                <select class="form-select" name="nivelAcceso" required>
                                    <option value="None">None</option>
                                    <option value="Low">Low</option>
                                    <option value="Medium">Medium</option>
                                    <option value="High">High</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Role</label>
                                <select class="form-select" name="role" required>
                                    <option value="Practicante">Practicante</option>
                                    <option value="Junior">Junior</option>
                                    <option value="Senior">Senior</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-ochre btn-sm">Crear Cuenta de Usuario</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Lista vertical de usuarios registrados -->
                <h5 class="text-ochre mb-3">Personal Registrado</h5>
                <div class="d-flex flex-column gap-3">
    
                <c:forEach var="u" items="${listaUsuarios}">
                    <div class="card p-3 shadow-sm border-0">
                        <div class="row align-items-center">

                            <!-- Información del Usuario -->
                            <div class="col-md-3">
                                <strong>${not empty u.name ? u.name : ''}</strong><br>
                                <small class="text-muted">${not empty u.email ? u.email : '-'}</small>
                            </div>

                            <!-- Badge de Rol -->
                            <div class="col-md-2">
                                <span class="badge bg-secondary">Role: ${not empty u.role ? u.role : 'N/D'}</span>
                            </div>

                            <!-- Badge de Acceso -->
                            <div class="col-md-2">
                                <span class="badge bg-success">Acceso: ${not empty u.access ? u.access : 'N/D'}</span>
                            </div>

                            <!-- Acciones (Modificar Nivel/Rol y Borrar) -->
                            <div class="col-md-5 text-end">

                                <!-- Formulario para actualizar privilegios del usuario específico -->
                                <form action="${pageContext.request.contextPath}/usuarios/actualizar-privilegios" method="POST" class="row g-2 justify-content-end align-items-center d-inline-block">
                                    <input type="hidden" name="id" value="${u.id}">
                        
                                        <div class="col-auto">
                                            <select class="form-select form-select-sm" name="nivelAcceso">
                                                <option value="None" ${u.access == 'None' ? 'selected' : ''}>None</option>
                                                <option value="Low" ${u.access == 'Low' ? 'selected' : ''}>Low</option>
                                                <option value="Medium" ${u.access == 'Medium' ? 'selected' : ''}>Medium</option>
                                                <option value="High" ${u.access == 'High' ? 'selected' : ''}>High</option>
                                                <option value="Admin" ${u.access == 'Admin' ? 'selected' : ''}>Admin</option>
                                            </select>
                                        </div>

                                        <div class="col-auto">
                                            <select class="form-select form-select-sm" name="role">
                                                <option value="Practicante" ${u.role == 'Practicante' ? 'selected' : ''}>Practicante</option>
                                                <option value="Junior" ${u.role == 'Junior' ? 'selected' : ''}>Junior</option>
                                                <option value="Senior" ${u.role == 'Senior' ? 'selected' : ''}>Senior</option>
                                                <option value="Admin" ${u.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                            </select>
                                        </div>

                                        <div class="col-auto">
                                            <button type="submit" class="btn btn-sm btn-outline-primary" title="Guardar Cambios">
                                                <i class="bi bi-check-lg"></i>
                                            </button>
                                        </div>
                                    </form>

                                    <!-- Formulario para eliminar usuario -->
                                    <form action="${pageContext.request.contextPath}/usuarios/borrar" method="POST" class="d-inline ms-1">
                                        <input type="hidden" name="id" value="${u.id}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Borrar Usuario" onclick="return confirm('¿Estás seguro de eliminar este usuario?');">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </div>
            </div>

            <!-- ================= TAB 5: REPORTES ================= -->
            <div class="tab-pane fade" id="reportes-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-3">Generación de Reportes y Documentos</h4>
                <p class="text-muted small">Seleccione un apartado analítico para enviar la petición al Servlet generador correspondiente.</p>
                
                <div class="row g-4 mt-2">
                    <div class="col-md-6">
                        <div class="card card-metric p-4 h-100">
                            <h5 class="text-ochre fw-bold"><i class="bi bi-people-fill me-2"></i> Registro de Usuarios</h5>
                            <p class="text-muted small mt-2">Genera un documento consolidado con todo el personal, niveles de acceso y roles activos en el sistema.</p>
                            <a href="/reporteUsuariosServlet" class="btn btn-ochre mt-auto align-self-start btn-sm">Generar Registro de Usuarios</a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card card-metric p-4 h-100">
                            <h5 class="text-ochre fw-bold"><i class="bi bi-cpu-fill me-2"></i> Registro de Máquinas</h5>
                            <p class="text-muted small mt-2">Descarga el reporte técnico de maquinarias registradas, estados operativos y endpoints de webhooks.</p>
                            <a href="/reporteMaquinasServlet" class="btn btn-ochre mt-auto align-self-start btn-sm">Generar Registro de Máquinas</a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card card-metric p-4 h-100">
                            <h5 class="text-ochre fw-bold"><i class="bi bi-diagram-2-fill me-2"></i> Registro de Procedimientos</h5>
                            <p class="text-muted small mt-2">Obtén el compendio histórico de procedimientos, mapeos de máquinas y secuencias de acciones en paralelo.</p>
                            <a href="/reporteProcedimientosServlet" class="btn btn-ochre mt-auto align-self-start btn-sm">Generar Registro de Procedimientos</a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card card-metric p-4 h-100">
                            <h5 class="text-ochre fw-bold"><i class="bi bi-activity me-2"></i> Actividades de Usuarios</h5>
                            <p class="text-muted small mt-2">Auditoría detallada de las acciones realizadas por el personal científico y operativo en el panel de control.</p>
                            <a href="/reporteActividadesServlet" class="btn btn-ochre mt-auto align-self-start btn-sm">Generar Actividades de Usuarios</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap JS Bundle (Requerido solo para Tabs y Dropdowns con mínima intervención) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    
</body>
</html>