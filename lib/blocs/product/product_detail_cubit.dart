import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ma_so_thue/blocs/product/product_detail_state.dart';
import 'package:ma_so_thue/data/repositories/product_reponsitories.dart';
import 'package:ma_so_thue/data/request/product_detail_request.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository repository;
  ProductDetailCubit(this.repository) : super(const ProductDetailState());
  Future<void> fetchDetailProduct({required int id}) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final req = ProductRequestID(id);
    final productCache = await repository.getProductDetail(req);
    emit(
      state.copyWith(
        status: ProductDetailStatus.successCache,
        product: productCache,
      ),
    );
    try {
      final request = ProductRequestID(id);
      final product = await repository.getProductDetail(request);
      emit(
        state.copyWith(
          status: ProductDetailStatus.successFresh,
          product: product,
        ),
      );
    } catch (e) {
      print('Lỗi hiển thị: $e');
      emit(state.copyWith(status: ProductDetailStatus.failure));
    }
  }

  Future<void> updateProduct(
    int id, {
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await repository.putProductUpdate(
      id,
      name: name,
      price: price,
      quantity: quantity,
      cover: cover,
    );
    emit(state.copyWith(status: ProductDetailStatus.success, product: result));
  }

  Future<void> deleteProduct(int id) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    try {
      final result = await repository.deleteProduct(id);
      if (result.success) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.deleteSuccess,
            message: result.message,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProductDetailStatus.failure,
            error: result.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}

class CartCubit extends Cubit<List<CartItem>> {
  final Box<CartItem> cartBox;

  CartCubit(this.cartBox) : super(cartBox.values.toList()) {
    // Lắng nghe thay đổi trong box, tự động emit lại state khi Hive thay đổi (auto realtime luôn)
    cartBox.listenable().addListener(_onBoxChanged);
  }

  void _onBoxChanged() {
    emit(cartBox.values.toList());
  }

  /// Thêm sản phẩm vào giỏ
  void addToCart(CartItem item) {
    print('Add to cart: ${item.name}, quantity: ${item.quantity}');
    CartItem? existed;
    try {
      existed = cartBox.values.firstWhere((e) => e.id == item.id);
    } catch (_) {
      existed = null;
    }
    if (existed != null) {
      existed.quantity += item.quantity;
      existed.save();
    } else {
      cartBox.add(item);
    }
  }

  /// Xóa sản phẩm khỏi giỏ
  void removeFromCart(int id) {
    final item = cartBox.values.firstWhere((e) => e.id == id);
    item?.delete();
    // Không cần emit, listener của box đã tự cập nhật UI
  }

  /// Xóa toàn bộ giỏ hàng
  void clearCart() {
    cartBox.clear();
    // Không cần emit, listener của box đã tự cập nhật UI
  }
}
