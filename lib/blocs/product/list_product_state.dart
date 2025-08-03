import 'package:equatable/equatable.dart';
import 'package:ma_so_thue/data/models/product.dart';

enum ListProductStatus { initial, loading, refreshing, success, failure }

// list_product_state.dart
class ListProductState extends Equatable {
  final List<Product> products;
  final ListProductStatus status;
  final String? error;
  final bool hasReachedEnd;
  final bool isLoadMore;
  final int currentPage;
  const ListProductState({
    this.products = const [],
    this.status = ListProductStatus.initial,
    this.error,
    this.hasReachedEnd = false,
    this.isLoadMore = false,
    this.currentPage = 1,
  });

  ListProductState copyWith({
    List<Product>? products,
    ListProductStatus? status,
    String? error,
    bool? isLoadMore,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return ListProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      error: error,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    products,
    status,
    error,
    isLoadMore,
    hasReachedEnd,
    currentPage,
  ];
}
