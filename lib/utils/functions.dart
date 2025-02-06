import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';

import '../bloc/user_bloc/user_bloc.dart';

class Functions {
  static Future<void> emitEvent(
      {required BuildContext context, UserEvent? event}) async {
    event != null ? context.read<UserBloc>().add(event) : null;
  }

  static Future<void> emitScreenEvent(
      {required BuildContext context, HomeScreenEvent? event}) async {
    event != null ? context.read<HomeScreenBloc>().add(event) : null;
  }
}
