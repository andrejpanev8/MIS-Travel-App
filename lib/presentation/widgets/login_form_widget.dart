import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/error_handler.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../utils/functions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final AuthService _authService = AuthService();

  bool _passwordVisible = true;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog(
          context, AppStrings.firebaseError, AppStrings.fillRequiredFields);
      return;
    }
    Functions.emitAuthEvent(
        context: context, event: LoginEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is LoginFail) {
            showErrorDialog(context, state.errorTitle, state.errorMessage);
          } else if (state is UserIsLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            });
          } else if (state is ProcessStarted) {
            return Center(child: CircularProgressIndicator());
          }
          return _initialLoginState(context);
        },
      ),
    );
  }

  Widget _initialLoginState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.email,
            style:
                StyledText().descriptionText(fontSize: 14, color: blackColor)),
        const SizedBox(height: 8),
        inputTextFieldCustom(
          context: context,
          hintText: AppStrings.email,
          controller: _emailController,
        ),
        const SizedBox(height: 12),
        Text(AppStrings.password,
            style:
                StyledText().descriptionText(fontSize: 14, color: blackColor)),
        const SizedBox(height: 8),
        inputTextFieldCustom(
          context: context,
          hintText: AppStrings.password,
          controller: _passwordController,
          obscureText: _passwordVisible,
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: blackColor),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _login,
            style: TextButton.styleFrom(
              backgroundColor: blueDeepColor,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              AppStrings.login,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, "/register", (route) => false),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: blackColor, fontSize: 14),
                children: [
                  const TextSpan(text: AppStrings.dontHaveAnAccount),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: AppStrings.register,
                    style: TextStyle(
                        color: blueDeepColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
