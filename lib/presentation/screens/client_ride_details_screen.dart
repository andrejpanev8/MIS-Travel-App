import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/presentation/widgets/client_ride_general_info_widget.dart';
import 'package:travel_app/utils/map_unique_keys.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/infoText_widget.dart';

class ClientRideDetailsScreen extends StatelessWidget {
  PassengerTrip? passengerTrip;
  Trip? trip;

  dynamic userRole;

  @override
  Widget build(BuildContext context) {
    passengerTrip =
        ModalRoute.of(context)?.settings.arguments as PassengerTrip?;

    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(context: context, arrowBack: true),
            body: SingleChildScrollView(child:
                BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
              if (authState is UserIsLoggedIn) {
                userRole = authState.user.role;
              }
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (userRole == null) {
                    return Center(
                        child: infoText(AppStrings.loginRequiredMessage2));
                  }

                  if (state is RideDetailsLoaded) {
                    trip = state.trip;
                  } else if (state is RideDetailsNotFound) {
                    return Center(child: infoText(AppStrings.rideNotFound));
                  }

                  return passengerTrip != null && trip != null
                      ? _buildClientRideDetails(context)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              );
            }))));
  }

  Widget _buildClientRideDetails(BuildContext context) {
    if (passengerTrip != null) {
      Functions.emitMapEvent(
          context: context,
          event: MapSelectionEvent(
              selectedLocation: passengerTrip!.startLocation.toLatLng,
              uniqueKey: START_LOCATION_CLIENT_RIDE_DETAILS_SCREEN));
      Functions.emitMapEvent(
          context: context,
          event: MapSelectionEvent(
              selectedLocation: passengerTrip!.endLocation.toLatLng,
              uniqueKey: END_LOCATION_CLIENT_RIDE_DETAILS_SCREEN));
    }

    return Padding(
        padding: EdgeInsets.only(top: 20.0, right: 10, bottom: 16, left: 10),
        child: clientRideGeneralInfo(context, trip, passengerTrip));
  }
}
