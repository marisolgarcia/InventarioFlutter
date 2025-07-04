import { Injectable } from '@angular/core';
import {
  HttpClient,
  HttpErrorResponse,
  HttpParams,
  HttpHeaders,
} from '@angular/common/http';
import { DataService } from './data.service';
import { AuthService } from './auth.service';
import { ProviderService } from './provider.service';

import { catchError, throwError } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { environment } from '../environments/environment';
import { JsonResponse } from '../model/JsonResponse.model';
import { saveAs } from 'file-saver';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  private api: string = '';
  private authUri: string = '';
  minDescontar: any;
  idhabdescId: any;
  id: any;
  montoDescontar!: number;
  router: any;

  constructor(
    private http: HttpClient,
    private data: DataService,
    private auth: AuthService,
    public provider: ProviderService,
    public dialog: MatDialog
  ) {
    // URL base correcta del backend (SIN /api/inventario)
    this.api = environment.apiServerUrl;
    this.authUri = environment.apiServerUrl + 'api/auth/';
  }

  login(data: any, authUrl: string = 'authenticate'): Promise<JsonResponse> {
    return new Promise((resolve, reject) => {
      const headers = new HttpHeaders({
        'Content-Type': 'application/json',
      });

      this.data.subscription = this.http
        .post<any>(this.authUri + authUrl, data, { headers })
        .subscribe(
          (response) => {
            return resolve(response);
          },
          (error) => {
            return reject(new Error(error));
          }
        );
    });
  }

  logout(authUrl: string = 'logout'): Promise<JsonResponse> {
    let token = this.auth.getToken() != null ? this.auth.getToken() : '';
    return new Promise((resolve) => {
      const headers = new HttpHeaders({
        'Content-Type': 'application/json',
      });

      this.data.subscription = this.http
        .post<any>(
          this.authUri + authUrl,
          {
            token: 'Bearer ' + token,
          },
          { headers }
        )
        .subscribe(
          (response) => {
            return resolve(response);
          },
          (error) => {
            return resolve(error);
          }
        );
    });
  }

  doRequest(url: string, data: any, type: string): Promise<JsonResponse> {
    this.data.sendMessage({ from: 'api', status: true });

    return new Promise((resolve, reject) => {
      let token = this.auth.getToken() != null ? this.auth.getToken() : '';
      const headers = new HttpHeaders({
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      });
      try {
        switch (type) {
          case 'post':
            this.data.subscription = this.http
              .post<any>(this.api + url, data, { headers })
              .subscribe(
                (response) => {
                  return resolve(this.handleResponse(response));
                },
                (error: HttpErrorResponse) => {
                  this.handleerror(error);
                  return reject(new Error(JSON.stringify(error)));
                }
              );
            break;
          case 'get':
            this.data.subscription = this.http
              .get<any>(this.api + url, { headers })
              .subscribe(
                (response) => {
                  return resolve(this.handleResponse(response));
                },
                (error: HttpErrorResponse) => {
                  this.handleerror(error);
                  return reject(new Error(JSON.stringify(error)));
                }
              );
            break;
          case 'delete':
            this.data.subscription = this.http
              .delete<any>(this.api + url, { headers })
              .subscribe(
                (response) => {
                  return resolve(this.handleResponse(response));
                },
                (error: HttpErrorResponse) => {
                  this.handleerror(error);
                  const errors: Error = new Error("Something went wrong");
                  return reject(errors);
                }
              );
            break;
          case 'put':
            this.data.subscription = this.http
              .put<any>(this.api + url, data, { headers })
              .subscribe(
                (response) => {
                  return resolve(this.handleResponse(response));
                },
                (error: HttpErrorResponse) => {
                  this.handleerror(error);
                  const errors: Error = new Error("Something went wrong");
                  return reject(errors);
                }
              );
            break;
        }
      } catch (error) {
        console.error('error : ', error);
      }
    });
  }

  getPage(
    url: string,
    search?: string,
    sortBy?: string,
    page?: number,
    size?: number
  ): Promise<JsonResponse> {
    let params = new HttpParams();
    if (search) {
      params = params.append('filterBy', '' + search);
    }
    if (sortBy) {
      params = params.append('sortBy', '' + sortBy);
    }
    if (page) {
      params = params.append('page', '' + page);
    }
    if (size) {
      params = params.append('size', '' + size);
    }
    const headers = new HttpHeaders().set(
      'Authorization',
      `Bearer ${this.auth.getLocalData('cnr-info', 'token')}`
    );

    return new Promise((resolve) => {
      this.http
        .get<any>(this.api + url, {
          observe: 'response',
          params: params,
          headers: headers,
        })
        .pipe(
          catchError((error: HttpErrorResponse) => {
            return throwError(error);
          })
        )
        .subscribe(
          (respose) => {
            return resolve(this.handleResponse(respose.body));
          },
          (error) => {
            return resolve(this.handleerror(error));
          }
        );
    });
  }

  handleResponse(res: any) {
    this.data.sendMessage({ from: 'api', status: false });
    return res;
  }

  handleerror(res: any) {
    this.data.sendMessage({ from: 'api', status: false });
    if (res.status == 500) {
      return res.error;
    }
  }

  private handleError(error: HttpErrorResponse) {
    console.error('An error occurred:', error);
    return throwError('Something bad happened; please try again later.');
  }

  // Métodos específicos para inventario (métodos legacy - pueden ser removidos)
  getProductosInventario(size: number = 10): Promise<JsonResponse> {
    return this.doRequest(`/productos/page?size=${size}`, null, 'get');
  }

  crearProductoInventario(productData: any): Promise<JsonResponse> {
    return this.doRequest('/productos', productData, 'post');
  }

  actualizarProductoInventario(id: number, productData: any): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, productData, 'put');
  }

  eliminarProductoInventario(id: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, null, 'delete');
  }

  buscarProductoInventario(id: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, null, 'get');
  }

  getProductosInventarioPaginado(page: number = 0, size: number = 10, search?: string, sortBy?: string): Promise<JsonResponse> {
    let endpoint = `/productos/page?page=${page}&size=${size}`;
    if (search) {
      endpoint += `&search=${encodeURIComponent(search)}`;
    }
    if (sortBy) {
      endpoint += `&sort=${encodeURIComponent(sortBy)}`;
    }
    return this.doRequest(endpoint, null, 'get');
  }

  getStockProducto(idProducto: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/page?size=1000`, null, 'get');
  }

  getCategorias(): Promise<JsonResponse> {
    return this.doRequest('/categorias', null, 'get');
  }

  // ==================== ENDPOINTS COMPLETOS DEL BACKEND ====================
  
  // ========== PRODUCTOS (6 endpoints) ==========
  
  /**
   * GET /productos - Obtener todos los productos
   */
  getAllProductos(): Promise<JsonResponse> {
    return this.doRequest('/productos', null, 'get');
  }

  /**
   * GET /productos/page - Obtener productos paginados con stock
   */
  getProductosPaginados(page: number = 0, size: number = 10): Promise<JsonResponse> {
    return this.doRequest(`/productos/page?page=${page}&size=${size}`, null, 'get');
  }

  /**
   * GET /productos/{id} - Obtener producto por ID
   */
  getProductoById(id: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, null, 'get');
  }

  /**
   * POST /productos - Crear nuevo producto
   */
  createProducto(producto: any): Promise<JsonResponse> {
    return this.doRequest('/productos', producto, 'post');
  }

  /**
   * PUT /productos/{id} - Actualizar producto completo
   */
  updateProducto(id: number, producto: any): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, producto, 'put');
  }

  /**
   * DELETE /productos/{id} - Eliminar producto
   */
  deleteProducto(id: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/${id}`, null, 'delete');
  }

  /**
   * PUT /productos/activar/{id} - Activar/Desactivar producto
   */
  toggleProductoEstado(id: number): Promise<JsonResponse> {
    return this.doRequest(`/productos/activar/${id}`, null, 'put');
  }

  // ========== CATEGORÍAS (6 endpoints) ==========
  
  /**
   * GET /categorias - Obtener todas las categorías
   */
  getAllCategorias(): Promise<JsonResponse> {
    return this.doRequest('/categorias', null, 'get');
  }

  /**
   * GET /categorias/{id} - Obtener categoría por ID
   */
  getCategoriaById(id: number): Promise<JsonResponse> {
    return this.doRequest(`/categorias/${id}`, null, 'get');
  }

  /**
   * POST /categorias - Crear nueva categoría
   */
  createCategoria(categoria: any): Promise<JsonResponse> {
    return this.doRequest('/categorias', categoria, 'post');
  }

  /**
   * PUT /categorias/{id} - Actualizar categoría completa
   */
  updateCategoria(id: number, categoria: any): Promise<JsonResponse> {
    return this.doRequest(`/categorias/${id}`, categoria, 'put');
  }

  /**
   * DELETE /categorias/{id} - Eliminar categoría
   */
  deleteCategoria(id: number): Promise<JsonResponse> {
    return this.doRequest(`/categorias/${id}`, null, 'delete');
  }

  /**
   * PUT /categorias/activar/{id} - Activar/Desactivar categoría
   */
  toggleCategoriaEstado(id: number): Promise<JsonResponse> {
    return this.doRequest(`/categorias/activar/${id}`, null, 'put');
  }

  // ========== MOVIMIENTOS (2 endpoints) ==========
  
  /**
   * POST /movimiento/compra - Registrar movimiento de compra
   */
  registrarCompra(movimiento: any): Promise<JsonResponse> {
    return this.doRequest('/movimiento/compra', movimiento, 'post');
  }

  /**
   * POST /movimiento/venta - Registrar movimiento de venta
   */
  registrarVenta(creditos: any[]): Promise<JsonResponse> {
    return this.doRequest('/movimiento/venta', creditos, 'post');
  }

  // ========== KARDEX (1 endpoint) ==========
  
  /**
   * GET /kardex/{productoId} - Obtener kardex (historial de movimientos) de un producto
   */
  getKardexProducto(productoId: number): Promise<JsonResponse> {
    if (!productoId || productoId === undefined || productoId === null) {
      console.error('❌ Error: ID del producto es inválido:', productoId);
      return Promise.reject(new Error('ID del producto es requerido para obtener el kardex'));
    }
    
    console.log('🔍 Obteniendo kardex para producto ID:', productoId);
    return this.doRequest(`/kardex/${productoId}`, null, 'get');  
  }

  // ========== CUENTAS POR COBRAR (5 endpoints) ==========
  
  /**
   * GET /pagarxcobrar - Obtener todas las cuentas por cobrar
   */
  getAllCuentasPorCobrar(): Promise<JsonResponse> {
    return this.doRequest('/pagarxcobrar', null, 'get');
  }

  /**
   * GET /pagarxcobrar/{id} - Obtener cuenta por cobrar por ID
   */
  getCuentaPorCobrarById(id: number): Promise<JsonResponse> {
    return this.doRequest(`/pagarxcobrar/${id}`, null, 'get');
  }

  /**
   * POST /pagarxcobrar - Crear nueva cuenta por cobrar
   */
  createCuentaPorCobrar(cuenta: any): Promise<JsonResponse> {
    return this.doRequest('/pagarxcobrar', cuenta, 'post');
  }

  /**
   * PUT /pagarxcobrar/{id} - Actualizar cuenta por cobrar
   */
  updateCuentaPorCobrar(id: number, cuenta: any): Promise<JsonResponse> {
    return this.doRequest(`/pagarxcobrar/${id}`, cuenta, 'put');
  }

  /**
   * DELETE /pagarxcobrar/{id} - Eliminar cuenta por cobrar
   */
  deleteCuentaPorCobrar(id: number): Promise<JsonResponse> {
    return this.doRequest(`/pagarxcobrar/${id}`, null, 'delete');
  }

  // ========== CUOTAS (5 endpoints) ==========
  
  /**
   * GET /cuotas - Obtener todas las cuotas
   */
  getAllCuotas(): Promise<JsonResponse> {
    return this.doRequest('/cuotas', null, 'get');
  }

  /**
   * GET /cuotas/{id} - Obtener cuota por ID
   */
  getCuotaById(id: number): Promise<JsonResponse> {
    return this.doRequest(`/cuotas/${id}`, null, 'get');
  }

  /**
   * POST /cuotas - Crear nueva cuota
   */
  createCuota(cuota: any): Promise<JsonResponse> {
    return this.doRequest('/cuotas', cuota, 'post');
  }

  /**
   * PUT /cuotas/{id} - Actualizar cuota
   */
  updateCuota(id: number, cuota: any): Promise<JsonResponse> {
    return this.doRequest(`/cuotas/${id}`, cuota, 'put');
  }

  /**
   * DELETE /cuotas/{id} - Eliminar cuota
   */
  deleteCuota(id: number): Promise<JsonResponse> {
    return this.doRequest(`/cuotas/${id}`, null, 'delete');
  }

  // ========== CLIENTES/PROVEEDORES (5 endpoints) ==========
  
  /**
   * GET /clientesprov - Obtener todos los clientes/proveedores
   */
  getAllClientesProveedores(): Promise<JsonResponse> {
    return this.doRequest('/clientesprov', null, 'get');
  }

  /**
   * GET /clientesprov/{id} - Obtener cliente/proveedor por ID
   */
  getClienteProveedorById(id: number): Promise<JsonResponse> {
    return this.doRequest(`/clientesprov/${id}`, null, 'get');
  }

  /**
   * POST /clientesprov - Crear nuevo cliente/proveedor
   */
  createClienteProveedor(cliente: any): Promise<JsonResponse> {
    return this.doRequest('/clientesprov', cliente, 'post');
  }

  /**
   * PUT /clientesprov/{id} - Actualizar cliente/proveedor
   */
  updateClienteProveedor(id: number, cliente: any): Promise<JsonResponse> {
    return this.doRequest(`/clientesprov/${id}`, cliente, 'put');
  }

  /**
   * DELETE /clientesprov/{id} - Eliminar cliente/proveedor
   */
  deleteClienteProveedor(id: number): Promise<JsonResponse> {
    return this.doRequest(`/clientesprov/${id}`, null, 'delete');
  }
}
