part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class ResetAuthState extends AuthEvent {}

class LogOutEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);
}

class CheckAuthState extends AuthEvent {}

class MultiFactorAuthenticationEvent extends AuthEvent {
  final int code;
  const MultiFactorAuthenticationEvent(this.code);
}
