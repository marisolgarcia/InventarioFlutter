import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ProviderService {

  constructor() { }

  // Métodos auxiliares que podrías necesitar
  showLoading() {
    console.log('Loading...');
  }

  hideLoading() {
    console.log('Loading finished');
  }

  showToast(message: string) {
    console.log('Toast:', message);
  }
}
