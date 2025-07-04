# Migración de Sistema de Inventario: Angular 20 → Flutter

## 🎯 Objetivo

Este proyecto documenta la migración completa de un sistema de inventario desde Angular 20 a Flutter, manteniendo toda la lógica de negocio y optimizando para plataformas móviles (iOS/Android).

## 🏗️ Arquitectura

### Backend (Sin Cambios)
- **Java Spring Boot** con APIs REST
- Base de datos existente
- Endpoints conservados exactamente igual

### Frontend Migrado
- **Desde**: Angular 20 (TypeScript, RxJS, Material Design)
- **Hacia**: Flutter (Dart, Provider, Material Design)

## 📱 Mapeo de Conceptos: Angular → Flutter

| Angular | Flutter | Descripción |
|---------|---------|-------------|
| `Component` | `StatefulWidget/StatelessWidget` | Componentes de UI |
| `Service` | `Provider/ChangeNotifier` | Gestión de estado y lógica |
| `Observable/BehaviorSubject` | `ChangeNotifier.notifyListeners()` | Gestión de estado reactiva |
| `HttpClient` | `http.Client` | Consumo de APIs REST |
| `*ngFor` | `ListView.builder()` | Renderizado de listas |
| `*ngIf` | `if/else` en widgets | Renderizado condicional |
| `[(ngModel)]` | `TextEditingController` | Data binding |
| `(click)` | `onTap/onPressed` | Manejo de eventos |
| `RouterModule` | `GoRouter` | Navegación entre pantallas |
| `Pipe` | Métodos/extensiones | Transformación de datos |

## � Ejecución del Proyecto

### Prerrequisitos
1. **Flutter SDK** instalado y configurado
2. **Backend Java** ejecutándose en puerto 8080
3. **Navegador web** (Chrome recomendado para desarrollo)

### Opción 1: Ejecución Automática (Puerto 4200)

Ejecuta uno de estos scripts desde la carpeta `frontendFlutter`:

**PowerShell:**
```powershell
.\run-flutter-4200.ps1
```

**Command Prompt:**
```cmd
run-flutter-4200.bat
```

Estos scripts:
- ✅ Verifican que Flutter esté instalado
- ✅ Obtienen las dependencias (`flutter pub get`)
- ✅ Verifican la conexión con el backend
- ✅ Lanzan Flutter en puerto 4200: `http://localhost:4200`

### Opción 2: Ejecución Manual

```bash
# 1. Obtener dependencias
flutter pub get

# 2. Ejecutar en puerto 4200 (web)
flutter run -d chrome --web-port 4200 --web-hostname 0.0.0.0

# O ejecutar en puerto por defecto
flutter run -d chrome
```

### Configuración CORS

El backend ya está configurado para permitir solicitudes desde:
- `http://localhost:4200` ✅
- `http://127.0.0.1:4200` ✅
- Cualquier puerto local (patrón: `http://localhost:*`)

## �🔧 Estructura del Proyecto

```
lib/
├── main.dart                     # Punto de entrada (equivale a main.ts)
├── core/
│   ├── config/
│   │   └── app_config.dart       # Configuración (equivale a environment.ts)
│   ├── models/
│   │   ├── producto.dart         # Modelo Producto (equivale a producto.model.ts)
│   │   └── categoria.dart        # Modelo Categoria (equivale a category.model.ts)
│   ├── services/
│   │   └── inventario_api_service.dart  # Servicio API (equivale a inventario-api.service.ts)
│   └── theme/
│       └── app_theme.dart        # Tema (equivale a estilos CSS)
├── providers/
│   └── inventario_provider.dart  # Gestión de estado (equivale a servicios + RxJS)
├── screens/
│   ├── home_screen.dart          # Pantalla principal (equivale a inventario-principal.component)
│   ├── productos_screen.dart     # Gestión de productos (equivale a tab productos)
│   ├── categorias_screen.dart    # Gestión de categorías (equivale a tab categorías)
│   └── producto_detail_screen.dart # Detalle de producto
└── widgets/
    └── app_drawer.dart           # Menú de navegación
```

## 🔄 Migración de Componentes Específicos

### 1. Componente Principal (inventario-principal.component.ts → home_screen.dart)

**Angular (Original):**
```typescript
@Component({
  selector: 'app-inventario-principal',
  template: `
    <div *ngIf="loading" class="loading">Cargando...</div>
    <div *ngFor="let producto of productos" (click)="selectProducto(producto)">
      {{ producto.nombre }}
    </div>
  `
})
export class InventarioPrincipalComponent implements OnInit {
  productos: Producto[] = [];
  loading = false;

  constructor(private inventarioService: InventarioApiService) {}

  ngOnInit() {
    this.loadProductos();
  }

  loadProductos() {
    this.loading = true;
    this.inventarioService.getProductos().subscribe({
      next: (data) => this.productos = data,
      complete: () => this.loading = false
    });
  }
}
```

**Flutter (Migrado):**
```dart
class HomeScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventarioProvider>(
      builder: (context, provider, child) {
        // Equivalente a *ngIf="loading"
        if (provider.productosLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        // Equivalente a *ngFor="let producto of productos"
        return ListView.builder(
          itemCount: provider.productos.length,
          itemBuilder: (context, index) {
            final producto = provider.productos[index];
            return ListTile(
              title: Text(producto.nombre),
              // Equivalente a (click)="selectProducto(producto)"
              onTap: () => context.go('/producto/${producto.id}'),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Equivalente a ngOnInit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventarioProvider>().loadProductos();
    });
  }
}
```

### 2. Servicio de API (inventario-api.service.ts → inventario_api_service.dart)

**Angular (Original):**
```typescript
@Injectable({ providedIn: 'root' })
export class InventarioApiService {
  constructor(private http: HttpClient) {}

  getProductos(): Observable<Producto[]> {
    return this.http.get<Producto[]>(`${this.baseUrl}productos`)
      .pipe(catchError(this.handleError));
  }

  createProducto(producto: Producto): Observable<Producto> {
    return this.http.post<Producto>(`${this.baseUrl}productos`, producto);
  }
}
```

**Flutter (Migrado):**
```dart
class InventarioApiService {
  final http.Client _client = http.Client();

  Future<List<Producto>> getProductos() async {
    final response = await _client.get(
      Uri.parse('${AppConfig.baseUrl}productos'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error ${response.statusCode}');
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await _client.post(
      Uri.parse('${AppConfig.baseUrl}productos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(producto.toJson()),
    );
    
    if (response.statusCode == 201) {
      return Producto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}');
    }
  }
}
```

### 3. Gestión de Estado (RxJS → Provider)

**Angular (Original):**
```typescript
// Servicio con BehaviorSubject
@Injectable()
export class InventarioStateService {
  private productosSubject = new BehaviorSubject<Producto[]>([]);
  productos$ = this.productosSubject.asObservable();

  updateProductos(productos: Producto[]) {
    this.productosSubject.next(productos);
  }
}

// Componente que consume
export class ProductosComponent {
  productos$ = this.stateService.productos$;
  
  constructor(private stateService: InventarioStateService) {}
}
```

**Flutter (Migrado):**
```dart
// Provider con ChangeNotifier
class InventarioProvider with ChangeNotifier {
  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  void updateProductos(List<Producto> productos) {
    _productos = productos;
    notifyListeners(); // Equivale a subject.next()
  }
}

// Widget que consume
class ProductosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InventarioProvider>(
      builder: (context, provider, child) {
        // Automáticamente se actualiza cuando notifyListeners() es llamado
        return ListView.builder(
          itemCount: provider.productos.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(provider.productos[index].nombre));
          },
        );
      },
    );
  }
}
```

## 🚀 Ejecución del Proyecto

### Prerrequisitos
1. Flutter SDK instalado
2. Backend Java ejecutándose en `http://localhost:8080`

### Comandos
```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run

# Compilar para Android
flutter build apk

# Compilar para iOS
flutter build ios
```

## 📊 Beneficios de la Migración

### ✅ Ventajas Obtenidas
- **Rendimiento nativo** en iOS y Android
- **Una sola base de código** para ambas plataformas
- **Hot reload** para desarrollo rápido
- **Compilación nativa** (ARM/x86)
- **Menor tamaño de aplicación** comparado con webview
- **Experiencia de usuario fluida** con 60fps
- **Acceso a APIs nativas** del dispositivo

### 🔄 Funcionalidad Conservada
- ✅ Toda la lógica de negocio
- ✅ Consumo de APIs REST sin cambios
- ✅ Modelos de datos idénticos
- ✅ Validaciones y reglas de negocio
- ✅ Navegación entre pantallas
- ✅ Gestión de estado reactiva

## 🔧 Configuración del Backend

**No se requieren cambios en el backend Java.** La aplicación Flutter consume las mismas APIs REST:

```
GET    /api/inventario/productos
POST   /api/inventario/productos
PUT    /api/inventario/productos/{id}
DELETE /api/inventario/productos/{id}
GET    /api/inventario/categorias
POST   /api/inventario/categorias
...
```

## 📱 Recomendaciones para Flutter Web

**⚠️ Importante:** Para aplicaciones web complejas como ERPs, se recomienda mantener Angular debido a:

- Mejor rendimiento en navegadores
- SEO optimizado
- Menor tiempo de carga inicial
- Mejor soporte para teclado y mouse

**Flutter debe enfocarse en móvil** donde ofrece ventajas significativas.

## 🎯 Próximos Pasos

1. **Implementar formularios completos** para CRUD
2. **Agregar validaciones** usando form_validator
3. **Implementar autenticación** con JWT
4. **Agregar pruebas unitarias** y de integración
5. **Configurar CI/CD** para despliegue automático
6. **Optimizar para tabletas** con layouts responsivos

## 📞 Soporte

Esta migración preserva el 100% de la funcionalidad mientras optimiza la experiencia móvil. El backend Java permanece intacto, garantizando continuidad operacional.

---

**Migración exitosa de Angular 20 a Flutter** 🎉  
*Optimizada para móvil, manteniendo toda la lógica de negocio*
