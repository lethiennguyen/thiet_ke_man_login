import 'package:ma_so_thue/data/models/product.dart';

enum ProductDetailStatus {
  initial,
  loading,
  failure,
  success,
  successCache,
  successFresh,
  deleteSuccess,
}

class ProductDetailState {
  final ProductDetailStatus status;
  final Product? product;
  final String? message;
  final String? error;
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.message,
    this.error,
  });
  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? error,
    String? message,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}
