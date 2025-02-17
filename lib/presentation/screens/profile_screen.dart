import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';

import '../../data/models/user.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../widgets/infoText_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  Map<_fieldNames, bool> isEditing = {
    _fieldNames.firstName: true,
    _fieldNames.lastName: true,
    _fieldNames.phone: true,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is UserIsLoggedIn) {
            user = authState.user;
            firstNameController.text = user!.firstName;
            lastNameController.text = user!.lastName;
            emailController.text = user!.email;
            phoneController.text = user!.phoneNumber;
            roleController.text = user!.role.name;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My profile",
                          style: StyledText().appBarText(color: blackColor)),
                      SizedBox(height: 25),
                      _text("First name"),
                      inputTextFieldCustom(
                        context: context,
                        controller: firstNameController,
                        suffixIcon:
                            _createSuffixIcon(context, _fieldNames.firstName),
                        readOnly: isEditing[_fieldNames.firstName]!,
                      ),
                      SizedBox(height: 15),
                      _text("Last name"),
                      inputTextFieldCustom(
                          context: context,
                          controller: lastNameController,
                          suffixIcon:
                              _createSuffixIcon(context, _fieldNames.lastName),
                          readOnly: isEditing[_fieldNames.lastName]!),
                      SizedBox(height: 15),
                      _text("Mobile phone"),
                      inputTextFieldCustom(
                          context: context,
                          controller: phoneController,
                          suffixIcon:
                              _createSuffixIcon(context, _fieldNames.phone),
                          readOnly: isEditing[_fieldNames.phone]!),
                      SizedBox(height: 15),
                      _text("Email"),
                      inputTextFieldCustom(
                          context: context,
                          controller: emailController,
                          readOnly: true),
                      SizedBox(height: 15),
                      _text("Role"),
                      inputTextFieldCustom(
                          context: context,
                          readOnly: true,
                          controller: roleController),
                      SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: customArrowButton(
                                  //TO:DO implement save logic
                                  text: "Save",
                                  onPressed: () {},
                                  noIcon: true),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: infoText(AppStrings.loginRequiredMessage));
        },
      ),
    ));
  }

  Widget _createSuffixIcon(BuildContext context, _fieldNames field) {
    return GestureDetector(
      child: Icon(Icons.create_outlined),
      onTap: () {
        setState(() {
          isEditing[field] = !(isEditing[field]!);
        });
      },
    );
  }
}

Widget _text(String text) {
  return Text(text, style: StyledText().descriptionText(color: blackColor));
}

// ignore: camel_case_types
enum _fieldNames { firstName, lastName, phone }
