export interface ProductoInventario {
  codigoProd: string;
  nombreProd: string;
  descripcionProd: string;
  unidadesMin: number;
  estadoProd: string;
  codigoCat: string;
  nombreCat: string;
  descripcionCat: string;
  estadoCat: string;
  stock: number;
  costo: number;
  porcentajeGan: number;
  precio: number;
  fechaVencimiento?: Date;
  idProducto?: string;
  listaMovimientos?: any[];
}
