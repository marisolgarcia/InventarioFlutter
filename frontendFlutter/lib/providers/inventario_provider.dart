import 'package:flutter/foundation.dart';
import '../core/models/producto.dart';
import '../core/models/categoria.dart';
import '../core/services/inventario_api_service.dart';

/// Provider para la gestión de estado del inventario
/// Equivalente a los servicios de Angular con RxJS/BehaviorSubject
class InventarioProvider with ChangeNotifier {
  final InventarioApiService _apiService = InventarioApiService();

  // ==================== PRODUCTOS ====================
  List<Producto> _productos = [];
  bool _productosLoading = false;
  String? _productosError;
  
  // Paginación
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  // ==================== CATEGORÍAS ====================
  List<Categoria> _categorias = [];
  bool _categoriasLoading = false;
  String? _categoriasError;

  // ==================== GETTERS ====================
  // Equivalente a los observables de Angular
  List<Producto> get productos => _productos;
  bool get productosLoading => _productosLoading;
  String? get productosError => _productosError;
  
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;

  List<Categoria> get categorias => _categorias;
  bool get categoriasLoading => _categoriasLoading;
  String? get categoriasError => _categoriasError;

  // ==================== MÉTODOS DE PRODUCTOS ====================

  /// Cargar todos los productos - Equivalente a loadProductos() en Angular
  Future<void> loadProductos() async {
    print('🔄 Iniciando carga de productos...');
    _productosLoading = true;
    _productosError = null;
    notifyListeners(); // Equivalente a next() en BehaviorSubject

    try {
      _productos = await _apiService.getProductos();
      print('✅ Productos cargados: ${_productos.length} items');
      print('📦 Productos: ${_productos.map((p) => p.nombreProd).join(', ')}');
    } catch (e) {
      print('❌ Error cargando productos: $e');
      _productosError = e.toString();
    } finally {
      _productosLoading = false;
      notifyListeners();
    }
  }

  /// Cargar productos paginados - Equivalente a loadProductosPaginados() en Angular
  Future<void> loadProductosPaginados({int page = 0, int size = 10}) async {
    _productosLoading = true;
    _productosError = null;
    notifyListeners();

    try {
      final result = await _apiService.getProductosPaginados(page: page, size: size);
      _productos = result['productos'];
      _currentPage = result['currentPage'];
      _totalPages = result['totalPages'];
      _totalElements = result['totalElements'];
      _hasNextPage = result['hasNext'];
      _hasPreviousPage = result['hasPrevious'];
    } catch (e) {
      _productosError = e.toString();
    } finally {
      _productosLoading = false;
      notifyListeners();
    }
  }

  /// Obtener producto por ID
  Future<Producto?> getProductoById(int id) async {
    try {
      return await _apiService.getProductoById(id);
    } catch (e) {
      _productosError = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Crear producto - Equivalente a createProducto() en Angular
  Future<bool> createProducto(Producto producto) async {
    try {
      final newProducto = await _apiService.createProducto(producto);
      _productos.add(newProducto);
      notifyListeners();
      return true;
    } catch (e) {
      _productosError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar producto - Equivalente a updateProducto() en Angular
  Future<bool> updateProducto(int id, Producto producto) async {
    try {
      final updatedProducto = await _apiService.updateProducto(id, producto);
      final index = _productos.indexWhere((p) => p.codigoProd == id);
      if (index != -1) {
        _productos[index] = updatedProducto;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _productosError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Eliminar producto - Equivalente a deleteProducto() en Angular
  Future<bool> deleteProducto(int id) async {
    try {
      await _apiService.deleteProducto(id);
      _productos.removeWhere((p) => p.codigoProd == id);
      notifyListeners();
      return true;
    } catch (e) {
      _productosError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cambiar estado del producto - Equivalente a toggleProductoEstado() en Angular
  Future<bool> toggleProductoEstado(int id) async {
    try {
      final updatedProducto = await _apiService.toggleProductoEstado(id);
      final index = _productos.indexWhere((p) => p.codigoProd == id);
      if (index != -1) {
        _productos[index] = updatedProducto;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _productosError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== NAVEGACIÓN DE PÁGINAS ====================

  /// Ir a la página siguiente
  Future<void> nextPage() async {
    if (_hasNextPage) {
      await loadProductosPaginados(page: _currentPage + 1);
    }
  }

  /// Ir a la página anterior
  Future<void> previousPage() async {
    if (_hasPreviousPage) {
      await loadProductosPaginados(page: _currentPage - 1);
    }
  }

  // ==================== MÉTODOS DE CATEGORÍAS ====================

  /// Cargar todas las categorías - Equivalente a loadCategorias() en Angular
  Future<void> loadCategorias() async {
    print('🔄 Iniciando carga de categorías...');
    _categoriasLoading = true;
    _categoriasError = null;
    notifyListeners();

    try {
      _categorias = await _apiService.getCategorias();
      print('✅ Categorías cargadas: ${_categorias.length} items');
      print('📂 Categorías: ${_categorias.map((c) => c.nombre).join(', ')}');
    } catch (e) {
      print('❌ Error cargando categorías: $e');
      _categoriasError = e.toString();
    } finally {
      _categoriasLoading = false;
      notifyListeners();
    }
  }

  /// Obtener categoría por ID
  Future<Categoria?> getCategoriaById(int id) async {
    try {
      return await _apiService.getCategoriaById(id);
    } catch (e) {
      _categoriasError = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Crear categoría - Equivalente a createCategoria() en Angular
  Future<bool> createCategoria(Categoria categoria) async {
    try {
      final newCategoria = await _apiService.createCategoria(categoria);
      _categorias.add(newCategoria);
      notifyListeners();
      return true;
    } catch (e) {
      _categoriasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar categoría - Equivalente a updateCategoria() en Angular
  Future<bool> updateCategoria(int id, Categoria categoria) async {
    try {
      final updatedCategoria = await _apiService.updateCategoria(id, categoria);
      final index = _categorias.indexWhere((c) => c.codigo == id);
      if (index != -1) {
        _categorias[index] = updatedCategoria;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _categoriasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Eliminar categoría - Equivalente a deleteCategoria() en Angular
  Future<bool> deleteCategoria(int id) async {
    try {
      await _apiService.deleteCategoria(id);
      _categorias.removeWhere((c) => c.codigo == id);
      notifyListeners();
      return true;
    } catch (e) {
      _categoriasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== MÉTODOS UTILITARIOS ====================

  /// Limpiar errores
  void clearErrors() {
    _productosError = null;
    _categoriasError = null;
    notifyListeners();
  }

  /// Filtrar productos por categoría - Equivalente a pipes en Angular
  List<Producto> getProductosByCategoria(String codigoCategoria) {
    return _productos.where((p) => p.categoria.codigo == codigoCategoria).toList();
  }

  /// Obtener productos activos - Equivalente a getters computados en Angular
  List<Producto> get productosActivos {
    return _productos.where((p) => p.isActivo).toList();
  }

  /// Obtener productos con stock bajo - Equivalente a getters computados en Angular
  List<Producto> get productosStockBajo {
    return _productos.where((p) => p.stockBajo).toList();
  }

  /// Obtener productos vencidos - Equivalente a getters computados en Angular
  List<Producto> get productosVencidos {
    // Los productos vencidos ya no están disponibles en el modelo simplificado
    return [];
  }

  /// Buscar productos por nombre - Equivalente a filtros en Angular
  List<Producto> searchProductos(String query) {
    if (query.isEmpty) return _productos;
    return _productos.where((p) => 
      p.nombreProd.toLowerCase().contains(query.toLowerCase()) ||
      p.codigoProd.toString().contains(query.toLowerCase())
    ).toList();
  }

  /// Buscar categorías por nombre - Equivalente a filtros en Angular
  List<Categoria> searchCategorias(String query) {
    if (query.isEmpty) return _categorias;
    return _categorias.where((c) => 
      c.nombre.toLowerCase().contains(query.toLowerCase()) ||
      c.codigo.toString().contains(query.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
