import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/data/mock/mock_passenger_trips.dart';
import 'package:travel_app/data/mock/mock_task_trips.dart';
import 'package:travel_app/data/mock/mock_users.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/presentation/widgets/custom_app_bar.dart';
import 'package:travel_app/presentation/widgets/passenger_widget.dart';
import 'package:travel_app/presentation/widgets/task_details_widget.dart';
import 'package:travel_app/presentation/widgets/widget_builder.dart';
import 'package:travel_app/utils/color_constants.dart';
import 'package:travel_app/utils/image_constants.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/models/trip.dart';

class RideDetailsScreen extends StatelessWidget {
  Trip? trip;
  //Initiated temporary data will be replaced with an event call
  UserModel? driver = mockUsers[0];
  List<PassengerTrip>? passengerTrips = mockPassengerTrips;
  List<TaskTrip>? taskTrips = mockTaskTrips;
  RideDetailsScreen({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    trip = ModalRoute.of(context)?.settings.arguments as Trip?;

    return SafeArea(
        child: Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) => {},
        builder: (context, state) {
          if (state is TripDetailsLoaded) {
            driver = state.driver!;
            passengerTrips = state.passengerTrips;
            taskTrips = state.taskTrips;
          }
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // children: [_generalInfo(trip!, driver!)],
                  children: [_generalInfo(trip!)],
                ),
                SizedBox(height: 10),
                Text(
                  "Passengers",
                  style: StyledText().appBarText(color: blackColor),
                ),
                widgetBuilder(
                    context: context,
                    items: passengerTrips!,
                    itemBuilder: (context, passengerTrip) =>
                        PassengerWidget(passenger: passengerTrip),
                    scrollPhysics: NeverScrollableScrollPhysics()),
                Text(
                  "Packages",
                  style: StyledText().appBarText(color: blackColor),
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
                    Text("Your route",
                        style: StyledText().descriptionText(color: blackColor)),
                    _mapSection()
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ));
  }

  // Widget _generalInfo(Trip trip, UserModel driver) {
  Widget _generalInfo(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on_outlined),
            Text("${trip.startCity} - ${trip.endCity}",
                style: StyledText().appBarText(color: blackColor))
          ],
        ),
        Row(
          children: [Icon(Icons.access_time), Text("${trip.startTime}")],
        ),
        Row(
          children: [
            Icon(Icons.badge_outlined),
            // Text("${driver.firstName} ${driver.lastName}")
            Text("Markus Primus")
          ],
        ),
        Row(
          children: [
            // TO:DO Change with resolved location by latitude longitude
            // create such service to be called
            SizedBox(width: 20),
            Text("Starting Location: ${trip.startLocation}")
          ],
        ),
        Row(
          children: [
            Icon(Icons.people_alt_outlined),
            Text("No. Passengers: ${trip.passengerTrips.length}")
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              boxIcon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
            ),
            Text("No. Packages: ${trip.taskTrips.length}")
          ],
        ),
      ],
    );
  }

  Widget _mapSection() {
    return CachedNetworkImage(
      imageUrl:
          "https://developers.google.com/static/maps/images/landing/hero_directions_api.png",
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      width: double.infinity,
      height: 250,
      fit: BoxFit.contain,
    );
  }
}
