import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventario_provider.dart';
import '../widgets/app_drawer.dart';

/// Pantalla de gestión de categorías - Equivalente al tab de categorías en Angular
class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventarioProvider>().loadCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Categorías'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: Consumer<InventarioProvider>(
        builder: (context, provider, child) {
          if (provider.categoriasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.categoriasError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.categoriasError}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadCategorias(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.categorias.length,
            itemBuilder: (context, index) {
              final categoria = provider.categorias[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: categoria.isActiva ? Colors.green : Colors.grey,
                    child: Text(
                      categoria.nombre.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(categoria.nombre),
                  subtitle: Text(categoria.descripcion),
                  trailing: Text(categoria.codigo.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
