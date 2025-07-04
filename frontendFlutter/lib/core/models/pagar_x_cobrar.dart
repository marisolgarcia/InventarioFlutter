/// Modelo de PagarXCobrar - Equivalente a PagarXCobrar entity
class PagarXCobrar {
  final int? codigo;
  final String numFactura;
  final double montoDeuda;
  final int numCuotas;
  final int tiempoCobro;
  final int interes;
  final double cuotaBase;
  final double? prima;
  final String estado;
  final String tipo;

  const PagarXCobrar({
    this.codigo,
    required this.numFactura,
    required this.montoDeuda,
    required this.numCuotas,
    required this.tiempoCobro,
    required this.interes,
    required this.cuotaBase,
    this.prima,
    required this.estado,
    required this.tipo,
  });

  factory PagarXCobrar.fromJson(Map<String, dynamic> json) {
    return PagarXCobrar(
      codigo: json['codigo'] as int?,
      numFactura: json['numFactura'] as String,
      montoDeuda: (json['montoDeuda'] as num).toDouble(),
      numCuotas: json['numCuotas'] as int,
      tiempoCobro: json['tiempoCobro'] as int,
      interes: json['interes'] as int,
      cuotaBase: (json['cuotaBase'] as num).toDouble(),
      prima: json['prima'] != null ? (json['prima'] as num).toDouble() : null,
      estado: json['estado'] as String,
      tipo: json['tipo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (codigo != null) 'codigo': codigo,
      'numFactura': numFactura,
      'montoDeuda': montoDeuda,
      'numCuotas': numCuotas,
      'tiempoCobro': tiempoCobro,
      'interes': interes,
      'cuotaBase': cuotaBase,
      if (prima != null) 'prima': prima,
      'estado': estado,
      'tipo': tipo,
    };
  }

  PagarXCobrar copyWith({
    int? codigo,
    String? numFactura,
    double? montoDeuda,
    int? numCuotas,
    int? tiempoCobro,
    int? interes,
    double? cuotaBase,
    double? prima,
    String? estado,
    String? tipo,
  }) {
    return PagarXCobrar(
      codigo: codigo ?? this.codigo,
      numFactura: numFactura ?? this.numFactura,
      montoDeuda: montoDeuda ?? this.montoDeuda,
      numCuotas: numCuotas ?? this.numCuotas,
      tiempoCobro: tiempoCobro ?? this.tiempoCobro,
      interes: interes ?? this.interes,
      cuotaBase: cuotaBase ?? this.cuotaBase,
      prima: prima ?? this.prima,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  @override
  String toString() {
    return 'PagarXCobrar(codigo: $codigo, factura: $numFactura, monto: $montoDeuda, estado: $estado)';
  }
}
