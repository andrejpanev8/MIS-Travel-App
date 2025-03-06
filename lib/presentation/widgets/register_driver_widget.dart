import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/presentation/widgets/custom_arrow_button.dart';
import 'package:travel_app/presentation/widgets/input_field.dart';

import '../../data/models/user.dart';
import '../../utils/error_handler.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/success_handler.dart';
import '../../utils/text_styles.dart';
import '../../utils/validation_utils.dart';

class RegisterDriverWidget extends StatefulWidget {
  const RegisterDriverWidget({super.key});

  @override
  State<RegisterDriverWidget> createState() => RegisterDriverWidgetState();
}

class RegisterDriverWidgetState extends State<RegisterDriverWidget> {
  UserModel? user;
  String? _emailError;

  final TextEditingController _emailController = TextEditingController();

  void _register() async {
    setState(() {
      _emailError =
          ValidationUtils.emailValidator(_emailController.text.trim());
    });

    if (_emailError != null) {
      return;
    }
    BlocProvider.of<UserBloc>(context)
        .add(CheckEmailExists(_emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(listener: (context, state) {
      if (state is EmailExists) {
        showErrorDialog(
            context, AppStrings.emailErrorTitle, AppStrings.emailErrorMessage);
      } else if (state is EmailAvailable) {
        BlocProvider.of<UserBloc>(context)
            .add(SendEmail(_emailController.text.trim()));
      } else if (state is EmailSentSuccessfully) {
        showSuccessDialog(context, AppStrings.emailSentSuccessfullyTitle,
            AppStrings.emailSentSuccessfullyMessage, () {
          Navigator.of(context).pop();
        });
        _emailController.clear();
        Functions.emitUserEvent(
            context: context, event: GetAllInvitations(forceRefresh: true));
      } else if (state is EmailSentFailed) {
        showErrorDialog(context, AppStrings.emailSentFailedTitle,
            AppStrings.emailSentFailedMessage);
        _emailController.clear();
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
      if (authState is UserIsLoggedIn &&
          authState.user.role == UserRole.ADMIN) {
        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                AppStrings.registerDriverTitle,
                style: StyledText().appBarText(),
              ),
              SizedBox(height: 25),
              _text("Email"),
              inputTextFieldCustom(
                  context: context, controller: _emailController),
              if (_emailError != null) _errorText(_emailError!),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: customArrowButton(
                        text: "Send code",
                        verticalPadding: 10,
                        onPressed: () => _register(),
                        noIcon: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    }));
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
}
