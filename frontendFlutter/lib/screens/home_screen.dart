import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventario_provider.dart';
import '../widgets/app_drawer.dart';

/// Pantalla principal - Equivalente al componente inventario-principal de Angular
/// Incluye navegación por tabs y resumen del inventario
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales - Equivalente a ngOnInit en Angular
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InventarioProvider>();
      provider.loadProductos();
      provider.loadCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.inventory, color: Colors.white),
            SizedBox(width: 8),
            Text('Sistema de Inventario'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Consumer<InventarioProvider>(
        // Equivalente a subscribirse a observables en Angular
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjetas de resumen
                _buildSummaryCards(provider),
                const SizedBox(height: 24),
                
                // Productos recientes
                _buildRecentProducts(provider),
                const SizedBox(height: 24),
                
                // Alertas
                _buildAlerts(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Tarjetas de resumen - Equivalente a las cards de Angular
  Widget _buildSummaryCards(InventarioProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen del Inventario',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Productos',
                value: '${provider.productos.length}',
                icon: Icons.inventory,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Stock Bajo',
                value: '${provider.productosStockBajo.length}',
                icon: Icons.warning,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Activos',
                value: '${provider.productosActivos.length}',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                title: 'Vencidos',
                value: '${provider.productosVencidos.length}',
                icon: Icons.error,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Tarjeta individual de resumen
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lista de productos recientes - Equivalente a *ngFor en Angular
  Widget _buildRecentProducts(InventarioProvider provider) {
    final recentProducts = provider.productos.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Productos Recientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/productos'), // Equivalente a routerLink
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Equivalente a *ngIf en Angular
        if (provider.productosLoading)
          const Center(child: CircularProgressIndicator())
        else if (recentProducts.isEmpty)
          const Center(
            child: Text('No hay productos registrados'),
          )
        else
          // Equivalente a *ngFor en Angular
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentProducts.length,
            itemBuilder: (context, index) {
              final producto = recentProducts[index];
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
                  subtitle: Text(producto.codigoProd.toString()),
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
                        'Stock: ${producto.unidadesMin}',
                        style: TextStyle(
                          color: producto.stockBajo ? Colors.red : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => context.go('/producto/${producto.codigoProd}'), // Equivalente a (click)
                ),
              );
            },
          ),
      ],
    );
  }

  /// Alertas del sistema - Equivalente a *ngIf con múltiples condiciones
  Widget _buildAlerts(InventarioProvider provider) {
    final alerts = <Widget>[];
    
    if (provider.productosStockBajo.isNotEmpty) {
      alerts.add(
        Card(
          color: Colors.orange.shade50,
          child: ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: const Text('Stock Bajo'),
            subtitle: Text(
              '${provider.productosStockBajo.length} productos con stock bajo',
            ),
            trailing: TextButton(
              onPressed: () => context.go('/productos'),
              child: const Text('Ver'),
            ),
          ),
        ),
      );
    }

    if (provider.productosVencidos.isNotEmpty) {
      alerts.add(
        Card(
          color: Colors.red.shade50,
          child: ListTile(
            leading: const Icon(Icons.error, color: Colors.red),
            title: const Text('Productos Vencidos'),
            subtitle: Text(
              '${provider.productosVencidos.length} productos vencidos',
            ),
            trailing: TextButton(
              onPressed: () => context.go('/productos'),
              child: const Text('Ver'),
            ),
          ),
        ),
      );
    }

    // Equivalente a *ngIf="alerts.length === 0"
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alertas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...alerts, // Equivalente a *ngFor
      ],
    );
  }
}
