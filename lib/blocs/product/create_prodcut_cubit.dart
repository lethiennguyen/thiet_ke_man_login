import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ma_so_thue/blocs/product/create_prodcut_state.dart';
import 'package:ma_so_thue/data/repositories/product_reponsitories.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  final CreateProductRepository repository;

  CreateProductCubit(this.repository) : super(const CreateProductState());
  Future<void> createprodcut({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    try {
      emit(state.copyWith(status: CreateProductStatus.loading, error: null));
      final result = await repository.postCreateProdcut(
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );
      emit(
        state.copyWith(
          status: CreateProductStatus.success,
          product: result,
          error: null,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CreateProductStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
