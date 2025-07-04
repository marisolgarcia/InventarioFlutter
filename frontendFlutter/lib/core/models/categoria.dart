class Categoria {
  final int codigo;
  final String nombre;
  final String descripcion;
  final String estado;

  const Categoria({
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.estado,
  });

  // Deserialización desde JSON - Mapea desde el backend Java
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      codigo: json['codigoCat'] as int? ?? 0,
      nombre: json['nombreCat'] as String? ?? '',
      descripcion: json['descripcionCat'] as String? ?? '',
      estado: json['estadoCat'] as String? ?? 'activo',
    );
  }

  // Serialización a JSON - Para enviar al backend Java
  Map<String, dynamic> toJson() {
    return {
      'codigoCat': codigo,
      'nombreCat': nombre,
      'descripcionCat': descripcion,
      'estadoCat': estado,
    };
  }

  // Métodos de conveniencia
  bool get isActiva => estado.toLowerCase() == 'activo';

  // Método para crear copias modificadas
  Categoria copyWith({
    int? codigo,
    String? nombre,
    String? descripcion,
    String? estado,
  }) {
    return Categoria(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
    );
  }
}
