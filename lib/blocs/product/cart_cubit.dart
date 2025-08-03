import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ma_so_thue/blocs/product/cart_state.dart';
import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';

class CartCubit extends Cubit<CartState> {
  final Box<CartItem> cartBox;
  CartCubit(this.cartBox)
    : super(CartState(cartItems: cartBox.values.toList(), selectedIds: {})) {
    cartBox.listenable().addListener(_onBoxChanged);
  }

  void _onBoxChanged() {
    emit(state.copyWith(cartItems: cartBox.values.toList()));
  }

  void toggleItemChecked(int id) {
    final checked = Set<int>.from(state.selectedIds);
    if (checked.contains(id))
      checked.remove(id);
    else
      checked.add(id);
    emit(state.copyWith(selectedIds: checked));
  }

  void toggleAllChecked(bool checked) {
    if (checked) {
      emit(
        state.copyWith(selectedIds: state.cartItems.map((e) => e.id).toSet()),
      );
    } else {
      emit(state.copyWith(selectedIds: {}));
    }
  }

  double get selectedTotalPrice {
    return state.cartItems
        .where((e) => state.selectedIds.contains(e.id))
        .map((e) => e.price * e.quantity)
        .fold(0, (a, b) => a + b);
  }

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
  }
}
