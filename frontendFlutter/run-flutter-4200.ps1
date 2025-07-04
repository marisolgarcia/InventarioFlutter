#!/usr/bin/env pwsh

# Script para ejecutar el frontend Flutter en el puerto 4200
# Este script debe ejecutarse desde la carpeta frontendFlutter

Write-Host "🚀 Iniciando servidor Flutter en puerto 4200..." -ForegroundColor Green
Write-Host "📂 Directorio actual: $(Get-Location)" -ForegroundColor Yellow

# Verificar que estamos en el directorio correcto
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "❌ Error: No se encontró pubspec.yaml. Asegúrate de ejecutar este script desde la carpeta frontendFlutter" -ForegroundColor Red
    exit 1
}

# Verificar que Flutter está instalado
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter"
    Write-Host "✅ Flutter detectado: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Flutter no está instalado o no está en el PATH" -ForegroundColor Red
    exit 1
}

# Obtener dependencias
Write-Host "📦 Obteniendo dependencias..." -ForegroundColor Yellow
flutter pub get

# Verificar que el backend está corriendo
Write-Host "🔍 Verificando conexión con el backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/inventario/productos" -Method GET -TimeoutSec 5
    Write-Host "✅ Backend disponible en puerto 8080" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Advertencia: Backend no disponible en puerto 8080. Asegúrate de iniciarlo primero." -ForegroundColor Yellow
    Write-Host "   Puedes iniciar el backend ejecutando: mvn spring-boot:run" -ForegroundColor Yellow
}

# Ejecutar Flutter en modo web con puerto 4200
Write-Host "🌐 Iniciando servidor web Flutter en puerto 4200..." -ForegroundColor Green
Write-Host "📱 La aplicación estará disponible en: http://localhost:4200" -ForegroundColor Cyan
Write-Host "🛑 Para detener el servidor, presiona Ctrl+C" -ForegroundColor Yellow

flutter run -d chrome --web-port 4200 --web-hostname 0.0.0.0
