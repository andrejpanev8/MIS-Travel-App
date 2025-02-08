import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserModel? currentUser;
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        if (currentUser != null) {
          emit(UserIsLoggedIn(currentUser!));
          return;
        }
        emit(ProcessStarted());
        var loggedUser =
            await AuthService().loginUser(event.email, event.password);
        loggedUser != null
            ? {emit(UserIsLoggedIn(loggedUser)), currentUser = loggedUser}
            : emit(LoginFail("Failed to login"));
      }

      // if (event is LoginEvent) {
      //   emit(ProcessStarted());
      //   dynamic logged = await AuthRepository.instance.login(event.userName, event.password);
      //   if (logged is UserInfo) {
      //     emit(LoginSuccess());
      //   } else if (logged != false) {
      //     emit(LoginFail(logged.toString()));
      //   } else {
      //     emit(const LoginFail("Something went wrong, try again"));
      //   }
      // }

      // if (event is MultiFactorAuthenticationEvent) {
      //   emit(ProcessStarted());
      //   bool isAuthenticated = await AuthRepository.instance.multiFactorAuthentication(event.code);
      //   if (isAuthenticated) {
      //     emit(MultiFactorAuthenticationSuccesfull());
      //   } else {
      //     emit(MultiFactorAuthenticationFailed());
      //   }
      // }
    });
  }
}
