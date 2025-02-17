import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';

import '../../utils/error_handler.dart';
import '../../utils/string_constants.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(ProcessStarted());
        try {
          var loggedUser =
              await AuthService().loginUser(event.email, event.password);
          emit(UserIsLoggedIn(loggedUser!));
        } on FirebaseException catch (e) {
          String errorTitle = getFirebaseErrorTitle(e.code);
          String errorMessage = e.message ?? AppStrings.unknownError;
          emit(LoginFail(errorTitle, errorMessage));
        } catch (e) {
          emit(LoginFail(AppStrings.unexpectedError, e.toString()));
        }
      }

      if (event is CheckAuthState) {
        emit(ProcessStarted());
        try {
          var user = await AuthService().getCurrentUser();
          user != null ? emit(UserIsLoggedIn(user)) : emit(AuthInitial());
        } catch (e) {
          print("Error in check auth state: ${e.toString()}");
        }
      }

      if (event is LogOutEvent) {
        emit(ProcessStarted());
        AuthService().logoutUser();
        emit(AuthInitial());
      }
    });
  }
}
