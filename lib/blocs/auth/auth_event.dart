import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final String taxCode;
  final String username;
  final String password;
  LoginRequested(this.taxCode, this.username, this.password);
  @override
  List<Object?> get props => [taxCode, username, password];
}

class LoginUsernameChanged extends LoginEvent {
  final String username;
  LoginUsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginTaxCodeChanged extends LoginEvent {
  final String taxCode;
  LoginTaxCodeChanged(this.taxCode);

  @override
  List<Object?> get props => [taxCode];
}
