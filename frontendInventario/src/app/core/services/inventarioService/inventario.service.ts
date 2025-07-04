import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Kardex } from '../../model/Kardex/kardex';
import { JsonResponse } from '../../model/JsonResponse.model';
import { CreditoDTO } from '../../model/credito-dto';
import { ApiService } from '../api.service';

@Injectable({
  providedIn: 'root'
})
export class InventarioService {

  constructor(private apiService: ApiService) {}

  // ==================== PRODUCTOS ====================
  
  /**
   * Obtiene todos los productos del inventario
   */
  getAllProductos(): Promise<JsonResponse> {
    console.log('🔍 Obteniendo todos los productos...');
    return this.apiService.getAllProductos();
  }

  /**
   * Obtiene un producto por su ID
   */
  getProductoById(id: number): Promise<JsonResponse> {
    console.log('🔍 Obteniendo producto por ID:', id);
    return this.apiService.getProductoById(id);
  }

  /**
   * Crea un nuevo producto
   */
  createProducto(producto: any): Promise<JsonResponse> {
    console.log('📦 Creando nuevo producto:', producto);
    return this.apiService.createProducto(producto);
  }

  /**
   * Actualiza un producto existente
   */
  updateProducto(id: number, producto: any): Promise<JsonResponse> {
    console.log('✏️ Actualizando producto:', id, producto);
    return this.apiService.updateProducto(id, producto);
  }

  /**
   * Elimina un producto
   */
  deleteProducto(id: number): Promise<JsonResponse> {
    console.log('🗑️ Eliminando producto:', id);
    return this.apiService.deleteProducto(id);
  }

  /**
   * Activa o desactiva un producto
   */
  toggleProductoEstado(id: number): Promise<JsonResponse> {
    console.log('🔄 Cambiando estado del producto:', id);
    return this.apiService.toggleProductoEstado(id);
  }

  // ==================== CATEGORÍAS ====================
  
  /**
   * Obtiene todas las categorías
   */
  getAllCategorias(): Promise<JsonResponse> {
    console.log('📂 Obteniendo todas las categorías...');
    return this.apiService.getAllCategorias();
  }

  /**
   * Obtiene una categoría por su ID
   */
  getCategoriaById(id: number): Promise<JsonResponse> {
    console.log('📂 Obteniendo categoría por ID:', id);
    return this.apiService.getCategoriaById(id);
  }

  /**
   * Crea una nueva categoría
   */
  createCategoria(categoria: any): Promise<JsonResponse> {
    console.log('📂 Creando nueva categoría:', categoria);
    return this.apiService.createCategoria(categoria);
  }

  /**
   * Actualiza una categoría existente
   */
  updateCategoria(id: number, categoria: any): Promise<JsonResponse> {
    console.log('📂 Actualizando categoría:', id, categoria);
    return this.apiService.updateCategoria(id, categoria);
  }

  /**
   * Elimina una categoría
   */
  deleteCategoria(id: number): Promise<JsonResponse> {
    console.log('🗑️ Eliminando categoría:', id);
    return this.apiService.deleteCategoria(id);
  }

  /**
   * Activa o desactiva una categoría
   */
  toggleCategoriaEstado(id: number): Promise<JsonResponse> {
    console.log('🔄 Cambiando estado de la categoría:', id);
    return this.apiService.toggleCategoriaEstado(id);
  }

  // ==================== MOVIMIENTOS ====================
  
  /**
   * Registra un movimiento de compra
   */
  registrarCompra(movimiento: any): Promise<JsonResponse> {
    console.log('🛒 Registrando compra:', movimiento);
    return this.apiService.registrarCompra(movimiento);
  }

  /**
   * Registra un movimiento de venta
   */
  registrarVenta(creditos: CreditoDTO[]): Promise<JsonResponse> {
    console.log('💰 Registrando venta:', creditos);
    return this.apiService.registrarVenta(creditos);
  }

  /**
   * Obtiene el stock actual de un producto
   */
  getStockProducto(productoId: number): Promise<JsonResponse> {
    console.log('📊 Obteniendo stock del producto:', productoId);
    return this.apiService.getProductosPaginados();
  }

  // ==================== KARDEX ====================
  
  /**
   * Obtiene el kardex completo de un producto
   */
  getKardexProducto(productoId: number): Promise<JsonResponse> {
    console.log('📋 Obteniendo kardex del producto:', productoId);
    return this.apiService.getKardexProducto(productoId);
  }

  // ==================== CUENTAS POR COBRAR ====================
  
  /**
   * Obtiene todas las cuentas por cobrar
   */
  getAllCuentasPorCobrar(): Promise<JsonResponse> {
    console.log('💰 Obteniendo todas las cuentas por cobrar...');
    return this.apiService.getAllCuentasPorCobrar();
  }

  /**
   * Obtiene una cuenta por cobrar por su ID
   */
  getCuentaPorCobrarById(id: number): Promise<JsonResponse> {
    console.log('💰 Obteniendo cuenta por cobrar por ID:', id);
    return this.apiService.getCuentaPorCobrarById(id);
  }

  /**
   * Crea una nueva cuenta por cobrar
   */
  createCuentaPorCobrar(cuenta: any): Promise<JsonResponse> {
    console.log('💰 Creando nueva cuenta por cobrar:', cuenta);
    return this.apiService.createCuentaPorCobrar(cuenta);
  }

  /**
   * Actualiza una cuenta por cobrar existente
   */
  updateCuentaPorCobrar(id: number, cuenta: any): Promise<JsonResponse> {
    console.log('💰 Actualizando cuenta por cobrar:', id, cuenta);
    return this.apiService.updateCuentaPorCobrar(id, cuenta);
  }

  /**
   * Elimina una cuenta por cobrar
   */
  deleteCuentaPorCobrar(id: number): Promise<JsonResponse> {
    console.log('🗑️ Eliminando cuenta por cobrar:', id);
    return this.apiService.deleteCuentaPorCobrar(id);
  }

  // ==================== CUOTAS ====================
  
  /**
   * Obtiene todas las cuotas
   */
  getAllCuotas(): Promise<JsonResponse> {
    console.log('📋 Obteniendo todas las cuotas...');
    return this.apiService.getAllCuotas();
  }

  /**
   * Obtiene una cuota por su ID
   */
  getCuotaById(id: number): Promise<JsonResponse> {
    console.log('📋 Obteniendo cuota por ID:', id);
    return this.apiService.getCuotaById(id);
  }

  /**
   * Crea una nueva cuota
   */
  createCuota(cuota: any): Promise<JsonResponse> {
    console.log('📋 Creando nueva cuota:', cuota);
    return this.apiService.createCuota(cuota);
  }

  /**
   * Actualiza una cuota existente
   */
  updateCuota(id: number, cuota: any): Promise<JsonResponse> {
    console.log('📋 Actualizando cuota:', id, cuota);
    return this.apiService.updateCuota(id, cuota);
  }

  /**
   * Elimina una cuota
   */
  deleteCuota(id: number): Promise<JsonResponse> {
    console.log('🗑️ Eliminando cuota:', id);
    return this.apiService.deleteCuota(id);
  }

  // ==================== CLIENTES/PROVEEDORES ====================
  
  /**
   * Obtiene todos los clientes/proveedores
   */
  getAllClientesProveedores(): Promise<JsonResponse> {
    console.log('👥 Obteniendo todos los clientes/proveedores...');
    return this.apiService.getAllClientesProveedores();
  }

  /**
   * Obtiene un cliente/proveedor por su ID
   */
  getClienteProveedorById(id: number): Promise<JsonResponse> {
    console.log('👥 Obteniendo cliente/proveedor por ID:', id);
    return this.apiService.getClienteProveedorById(id);
  }

  /**
   * Crea un nuevo cliente/proveedor
   */
  createClienteProveedor(cliente: any): Promise<JsonResponse> {
    console.log('👥 Creando nuevo cliente/proveedor:', cliente);
    return this.apiService.createClienteProveedor(cliente);
  }

  /**
   * Actualiza un cliente/proveedor existente
   */
  updateClienteProveedor(id: number, cliente: any): Promise<JsonResponse> {
    console.log('👥 Actualizando cliente/proveedor:', id, cliente);
    return this.apiService.updateClienteProveedor(id, cliente);
  }

  /**
   * Elimina un cliente/proveedor
   */
  deleteClienteProveedor(id: number): Promise<JsonResponse> {
    console.log('🗑️ Eliminando cliente/proveedor:', id);
    return this.apiService.deleteClienteProveedor(id);
  }

  /**
   * Obtiene productos con paginación y stock
   */
  getProductosPaginados(page: number = 0, size: number = 10, search?: string, sortBy?: string): Promise<JsonResponse> {
    console.log('📄 Obteniendo productos paginados...');
    return this.apiService.getProductosPaginados(page, size);
  }

  // ==================== MÉTODOS LEGACY (mantenidos para compatibilidad) ====================
  
  /**
   * @deprecated Use getAllProductos() instead
   * Obtiene productos con paginación usando el endpoint legacy
   */
  getProductos(page: number = 0, size: number = 10): Promise<JsonResponse> {
    console.log('🔍 Obteniendo productos paginados (legacy)...');
    return this.apiService.getProductosInventarioPaginado(page, size);
  }

  /**
   * @deprecated Use getAllCategorias() instead
   */
  getCategorias(): Promise<JsonResponse> {
    console.log('📂 Obteniendo categorías (legacy)...');
    return this.getAllCategorias();
  }
}
