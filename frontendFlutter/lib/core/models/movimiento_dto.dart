/// Modelo de MovimientoDTO - Equivalente a MovimientoDTO para Kardex
class MovimientoDto {
  final int numMovimiento;
  final DateTime fecha;
  final String tipo;
  final int invInicial;
  final double costoUnitario;
  final int entrada;
  final int salida;
  final int invFinal;

  const MovimientoDto({
    required this.numMovimiento,
    required this.fecha,
    required this.tipo,
    required this.invInicial,
    required this.costoUnitario,
    required this.entrada,
    required this.salida,
    required this.invFinal,
  });

  factory MovimientoDto.fromJson(Map<String, dynamic> json) {
    return MovimientoDto(
      numMovimiento: json['numMovimiento'] as int,
      fecha: DateTime.parse(json['fecha'] as String),
      tipo: json['tipo'] as String,
      invInicial: json['invInicial'] as int,
      costoUnitario: (json['costoUnitario'] as num).toDouble(),
      entrada: json['entrada'] as int,
      salida: json['salida'] as int,
      invFinal: json['invFinal'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numMovimiento': numMovimiento,
      'fecha': fecha.toIso8601String(),
      'tipo': tipo,
      'invInicial': invInicial,
      'costoUnitario': costoUnitario,
      'entrada': entrada,
      'salida': salida,
      'invFinal': invFinal,
    };
  }

  MovimientoDto copyWith({
    int? numMovimiento,
    DateTime? fecha,
    String? tipo,
    int? invInicial,
    double? costoUnitario,
    int? entrada,
    int? salida,
    int? invFinal,
  }) {
    return MovimientoDto(
      numMovimiento: numMovimiento ?? this.numMovimiento,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      invInicial: invInicial ?? this.invInicial,
      costoUnitario: costoUnitario ?? this.costoUnitario,
      entrada: entrada ?? this.entrada,
      salida: salida ?? this.salida,
      invFinal: invFinal ?? this.invFinal,
    );
  }

  @override
  String toString() {
    return 'MovimientoDto(num: $numMovimiento, tipo: $tipo, entrada: $entrada, salida: $salida, invFinal: $invFinal)';
  }
}
