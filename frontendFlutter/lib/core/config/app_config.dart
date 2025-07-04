class AppConfig {
  // URL base del backend Java - Cambia según tu configuración
  static const String baseUrl = 'http://localhost:8080/api/inventario/';
  
  // Configuración de la aplicación
  static const String appName = 'Sistema de Inventario';
  static const String version = '1.0.0';
  
  // Configuración de HTTP
  static const int timeoutSeconds = 30;
  
  // Configuración de paginación
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // Configuración de desarrollo
  static const bool enableDebugMode = true;
  static const bool enableLogging = true;
}
