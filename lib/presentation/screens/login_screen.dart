import 'package:flutter/material.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/login_form_widget.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/string_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context: context),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: blueDeepColor,
              padding:
                  EdgeInsets.only(left: 50, top: 35, right: 50, bottom: 35),
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
            const LoginForm(),
          ],
        ));
  }
}
