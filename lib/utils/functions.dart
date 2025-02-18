import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';

class Functions {
  static Future<void> emitUserEvent(
      {required BuildContext context, UserEvent? event}) async {
    event != null ? context.read<UserBloc>().add(event) : null;
  }

  static Future<void> emitScreenEvent(
      {required BuildContext context, HomeScreenEvent? event}) async {
    event != null ? context.read<HomeScreenBloc>().add(event) : null;
  }

  static Future<void> emitAuthEvent(
      {required BuildContext context, AuthEvent? event}) async {
    event != null ? context.read<AuthBloc>().add(event) : null;
  }

  static String generateUniqueCode() {
    final random = Random.secure();
    final code = List.generate(6, (_) {
      final asciiValue = random.nextInt(26) + (random.nextBool() ? 65 : 97);
      return String.fromCharCode(asciiValue);
    }).join();
    return code;
  }

  static bool isTextOverflowing(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
