import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/error_handler.dart';
import 'package:travel_app/utils/string_constants.dart';
import 'package:travel_app/utils/success_handler.dart';
import 'package:travel_app/utils/text_styles.dart';
import 'package:travel_app/utils/validation_utils.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = true;
  final AuthService _authService = AuthService();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  List<String> _passwordErrors = List.empty();

  void _register() async {
    setState(() {
      _firstNameError =
          ValidationUtils.nameValidator(_firstNameController.text);
      _lastNameError =
          ValidationUtils.surnameValidator(_lastNameController.text);
      _phoneError = ValidationUtils.phoneValidator(_phoneController.text);
      _emailError = ValidationUtils.emailValidator(_emailController.text);
      _passwordErrors =
          ValidationUtils.passwordValidator(_passwordController.text);
    });

    if (_firstNameError != null ||
        _lastNameError != null ||
        _phoneError != null ||
        _emailError != null ||
        _passwordErrors.isNotEmpty) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        await _authService.registerUser(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        showSuccessDialog(
          context,
          AppStrings.registrationSuccessTitle,
          AppStrings.registrationSuccessMessage,
          () {
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(
                context, "/login", (route) => false);
          },
        );
      } on FirebaseAuthException catch (e) {
        String errorTitle = getFirebaseErrorTitle(e.code);
        String errorMessage = e.message ?? AppStrings.unknownError;
        showErrorDialog(context, errorTitle, errorMessage);
      } catch (e) {
        showErrorDialog(
            context, AppStrings.registrationErrorTitle, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(AppStrings.firstName),
            inputTextFieldCustom(
              context: context,
              hintText: AppStrings.firstNameHint,
              controller: _firstNameController,
            ),
            _buildErrorText(_firstNameError),
            const SizedBox(height: 12),
            _buildLabel(AppStrings.lastName),
            inputTextFieldCustom(
              context: context,
              hintText: AppStrings.lastNameHint,
              controller: _lastNameController,
            ),
            _buildErrorText(_lastNameError),
            const SizedBox(height: 12),
            _buildLabel(AppStrings.phone),
            inputTextFieldCustom(
              context: context,
              hintText: AppStrings.phoneHint,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildErrorText(_phoneError),
            const SizedBox(height: 12),
            _buildLabel(AppStrings.email),
            inputTextFieldCustom(
              context: context,
              hintText: AppStrings.emailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildErrorText(_emailError),
            const SizedBox(height: 12),
            _buildLabel(AppStrings.password),
            inputTextFieldCustom(
              context: context,
              hintText: AppStrings.passwordHint,
              controller: _passwordController,
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
            if (_passwordErrors.isNotEmpty)
              ..._passwordErrors.map((error) => _buildErrorText(error))
            else
              const SizedBox.shrink(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _register,
                style: TextButton.styleFrom(
                  backgroundColor: blueDeepColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  AppStrings.register,
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
                      const TextSpan(text: AppStrings.alreadyHaveAccount),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: AppStrings.login,
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: StyledText().descriptionText(fontSize: 14),
    );
  }

  Widget _buildErrorText(String? error) {
    return error != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              error,
              style:
                  StyledText().descriptionText(fontSize: 12, color: Colors.red),
            ),
          )
        : const SizedBox.shrink();
  }
}
