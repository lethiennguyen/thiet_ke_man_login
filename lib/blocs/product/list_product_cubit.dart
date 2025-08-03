import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ma_so_thue/blocs/product/list_product_state.dart';
import 'package:ma_so_thue/data/repositories/product_reponsitories.dart';
import 'package:ma_so_thue/data/request/product_request.dart';

class ListProductCubit extends Cubit<ListProductState> {
  final ProductRepository repo;
  final int _pageSize = 10;
  bool _isFetching = false;

  ListProductCubit(this.repo) : super(const ListProductState());

  /// Gọi khi đăng nhập xong hoặc pull‑to‑refresh
  Future<void> loadFirstPage() async {
    emit(state.copyWith(currentPage: 1, hasReachedEnd: false));
    await _fetch(page: 1, isRefresh: true);
  }

  /// Gọi khi cuộn gần đáy ListView (infinite scroll)
  Future<void> loadMore() async {
    if (_isFetching || state.hasReachedEnd) return;
    emit(state.copyWith(isLoadMore: true));
    final nextPage = state.currentPage + 1;
    await _fetch(page: nextPage);
    emit(state.copyWith(isLoadMore: false));
  }

  // kéo cuộn lại
  Future<void> pullToRefresh() async {
    if (_isFetching) return;
    emit(
      state.copyWith(
        status: ListProductStatus.refreshing,
        currentPage: 1,
        hasReachedEnd: false,
        isLoadMore: false,
      ),
    );
    await _fetch(page: 1, isRefresh: true);
  }

  Future<void> _fetch({required int page, bool isRefresh = false}) async {
    _isFetching = true;

    emit(
      state.copyWith(
        status:
            isRefresh
                ? ListProductStatus.refreshing
                : ListProductStatus.loading,
      ),
    );
    try {
      final request = ProductListRequest(page: page, size: _pageSize);
      final items = await repo.getProductList(request);

      final merged = isRefresh ? items : [...state.products, ...items];

      final reachedEnd = items.length < _pageSize;

      emit(
        state.copyWith(
          products: merged,
          currentPage: page,
          hasReachedEnd: reachedEnd,
          status: ListProductStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ListProductStatus.failure, error: e.toString()),
      );
    } finally {
      _isFetching = false;
    }
  }
}
