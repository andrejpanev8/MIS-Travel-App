import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 50, top: 35, right: 50, bottom: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style:
                StyledText().descriptionText(fontSize: 14, color: blackColor),
          ),
          const SizedBox(height: 8),
          inputTextFieldCustom(
            context: context,
            hintText: AppStrings.email,
          ),
          const SizedBox(height: 12),
          Text(
            "Password",
            style:
                StyledText().descriptionText(fontSize: 14, color: blackColor),
          ),
          const SizedBox(height: 8),
          inputTextFieldCustom(
            context: context,
            hintText: AppStrings.password,
            obscureText: _passwordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: blackColor,
              ),
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
              onPressed: () {
                // TODO call authService.login
              },
              style: TextButton.styleFrom(
                backgroundColor: blueDeepColor, // Button color
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () {
                // replace with Naviagor.pushNamedAndRemoveUntil(..., (Route<dynamic> route) => false);
                Navigator.pushNamed(context, "/register");
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: blackColor, fontSize: 14),
                  children: [
                    const TextSpan(text: "Don't have an account yet? "),
                    TextSpan(
                      text: "Register",
                      style: TextStyle(
                        color: blueDeepColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
