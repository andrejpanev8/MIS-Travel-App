import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../utils/string_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/infoText_widget.dart';

class DeliveryDetailsScreen extends StatelessWidget {

  dynamic userRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body:
            BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
              if (authState is UserIsLoggedIn) {
                userRole = authState.user.role;
              }
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if(userRole == null) {
                    return Center(
                        child: infoText(AppStrings.loginRequiredMessage2));
                  }


                  return Text("delivery details screen");
                  // if (state is TripDetailsLoaded) {
                  //   driver = state.driver!;
                  //   passengerTrips = state.passengerTrips;
                  //   taskTrips = state.taskTrips;
                  //   return _buildContent(context);
                  // }
                  return Center(child: CircularProgressIndicator());
                },
              );
            })));
  }
}
