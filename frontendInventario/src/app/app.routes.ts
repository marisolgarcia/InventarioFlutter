import { Routes } from '@angular/router';
import { InventarioPrincipalComponent } from './components/inventario-principal/inventario-principal.component';

export const routes: Routes = [
  { path: '', redirectTo: '/inventario', pathMatch: 'full' },
  { path: 'inventario', component: InventarioPrincipalComponent },
  { path: '**', redirectTo: '/inventario' } // Ruta comodín para rutas no encontradas
];
