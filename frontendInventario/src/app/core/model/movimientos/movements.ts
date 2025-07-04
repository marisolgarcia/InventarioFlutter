export interface Movements {
  id?: number;
  numMovimiento?: number;
  fecha: Date | any[];
  tipo: string;
  cantidad?: number;
  entrada?: number;
  salida?: number;
  invInicial?: number;
  invFinal?: number;
  precio?: number;
  costoUnitario?: number;
  descripcion?: string;
}
