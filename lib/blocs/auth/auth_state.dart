import 'package:equatable/equatable.dart';

enum LoginStatus { initial, submitting, success, failure, loading }

class LoginState extends Equatable {
  final String username;
  final String password;
  final String taxCode;
  final LoginStatus status;

  final List<String?> errors;

  const LoginState({
    this.username = '',
    this.password = '',
    this.taxCode = '',
    this.status = LoginStatus.initial,
    this.errors = const [null, null, null],
  });

  LoginState copyWith({
    String? username,
    String? password,
    String? taxCode,
    LoginStatus? status,
    List<String?>? errors,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      taxCode: taxCode ?? this.taxCode,
      status: status ?? this.status,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [username, password, taxCode, status, errors];
}
