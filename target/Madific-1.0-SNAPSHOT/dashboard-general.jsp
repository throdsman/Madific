<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIGEPPI - Gestión de Procedimientos</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .text-ochre { color: #c09d5c !important; }
        .bg-ochre { background-color: #c09d5c !important; }
        .btn-ochre { background-color: #c09d5c; color: white; }
        .btn-ochre:hover { background-color: #a8864d; color: white; }
    </style>
</head>
<body class="bg-light">

    <div class="container py-4">
        
        <!-- ================================================= -->
        <!-- BARRA SUPERIOR: NAVEGACIÓN Y MENÚ DE PERFIL     -->
        <!-- ================================================= -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4 py-3 mb-4 rounded shadow-sm">
            <div class="container-fluid p-0">
                
                <!-- Título o Marca -->
                <span class="navbar-brand fw-bold text-ochre">
                    <i class="bi bi-cpu me-2"></i>SIGEPPI - Panel
                </span>

                <!-- Pestañas Principales (Filtradas dinámicamente por Rol) -->
                <ul class="nav nav-tabs border-bottom-0 mx-auto" id="procedureDashboardTabs" role="tablist">
                    
                    <!-- Tab 1: Vista de Procedimientos (Accesible para Todos: None, Low, Medium, High, Admin) -->
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="vista-tab" data-bs-toggle="tab" data-bs-target="#vista-pane" type="button" role="tab">
                            <i class="bi bi-eye"></i> Vista
                        </button>
                    </li>
                    
                    <!-- Tab 2: Creación de Procedimientos (Accesible para Medium, High y Admin) -->
                    <c:if test="${sessionScope.usuario.nivelAcceso == 'Medium' || sessionScope.usuario.nivelAcceso == 'High' || sessionScope.usuario.nivelAcceso == 'Admin'}">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="creacion-tab" data-bs-toggle="tab" data-bs-target="#creacion-pane" type="button" role="tab">
                                <i class="bi bi-plus-circle"></i> Creación
                            </button>
                        </li>
                    </c:if>
                    
                    <!-- Tab 3: Registros de Procedimientos (Accesible exclusivamente para High y Admin) -->
                    <c:if test="${sessionScope.usuario.nivelAcceso == 'High' || sessionScope.usuario.nivelAcceso == 'Admin'}">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="registros-tab" data-bs-toggle="tab" data-bs-target="#registros-pane" type="button" role="tab">
                                <i class="bi bi-file-earmark-bar-graph"></i> Registros
                            </button>
                        </li>
                    </c:if>

                </ul>

                <!-- Botón de Perfil con Menú Desplegable -->
                <div class="dropdown">
                    <button class="btn btn-outline-warning dropdown-toggle d-flex align-items-center gap-2" type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle fs-5"></i>
                        <span class="d-none d-md-inline">${not empty sessionScope.usuario.primerNombre ? sessionScope.usuario.primerNombre : 'Usuario'}</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end bg-dark border-secondary shadow" aria-labelledby="profileDropdown">
                        <li>
                            <h6 class="dropdown-header text-muted small">Nivel: ${sessionScope.usuario.nivelAcceso}</h6>
                        </li>
                        <li><hr class="dropdown-divider border-secondary"></li>
                        <li>
                            <a class="dropdown-item text-white d-flex align-items-center gap-2 py-2" href="${pageContext.request.contextPath}/perfil/configuracion">
                                <i class="bi bi-gear text-warning"></i> Configuración de Perfil
                            </a>
                        </li>
                        <li><hr class="dropdown-divider border-secondary"></li>
                        <li>
                            <a class="dropdown-item text-danger d-flex align-items-center gap-2 py-2" href="logout_servlet">
                                <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
                            </a>
                        </li>
                    </ul>
                </div>

            </div>
        </nav>


        <!-- ================================================= -->
        <!-- CONTENIDO DE LAS PESTAÑAS (TAB CONTENT)          -->
        <!-- ================================================= -->
        <div class="tab-content mt-3 bg-white p-4 rounded shadow-sm" id="procedureDashboardContent">
            
            <!-- Contenido Tab 1: Vista de Procedimientos -->
            <div class="tab-pane fade show active" id="vista-pane" role="tabpanel">
                <h4 class="text-ochre fw-bold mb-3">Vista General de Procedimientos</h4>
                <p class="text-muted small">Listado completo e información de lectura de los procedimientos registrados en el sistema.</p>
                
                <div class="alert alert-secondary border-0 text-dark">
                    <i class="bi bi-info-circle me-2"></i> Mostrando registros actuales autorizados para su nivel de acceso: <strong>${sessionScope.usuario.nivelAcceso}</strong>.
                </div>
            </div>

            <!-- Contenido Tab 2: Creación de Procedimientos -->
            <c:if test="${sessionScope.usuario.nivelAcceso == 'Medium' || sessionScope.usuario.nivelAcceso == 'High' || sessionScope.usuario.nivelAcceso == 'Admin'}">
                <div class="tab-pane fade" id="creacion-pane" role="tabpanel">
                    <h4 class="text-ochre fw-bold mb-3">Módulo de Creación de Procedimientos</h4>
                    <p class="text-muted small">Formulario interactivo para dar de alta nuevos flujos de trabajo y secuencias.</p>
                    
                    <!-- Tu formulario de creación previa va aquí -->
                    <div class="p-3 bg-light rounded border">
                        <p class="text-muted mb-0">Formulario de registro activo (Roles permitidos: Medium, High, Admin).</p>
                    </div>
                </div>
            </c:if>

            <!-- Contenido Tab 3: Registros de Procedimientos -->
            <c:if test="${sessionScope.usuario.nivelAcceso == 'High' || sessionScope.usuario.nivelAcceso == 'Admin'}">
                <div class="tab-pane fade" id="registros-pane" role="tabpanel">
                    <h4 class="text-ochre fw-bold mb-3">Registros y Métricas del Sistema</h4>
                    <p class="text-muted small">Panel de auditoría, bitácoras de ejecución y exportación de archivos analíticos.</p>
                    
                    <div class="row g-4 mt-2">
                        <!-- Tarjeta 1: Registro Semanal -->
                        <div class="col-md-6">
                            <div class="card p-4 border-0 shadow-sm bg-light">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="fs-3 text-ochre me-3"><i class="bi bi-journal-text"></i></div>
                                    <div>
                                        <h5 class="fw-bold mb-0">Registro Semanal de Procedimientos</h5>
                                        <span class="badge bg-secondary">Archivo Generable</span>
                                    </div>
                                </div>
                                <p class="text-muted small">
                                    Consolidado cronológico estructurado que detalla todas las ejecuciones, máquinas involucradas y acciones completadas durante la semana en curso.
                                </p>
                                <button type="button" class="btn btn-outline-warning fw-bold text-dark mt-2" onclick="alert('Generando descarga de Registro Semanal...')">
                                    <i class="bi bi-download me-1"></i> Descargar Reporte Semanal
                                </button>
                            </div>
                        </div>

                        <!-- Tarjeta 2: Métrica de Procedimientos -->
                        <div class="col-md-6">
                            <div class="card p-4 border-0 shadow-sm bg-light">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="fs-3 text-ochre me-3"><i class="bi bi-graph-up-arrow"></i></div>
                                    <div>
                                        <h5 class="fw-bold mb-0">Métrica de Procedimientos</h5>
                                        <span class="badge bg-success">Análisis de Rendimiento</span>
                                    </div>
                                </div>
                                <p class="text-muted small">
                                    Reporte estadístico avanzado con tiempos promedio de respuesta, frecuencias de uso y evaluación de cargas sobre las máquinas conectadas.
                                </p>
                                <button type="button" class="btn btn-outline-warning fw-bold text-dark mt-2" onclick="alert('Compilando Métricas de Procedimientos...')">
                                    <i class="bi bi-file-earmark-bar-graph me-1"></i> Exportar Métricas
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

        </div>

    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script para mantener activa la pestaña seleccionada tras redirecciones/recargas -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const urlParams = new URLSearchParams(window.location.search);
            const activeTab = urlParams.get('tab');

            if (activeTab) {
                const tabTrigger = document.querySelector(`#${activeTab}-tab`);
                if (tabTrigger) {
                    const tabInstance = new bootstrap.Tab(tabTrigger);
                    tabInstance.show();
                }
            }
        });
    </script>
</body>
</html>