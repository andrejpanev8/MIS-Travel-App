import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
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
import 'package:travel_app/utils/string_constants.dart';

import '../../data/models/trip.dart';

class RideDetailsScreen extends StatelessWidget {
  Trip? trip;
  UserModel? driver;
  List<PassengerTrip>? passengerTrips;
  List<TaskTrip>? taskTrips;
  RideDetailsScreen({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    trip = ModalRoute.of(context)?.settings.arguments as Trip?;

    return SafeArea(
        child: Scaffold(
      appBar: customAppBar(context: context, arrowBack: true),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is TripDetailsLoaded) {
            driver = state.driver!;
            passengerTrips = state.passengerTrips;
            taskTrips = state.taskTrips;
            return _buildContent(context);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_generalInfo(trip!, driver)],
          ),
          SizedBox(height: 10),
          Text(
            AppStrings.passengers,
            style: StyledText().appBarText(color: blackColor),
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
              Text(AppStrings.yourRoute,
                  style: StyledText().descriptionText(color: blackColor)),
              _mapSection()
            ],
          ),
        ],
      ),
    );
  }

  Widget _generalInfo(Trip trip, UserModel? driver) {
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
        _buildRow(icon: Icons.access_time, text: "${trip.startTime}"),
        _buildRow(
            icon: Icons.badge_outlined,
            text:
                driver != null ? "${driver.firstName} ${driver.lastName}" : ""),
        _buildRow(
            text: "${AppStrings.startingLocation}: ${trip.startLocation}"),
        _buildRow(
            icon: Icons.people_alt_outlined,
            text:
                "${AppStrings.numberOfPassengers}: ${trip.passengerTrips.length}"),
        _buildRow(
            text: "${AppStrings.numberOfPackages}: ${trip.taskTrips.length}",
            assetIcon: boxIcon),
      ],
    );
  }

  Widget _buildRow({IconData? icon, String text = "", String? assetIcon}) {
    return Row(
      children: [
        icon != null
            ? Icon(icon)
            : assetIcon != null
                ? SvgPicture.asset(
                    assetIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(blackColor, BlendMode.srcIn),
                  )
                : SizedBox(width: 25),
        SizedBox(width: 10),
        Text(text)
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
