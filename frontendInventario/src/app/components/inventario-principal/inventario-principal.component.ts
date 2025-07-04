import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { InventarioApiService } from '../../core/services/inventario-api.service';

@Component({
  selector: 'app-inventario-principal',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container">
      <h1>Sistema de Inventario</h1>
      
      <!-- Navegación por tabs -->
      <div class="tabs">
        <button 
          *ngFor="let tab of tabs" 
          [class.active]="activeTab === tab.id"
          (click)="setActiveTab(tab.id)">
          {{ tab.label }}
        </button>
      </div>

      <!-- TAB: PRODUCTOS -->
      <div *ngIf="activeTab === 'productos'" class="tab-content">
        <h2>Gestión de Productos</h2>
        
        <div class="actions">
          <button class="btn-load btn-primary" (click)="loadProductos()" [disabled]="loading">
            <i class="material-icons">refresh</i>
            {{ loading ? 'Cargando...' : 'Cargar Productos' }}
          </button>
          <button class="btn-load btn-secondary" (click)="loadProductosPaginados()" [disabled]="loading">
            <i class="material-icons">view_list</i>
            Cargar Productos Paginados
          </button>
        </div>

        <div *ngIf="error" class="error">
          {{ error }}
        </div>

        <div *ngIf="productos.length > 0" class="data-table">
          <h3>Productos ({{ productos.length }})</h3>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Unidades Mín</th>
                <th>Estado</th>
                <th>Categoría</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let producto of productos">
                <td>{{ producto.codigoProd }}</td>
                <td>{{ producto.nombreProd }}</td>
                <td>{{ producto.descripcionProd }}</td>
                <td>{{ producto.unidadesMin }}</td>
                <td>{{ producto.estadoProd }}</td>
                <td>{{ producto.categoria?.nombreCat || 'N/A' }}</td>
                <td>
                  <button class="btn-action btn-info" (click)="verKardex(producto.codigoProd)">
                    <i class="material-icons">history</i>
                    Ver Kardex
                  </button>
                  <button class="btn-action btn-primary" (click)="verMovimientos(producto.codigoProd)">
                    <i class="material-icons">swap_horiz</i>
                    Movimientos
                  </button>
                  <button class="btn-action" [ngClass]="producto.estadoProd === 'activo' ? 'btn-warning' : 'btn-success'" (click)="toggleEstadoProducto(producto.codigoProd)">
                    <i class="material-icons">{{ producto.estadoProd === 'activo' ? 'visibility_off' : 'visibility' }}</i>
                    {{ producto.estadoProd === 'activo' ? 'Desactivar' : 'Activar' }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB: CATEGORÍAS -->
      <div *ngIf="activeTab === 'categorias'" class="tab-content">
        <h2>Gestión de Categorías</h2>
        
        <div class="actions">
          <button class="btn-load btn-primary" (click)="loadCategorias()" [disabled]="loading">
            <i class="material-icons">refresh</i>
            {{ loading ? 'Cargando...' : 'Cargar Categorías' }}
          </button>
        </div>

        <div *ngIf="categorias.length > 0" class="data-table">
          <h3>Categorías ({{ categorias.length }})</h3>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let categoria of categorias">
                <td>{{ categoria.codigoCat }}</td>
                <td>{{ categoria.nombreCat }}</td>
                <td>{{ categoria.descripcionCat }}</td>
                <td>{{ categoria.estadoCat }}</td>
                <td>
                  <button class="btn-action" [ngClass]="categoria.estadoCat === 'activo' ? 'btn-warning' : 'btn-success'" (click)="toggleEstadoCategoria(categoria.codigoCat)">
                    <i class="material-icons">{{ categoria.estadoCat === 'activo' ? 'visibility_off' : 'visibility' }}</i>
                    {{ categoria.estadoCat === 'activo' ? 'Desactivar' : 'Activar' }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB: CUENTAS POR COBRAR -->
      <div *ngIf="activeTab === 'cuentas'" class="tab-content">
        <h2>Cuentas por Cobrar</h2>
        
        <div class="actions">
          <button class="btn-load btn-primary" (click)="loadCuentasPorCobrar()" [disabled]="loading">
            <i class="material-icons">account_balance</i>
            {{ loading ? 'Cargando...' : 'Cargar Cuentas' }}
          </button>
        </div>

        <div *ngIf="cuentasPorCobrar.length > 0" class="data-table">
          <h3>Cuentas por Cobrar ({{ cuentasPorCobrar.length }})</h3>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Num Factura</th>
                <th>Monto Deuda</th>
                <th>Cuota Base</th>
                <th>Num Cuotas</th>
                <th>Interés %</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let cuenta of cuentasPorCobrar">
                <td>{{ cuenta.codigo }}</td>
                <td>{{ cuenta.numFactura }}</td>
                <td>{{ cuenta.montoDeuda | currency }}</td>
                <td>{{ cuenta.cuotaBase | currency }}</td>
                <td>{{ cuenta.numCuotas }}</td>
                <td>{{ cuenta.interes }}%</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB: CUOTAS -->
      <div *ngIf="activeTab === 'cuotas'" class="tab-content">
        <h2>Gestión de Cuotas</h2>
        
        <div class="actions">
          <button class="btn-load btn-primary" (click)="loadCuotas()" [disabled]="loading">
            <i class="material-icons">payment</i>
            {{ loading ? 'Cargando...' : 'Cargar Cuotas' }}
          </button>
        </div>

        <div *ngIf="cuotas.length > 0" class="data-table">
          <h3>Cuotas ({{ cuotas.length }})</h3>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Cargo</th>
                <th>Fecha de Pago</th>
                <th>Estado</th>
                <th>Cuenta</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let cuota of cuotas">
                <td>{{ cuota.codigoCuota }}</td>
                <td>{{ cuota.cargo | currency }}</td>
                <td>{{ cuota.fechaDePago | date }}</td>
                <td>{{ cuota.estado_cuota }}</td>
                <td>{{ cuota.cuenta?.codigo || 'N/A' }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB: CLIENTES/PROVEEDORES -->
      <div *ngIf="activeTab === 'clientes'" class="tab-content">
        <h2>Clientes y Proveedores</h2>
        
        <div class="actions">
          <button class="btn-load btn-primary" (click)="loadClientesProveedores()" [disabled]="loading">
            <i class="material-icons">people</i>
            {{ loading ? 'Cargando...' : 'Cargar Clientes/Proveedores' }}
          </button>
        </div>

        <div *ngIf="clientesProveedores.length > 0" class="data-table">
          <h3>Clientes y Proveedores ({{ clientesProveedores.length }})</h3>
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Identificación</th>
                <th>Dirección</th>
                <th>Teléfono</th>
                <th>Email</th>
                <th>Tipo</th>
              </tr>
            </thead>
            <tbody>
              <tr *ngFor="let cliente of clientesProveedores">
                <td>{{ cliente.codigo }}</td>
                <td>{{ cliente.nombre }}</td>
                <td>{{ cliente.identificacion }}</td>
                <td>{{ cliente.direccion }}</td>
                <td>{{ cliente.telefono }}</td>
                <td>{{ cliente.email }}</td>
                <td>{{ cliente.tipo }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- MODAL KARDEX -->
      <div *ngIf="showKardexModal" class="modal-overlay" (click)="closeKardexModal()">
        <div class="modal-content" (click)="$event.stopPropagation()">
          <h3>
            <i class="material-icons">history</i>
            Kardex - {{ kardexData?.producto?.nombreProd }}
          </h3>
          <button class="close-btn" (click)="closeKardexModal()">
            <i class="material-icons">close</i>
          </button>
          
          <div *ngIf="kardexData?.listaMovimientos?.length > 0">
            <table>
              <thead>
                <tr>
                  <th>Num Mov</th>
                  <th>Fecha</th>
                  <th>Tipo</th>
                  <th>Inv Inicial</th>
                  <th>Entrada</th>
                  <th>Salida</th>
                  <th>Inv Final</th>
                  <th>Costo Unit</th>
                </tr>
              </thead>
              <tbody>
                <tr *ngFor="let mov of kardexData.listaMovimientos">
                  <td>{{ mov.numMovimiento }}</td>
                  <td>{{ mov.fecha | date }}</td>
                  <td>{{ mov.tipo }}</td>
                  <td>{{ mov.invInicial }}</td>
                  <td>{{ mov.entrada }}</td>
                  <td>{{ mov.salida }}</td>
                  <td>{{ mov.invFinal }}</td>
                  <td>{{ mov.costoUnitario | currency }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <div *ngIf="!kardexData?.listaMovimientos?.length">
            <p>No hay movimientos para este producto</p>
          </div>
        </div>
      </div>

      <!-- MODAL MOVIMIENTOS -->
      <div *ngIf="showMovimientosModal" class="modal-overlay" (click)="closeMovimientosModal()">
        <div class="modal-content" (click)="$event.stopPropagation()">
          <h3>
            <i class="material-icons">swap_horiz</i>
            Movimientos - {{ movimientosData?.producto?.nombreProd }}
          </h3>
          <button class="close-btn" (click)="closeMovimientosModal()">
            <i class="material-icons">close</i>
          </button>
          
          <div *ngIf="movimientosData?.listaMovimientos?.length > 0">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Fecha</th>
                  <th>Tipo</th>
                  <th>Cantidad</th>
                  <th>Precio</th>
                  <th>Observaciones</th>
                </tr>
              </thead>
              <tbody>
                <tr *ngFor="let mov of movimientosData.listaMovimientos">
                  <td>{{ mov.id }}</td>
                  <td>{{ mov.fechaMovimiento | date }}</td>
                  <td>{{ mov.tipoMovimiento }}</td>
                  <td>{{ mov.cantidad }}</td>
                  <td>{{ mov.precio | currency }}</td>
                  <td>{{ mov.observaciones }}</td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <div *ngIf="!movimientosData?.listaMovimientos?.length">
            <p>No hay movimientos para este producto</p>
          </div>
        </div>
      </div>

      <!-- LOG DE REQUESTS -->
      <div class="log-section">
        <h3>Log de Requests</h3>
        <div class="log" *ngFor="let log of requestLogs">
          <span class="timestamp">{{ log.timestamp }}</span>
          <span class="method">{{ log.method }}</span>
          <span class="url">{{ log.url }}</span>
          <span class="status" [class]="log.success ? 'success' : 'error'">
            {{ log.success ? 'SUCCESS' : 'ERROR' }}
          </span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 24px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
    }

    h1 {
      color: #2c3e50;
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 2rem;
      text-align: center;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .tabs {
      display: flex;
      background: white;
      border-radius: 12px;
      padding: 6px;
      margin-bottom: 24px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      overflow-x: auto;
    }

    .tabs button {
      flex: 1;
      padding: 12px 20px;
      border: none;
      background: transparent;
      cursor: pointer;
      border-radius: 8px;
      font-weight: 500;
      color: #64748b;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      white-space: nowrap;
      min-width: 140px;
    }

    .tabs button:hover {
      background: #f1f5f9;
      color: #475569;
      transform: translateY(-1px);
    }

    .tabs button.active {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
      transform: translateY(-2px);
    }

    .tab-content {
      background: white;
      border-radius: 16px;
      padding: 32px;
      min-height: 500px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.1);
    }

    h2 {
      color: #1e293b;
      font-size: 1.875rem;
      font-weight: 600;
      margin-bottom: 24px;
      border-bottom: 3px solid #e2e8f0;
      padding-bottom: 12px;
    }

    .actions {
      margin-bottom: 24px;
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    /* Botones de carga modernos */
    .btn-load {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 24px;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
    }

    .btn-primary {
      background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    }

    .btn-secondary {
      background: linear-gradient(135deg, #64748b 0%, #475569 100%);
    }

    .btn-load:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
    }

    .btn-load:disabled {
      background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }

    .btn-load .material-icons {
      font-size: 18px;
    }

    /* Botones de acción en tablas */
    .btn-action {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      margin: 2px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 12px;
      font-weight: 500;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      min-width: 100px;
      justify-content: center;
    }

    .btn-info {
      background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
      color: white;
    }

    .btn-info:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(6, 182, 212, 0.4);
    }

    .btn-success {
      background: linear-gradient(135deg, #10b981 0%, #059669 100%);
      color: white;
    }

    .btn-success:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
    }

    .btn-warning {
      background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
      color: white;
    }

    .btn-warning:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(245, 158, 11, 0.4);
    }

    .btn-action .material-icons {
      font-size: 16px;
    }

    /* Botones originales (mantener compatibilidad) */
    .actions button:not(.btn-load):not(.btn-action) {
      padding: 12px 24px;
      background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
    }

    .actions button:not(.btn-load):not(.btn-action):hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(79, 70, 229, 0.4);
    }

    .actions button:not(.btn-load):not(.btn-action):disabled {
      background: linear-gradient(135deg, #9ca3af 0%, #6b7280 100%);
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }

    .error {
      background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
      color: #b91c1c;
      padding: 16px;
      border-radius: 12px;
      margin-bottom: 24px;
      border-left: 4px solid #dc2626;
      font-weight: 500;
    }

    .data-table {
      overflow-x: auto;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 12px;
      overflow: hidden;
    }

    th, td {
      padding: 16px 20px;
      text-align: left;
      border-bottom: 1px solid #e2e8f0;
    }

    th {
      background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
      font-weight: 600;
      color: #374151;
      text-transform: uppercase;
      font-size: 0.875rem;
      letter-spacing: 0.05em;
    }

    tr:hover {
      background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    }

    tr:last-child td {
      border-bottom: none;
    }

    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.7);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 1000;
      backdrop-filter: blur(4px);
    }

    .modal-content {
      background: white;
      padding: 32px;
      border-radius: 20px;
      max-width: 90%;
      max-height: 90%;
      overflow: auto;
      position: relative;
      box-shadow: 0 25px 50px rgba(0,0,0,0.25);
      animation: modalSlideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .modal-content h3 {
      color: #1e293b;
      font-size: 1.5rem;
      font-weight: 600;
      margin-bottom: 24px;
      padding-bottom: 12px;
      border-bottom: 2px solid #e2e8f0;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .modal-content h3 .material-icons {
      font-size: 24px;
      color: #4f46e5;
    }

    @keyframes modalSlideIn {
      from {
        opacity: 0;
        transform: translateY(-20px) scale(0.95);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    .close-btn {
      position: absolute;
      top: 16px;
      right: 20px;
      background: #f3f4f6;
      border: none;
      cursor: pointer;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      color: #6b7280;
    }

    .close-btn:hover {
      background: #e5e7eb;
      transform: scale(1.1);
    }

    .close-btn .material-icons {
      font-size: 20px;
    }

    .log-section {
      margin-top: 48px;
      border-top: 2px solid #e2e8f0;
      padding-top: 32px;
    }

    .log-section h3 {
      color: #374151;
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 16px;
    }

    .log {
      display: flex;
      gap: 16px;
      padding: 12px 16px;
      font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
      font-size: 13px;
      background: #f8fafc;
      border-radius: 8px;
      margin-bottom: 8px;
      border-left: 4px solid #e2e8f0;
      transition: all 0.3s ease;
    }

    .log:hover {
      background: #f1f5f9;
      border-left-color: #6366f1;
    }

    .timestamp {
      color: #6b7280;
      font-weight: 500;
    }

    .method {
      font-weight: 700;
      color: #6366f1;
      background: #e0e7ff;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
    }

    .url {
      color: #374151;
      font-weight: 500;
    }

    .status.success {
      color: #059669;
      font-weight: 700;
      background: #d1fae5;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
    }

    .status.error {
      color: #dc2626;
      font-weight: 700;
      background: #fee2e2;
      padding: 2px 8px;
      border-radius: 4px;
      font-size: 11px;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .container {
        padding: 16px;
      }

      h1 {
        font-size: 2rem;
      }

      .tabs button {
        padding: 10px 16px;
        font-size: 14px;
        min-width: 120px;
      }

      .tab-content {
        padding: 24px;
      }

      .actions {
        flex-direction: column;
        align-items: stretch;
      }

      .actions button, .btn-load, .btn-action {
        width: 100%;
        margin-bottom: 8px;
        justify-content: center;
      }

      .btn-action {
        min-width: auto;
      }

      .log {
        flex-direction: column;
        gap: 8px;
      }

      .modal-content {
        padding: 20px;
        margin: 20px;
        max-width: calc(100% - 40px);
      }

      .modal-content h3 {
        font-size: 1.25rem;
      }
    }

    /* Scrollbar personalizado */
    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background: #f1f5f9;
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb {
      background: #cbd5e1;
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: #94a3b8;
    }
  `]
})
export class InventarioPrincipalComponent implements OnInit {
  activeTab = 'productos';
  loading = false;
  error = '';

  // Datos de las diferentes entidades
  productos: any[] = [];
  categorias: any[] = [];
  cuentasPorCobrar: any[] = [];
  cuotas: any[] = [];
  clientesProveedores: any[] = [];

  // Modal kardex
  showKardexModal = false;
  kardexData: any = null;

  // Modal movimientos
  showMovimientosModal = false;
  movimientosData: any = null;

  // Log de requests
  requestLogs: any[] = [];

  tabs = [
    { id: 'productos', label: 'Productos' },
    { id: 'categorias', label: 'Categorías' },
    { id: 'cuentas', label: 'Cuentas por Cobrar' },
    { id: 'cuotas', label: 'Cuotas' },
    { id: 'clientes', label: 'Clientes/Proveedores' }
  ];

  constructor(private apiService: InventarioApiService) {}

  ngOnInit() {
    this.loadProductos();
  }

  setActiveTab(tabId: string) {
    this.activeTab = tabId;
  }

  // ==================== PRODUCTOS ====================
  loadProductos() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/productos');

    this.apiService.getProductos().subscribe({
      next: (data) => {
        this.productos = data;
        this.logRequest('GET', '/productos', true);
        this.loading = false;
        console.log('✅ Productos cargados:', data);
      },
      error: (error) => {
        this.error = `Error al cargar productos: ${error.message}`;
        this.logRequest('GET', '/productos', false);
        this.loading = false;
        console.error('❌ Error al cargar productos:', error);
      }
    });
  }

  loadProductosPaginados() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/productos/page');

    this.apiService.getProductosPaginados(0, 10).subscribe({
      next: (data) => {
        // Si la respuesta tiene estructura paginada
        if (data.pages && data.pages.content) {
          this.productos = data.pages.content;
        } else {
          this.productos = data;
        }
        this.logRequest('GET', '/productos/page', true);
        this.loading = false;
        console.log('✅ Productos paginados cargados:', data);
      },
      error: (error) => {
        this.error = `Error al cargar productos paginados: ${error.message}`;
        this.logRequest('GET', '/productos/page', false);
        this.loading = false;
        console.error('❌ Error al cargar productos paginados:', error);
      }
    });
  }

  toggleEstadoProducto(id: number) {
    this.logRequest('PUT', `/productos/activar/${id}`);
    
    this.apiService.toggleProductoEstado(id).subscribe({
      next: (data) => {
        this.logRequest('PUT', `/productos/activar/${id}`, true);
        console.log('✅ Estado del producto cambiado:', data);
        this.loadProductos(); // Recargar lista
      },
      error: (error) => {
        this.logRequest('PUT', `/productos/activar/${id}`, false);
        console.error('❌ Error al cambiar estado del producto:', error);
      }
    });
  }

  verKardex(productoId: number) {
    this.logRequest('GET', `/kardex/${productoId}`);
    
    this.apiService.getKardex(productoId).subscribe({
      next: (data) => {
        this.kardexData = data;
        this.showKardexModal = true;
        this.logRequest('GET', `/kardex/${productoId}`, true);
        console.log('✅ Kardex cargado:', data);
      },
      error: (error) => {
        this.logRequest('GET', `/kardex/${productoId}`, false);
        console.error('❌ Error al cargar kardex:', error);
      }
    });
  }

  verMovimientos(productoId: number) {
    this.logRequest('GET', `/movimientos/${productoId}`);
    
    // Simular carga de movimientos (puedes implementar la lógica real aquí)
    this.movimientosData = {
      producto: { nombreProd: 'Producto ' + productoId },
      listaMovimientos: [
        {
          id: 1,
          fechaMovimiento: new Date(),
          tipoMovimiento: 'Compra',
          cantidad: 10,
          precio: 100,
          observaciones: 'Compra inicial'
        },
        {
          id: 2,
          fechaMovimiento: new Date(),
          tipoMovimiento: 'Venta',
          cantidad: 5,
          precio: 150,
          observaciones: 'Venta al cliente'
        }
      ]
    };
    this.showMovimientosModal = true;
    this.logRequest('GET', `/movimientos/${productoId}`, true);
    console.log('✅ Movimientos cargados:', this.movimientosData);
  }

  closeKardexModal() {
    this.showKardexModal = false;
    this.kardexData = null;
  }

  closeMovimientosModal() {
    this.showMovimientosModal = false;
    this.movimientosData = null;
  }

  // ==================== CATEGORÍAS ====================
  loadCategorias() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/categorias');

    this.apiService.getCategorias().subscribe({
      next: (data) => {
        this.categorias = data;
        this.logRequest('GET', '/categorias', true);
        this.loading = false;
        console.log('✅ Categorías cargadas:', data);
      },
      error: (error) => {
        this.error = `Error al cargar categorías: ${error.message}`;
        this.logRequest('GET', '/categorias', false);
        this.loading = false;
        console.error('❌ Error al cargar categorías:', error);
      }
    });
  }

  toggleEstadoCategoria(id: number) {
    this.logRequest('PUT', `/categorias/activar/${id}`);
    
    this.apiService.toggleCategoriaEstado(id).subscribe({
      next: (data) => {
        this.logRequest('PUT', `/categorias/activar/${id}`, true);
        console.log('✅ Estado de la categoría cambiado:', data);
        this.loadCategorias(); // Recargar lista
      },
      error: (error) => {
        this.logRequest('PUT', `/categorias/activar/${id}`, false);
        console.error('❌ Error al cambiar estado de la categoría:', error);
      }
    });
  }

  // ==================== CUENTAS POR COBRAR ====================
  loadCuentasPorCobrar() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/pagarxcobrar');

    this.apiService.getCuentasPorCobrar().subscribe({
      next: (data) => {
        this.cuentasPorCobrar = data;
        this.logRequest('GET', '/pagarxcobrar', true);
        this.loading = false;
        console.log('✅ Cuentas por cobrar cargadas:', data);
      },
      error: (error) => {
        this.error = `Error al cargar cuentas por cobrar: ${error.message}`;
        this.logRequest('GET', '/pagarxcobrar', false);
        this.loading = false;
        console.error('❌ Error al cargar cuentas por cobrar:', error);
      }
    });
  }

  // ==================== CUOTAS ====================
  loadCuotas() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/cuotas');

    this.apiService.getCuotas().subscribe({
      next: (data) => {
        this.cuotas = data;
        this.logRequest('GET', '/cuotas', true);
        this.loading = false;
        console.log('✅ Cuotas cargadas:', data);
      },
      error: (error) => {
        this.error = `Error al cargar cuotas: ${error.message}`;
        this.logRequest('GET', '/cuotas', false);
        this.loading = false;
        console.error('❌ Error al cargar cuotas:', error);
      }
    });
  }

  // ==================== CLIENTES/PROVEEDORES ====================
  loadClientesProveedores() {
    this.loading = true;
    this.error = '';
    this.logRequest('GET', '/clientesprov');

    this.apiService.getClientesProveedores().subscribe({
      next: (data) => {
        this.clientesProveedores = data;
        this.logRequest('GET', '/clientesprov', true);
        this.loading = false;
        console.log('✅ Clientes/Proveedores cargados:', data);
      },
      error: (error) => {
        this.error = `Error al cargar clientes/proveedores: ${error.message}`;
        this.logRequest('GET', '/clientesprov', false);
        this.loading = false;
        console.error('❌ Error al cargar clientes/proveedores:', error);
      }
    });
  }

  // ==================== LOGGING ====================
  private logRequest(method: string, url: string, success: boolean = false) {
    this.requestLogs.unshift({
      timestamp: new Date().toLocaleTimeString(),
      method,
      url,
      success
    });
    
    // Mantener solo los últimos 20 logs
    if (this.requestLogs.length > 20) {
      this.requestLogs = this.requestLogs.slice(0, 20);
    }
  }
}
