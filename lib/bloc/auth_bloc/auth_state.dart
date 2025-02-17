part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class ProcessStarted extends AuthState {}

final class ProcessFailed extends AuthState {}

final class UserIsLoggedIn extends AuthState {
  final UserModel user;
  const UserIsLoggedIn(this.user);
}

final class LoginFail extends AuthState {
  final String errorTitle;
  final String errorMessage;
  const LoginFail(this.errorTitle, this.errorMessage);
}

class MultiFactorAuthenticationSuccesfull extends AuthState {}

class MultiFactorAuthenticationFailed extends AuthState {}
