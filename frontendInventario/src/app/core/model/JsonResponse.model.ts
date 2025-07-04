export interface JsonResponse {
  success: boolean;
  message?: string;
  data?: any;
  pages?: {
    content: any[];
    totalElements: number;
    totalPages: number;
    number: number;
    size: number;
    first: boolean;
    last: boolean;
  };
  error?: any;
  status?: number;
}
