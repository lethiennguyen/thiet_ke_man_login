import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/data/core/constants.dart';
import 'package:ma_so_thue/data/dio/dio.dart';
import 'package:ma_so_thue/data/response/users_respon.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';

class AuthRepository {
  AuthRepository(dio);

  Future<LoginResponse> postUserProviders({
    required int tax_code,
    required String users_name,
    required String password,
  }) async {
    try {
      print('tax_code: $tax_code');
      print('users_name: $users_name');
      print('password: $password');
      final res = await dio.post(
        ApiConfig.login,
        data: {
          'tax_code': tax_code,
          'user_name': users_name,
          'password': password,
        },
      );
      dev.log(ApiConfig.login);
      dev.log('url: $res');
      final result = LoginResponse.fromJson(res.data);
      if (!result.success || result.token.isEmpty) {
        throw Exception(result.message); // hoặc làm gì đó
      }
      dev.log('$result');
      final box = Hive.box(HiveBoxNames.auth);
      box.put(HiveKeys.token, result.token);
      box.put(HiveKeys.tax_code, tax_code);
      box.put(HiveKeys.user_name, users_name);
      return result;
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode}');
      print('Response body: ${e.response?.data}');
      rethrow;
    }
  }
}
