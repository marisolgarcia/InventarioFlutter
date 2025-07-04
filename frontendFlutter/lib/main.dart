import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/inventario_provider.dart';
import 'providers/inventario_extended_provider.dart';
import 'screens/home_screen.dart';
import 'screens/productos_screen.dart';
import 'screens/categorias_screen.dart';
import 'screens/producto_detail_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InventarioProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InventarioExtendedProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Sistema de Inventario',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Configuración de rutas - Equivalente al RouterModule de Angular
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/productos',
      name: 'productos',
      builder: (context, state) => const ProductosScreen(),
    ),
    GoRoute(
      path: '/categorias',
      name: 'categorias',
      builder: (context, state) => const CategoriasScreen(),
    ),
    GoRoute(
      path: '/producto/:id',
      name: 'producto-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductoDetailScreen(productId: id);
      },
    ),
  ],
);
