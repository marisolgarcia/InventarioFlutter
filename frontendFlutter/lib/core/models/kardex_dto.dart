import 'producto.dart';
import 'movimiento_dto.dart';

/// Modelo de KardexDTO - Equivalente a KardexDTO
class KardexDto {
  final Producto producto;
  final List<MovimientoDto> listaMovimientos;

  const KardexDto({
    required this.producto,
    required this.listaMovimientos,
  });

  factory KardexDto.fromJson(Map<String, dynamic> json) {
    return KardexDto(
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      listaMovimientos: (json['listaMovimientos'] as List<dynamic>)
          .map((item) => MovimientoDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto': producto.toJson(),
      'listaMovimientos': listaMovimientos.map((m) => m.toJson()).toList(),
    };
  }

  KardexDto copyWith({
    Producto? producto,
    List<MovimientoDto>? listaMovimientos,
  }) {
    return KardexDto(
      producto: producto ?? this.producto,
      listaMovimientos: listaMovimientos ?? this.listaMovimientos,
    );
  }

  @override
  String toString() {
    return 'KardexDto(producto: ${producto.nombreProd}, movimientos: ${listaMovimientos.length})';
  }
}
