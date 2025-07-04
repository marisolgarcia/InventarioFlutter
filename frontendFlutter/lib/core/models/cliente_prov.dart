/// Modelo de Cliente/Proveedor - Equivalente a ClienteProv entity
class ClienteProv {
  final int? codigo;
  final String nombre;
  final String direccion;
  final String telefono;
  final String numDocumento;
  final String tipoPersona;
  final String? infoFinanciera; // Se serializa como String en lugar de byte[]
  final String estado;
  final String tipo;

  const ClienteProv({
    this.codigo,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.numDocumento,
    required this.tipoPersona,
    this.infoFinanciera,
    required this.estado,
    required this.tipo,
  });

  factory ClienteProv.fromJson(Map<String, dynamic> json) {
    return ClienteProv(
      codigo: json['codigo'] as int?,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      telefono: json['telefono'] as String,
      numDocumento: json['numDocumento'] as String,
      tipoPersona: json['tipoPersona'] as String,
      infoFinanciera: json['infoFinanciera'] as String?,
      estado: json['estado'] as String,
      tipo: json['tipo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (codigo != null) 'codigo': codigo,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'numDocumento': numDocumento,
      'tipoPersona': tipoPersona,
      if (infoFinanciera != null) 'infoFinanciera': infoFinanciera,
      'estado': estado,
      'tipo': tipo,
    };
  }

  ClienteProv copyWith({
    int? codigo,
    String? nombre,
    String? direccion,
    String? telefono,
    String? numDocumento,
    String? tipoPersona,
    String? infoFinanciera,
    String? estado,
    String? tipo,
  }) {
    return ClienteProv(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      numDocumento: numDocumento ?? this.numDocumento,
      tipoPersona: tipoPersona ?? this.tipoPersona,
      infoFinanciera: infoFinanciera ?? this.infoFinanciera,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  String toString() {
    return 'ClienteProv(codigo: $codigo, nombre: $nombre, tipo: $tipo, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClienteProv && other.codigo == codigo;
  }

  @override
  int get hashCode => codigo.hashCode;
}
