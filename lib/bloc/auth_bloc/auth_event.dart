part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);
}

class MultiFactorAuthenticationEvent extends AuthEvent {
  final int code;
  const MultiFactorAuthenticationEvent(this.code);
}
