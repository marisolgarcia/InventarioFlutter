import '../config/app_config.dart';

class AppConfigWeb extends AppConfig {
  // Para desarrollo web, podemos usar un proxy o cambiar la URL
  static const String baseUrlWeb = '/api/inventario/';
  
  // Override para web
  static String get effectiveBaseUrl {
    return baseUrlWeb;
  }
}
