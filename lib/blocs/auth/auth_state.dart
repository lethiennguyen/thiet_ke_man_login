enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? message;

  AuthState({required this.status, this.message});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
}
