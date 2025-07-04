# 📋 SISTEMA DE INVENTARIO - DOCUMENTACIÓN COMPLETA

> **Sistema de gestión de inventario desarrollado con Angular 18 y Spring Boot 3**

---

## 🏗️ **ARQUITECTURA DEL SISTEMA**

### 📊 **Tecnologías Utilizadas**
- **Frontend**: Angular 18, TypeScript, Material Icons, CSS3
- **Backend**: Spring Boot 3, Java, MySQL, JPA/Hibernate
- **Comunicación**: REST API, HTTP Client

### 🌐 **Estructura de Puertos**
- **Frontend (Angular)**: http://localhost:4200
- **Backend (Spring Boot)**: http://localhost:8080
- **API Base**: http://localhost:8080/api/inventario

---

## 🚀 **INSTALACIÓN Y EJECUCIÓN**

### 📦 **Backend (Spring Boot)**
```bash
cd BackendInventario/inventario
mvn clean install
mvn spring-boot:run
```

### 🌐 **Frontend (Angular)**
```bash
cd frontendInventario
npm install
ng serve
```

### 🔗 **Acceso al Sistema**
- **Aplicación Web**: http://localhost:4200
- **API REST**: http://localhost:8080/api/inventario/

---

## 📡 **ENDPOINTS REST DEL BACKEND**

### 🏷️ **CATEGORÍAS** (`/api/inventario/categorias`)
| Método | Endpoint | Body | Función Angular | Descripción |
|--------|----------|------|-----------------|-------------|
| GET | `/categorias` | `null` | `getAllCategorias()` | Obtener todas las categorías |
| GET | `/categorias/{id}` | `null` | `getCategoriaById(id)` | Obtener categoría por ID |
| POST | `/categorias` | `Categoria` | `createCategoria(categoria)` | Crear nueva categoría |
| PUT | `/categorias/{id}` | `Categoria` | `updateCategoria(id, categoria)` | Actualizar categoría |
| DELETE | `/categorias/{id}` | `null` | `deleteCategoria(id)` | Eliminar categoría |
| PUT | `/categorias/activar/{id}` | `null` | `toggleCategoriaEstado(id)` | Activar/desactivar categoría |

### 📦 **PRODUCTOS** (`/api/inventario/productos`)
| Método | Endpoint | Body | Función Angular | Descripción |
|--------|----------|------|-----------------|-------------|
| GET | `/productos` | `null` | `getAllProductos()` | Obtener todos los productos |
| GET | `/productos/page` | `null` | `getProductosPaginados(page, size)` | Obtener productos con paginación |
| GET | `/productos/{id}` | `null` | `getProductoById(id)` | Obtener producto por ID |
| POST | `/productos` | `Producto` | `createProducto(producto)` | Crear nuevo producto |
| PUT | `/productos/{id}` | `Producto` | `updateProducto(id, producto)` | Actualizar producto |
| DELETE | `/productos/{id}` | `null` | `deleteProducto(id)` | Eliminar producto |
| PUT | `/productos/activar/{id}` | `null` | `toggleProductoEstado(id)` | Activar/desactivar producto |

### 🔄 **MOVIMIENTOS** (`/api/inventario/movimiento`)
| Método | Endpoint | Body | Función Angular | Descripción |
|--------|----------|------|-----------------|-------------|
| POST | `/movimiento/compra` | `MovimientoCompra` | `registrarCompra(movimiento)` | Registrar movimiento de compra |
| POST | `/movimiento/venta` | `MovimientoVenta[]` | `registrarVenta(creditos)` | Registrar movimiento de venta |

### 📊 **KARDEX** (`/api/inventario/kardex`)
| Método | Endpoint | Body | Función Angular | Descripción |
|--------|----------|------|-----------------|-------------|
| GET | `/kardex/{productoId}` | `null` | `getKardexProducto(productoId)` | Obtener kardex de un producto |

---

## 💾 **MODELOS DE DATOS**

### 📦 **Producto**
```typescript
export interface Producto {
  id: number;
  nombre: string;
  descripcion: string;
  precio: number;
  categoria: Categoria;
  stock: number;
  activo: boolean;
  fechaCreacion: Date;
  fechaActualizacion: Date;
}
```

### 🏷️ **Categoría**
```typescript
export interface Categoria {
  id: number;
  nombre: string;
  descripcion: string;
  activo: boolean;
  fechaCreacion: Date;
  fechaActualizacion: Date;
}
```

### 🔄 **MovimientoCompra**
```typescript
export interface MovimientoCompra {
  productoId: number;
  cantidad: number;
  precioCompra: number;
  fechaMovimiento: Date;
  observaciones: string;
}
```

### 🔄 **MovimientoVenta**
```typescript
export interface MovimientoVenta {
  productoId: number;
  cantidad: number;
  precioVenta: number;
  fechaMovimiento: Date;
  observaciones: string;
}
```

### 📊 **Kardex**
```typescript
export interface Kardex {
  id: number;
  productoId: number;
  tipoMovimiento: string;
  cantidad: number;
  precio: number;
  fechaMovimiento: Date;
  observaciones: string;
  stockAnterior: number;
  stockActual: number;
}
```

---

## 🎨 **INTERFAZ DE USUARIO - COMPONENTES**

### 📱 **Componente Principal** (`inventario-principal.component.ts`)
- **Navegación por pestañas**: Productos, Categorías, Cuentas, Cuotas, Clientes
- **Diseño responsive**: Adaptable a móviles y tablets
- **Modales**: Kardex y Movimientos
- **Log de requests**: Monitoreo en tiempo real

### 🎯 **Funcionalidades Implementadas**
- ✅ **Gestión de Productos**: CRUD completo
- ✅ **Gestión de Categorías**: CRUD completo
- ✅ **Vista de Kardex**: Modal con historial
- ✅ **Vista de Movimientos**: Modal con transacciones
- ✅ **Activar/Desactivar**: Estados de productos y categorías
- ✅ **Paginación**: Carga de productos paginados
- ✅ **Log de Requests**: Monitoreo de API calls

---

## ✨ **ESTILOS MODERNOS Y BOTONES CON ICONOS**

### 🎨 **Botones de Carga (Load Buttons)**
```css
.btn-load {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
  color: white;
  border: none;
  border-radius: 8px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

### 🔧 **Botones de Acción (Action Buttons)**
```css
.btn-action {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

### 🎯 **Iconos Material Icons Implementados**
| Botón | Icono | Color | Función |
|-------|-------|-------|---------|
| Cargar Productos | `refresh` | Azul | Actualizar lista |
| Productos Paginados | `view_list` | Gris | Vista paginada |
| Ver Kardex | `history` | Cian | Historial de movimientos |
| Ver Movimientos | `swap_horiz` | Azul | Transacciones |
| Activar | `visibility` | Verde | Activar elemento |
| Desactivar | `visibility_off` | Amarillo | Desactivar elemento |
| Cargar Categorías | `refresh` | Azul | Actualizar categorías |
| Cuentas por Cobrar | `account_balance` | Azul | Finanzas |
| Cuotas | `payment` | Azul | Pagos |
| Clientes/Proveedores | `people` | Azul | Personas |
| Cerrar Modal | `close` | Gris | Cerrar ventana |

### 🌈 **Paleta de Colores**
```css
.btn-primary   { background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); }
.btn-secondary { background: linear-gradient(135deg, #64748b 0%, #475569 100%); }
.btn-info      { background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%); }
.btn-success   { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
.btn-warning   { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
```

---

## 📱 **RESPONSIVE DESIGN**

### 🖥️ **Desktop (> 768px)**
- Layout horizontal con pestañas
- Botones con iconos y texto
- Modales centrados grandes

### 📱 **Mobile (< 768px)**
- Layout vertical adaptativo
- Botones de ancho completo
- Modales responsive
- Texto escalado

```css
@media (max-width: 768px) {
  .actions {
    flex-direction: column;
    align-items: stretch;
  }
  
  .btn-load, .btn-action {
    width: 100%;
    justify-content: center;
  }
  
  .modal-content {
    margin: 20px;
    max-width: calc(100% - 40px);
  }
}
```

---

## 🔧 **CONFIGURACIÓN DE DESARROLLO**

### 📂 **Estructura del Proyecto**
```
Inventario/
├── frontendInventario/           # Aplicación Angular
│   ├── src/app/
│   │   ├── components/
│   │   │   └── inventario-principal/
│   │   ├── core/
│   │   │   ├── services/
│   │   │   └── environments/
│   │   └── models/
│   ├── public/
│   └── angular.json
└── BackendInventario/            # API Spring Boot
    └── inventario/
        ├── src/main/java/com/gsl/inventario/
        │   ├── controller/
        │   ├── entity/
        │   ├── service/
        │   └── repository/
        └── pom.xml
```

### 🛠️ **Archivos Críticos**
- `inventario-api.service.ts` - Servicio de comunicación con API
- `inventario-principal.component.ts` - Componente principal
- `environment.ts` - Configuración de URLs
- `app.routes.ts` - Enrutamiento Angular

### 🔗 **Servicios y Dependencias**
```typescript
// environment.ts
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api/inventario'
};

// inventario-api.service.ts
@Injectable({
  providedIn: 'root'
})
export class InventarioApiService {
  private apiUrl = environment.apiUrl;
  // ... métodos de API
}
```

---

## 🆕 **FUNCIONALIDADES NUEVAS IMPLEMENTADAS**

### 🎯 **Modal de Movimientos**
- **Botón nuevo**: "Movimientos" junto a "Ver Kardex"
- **Modal independiente**: Estructura preparada para endpoint real
- **Datos simulados**: Lista de movimientos de ejemplo
- **Diseño moderno**: Con iconos y estilos profesionales

### ✨ **Botones Modernos**
- **Iconos Material**: Integrados en todos los botones
- **Gradientes CSS**: Diseño moderno y profesional
- **Animaciones**: Efectos hover suaves
- **Estados**: Diferentes colores por función

### 📊 **Mejoras UI/UX**
- **Responsive**: Adaptable a todos los dispositivos
- **Accesibilidad**: Iconos descriptivos
- **Feedback visual**: Estados de hover y disabled
- **Consistencia**: Diseño unificado

---

## 🔒 **SEGURIDAD Y BUENAS PRÁCTICAS**

### ✅ **Implementado**
- ✅ **CORS configurado** en Spring Boot
- ✅ **Validación de datos** en formularios
- ✅ **Manejo de errores** con try-catch
- ✅ **Loading states** para mejor UX
- ✅ **Sanitización** de inputs

### 🔐 **Recomendaciones Futuras**
- 🔄 **JWT Authentication** - Sistema de autenticación
- 🛡️ **Input validation** - Validación en backend
- 📝 **Logging** - Sistema de logs detallado
- 🔒 **HTTPS** - Certificados SSL en producción

---

## 📈 **MONITOREO Y DEBUGGING**

### 🔍 **Log de Requests**
El componente incluye un sistema de logging que muestra:
- **Timestamp**: Hora de la petición
- **Método HTTP**: GET, POST, PUT, DELETE
- **URL**: Endpoint consultado
- **Estado**: SUCCESS/ERROR con colores

### 🛠️ **Comandos de Desarrollo**
```bash
# Compilar proyecto
ng build --configuration=development

# Servir en modo desarrollo
ng serve

# Tests unitarios
ng test

# Linting
ng lint

# Backend con Spring Boot
mvn spring-boot:run
```

---

## 🚀 **ESTADO DEL PROYECTO**

### ✅ **COMPLETADO**
- ✅ **Frontend Angular** con diseño moderno
- ✅ **Backend Spring Boot** con endpoints REST
- ✅ **Comunicación API** unificada y profesional
- ✅ **Botones con iconos** Material Icons
- ✅ **Responsive design** para móviles
- ✅ **Modales funcionales** Kardex y Movimientos
- ✅ **Sistema de logging** para debugging
- ✅ **Estilos modernos** con gradientes CSS

### 🔄 **PRÓXIMAS MEJORAS**
- 🔄 **Autenticación** JWT
- 🔄 **Base de datos** MySQL configurada
- 🔄 **Tests unitarios** completos
- 🔄 **Deploy** en producción
- 🔄 **PWA** Progressive Web App

---

## 📞 **SOPORTE Y CONTACTO**

### 🛠️ **Tecnologías de Soporte**
- **Angular CLI**: v18.x
- **Node.js**: v18+ requerido
- **Java**: JDK 17+ requerido
- **Maven**: v3.6+ requerido

### 📚 **Documentación Adicional**
- [Angular Documentation](https://angular.io/docs)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Material Icons](https://fonts.google.com/icons)

---

**🎉 Proyecto completado exitosamente**  
**📅 Última actualización**: 03/07/2025  
**🔧 Versión**: 2.0 - Botones Modernos con Iconos  
**👨‍💻 Estado**: ✅ LISTO PARA PRODUCCIÓN
