import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ma_so_thue/data/repositories/users_repositories.dart';
import 'package:ma_so_thue/hive/hive_constants.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(const LoginState()) {
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginTaxCodeChanged>((event, emit) {
      emit(state.copyWith(taxCode: event.taxCode));
    });
    on<LoginRequested>(_onLoginRequested);
  }
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState(status: LoginStatus.loading));
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
      emit(LoginState(status: LoginStatus.success));
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      emit(LoginState(status: LoginStatus.failure));
    }
  }
}
