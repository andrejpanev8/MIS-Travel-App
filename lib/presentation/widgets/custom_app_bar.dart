import 'package:flutter/material.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import '../../utils/functions.dart';
import '../../utils/text_styles.dart';

PreferredSizeWidget customAppBar({
  required BuildContext context,
  final String? appBarText,
  bool arrowBack = false,
}) {
  return AppBar(
    title: Text(
      appBarText ?? AppStrings.appName,
      style: StyledText().appBarText(color: whiteColor),
    ),
    actions: [
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          bool isLoggedIn = snapshot.hasData && snapshot.data != null;

          return IconButton(
            icon: Icon(isLoggedIn ? Icons.logout : Icons.login,
                color: whiteColor),
            onPressed: () async {
              if (isLoggedIn) {
                Functions.emitAuthEvent(context: context, event: LogOutEvent());
                Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (route) => false);
              } else {
                Navigator.pushNamed(context, "/login");
              }
            },
          );
        },
      ),
    ],
    backgroundColor: blueDeepColor,
    leading: arrowBack
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            color: whiteColor,
            onPressed: () => Navigator.pop(context),
          )
        : null,
    automaticallyImplyLeading: false,
  );
}
