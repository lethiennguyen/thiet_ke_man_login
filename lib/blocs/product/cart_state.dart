import 'package:ma_so_thue/hive/shopping_cart/hive_shopping_cart.dart';

class CartState {
  final List<CartItem> cartItems;
  final Set<int> selectedIds; // id các item đã tick

  CartState({required this.cartItems, required this.selectedIds});

  CartState copyWith({List<CartItem>? cartItems, Set<int>? selectedIds}) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}
