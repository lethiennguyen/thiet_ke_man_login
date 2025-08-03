import 'package:ma_so_thue/data/models/product.dart';

enum CreateProductStatus { initial, loading, success, failure }

class CreateProductState {
  final CreateProductStatus status;
  final Product? product;
  final String? error;
  final String? message;

  const CreateProductState({
    this.status = CreateProductStatus.initial,
    this.product,
    this.error,
    this.message,
  });

  CreateProductState copyWith({
    CreateProductStatus? status,
    Product? product,
    String? error,
    String? message,
  }) {
    return CreateProductState(
      status: status ?? this.status,
      product: product ?? this.product,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
