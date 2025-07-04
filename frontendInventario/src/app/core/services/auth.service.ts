import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor() { }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  setToken(token: string): void {
    localStorage.setItem('token', token);
  }

  removeToken(): void {
    localStorage.removeItem('token');
  }

  getLocalData(namespace: string, key: string): string | null {
    const data = localStorage.getItem(namespace);
    if (data) {
      try {
        const parsedData = JSON.parse(data);
        return parsedData[key] || null;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  setLocalData(namespace: string, key: string, value: any): void {
    let data = {};
    const existingData = localStorage.getItem(namespace);
    if (existingData) {
      try {
        data = JSON.parse(existingData);
      } catch (e) {
        data = {};
      }
    }
    (data as any)[key] = value;
    localStorage.setItem(namespace, JSON.stringify(data));
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }
}
