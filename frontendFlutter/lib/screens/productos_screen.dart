import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventario_provider.dart';
import '../core/models/producto.dart';
import '../widgets/app_drawer.dart';

/// Pantalla de gestión de productos - Equivalente al tab de productos en Angular
/// Incluye listado, búsqueda, paginación y acciones CRUD
class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Cargar productos al inicializar - Equivalente a ngOnInit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventarioProvider>().loadProductosPaginados();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProductDialog(context),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<InventarioProvider>(
        // Equivalente a subscribirse a observables en Angular
        builder: (context, provider, child) {
          return Column(
            children: [
              // Barra de búsqueda y acciones
              _buildSearchAndActions(provider),
              
              // Lista de productos o loading
              Expanded(
                child: _buildProductList(provider),
              ),
              
              // Paginación
              if (provider.totalPages > 1) _buildPagination(provider),
            ],
          );
        },
      ),
    );
  }

  /// Barra de búsqueda y acciones - Equivalente a los controles de Angular
  Widget _buildSearchAndActions(InventarioProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Campo de búsqueda - Equivalente a [(ngModel)]
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Buscar productos...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Botones de acción - Equivalente a (click) en Angular
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: provider.productosLoading 
                    ? null 
                    : () => provider.loadProductosPaginados(),
                icon: provider.productosLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(provider.productosLoading ? 'Cargando...' : 'Actualizar'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateProductDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Lista de productos - Equivalente a *ngFor en Angular
  Widget _buildProductList(InventarioProvider provider) {
    // Mostrar error si existe - Equivalente a *ngIf="error"
    if (provider.productosError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${provider.productosError}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadProductosPaginados(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // Mostrar loading - Equivalente a *ngIf="loading"
    if (provider.productosLoading && provider.productos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrar productos según búsqueda - Equivalente a pipes en Angular
    final filteredProducts = _searchQuery.isEmpty 
        ? provider.productos 
        : provider.searchProductos(_searchQuery);

    // Lista vacía - Equivalente a *ngIf="productos.length === 0"
    if (filteredProducts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No hay productos disponibles'),
          ],
        ),
      );
    }

    // Lista de productos - Equivalente a *ngFor="let producto of productos"
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final producto = filteredProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: producto.isActivo ? Colors.green : Colors.grey,
              child: Text(
                producto.nombreProd.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(producto.nombreProd),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código: ${producto.codigoProd}'),
                Text('Categoría: ${producto.categoria.nombre}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Información no disponible', // El precio no está en el modelo actual
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  producto.estadoDisplay,
                  style: TextStyle(
                    color: producto.stockBajo ? Colors.red : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () => context.go('/producto/${producto.codigoProd}'), // Equivalente a routerLink
            onLongPress: () => _showProductActions(context, producto),
          ),
        );
      },
    );
  }

  /// Paginación - Equivalente a los controles de paginación de Angular
  Widget _buildPagination(InventarioProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de página
          Text(
            'Página ${provider.currentPage + 1} de ${provider.totalPages}',
            style: const TextStyle(fontSize: 14),
          ),
          
          // Botones de navegación
          Row(
            children: [
              IconButton(
                onPressed: provider.hasPreviousPage && !provider.productosLoading
                    ? () => provider.previousPage()
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: provider.hasNextPage && !provider.productosLoading
                    ? () => provider.nextPage()
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Mostrar acciones del producto - Equivalente a menús contextuales
  void _showProductActions(BuildContext context, Producto producto) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar'),
            onTap: () {
              Navigator.pop(context);
              _showEditProductDialog(context, producto);
            },
          ),
          ListTile(
            leading: Icon(
              producto.isActivo ? Icons.visibility_off : Icons.visibility,
            ),
            title: Text(producto.isActivo ? 'Desactivar' : 'Activar'),
            onTap: () {
              Navigator.pop(context);
              _toggleProductStatus(context, producto);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _deleteProduct(context, producto);
            },
          ),
        ],
      ),
    );
  }

  /// Crear producto - Equivalente a formularios de Angular
  void _showCreateProductDialog(BuildContext context) {
    // Implementar formulario de creación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Producto'),
        content: const Text('Implementar formulario de creación de producto'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar lógica de creación
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  /// Editar producto - Equivalente a formularios de edición de Angular
  void _showEditProductDialog(BuildContext context, Producto producto) {
    // Implementar formulario de edición
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Producto'),
        content: Text('Implementar formulario de edición para: ${producto.nombreProd}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar lógica de edición
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Cambiar estado del producto - Equivalente a llamadas a servicios
  void _toggleProductStatus(BuildContext context, Producto producto) async {
    final provider = context.read<InventarioProvider>();
    final success = await provider.toggleProductoEstado(producto.codigoProd);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Estado del producto ${producto.isActivo ? 'desactivado' : 'activado'}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Eliminar producto - Equivalente a confirmaciones y llamadas a servicios
  void _deleteProduct(BuildContext context, Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar el producto "${producto.nombreProd}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<InventarioProvider>();
              final success = await provider.deleteProducto(producto.codigoProd);
              
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto eliminado exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
