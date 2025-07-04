import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../models/categoria.dart';
import '../models/cliente_prov.dart';
import '../models/movimiento.dart';
import '../models/pagar_x_cobrar.dart';
import '../models/cuotas.dart';
import '../models/credito_dto.dart';
import '../models/kardex_dto.dart';
import '../config/app_config.dart';

/// Servicio de API para el inventario - Equivalente al InventarioApiService de Angular
/// Consume las APIs REST del backend Java sin modificación
class InventarioApiService {
  static final InventarioApiService _instance = InventarioApiService._internal();
  factory InventarioApiService() => _instance;
  InventarioApiService._internal();

  final http.Client _client = http.Client();

  // Headers comunes para todas las peticiones
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== PRODUCTOS ====================
  
  /// GET /productos - Obtener todos los productos
  /// Equivalente a getProductos() en Angular
  Future<List<Producto>> getProductos() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}productos');
      print('🔍 Solicitando: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta: ${response.statusCode}');
      print('📋 Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          print('⚠️  Respuesta vacía del servidor');
          return [];
        }
        
        final dynamic jsonData = jsonDecode(responseBody);
        print('📊 Datos JSON: $jsonData');
        
        if (jsonData is List) {
          final List<dynamic> jsonList = jsonData;
          print('✅ Lista de productos: ${jsonList.length} items');
          return jsonList.map((json) => Producto.fromJson(json)).toList();
        } else {
          print('⚠️  Formato inesperado: ${jsonData.runtimeType}');
          return [];
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getProductos: $e');
      throw Exception('Error obteniendo productos: $e');
    }
  }

  /// GET /productos/page - Productos paginados
  /// Equivalente a getProductosPaginados() en Angular
  Future<Map<String, dynamic>> getProductosPaginados({
    int page = 0,
    int size = 10,
  }) async {
    try {
      print('🔄 Solicitando productos paginados: página $page, tamaño $size');
      final uri = Uri.parse('${AppConfig.baseUrl}productos/page').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
        },
      );
      print('🔍 URL paginada: $uri');

      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta paginada: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('📋 Body paginado: ${response.body}');
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        // El backend envuelve la respuesta en 'pages'
        final Map<String, dynamic> pagesData = jsonResponse['pages'] ?? {};
        
        if (pagesData.isEmpty) {
          print('⚠️  No hay estructura de paginación, usando endpoint normal');
          final List<Producto> productos = await getProductos();
          return {
            'productos': productos,
            'totalElements': productos.length,
            'totalPages': 1,
            'currentPage': 0,
            'size': productos.length,
            'hasNext': false,
            'hasPrevious': false,
          };
        }
        
        final List<dynamic> contentList = pagesData['content'] as List? ?? [];
        print('📊 Datos paginados: ${contentList.length} items');
        
        // Convertir StockDTO a Producto
        final List<Producto> productos = contentList.map((stockDto) {
          // StockDTO tiene campos de categoria directamente, necesitamos crear el objeto categoria
          final Map<String, dynamic> categoriaMap = {
            'codigoCat': stockDto['codigoCat'],
            'nombreCat': stockDto['nombreCat'], 
            'descripcionCat': stockDto['descripcionCat'],
            'estadoCat': stockDto['estadoCat'],
          };
          
          // Crear el formato esperado por Producto.fromJson
          final Map<String, dynamic> productoMap = {
            'codigoProd': stockDto['codigoProd'],
            'nombreProd': stockDto['nombreProd'],
            'descripcionProd': stockDto['descripcionProd'],
            'unidadesMin': stockDto['unidadesMin'],
            'estadoProd': stockDto['estadoProd'],
            'categoria': categoriaMap,
          };
          
          return Producto.fromJson(productoMap);
        }).toList();
        
        return {
          'productos': productos,
          'totalElements': pagesData['totalElements'] ?? 0,
          'totalPages': pagesData['totalPages'] ?? 1,
          'currentPage': pagesData['number'] ?? 0,
          'size': pagesData['size'] ?? size,
          'hasNext': !(pagesData['last'] ?? true),
          'hasPrevious': !(pagesData['first'] ?? true),
        };
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getProductosPaginados: $e');
      throw Exception('Error obteniendo productos paginados: $e');
    }
  }

  /// GET /productos/{id} - Obtener producto por ID
  /// Equivalente a getProductoById() en Angular
  Future<Producto> getProductoById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.baseUrl}productos/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Producto.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo producto $id: $e');
    }
  }

  /// POST /productos - Crear nuevo producto
  /// Equivalente a createProducto() en Angular
  Future<Producto> createProducto(Producto producto) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}productos'),
        headers: _headers,
        body: jsonEncode(producto.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Producto.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creando producto: $e');
    }
  }

  /// PUT /productos/{id} - Actualizar producto
  /// Equivalente a updateProducto() en Angular
  Future<Producto> updateProducto(int id, Producto producto) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}productos/$id'),
        headers: _headers,
        body: jsonEncode(producto.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Producto.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error actualizando producto $id: $e');
    }
  }

  /// DELETE /productos/{id} - Eliminar producto
  /// Equivalente a deleteProducto() en Angular
  Future<void> deleteProducto(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.baseUrl}productos/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error eliminando producto $id: $e');
    }
  }

  /// PUT /productos/activar/{id} - Cambiar estado del producto
  /// Equivalente a toggleProductoEstado() en Angular
  Future<Producto> toggleProductoEstado(int id) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}productos/activar/$id'),
        headers: _headers,
        body: jsonEncode({}),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Producto.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cambiando estado del producto $id: $e');
    }
  }

  // ==================== CATEGORÍAS ====================

  /// GET /categorias - Obtener todas las categorías
  /// Equivalente a getCategorias() en Angular
  Future<List<Categoria>> getCategorias() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}categorias');
      print('🔍 Solicitando categorías: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta categorías: ${response.statusCode}');
      print('📋 Body categorías: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          print('⚠️  Respuesta vacía del servidor para categorías');
          return [];
        }
        
        final dynamic jsonData = jsonDecode(responseBody);
        print('📊 Datos JSON categorías: $jsonData');
        
        if (jsonData is List) {
          final List<dynamic> jsonList = jsonData;
          print('✅ Lista de categorías: ${jsonList.length} items');
          return jsonList.map((json) => Categoria.fromJson(json)).toList();
        } else {
          print('⚠️  Formato inesperado categorías: ${jsonData.runtimeType}');
          return [];
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getCategorias: $e');
      throw Exception('Error obteniendo categorías: $e');
    }
  }

  /// GET /categorias/{id} - Obtener categoría por ID
  /// Equivalente a getCategoriaById() en Angular
  Future<Categoria> getCategoriaById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.baseUrl}categorias/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Categoria.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo categoría $id: $e');
    }
  }

  /// POST /categorias - Crear nueva categoría
  /// Equivalente a createCategoria() en Angular
  Future<Categoria> createCategoria(Categoria categoria) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}categorias'),
        headers: _headers,
        body: jsonEncode(categoria.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Categoria.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creando categoría: $e');
    }
  }

  /// PUT /categorias/{id} - Actualizar categoría
  /// Equivalente a updateCategoria() en Angular
  Future<Categoria> updateCategoria(int id, Categoria categoria) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}categorias/$id'),
        headers: _headers,
        body: jsonEncode(categoria.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Categoria.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error actualizando categoría $id: $e');
    }
  }

  /// DELETE /categorias/{id} - Eliminar categoría
  /// Equivalente a deleteCategoria() en Angular
  Future<void> deleteCategoria(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.baseUrl}categorias/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error eliminando categoría $id: $e');
    }
  }

  /// PUT /categorias/activar/{id} - Activar/Desactivar categoría
  /// Equivalente a activarCategoria() en Angular
  Future<Categoria> toggleCategoriaEstado(int id) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}categorias/activar/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Categoria.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error cambiando estado de categoría $id: $e');
    }
  }

  // ==================== CLIENTES/PROVEEDORES ====================

  /// GET /clientesprov - Obtener todos los clientes/proveedores
  Future<List<ClienteProv>> getClientesProveedores() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}clientesprov');
      print('🔍 Solicitando clientes/proveedores: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta clientes/proveedores: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('✅ Lista de clientes/proveedores: ${jsonList.length} items');
        return jsonList.map((json) => ClienteProv.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getClientesProveedores: $e');
      throw Exception('Error obteniendo clientes/proveedores: $e');
    }
  }

  /// GET /clientesprov/{id} - Obtener cliente/proveedor por ID
  Future<ClienteProv> getClienteProveedorById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.baseUrl}clientesprov/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ClienteProv.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo cliente/proveedor $id: $e');
    }
  }

  /// POST /clientesprov - Crear nuevo cliente/proveedor
  Future<ClienteProv> createClienteProveedor(ClienteProv clienteProv) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}clientesprov'),
        headers: _headers,
        body: jsonEncode(clienteProv.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ClienteProv.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creando cliente/proveedor: $e');
    }
  }

  /// PUT /clientesprov/{id} - Actualizar cliente/proveedor
  Future<ClienteProv> updateClienteProveedor(int id, ClienteProv clienteProv) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}clientesprov/$id'),
        headers: _headers,
        body: jsonEncode(clienteProv.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ClienteProv.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error actualizando cliente/proveedor $id: $e');
    }
  }

  /// DELETE /clientesprov/{id} - Eliminar cliente/proveedor
  Future<void> deleteClienteProveedor(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.baseUrl}clientesprov/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error eliminando cliente/proveedor $id: $e');
    }
  }

  // ==================== MOVIMIENTOS ====================

  /// POST /movimiento/compra - Registrar movimiento de compra
  Future<Movimiento> registrarCompra(Movimiento movimiento) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}movimiento/compra'),
        headers: _headers,
        body: jsonEncode(movimiento.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Movimiento.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registrando compra: $e');
    }
  }

  /// POST /movimiento/venta - Registrar movimiento de venta (con créditos)
  Future<void> registrarVenta(List<CreditoDto> creditos) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}movimiento/venta'),
        headers: _headers,
        body: jsonEncode(creditos.map((c) => c.toJson()).toList()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registrando venta: $e');
    }
  }

  // ==================== PAGAR X COBRAR ====================

  /// GET /pagarxcobrar - Obtener todas las cuentas por cobrar/pagar
  Future<List<PagarXCobrar>> getCuentasPorCobrarPagar() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}pagarxcobrar');
      print('🔍 Solicitando cuentas por cobrar/pagar: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta cuentas: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('✅ Lista de cuentas: ${jsonList.length} items');
        return jsonList.map((json) => PagarXCobrar.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getCuentasPorCobrarPagar: $e');
      throw Exception('Error obteniendo cuentas por cobrar/pagar: $e');
    }
  }

  /// GET /pagarxcobrar/{id} - Obtener cuenta por ID
  Future<PagarXCobrar> getCuentaPorCobrarPagarById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.baseUrl}pagarxcobrar/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PagarXCobrar.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo cuenta $id: $e');
    }
  }

  /// POST /pagarxcobrar - Crear nueva cuenta por cobrar/pagar
  Future<PagarXCobrar> createCuentaPorCobrarPagar(PagarXCobrar cuenta) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}pagarxcobrar'),
        headers: _headers,
        body: jsonEncode(cuenta.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PagarXCobrar.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creando cuenta: $e');
    }
  }

  /// PUT /pagarxcobrar/{id} - Actualizar cuenta por cobrar/pagar
  Future<PagarXCobrar> updateCuentaPorCobrarPagar(int id, PagarXCobrar cuenta) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}pagarxcobrar/$id'),
        headers: _headers,
        body: jsonEncode(cuenta.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PagarXCobrar.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error actualizando cuenta $id: $e');
    }
  }

  /// DELETE /pagarxcobrar/{id} - Eliminar cuenta por cobrar/pagar
  Future<void> deleteCuentaPorCobrarPagar(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.baseUrl}pagarxcobrar/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error eliminando cuenta $id: $e');
    }
  }

  // ==================== CUOTAS ====================

  /// GET /cuotas - Obtener todas las cuotas
  Future<List<Cuotas>> getCuotas() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}cuotas');
      print('🔍 Solicitando cuotas: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta cuotas: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('✅ Lista de cuotas: ${jsonList.length} items');
        return jsonList.map((json) => Cuotas.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getCuotas: $e');
      throw Exception('Error obteniendo cuotas: $e');
    }
  }

  /// GET /cuotas/{id} - Obtener cuota por ID
  Future<Cuotas> getCuotaById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${AppConfig.baseUrl}cuotas/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Cuotas.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error obteniendo cuota $id: $e');
    }
  }

  /// POST /cuotas - Crear nueva cuota
  Future<Cuotas> createCuota(Cuotas cuota) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.baseUrl}cuotas'),
        headers: _headers,
        body: jsonEncode(cuota.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Cuotas.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creando cuota: $e');
    }
  }

  /// PUT /cuotas/{id} - Actualizar cuota
  Future<Cuotas> updateCuota(int id, Cuotas cuota) async {
    try {
      final response = await _client.put(
        Uri.parse('${AppConfig.baseUrl}cuotas/$id'),
        headers: _headers,
        body: jsonEncode(cuota.toJson()),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Cuotas.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error actualizando cuota $id: $e');
    }
  }

  /// DELETE /cuotas/{id} - Eliminar cuota
  Future<void> deleteCuota(int id) async {
    try {
      final response = await _client.delete(
        Uri.parse('${AppConfig.baseUrl}cuotas/$id'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error eliminando cuota $id: $e');
    }
  }

  // ==================== KARDEX ====================

  /// GET /kardex/{productoId} - Obtener kardex de un producto
  Future<KardexDto> getKardexByProducto(int productoId) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}kardex/$productoId');
      print('🔍 Solicitando kardex para producto $productoId: $uri');
      
      final response = await _client.get(
        uri,
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Respuesta kardex: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        print('✅ Kardex obtenido para producto $productoId');
        return KardexDto.fromJson(json);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error en getKardexByProducto: $e');
      throw Exception('Error obteniendo kardex del producto $productoId: $e');
    }
  }

  // Método para limpiar recursos
  void dispose() {
    _client.close();
  }
}
