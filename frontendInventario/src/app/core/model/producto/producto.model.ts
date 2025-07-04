export interface Producto {
  idProducto: number;
  codigoProd: string;
  nombreProd: string;
  descripcionProd: string;
  unidadesMin: number;
  estadoProd: string;
  codigoCat: string;
  precio: number;
  costo: number;
  porcentajeGan: number;
  fechaVencimiento?: Date;
}
