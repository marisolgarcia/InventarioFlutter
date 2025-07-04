export interface CreditoDTO {
  movimiento: Movement;
  cuentaXCobrar: CuentaXCobrar | null;
}

export interface Movement {
  idMovimiento?: number;
  tipoMovimiento?: string;
  fechaMovimiento?: string; // LocalDateTime as ISO string
  producto: {
    codigoProd: number;
  };
  unidades: number;
  stock?: number;
  costo?: number;
  porcentajeGan?: number;
  precio?: number;
  tipoPago: string;
  fechaVencimiento?: string; // Date as ISO string
  cliente?: {
    codigoCliente: number;
  };
  numFactura: string;
}

export interface CuentaXCobrar {
  codigoCobrar?: number;
  numFactura: string;
  montoDeuda?: number;
  numCuotas: number;
  tiempoCobro: number; // días entre pagos
  interes: number; // porcentaje
  cuotaBase?: number;
}

export interface Cliente {
  codigoCliente?: number;
  nombreCliente: string;
  direccion: string;
  telefono: string;
  numDocumento: string;
  tipoCliente: string;
  infoFinanciera?: any; // byte[] se puede manejar como any
  estadoCliente: string;
}
