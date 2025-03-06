import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/passenger_trip.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../data/models/user.dart';
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
                  if(userRole == null) {
                    return Center(
                      child: infoText(AppStrings.loginRequiredMessage1));
                  }

                  if (state is TripDetailsLoaded) {
                    driver = state.driver!;
                    passengerTrips = state.passengerTrips;
                    taskTrips = state.taskTrips;
                    return _buildContent(context);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              );
            })));
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [rideGeneralInfo(trip!, driver)],
          ),
          SizedBox(height: 10),
          Text(
            AppStrings.passengers,
            style: StyledText().appBarText(),
          ),
          widgetBuilder(
              context: context,
              items: passengerTrips!,
              itemBuilder: (context, passengerTrip) =>
                  PassengerWidget(passenger: passengerTrip),
              scrollPhysics: NeverScrollableScrollPhysics()),
          SizedBox(height: 30),
          Text(
            AppStrings.packages,
            style: StyledText().appBarText(),
          ),
          widgetBuilder(
              context: context,
              items: taskTrips!,
              itemBuilder: (context, taskTrip) =>
                  TaskTripDetailsWidget(taskTrip: taskTrip),
              scrollPhysics: NeverScrollableScrollPhysics()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.yourRoute, style: StyledText().descriptionText()),
              MapStatic(),
            ],
          ),
        ],
      ),
    );
  }
}
