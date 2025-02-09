import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: blueDeepColor,
          padding: EdgeInsets.only(left: 50, top: 35, right: 50, bottom: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.loginTitleWithNewline,
                style: TextStyle(
                    color: silverColorLight,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                AppStrings.loginTitle,
                style: TextStyle(
                  color: silverColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        inputTextFieldCustom(
          context: context,
          hintText: AppStrings.email,
        ),
        //TODO add labels, add login button, add register link, add validation
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
              }),
        ),
      ],
    );
  }
}
