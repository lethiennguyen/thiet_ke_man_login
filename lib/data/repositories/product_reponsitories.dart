import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/data/core/constants.dart';
import 'package:ma_so_thue/data/dio/dio.dart';
import 'package:ma_so_thue/data/models/product.dart';
import 'package:ma_so_thue/data/request/product_request.dart';
import 'package:ma_so_thue/data/response/product_respone.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';

class ProductRepository {
  ProductRepository(dio);
  Future<List<Product>> getProductList(ProductListRequest request) async {
    try {
      final box = Hive.box(HiveBoxNames.auth);
      final token = box.get(HiveKeys.token) ?? '';

      final response = await dio.get(
        ApiConfig.listProduct,
        queryParameters: request.toQueryParams(),
        options: Options(headers: {'Authorization': token}),
      );
      final apiResponse = ApiListResponse<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}

class ProductDetailRepository {
  ProductDetailRepository(dio);

  Future<Product> getProductDetail(int id) async {
    final box = Hive.box(HiveBoxNames.auth);
    final token = box.get(HiveKeys.token) ?? '';
    try {
      final response = await dio.get(
        '${ApiConfig.productDetial}${id}',
        options: Options(headers: {'Authorization': token}),
      );
      print('respon: $response');

      final apiRes = ApiSingleResponse<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json as Map<String, dynamic>),
      );
      return apiRes.data;
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }

  Future<bool> deleteProduct(int id) async {
    final box = Hive.box(HiveBoxNames.auth);
    final token = box.get(HiveKeys.token) ?? '';

    final response = await dio.delete(
      '${ApiConfig.productDelete}${id}',
      options: Options(headers: {'Authorization': token}),
    );
    print('$response');
    return response.statusCode == 200;
  }

  Future<Product?> putProductUpdate(
    int id, {
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    final box = Hive.box(HiveBoxNames.auth);
    final token = box.get(HiveKeys.token);

    try {
      final response = await dio.put(
        '${ApiConfig.productUpdate}${id}',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );
      print('respon : $response');

      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}

class CreateProductRepository {
  CreateProductRepository(dio);
  Future<Product?> postCreateProdcut({
    required String name,
    required int price,
    required int quantity,
    required String cover,
  }) async {
    final box = Hive.box(HiveBoxNames.auth);
    final token = box.get(HiveKeys.token);

    try {
      final response = await dio.post(
        '${ApiConfig.productCreate}',
        data: {
          'name': name,
          'price': price,
          'quantity': quantity,
          'cover': cover,
        },
        options: Options(headers: {'Authorization': token}),
      );

      return Product.fromJson(response.data['data']);
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}
