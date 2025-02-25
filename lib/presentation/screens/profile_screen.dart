import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';
import 'package:travel_app/utils/color_constants.dart';

import '../../data/models/user.dart';
import '../../utils/string_constants.dart';
import '../../utils/success_handler.dart';
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

  Map<String, String> validationErrors = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserValidationFailed) {
              setState(() {
                validationErrors = state.errors;
              });
            }
            if (state is UserUpdateSuccess) {
              showSuccessDialog(
                context,
                AppStrings.updateUserInfoSuccessTitle,
                AppStrings.updateUserInfoSuccessMessage,
                () {
                  Navigator.of(context).pop();
                },
              );
              setState(() {
                user = user!.copyWith(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneController.text,
                );
                firstNameController.text = user!.firstName;
                lastNameController.text = user!.lastName;
                emailController.text = user!.email;
                phoneController.text = user!.phoneNumber;
              });
            }
          },
          child: Scaffold(
            body: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is UserIsLoggedIn) {
                  user = authState.user;
                  firstNameController.text = firstNameController.text.isEmpty
                      ? user!.firstName
                      : firstNameController.text;
                  lastNameController.text = lastNameController.text.isEmpty
                      ? user!.lastName
                      : lastNameController.text;
                  phoneController.text = phoneController.text.isEmpty
                      ? user!.phoneNumber
                      : phoneController.text;
                  emailController.text = user!.email;
                  roleController.text = user!.role.name;
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My profile",
                              style: StyledText().appBarText(),
                            ),
                            SizedBox(height: 25),
                            _text("First name"),
                            inputTextFieldCustom(
                              context: context,
                              controller: firstNameController,
                              suffixIcon: _createSuffixIcon(
                                  context, _fieldNames.firstName),
                              readOnly: isEditing[_fieldNames.firstName]!,
                            ),
                            if (validationErrors.containsKey("name"))
                              _errorText(validationErrors["name"]!),
                            SizedBox(height: 15),
                            _text("Last name"),
                            inputTextFieldCustom(
                              context: context,
                              controller: lastNameController,
                              suffixIcon: _createSuffixIcon(
                                  context, _fieldNames.lastName),
                              readOnly: isEditing[_fieldNames.lastName]!,
                            ),
                            if (validationErrors.containsKey("surname"))
                              _errorText(validationErrors["surname"]!),
                            SizedBox(height: 15),
                            _text("Mobile phone"),
                            inputTextFieldCustom(
                              context: context,
                              controller: phoneController,
                              suffixIcon:
                                  _createSuffixIcon(context, _fieldNames.phone),
                              readOnly: isEditing[_fieldNames.phone]!,
                            ),
                            if (validationErrors.containsKey("phoneNumber"))
                              _errorText(validationErrors["phoneNumber"]!),
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
                              controller: roleController,
                            ),
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: customArrowButton(
                                      text: "Save",
                                      verticalPadding: 10,
                                      onPressed: () {
                                        if (firstNameController.text !=
                                                user!.firstName ||
                                            lastNameController.text !=
                                                user!.lastName ||
                                            phoneController.text !=
                                                user!.phoneNumber) {
                                          BlocProvider.of<UserBloc>(context)
                                              .add(
                                            UpdateUserInfo(
                                              user!.id,
                                              firstNameController.text,
                                              lastNameController.text,
                                              phoneController.text,
                                            ),
                                          );
                                          setState(() {
                                            validationErrors.clear();
                                          });
                                        }
                                      },
                                      noIcon: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Center(child: infoText(AppStrings.loginRequiredMessage));
              },
            ),
          ),
        ),
      ),
    );
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
  return Text(text, style: StyledText().descriptionText());
}

Widget _errorText(String errorMessage) {
  return Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Text(
      errorMessage,
      style: TextStyle(color: Colors.red, fontSize: 12),
    ),
  );
}

// ignore: camel_case_types
enum _fieldNames { firstName, lastName, phone }
