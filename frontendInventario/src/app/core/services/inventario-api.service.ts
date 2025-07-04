import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class InventarioApiService {
  private readonly baseUrl = environment.apiServerUrl + 'api/inventario/';

  constructor(private http: HttpClient) {}

  // ==================== PRODUCTOS ====================
  // Endpoints reales del ProductoController
  
  /**
   * GET /productos - Obtener todos los productos
   */
  getProductos(): Observable<any> {
    return this.http.get(`${this.baseUrl}productos`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /productos/page - Productos paginados con stock
   */
  getProductosPaginados(page: number = 0, size: number = 10): Observable<any> {
    return this.http.get(`${this.baseUrl}productos/page?page=${page}&size=${size}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /productos/{id} - Obtener producto por ID
   */
  getProductoById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}productos/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /productos - Crear nuevo producto
   */
  createProducto(producto: any): Observable<any> {
    return this.http.post(`${this.baseUrl}productos`, producto).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /productos/{id} - Actualizar producto
   */
  updateProducto(id: number, producto: any): Observable<any> {
    return this.http.put(`${this.baseUrl}productos/${id}`, producto).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * DELETE /productos/{id} - Eliminar producto
   */
  deleteProducto(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}productos/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /productos/activar/{id} - Activar/Desactivar producto
   */
  toggleProductoEstado(id: number): Observable<any> {
    return this.http.put(`${this.baseUrl}productos/activar/${id}`, {}).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== CATEGORÍAS ====================
  // Endpoints reales del CategoriaController

  /**
   * GET /categorias - Obtener todas las categorías
   */
  getCategorias(): Observable<any> {
    return this.http.get(`${this.baseUrl}categorias`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /categorias/{id} - Obtener categoría por ID
   */
  getCategoriaById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}categorias/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /categorias - Crear nueva categoría
   */
  createCategoria(categoria: any): Observable<any> {
    return this.http.post(`${this.baseUrl}categorias`, categoria).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /categorias/{id} - Actualizar categoría
   */
  updateCategoria(id: number, categoria: any): Observable<any> {
    return this.http.put(`${this.baseUrl}categorias/${id}`, categoria).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * DELETE /categorias/{id} - Eliminar categoría
   */
  deleteCategoria(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}categorias/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /categorias/activar/{id} - Activar/Desactivar categoría
   */
  toggleCategoriaEstado(id: number): Observable<any> {
    return this.http.put(`${this.baseUrl}categorias/activar/${id}`, {}).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== MOVIMIENTOS ====================
  // Endpoints reales del MovimientoController

  /**
   * POST /movimiento/compra - Registrar movimiento de compra
   */
  movimientoCompra(movimiento: any): Observable<any> {
    return this.http.post(`${this.baseUrl}movimiento/compra`, movimiento).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /movimiento/venta - Registrar movimiento de venta (con crédito)
   */
  movimientoVenta(creditos: any[]): Observable<any> {
    return this.http.post(`${this.baseUrl}movimiento/venta`, creditos).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== KARDEX ====================
  // Endpoint real del KardexController

  /**
   * GET /kardex/{productoId} - Obtener kardex de un producto
   */
  getKardex(productoId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}kardex/${productoId}`).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== CUENTAS POR COBRAR ====================
  // Endpoints reales del PagarXCobrarController

  /**
   * GET /pagarxcobrar - Obtener todas las cuentas por cobrar
   */
  getCuentasPorCobrar(): Observable<any> {
    return this.http.get(`${this.baseUrl}pagarxcobrar`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /pagarxcobrar/{id} - Obtener cuenta por cobrar por ID
   */
  getCuentaPorCobrarById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}pagarxcobrar/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /pagarxcobrar - Crear nueva cuenta por cobrar
   */
  createCuentaPorCobrar(cuenta: any): Observable<any> {
    return this.http.post(`${this.baseUrl}pagarxcobrar`, cuenta).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /pagarxcobrar/{id} - Actualizar cuenta por cobrar
   */
  updateCuentaPorCobrar(id: number, cuenta: any): Observable<any> {
    return this.http.put(`${this.baseUrl}pagarxcobrar/${id}`, cuenta).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * DELETE /pagarxcobrar/{id} - Eliminar cuenta por cobrar
   */
  deleteCuentaPorCobrar(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}pagarxcobrar/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== CUOTAS ====================
  // Endpoints reales del CuotasController

  /**
   * GET /cuotas - Obtener todas las cuotas
   */
  getCuotas(): Observable<any> {
    return this.http.get(`${this.baseUrl}cuotas`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /cuotas/{id} - Obtener cuota por ID
   */
  getCuotaById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}cuotas/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /cuotas - Crear nueva cuota
   */
  createCuota(cuota: any): Observable<any> {
    return this.http.post(`${this.baseUrl}cuotas`, cuota).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /cuotas/{id} - Actualizar cuota
   */
  updateCuota(id: number, cuota: any): Observable<any> {
    return this.http.put(`${this.baseUrl}cuotas/${id}`, cuota).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * DELETE /cuotas/{id} - Eliminar cuota
   */
  deleteCuota(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}cuotas/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== CLIENTES/PROVEEDORES ====================
  // Endpoints reales del ClienteProvController

  /**
   * GET /clientesprov - Obtener todos los clientes/proveedores
   */
  getClientesProveedores(): Observable<any> {
    return this.http.get(`${this.baseUrl}clientesprov`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * GET /clientesprov/{id} - Obtener cliente/proveedor por ID
   */
  getClienteProveedorById(id: number): Observable<any> {
    return this.http.get(`${this.baseUrl}clientesprov/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * POST /clientesprov - Crear nuevo cliente/proveedor
   */
  createClienteProveedor(cliente: any): Observable<any> {
    return this.http.post(`${this.baseUrl}clientesprov`, cliente).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * PUT /clientesprov/{id} - Actualizar cliente/proveedor
   */
  updateClienteProveedor(id: number, cliente: any): Observable<any> {
    return this.http.put(`${this.baseUrl}clientesprov/${id}`, cliente).pipe(
      catchError(this.handleError)
    );
  }

  /**
   * DELETE /clientesprov/{id} - Eliminar cliente/proveedor
   */
  deleteClienteProveedor(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}clientesprov/${id}`).pipe(
      catchError(this.handleError)
    );
  }

  // ==================== MANEJO DE ERRORES ====================
  private handleError(error: HttpErrorResponse) {
    let errorMessage = 'Error desconocido';
    
    if (error.error instanceof ErrorEvent) {
      // Error del cliente
      errorMessage = `Error: ${error.error.message}`;
    } else {
      // Error del servidor
      errorMessage = `Código de error: ${error.status}\nMensaje: ${error.message}`;
    }
    
    console.error('Error en API:', errorMessage);
    return throwError(() => new Error(errorMessage));
  }
}
