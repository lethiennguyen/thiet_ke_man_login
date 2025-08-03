import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class LoginRequested extends AuthEvent {
  final String taxCode;
  final String username;
  final String password;

  LoginRequested(this.taxCode, this.username, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [taxCode, username, password];
}
