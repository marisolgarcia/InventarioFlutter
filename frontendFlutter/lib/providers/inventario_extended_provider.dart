import 'package:flutter/foundation.dart';
import '../core/models/cliente_prov.dart';
import '../core/models/movimiento.dart';
import '../core/models/pagar_x_cobrar.dart';
import '../core/models/cuotas.dart';
import '../core/models/credito_dto.dart';
import '../core/models/kardex_dto.dart';
import '../core/services/inventario_api_service.dart';

/// Provider para la gestión completa del sistema - Nuevos endpoints
/// Complementa al InventarioProvider principal
class InventarioExtendedProvider with ChangeNotifier {
  final InventarioApiService _apiService = InventarioApiService();

  // ==================== CLIENTES/PROVEEDORES ====================
  List<ClienteProv> _clientesProveedores = [];
  bool _clientesProveedoresLoading = false;
  String? _clientesProveedoresError;

  // ==================== MOVIMIENTOS ====================
  bool _movimientosLoading = false;
  String? _movimientosError;

  // ==================== CUENTAS POR COBRAR/PAGAR ====================
  List<PagarXCobrar> _cuentasPorCobrarPagar = [];
  bool _cuentasPorCobrarPagarLoading = false;
  String? _cuentasPorCobrarPagarError;

  // ==================== CUOTAS ====================
  List<Cuotas> _cuotas = [];
  bool _cuotasLoading = false;
  String? _cuotasError;

  // ==================== KARDEX ====================
  KardexDto? _kardexActual;
  bool _kardexLoading = false;
  String? _kardexError;

  // ==================== GETTERS ====================
  
  // Clientes/Proveedores
  List<ClienteProv> get clientesProveedores => _clientesProveedores;
  bool get clientesProveedoresLoading => _clientesProveedoresLoading;
  String? get clientesProveedoresError => _clientesProveedoresError;

  // Movimientos
  bool get movimientosLoading => _movimientosLoading;
  String? get movimientosError => _movimientosError;

  // Cuentas por cobrar/pagar
  List<PagarXCobrar> get cuentasPorCobrarPagar => _cuentasPorCobrarPagar;
  bool get cuentasPorCobrarPagarLoading => _cuentasPorCobrarPagarLoading;
  String? get cuentasPorCobrarPagarError => _cuentasPorCobrarPagarError;

  // Cuotas
  List<Cuotas> get cuotas => _cuotas;
  bool get cuotasLoading => _cuotasLoading;
  String? get cuotasError => _cuotasError;

  // Kardex
  KardexDto? get kardexActual => _kardexActual;
  bool get kardexLoading => _kardexLoading;
  String? get kardexError => _kardexError;

  // ==================== MÉTODOS DE CLIENTES/PROVEEDORES ====================

  /// Cargar todos los clientes/proveedores
  Future<void> loadClientesProveedores() async {
    print('🔄 Iniciando carga de clientes/proveedores...');
    _clientesProveedoresLoading = true;
    _clientesProveedoresError = null;
    notifyListeners();

    try {
      _clientesProveedores = await _apiService.getClientesProveedores();
      print('✅ Clientes/Proveedores cargados: ${_clientesProveedores.length} items');
    } catch (e) {
      print('❌ Error cargando clientes/proveedores: $e');
      _clientesProveedoresError = e.toString();
    } finally {
      _clientesProveedoresLoading = false;
      notifyListeners();
    }
  }

  /// Obtener cliente/proveedor por ID
  Future<ClienteProv?> getClienteProveedorById(int id) async {
    try {
      return await _apiService.getClienteProveedorById(id);
    } catch (e) {
      _clientesProveedoresError = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Crear cliente/proveedor
  Future<bool> createClienteProveedor(ClienteProv clienteProv) async {
    try {
      final nuevoClienteProv = await _apiService.createClienteProveedor(clienteProv);
      _clientesProveedores.add(nuevoClienteProv);
      notifyListeners();
      return true;
    } catch (e) {
      _clientesProveedoresError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar cliente/proveedor
  Future<bool> updateClienteProveedor(int id, ClienteProv clienteProv) async {
    try {
      final clienteProvActualizado = await _apiService.updateClienteProveedor(id, clienteProv);
      final index = _clientesProveedores.indexWhere((cp) => cp.codigo == id);
      if (index != -1) {
        _clientesProveedores[index] = clienteProvActualizado;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _clientesProveedoresError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Eliminar cliente/proveedor
  Future<bool> deleteClienteProveedor(int id) async {
    try {
      await _apiService.deleteClienteProveedor(id);
      _clientesProveedores.removeWhere((cp) => cp.codigo == id);
      notifyListeners();
      return true;
    } catch (e) {
      _clientesProveedoresError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== MÉTODOS DE MOVIMIENTOS ====================

  /// Registrar compra
  Future<bool> registrarCompra(Movimiento movimiento) async {
    _movimientosLoading = true;
    _movimientosError = null;
    notifyListeners();

    try {
      await _apiService.registrarCompra(movimiento);
      print('✅ Compra registrada exitosamente');
      return true;
    } catch (e) {
      print('❌ Error registrando compra: $e');
      _movimientosError = e.toString();
      return false;
    } finally {
      _movimientosLoading = false;
      notifyListeners();
    }
  }

  /// Registrar venta
  Future<bool> registrarVenta(List<CreditoDto> creditos) async {
    _movimientosLoading = true;
    _movimientosError = null;
    notifyListeners();

    try {
      await _apiService.registrarVenta(creditos);
      print('✅ Venta registrada exitosamente');
      return true;
    } catch (e) {
      print('❌ Error registrando venta: $e');
      _movimientosError = e.toString();
      return false;
    } finally {
      _movimientosLoading = false;
      notifyListeners();
    }
  }

  // ==================== MÉTODOS DE CUENTAS POR COBRAR/PAGAR ====================

  /// Cargar todas las cuentas por cobrar/pagar
  Future<void> loadCuentasPorCobrarPagar() async {
    print('🔄 Iniciando carga de cuentas por cobrar/pagar...');
    _cuentasPorCobrarPagarLoading = true;
    _cuentasPorCobrarPagarError = null;
    notifyListeners();

    try {
      _cuentasPorCobrarPagar = await _apiService.getCuentasPorCobrarPagar();
      print('✅ Cuentas cargadas: ${_cuentasPorCobrarPagar.length} items');
    } catch (e) {
      print('❌ Error cargando cuentas: $e');
      _cuentasPorCobrarPagarError = e.toString();
    } finally {
      _cuentasPorCobrarPagarLoading = false;
      notifyListeners();
    }
  }

  /// Obtener cuenta por ID
  Future<PagarXCobrar?> getCuentaPorCobrarPagarById(int id) async {
    try {
      return await _apiService.getCuentaPorCobrarPagarById(id);
    } catch (e) {
      _cuentasPorCobrarPagarError = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Crear cuenta por cobrar/pagar
  Future<bool> createCuentaPorCobrarPagar(PagarXCobrar cuenta) async {
    try {
      final nuevaCuenta = await _apiService.createCuentaPorCobrarPagar(cuenta);
      _cuentasPorCobrarPagar.add(nuevaCuenta);
      notifyListeners();
      return true;
    } catch (e) {
      _cuentasPorCobrarPagarError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar cuenta por cobrar/pagar
  Future<bool> updateCuentaPorCobrarPagar(int id, PagarXCobrar cuenta) async {
    try {
      final cuentaActualizada = await _apiService.updateCuentaPorCobrarPagar(id, cuenta);
      final index = _cuentasPorCobrarPagar.indexWhere((c) => c.codigo == id);
      if (index != -1) {
        _cuentasPorCobrarPagar[index] = cuentaActualizada;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _cuentasPorCobrarPagarError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Eliminar cuenta por cobrar/pagar
  Future<bool> deleteCuentaPorCobrarPagar(int id) async {
    try {
      await _apiService.deleteCuentaPorCobrarPagar(id);
      _cuentasPorCobrarPagar.removeWhere((c) => c.codigo == id);
      notifyListeners();
      return true;
    } catch (e) {
      _cuentasPorCobrarPagarError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== MÉTODOS DE CUOTAS ====================

  /// Cargar todas las cuotas
  Future<void> loadCuotas() async {
    print('🔄 Iniciando carga de cuotas...');
    _cuotasLoading = true;
    _cuotasError = null;
    notifyListeners();

    try {
      _cuotas = await _apiService.getCuotas();
      print('✅ Cuotas cargadas: ${_cuotas.length} items');
    } catch (e) {
      print('❌ Error cargando cuotas: $e');
      _cuotasError = e.toString();
    } finally {
      _cuotasLoading = false;
      notifyListeners();
    }
  }

  /// Obtener cuota por ID
  Future<Cuotas?> getCuotaById(int id) async {
    try {
      return await _apiService.getCuotaById(id);
    } catch (e) {
      _cuotasError = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Crear cuota
  Future<bool> createCuota(Cuotas cuota) async {
    try {
      final nuevaCuota = await _apiService.createCuota(cuota);
      _cuotas.add(nuevaCuota);
      notifyListeners();
      return true;
    } catch (e) {
      _cuotasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar cuota
  Future<bool> updateCuota(int id, Cuotas cuota) async {
    try {
      final cuotaActualizada = await _apiService.updateCuota(id, cuota);
      final index = _cuotas.indexWhere((c) => c.codigoCuota == id);
      if (index != -1) {
        _cuotas[index] = cuotaActualizada;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _cuotasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Eliminar cuota
  Future<bool> deleteCuota(int id) async {
    try {
      await _apiService.deleteCuota(id);
      _cuotas.removeWhere((c) => c.codigoCuota == id);
      notifyListeners();
      return true;
    } catch (e) {
      _cuotasError = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== MÉTODOS DE KARDEX ====================

  /// Obtener kardex de un producto
  Future<void> loadKardexByProducto(int productoId) async {
    print('🔄 Iniciando carga de kardex para producto $productoId...');
    _kardexLoading = true;
    _kardexError = null;
    notifyListeners();

    try {
      _kardexActual = await _apiService.getKardexByProducto(productoId);
      print('✅ Kardex cargado para producto $productoId');
    } catch (e) {
      print('❌ Error cargando kardex: $e');
      _kardexError = e.toString();
    } finally {
      _kardexLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar kardex actual
  void clearKardex() {
    _kardexActual = null;
    _kardexError = null;
    notifyListeners();
  }

  // ==================== MÉTODOS DE BÚSQUEDA ====================

  /// Buscar clientes/proveedores por nombre
  List<ClienteProv> searchClientesProveedores(String query) {
    if (query.isEmpty) return _clientesProveedores;
    return _clientesProveedores.where((cp) => 
      cp.nombre.toLowerCase().contains(query.toLowerCase()) ||
      cp.tipo.toLowerCase().contains(query.toLowerCase()) ||
      cp.numDocumento.contains(query)
    ).toList();
  }

  /// Buscar cuentas por número de factura
  List<PagarXCobrar> searchCuentasPorFactura(String query) {
    if (query.isEmpty) return _cuentasPorCobrarPagar;
    return _cuentasPorCobrarPagar.where((c) => 
      c.numFactura.toLowerCase().contains(query.toLowerCase()) ||
      c.tipo.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Buscar cuotas por estado
  List<Cuotas> searchCuotasPorEstado(String estado) {
    if (estado.isEmpty) return _cuotas;
    return _cuotas.where((c) => 
      c.estadoCuota.toLowerCase() == estado.toLowerCase()
    ).toList();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
