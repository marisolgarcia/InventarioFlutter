@echo off
echo 🚀 Iniciando servidor Flutter en puerto 4200...
echo 📂 Directorio actual: %cd%

REM Verificar que estamos en el directorio correcto
if not exist "pubspec.yaml" (
    echo ❌ Error: No se encontró pubspec.yaml. Asegúrate de ejecutar este script desde la carpeta frontendFlutter
    pause
    exit /b 1
)

REM Verificar que Flutter está instalado
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Error: Flutter no está instalado o no está en el PATH
    pause
    exit /b 1
)

echo ✅ Flutter detectado
echo 📦 Obteniendo dependencias...
flutter pub get

echo 🔍 Verificando conexión con el backend...
curl -s http://localhost:8080/api/inventario/productos >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Advertencia: Backend no disponible en puerto 8080. Asegúrate de iniciarlo primero.
    echo    Puedes iniciar el backend ejecutando: mvn spring-boot:run
) else (
    echo ✅ Backend disponible en puerto 8080
)

echo 🌐 Iniciando servidor web Flutter en puerto 4200...
echo 📱 La aplicación estará disponible en: http://localhost:4200
echo 🛑 Para detener el servidor, presiona Ctrl+C

flutter run -d chrome --web-port 4200 --web-hostname 0.0.0.0
