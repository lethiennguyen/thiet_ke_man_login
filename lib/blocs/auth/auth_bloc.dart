import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/data/repositories/users_repositories.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState(status: AuthStatus.loading));
    try {
      await repository.postUserProviders(
        tax_code: int.parse(event.taxCode),
        users_name: event.username,
        password: event.password,
      );
      final box = Hive.box(HiveBoxNames.auth);
      box.put(HiveKeys.tax_code, event.taxCode);
      box.put(HiveKeys.user_name, event.username);
      box.put(HiveKeys.password, event.password);
      box.put('isLoggedIn', true);
      await Future.delayed(Duration(milliseconds: 100));
      emit(AuthState(status: AuthStatus.success));
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      emit(
        AuthState(status: AuthStatus.failure, message: 'Đăng nhập thất bại'),
      );
    }
  }
}
