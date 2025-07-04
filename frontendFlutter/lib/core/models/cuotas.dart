import 'pagar_x_cobrar.dart';

/// Modelo de Cuotas - Equivalente a Cuotas entity
class Cuotas {
  final int? codigoCuota;
  final PagarXCobrar cuenta;
  final double cargo;
  final double? abono;
  final DateTime fechaDePago;
  final String estadoCuota;

  const Cuotas({
    this.codigoCuota,
    required this.cuenta,
    required this.cargo,
    this.abono,
    required this.fechaDePago,
    required this.estadoCuota,
  });

  factory Cuotas.fromJson(Map<String, dynamic> json) {
    return Cuotas(
      codigoCuota: json['codigoCuota'] as int?,
      cuenta: PagarXCobrar.fromJson(json['cuenta'] as Map<String, dynamic>),
      cargo: (json['cargo'] as num).toDouble(),
      abono: json['abono'] != null ? (json['abono'] as num).toDouble() : null,
      fechaDePago: DateTime.parse(json['fechaDePago'] as String),
      estadoCuota: json['estado_cuota'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (codigoCuota != null) 'codigoCuota': codigoCuota,
      'cuenta': cuenta.toJson(),
      'cargo': cargo,
      if (abono != null) 'abono': abono,
      'fechaDePago': fechaDePago.toIso8601String(),
      'estado_cuota': estadoCuota,
    };
  }

  Cuotas copyWith({
    int? codigoCuota,
    PagarXCobrar? cuenta,
    double? cargo,
    double? abono,
    DateTime? fechaDePago,
    String? estadoCuota,
  }) {
    return Cuotas(
      codigoCuota: codigoCuota ?? this.codigoCuota,
      cuenta: cuenta ?? this.cuenta,
      cargo: cargo ?? this.cargo,
      abono: abono ?? this.abono,
      fechaDePago: fechaDePago ?? this.fechaDePago,
      estadoCuota: estadoCuota ?? this.estadoCuota,
    );
  }

  @override
  String toString() {
    return 'Cuotas(codigo: $codigoCuota, cargo: $cargo, fecha: $fechaDePago, estado: $estadoCuota)';
  }
}
