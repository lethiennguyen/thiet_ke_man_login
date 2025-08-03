import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ma_so_thue/blocs/product/product_detail_state.dart';
import 'package:ma_so_thue/data/repositories/product_reponsitories.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository repository;
  ProductDetailCubit(this.repository) : super(const ProductDetailState());
  Future<void> fetchDetailProduct({required int id}) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final productCache = await repository.getProductDetail(id);
    emit(
      state.copyWith(
        status: ProductDetailStatus.successCache,
        product: productCache,
      ),
    );
    try {
      final product = await repository.getProductDetail(id);
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
      final isSucces = await repository.deleteProduct(id);
      if (isSucces) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.deleteSuccess,
            message: "Xóa thành công",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProductDetailStatus.failure,
            error: "Xóa thất bại",
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
