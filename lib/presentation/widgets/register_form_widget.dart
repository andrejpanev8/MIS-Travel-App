import 'package:flutter/material.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("First Name"),
          inputTextFieldCustom(
            context: context,
            hintText: "Enter your first name",
          ),
          const SizedBox(height: 12),

          _buildLabel("Last Name"),
          inputTextFieldCustom(
            context: context,
            hintText: "Enter your last name",
          ),
          const SizedBox(height: 12),

          _buildLabel("Phone Number"),
          inputTextFieldCustom(
            context: context,
            hintText: "Enter your phone number",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),

          _buildLabel("Email"),
          inputTextFieldCustom(
            context: context,
            hintText: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          _buildLabel("Password"),
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
                // TODO call authService.register(fields...)
              },
              style: TextButton.styleFrom(
                backgroundColor: blueDeepColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
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
                Navigator.pushNamed(context, "/login");
              },
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 14,
                  ),
                  children: [
                    const TextSpan(text: "Already have an account? "),
                    TextSpan(
                      text: "Login",
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: StyledText().descriptionText(
        fontSize: 14,
        color: blackColor,
      ),
    );
  }
}