import 'cliente_prov.dart';
import 'producto.dart';

/// Modelo de Movimiento - Equivalente a Movimiento entity
class Movimiento {
  final int? idMovimiento;
  final String tipoMovimiento;
  final DateTime fechaMovimiento;
  final Producto producto;
  final int unidades;
  final int? stock;
  final double costo;
  final int? porcentajeGan;
  final double precio;
  final String tipoPago;
  final DateTime? fechaVencimiento;
  final ClienteProv? clienteProv;
  final String? numFactura;

  const Movimiento({
    this.idMovimiento,
    required this.tipoMovimiento,
    required this.fechaMovimiento,
    required this.producto,
    required this.unidades,
    this.stock,
    required this.costo,
    this.porcentajeGan,
    required this.precio,
    required this.tipoPago,
    this.fechaVencimiento,
    this.clienteProv,
    this.numFactura,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      idMovimiento: json['idMovimiento'] as int?,
      tipoMovimiento: json['tipoMovimiento'] as String,
      fechaMovimiento: DateTime.parse(json['fechaMovimiento'] as String),
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      unidades: json['unidades'] as int,
      stock: json['stock'] as int?,
      costo: (json['costo'] as num).toDouble(),
      porcentajeGan: json['porcentajeGan'] as int?,
      precio: (json['precio'] as num).toDouble(),
      tipoPago: json['tipoPago'] as String,
      fechaVencimiento: json['fechaVencimiento'] != null 
          ? DateTime.parse(json['fechaVencimiento'] as String)
          : null,
      clienteProv: json['clienteProv'] != null 
          ? ClienteProv.fromJson(json['clienteProv'] as Map<String, dynamic>)
          : null,
      numFactura: json['numFactura'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (idMovimiento != null) 'idMovimiento': idMovimiento,
      'tipoMovimiento': tipoMovimiento,
      'fechaMovimiento': fechaMovimiento.toIso8601String(),
      'producto': producto.toJson(),
      'unidades': unidades,
      if (stock != null) 'stock': stock,
      'costo': costo,
      if (porcentajeGan != null) 'porcentajeGan': porcentajeGan,
      'precio': precio,
      'tipoPago': tipoPago,
      if (fechaVencimiento != null) 'fechaVencimiento': fechaVencimiento!.toIso8601String(),
      if (clienteProv != null) 'clienteProv': clienteProv!.toJson(),
      if (numFactura != null) 'numFactura': numFactura,
    };
  }

  Movimiento copyWith({
    int? idMovimiento,
    String? tipoMovimiento,
    DateTime? fechaMovimiento,
    Producto? producto,
    int? unidades,
    int? stock,
    double? costo,
    int? porcentajeGan,
    double? precio,
    String? tipoPago,
    DateTime? fechaVencimiento,
    ClienteProv? clienteProv,
    String? numFactura,
  }) {
    return Movimiento(
      idMovimiento: idMovimiento ?? this.idMovimiento,
      tipoMovimiento: tipoMovimiento ?? this.tipoMovimiento,
      fechaMovimiento: fechaMovimiento ?? this.fechaMovimiento,
      producto: producto ?? this.producto,
      unidades: unidades ?? this.unidades,
      stock: stock ?? this.stock,
      costo: costo ?? this.costo,
      porcentajeGan: porcentajeGan ?? this.porcentajeGan,
      precio: precio ?? this.precio,
      tipoPago: tipoPago ?? this.tipoPago,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      clienteProv: clienteProv ?? this.clienteProv,
      numFactura: numFactura ?? this.numFactura,
    );
  }

  @override
  String toString() {
    return 'Movimiento(id: $idMovimiento, tipo: $tipoMovimiento, producto: ${producto.nombreProd}, unidades: $unidades)';
  }
}
