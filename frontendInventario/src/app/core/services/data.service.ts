import { Injectable } from '@angular/core';
import { BehaviorSubject, Subscription } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private messageSource = new BehaviorSubject<any>(null);
  public currentMessage = this.messageSource.asObservable();
  public subscription!: Subscription;

  constructor() { }

  sendMessage(message: any) {
    this.messageSource.next(message);
  }

  clearMessage() {
    this.messageSource.next(null);
  }
}
