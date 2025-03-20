import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/models/task_trip.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/delivery_general_info_widget.dart';
import '../widgets/infoText_widget.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  TaskTrip? taskTrip;
  Trip? trip;

  dynamic userRole;

  @override
  Widget build(BuildContext context) {
    taskTrip = ModalRoute.of(context)?.settings.arguments as TaskTrip?;

    return PopScope(
      onPopInvokedWithResult: (onPopped, result) {
        context.read<MapBloc>().add(ClearMapEvent());
      },
      canPop: true,
      child: SafeArea(
          child: Scaffold(
              appBar: customAppBar(context: context, arrowBack: true),
              body: SingleChildScrollView(
                  padding: EdgeInsets.all(0),
                  child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                    if (authState is UserIsLoggedIn) {
                      userRole = authState.user.role;
                    }
                    return BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (userRole == null) {
                          return Center(
                              child:
                                  infoText(AppStrings.loginRequiredMessage2));
                        }
                        if (state is DeliveryDetailsLoaded) {
                          trip = state.trip;
                        } else if (state is DeliveryDetailsNotFound) {
                          return Center(
                              child: infoText(AppStrings.deliveryNotFound));
                        }

                        return taskTrip != null && trip != null
                            ? _buildClientDeliveryDetails(context)
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    );
                  })))),
    );
  }

  Widget _buildClientDeliveryDetails(BuildContext context) {
    if (taskTrip != null) {
      Functions.emitMapEvent(
          context: context,
          event: AddressDoubleEntryEvent(
              taskTrip!.startLocation.address, taskTrip!.endLocation.address));
    }

    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 10, bottom: 16, left: 10),
      child: deliveryGeneralInfo(context, trip, taskTrip, userRole),
    );
  }
}
