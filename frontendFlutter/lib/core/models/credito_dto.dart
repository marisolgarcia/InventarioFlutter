import 'movimiento.dart';
import 'pagar_x_cobrar.dart';

/// Modelo de CreditoDTO - Equivalente a CreditoDTO
class CreditoDto {
  final Movimiento movimiento;
  final PagarXCobrar? cuentaXCobrar;

  const CreditoDto({
    required this.movimiento,
    this.cuentaXCobrar,
  });

  factory CreditoDto.fromJson(Map<String, dynamic> json) {
    return CreditoDto(
      movimiento: Movimiento.fromJson(json['movimiento'] as Map<String, dynamic>),
      cuentaXCobrar: json['cuentaXCobrar'] != null
          ? PagarXCobrar.fromJson(json['cuentaXCobrar'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movimiento': movimiento.toJson(),
      if (cuentaXCobrar != null) 'cuentaXCobrar': cuentaXCobrar!.toJson(),
    };
  }

  CreditoDto copyWith({
    Movimiento? movimiento,
    PagarXCobrar? cuentaXCobrar,
  }) {
    return CreditoDto(
      movimiento: movimiento ?? this.movimiento,
      cuentaXCobrar: cuentaXCobrar ?? this.cuentaXCobrar,
    );
  }

  @override
  String toString() {
    return 'CreditoDto(movimiento: $movimiento, cuenta: $cuentaXCobrar)';
  }
}
