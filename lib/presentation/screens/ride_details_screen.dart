import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/data/enums/user_role.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/passenger_trip.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/infoText_widget.dart';
import '../widgets/map_static.dart';
import '../widgets/passenger_widget.dart';
import '../widgets/ride_general_info_widget.dart';
import '../widgets/task_details_widget.dart';
import '../widgets/widget_builder.dart';

class RideDetailsScreen extends StatelessWidget {
  Trip? trip;
  UserModel? driver;
  List<PassengerTrip>? passengerTrips;
  List<TaskTrip>? taskTrips;
  RideDetailsScreen({super.key, this.trip});
  dynamic userRole;

  @override
  Widget build(BuildContext context) {
    trip = ModalRoute.of(context)?.settings.arguments as Trip?;

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
                  if (userRole == null) {
                    return Center(
                        child: infoText(AppStrings.loginRequiredMessage1));
                  }

                  if (state is TripDetailsLoaded) {
                    driver = state.driver!;
                    passengerTrips = state.passengerTrips;
                    taskTrips = state.taskTrips;
                  }
                  return driver != null &&
                          passengerTrips != null &&
                          taskTrips != null
                      ? _buildContent(context)
                      : Center(child: CircularProgressIndicator());
                },
              );
            })));
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rideGeneralInfo(trip!, driver),
              userRole == UserRole.ADMIN
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Functions.emitUserEvent(
                            context: context,
                            event: EditTripEvent(trip!, driver!));
                        Navigator.of(context).pushNamed('/addRide');
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle(AppStrings.passengers),
          _buildPassengerList(context),
          const SizedBox(height: 20),
          _sectionTitle(AppStrings.packages),
          _buildTaskList(context),
          const SizedBox(height: 20),
          _sectionTitle(AppStrings.yourRoute),
          //TODO: GET TRIP FOR ENTIRE ROUTE
          const MapStatic(
            uniqueKey: "TO:DO GET TRIP ENTIRE ROUTE",
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(
        title,
        style: StyledText().appBarText(),
      ),
    );
  }

  Widget _buildPassengerList(BuildContext context) {
    return widgetBuilder(
      context: context,
      items: passengerTrips!,
      itemBuilder: (context, passengerTrip) =>
          PassengerWidget(passenger: passengerTrip),
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return widgetBuilder(
      context: context,
      items: taskTrips!,
      itemBuilder: (context, taskTrip) =>
          TaskTripDetailsWidget(taskTrip: taskTrip),
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }
}
