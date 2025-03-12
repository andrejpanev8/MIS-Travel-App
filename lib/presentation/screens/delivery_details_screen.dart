import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/mock/mock_task_trips.dart';
import 'package:travel_app/data/mock/mock_trips.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

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
  Trip? trip = mockTrips[0];
  TaskTrip? taskTrip = mockTaskTrips[0];

  dynamic userRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                  if (authState is UserIsLoggedIn) {
                    userRole = authState.user.role;
                  }
                  return BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (userRole == null) {
                        return Center(
                            child: infoText(AppStrings.loginRequiredMessage2));
                      }
                      if (state is DeliveryDetailsLoaded) {
                        trip = state.trip;
                        taskTrip = state.taskTrip;
                      }

                      return _buildClientDeliveryDetails(context);

                      // if (state is TripDetailsLoaded) {
                      //   driver = state.driver!;
                      //   passengerTrips = state.passengerTrips;
                      //   taskTrips = state.taskTrips;
                      //   return _buildContent(context);
                      // }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }))));
  }

  Widget _buildClientDeliveryDetails(BuildContext context) {
    if (taskTrip != null) {
      Functions.emitMapEvent(
          context: context,
          event: MapSelectionEvent(
              selectedLocation: taskTrip!.startLocation.toLatLng,
              uniqueKey: START_LOCATION_DELIVERY_DETAILS_SCREEN));
      Functions.emitMapEvent(
          context: context,
          event: MapSelectionEvent(
              selectedLocation: taskTrip!.endLocation.toLatLng,
              uniqueKey: END_LOCATION_DELIVERY_DETAILS_SCREEN));
    }

    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 10, bottom: 16, left: 10),
      child: deliveryGeneralInfo(trip, taskTrip),
    );
  }
}
