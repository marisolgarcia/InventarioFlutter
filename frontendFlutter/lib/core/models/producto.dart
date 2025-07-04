import 'categoria.dart';

class Producto {
  final int codigoProd;
  final String nombreProd;
  final Categoria categoria;
  final String descripcionProd;
  final int unidadesMin;
  final String estadoProd;

  const Producto({
    required this.codigoProd,
    required this.nombreProd,
    required this.categoria,
    required this.descripcionProd,
    required this.unidadesMin,
    required this.estadoProd,
  });

  // Deserialización desde JSON - Equivalente a mapear desde el backend Java
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigoProd: json['codigoProd'] as int? ?? 0,
      nombreProd: json['nombreProd'] as String? ?? '',
      categoria: Categoria.fromJson(json['categoria'] as Map<String, dynamic>),
      descripcionProd: json['descripcionProd'] as String? ?? '',
      unidadesMin: json['unidadesMin'] as int? ?? 0,
      estadoProd: json['estadoProd'] as String? ?? 'activo',
    );
  }
  
  // Serialización a JSON - Para enviar al backend Java
  Map<String, dynamic> toJson() {
    return {
      'codigoProd': codigoProd,
      'nombreProd': nombreProd,
      'categoria': categoria.toJson(),
      'descripcionProd': descripcionProd,
      'unidadesMin': unidadesMin,
      'estadoProd': estadoProd,
    };
  }

  // Métodos de conveniencia - Equivalente a getters computados en Angular
  bool get isActivo => estadoProd.toLowerCase() == 'activo';
  bool get stockBajo => unidadesMin <= 5;
  
  String get estadoDisplay {
    if (stockBajo) return 'Stock Bajo';
    return isActivo ? 'Activo' : 'Inactivo';
  }

  // Método para crear copias modificadas - Inmutabilidad
  Producto copyWith({
    int? codigoProd,
    String? nombreProd,
    Categoria? categoria,
    String? descripcionProd,
    int? unidadesMin,
    String? estadoProd,
  }) {
    return Producto(
      codigoProd: codigoProd ?? this.codigoProd,
      nombreProd: nombreProd ?? this.nombreProd,
      categoria: categoria ?? this.categoria,
      descripcionProd: descripcionProd ?? this.descripcionProd,
      unidadesMin: unidadesMin ?? this.unidadesMin,
      estadoProd: estadoProd ?? this.estadoProd,
    );
  }

  @override
  String toString() {
    return 'Producto(codigoProd: $codigoProd, nombreProd: $nombreProd, categoria: ${categoria.nombre}, estadoProd: $estadoProd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Producto && other.codigoProd == codigoProd;
  }

  @override
  int get hashCode => codigoProd.hashCode;
}
