import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/presentation/widgets/home_screen_top_nav.dart';
import 'package:travel_app/presentation/widgets/rides_wiget.dart';
import 'package:travel_app/utils/color_constants.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../widgets/tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<Trip> trips = [];
  List<TaskTrip> taskTrips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RidesDeliveriesToggle(),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is DriverUpcomingTripsLoaded) {
                  return _buildDriverTrips(context, state.driverTrips);
                } else if (state is DriverUpcomingDeliveriesLoaded) {
                  return _buildDriverDeliveries(
                      context, state.driverDeliveries);
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDriverTrips(BuildContext context, List<Trip> trips) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
          context: context,
          event: GetDriverUpcomingRides(forceRefresh: true),
        ),
        child: trips.isNotEmpty
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return RidesWidget(
                    startCity: trip.startCity,
                    endCity: trip.endCity,
                    startTime: trip.startTime,
                    passengers: trip.passengerTrips.length,
                  );
                },
              )
            : _emptyListIndicator("No upcoming rides available"),
      ),
    );
  }

  Widget _buildDriverDeliveries(
      BuildContext context, List<TaskTrip> taskTrips) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
            context: context,
            event: GetDriverUpcomingDeliveries(forceRefresh: true)),
        child: taskTrips.isNotEmpty
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: taskTrips.length,
                itemBuilder: (context, index) {
                  final taskTrip = taskTrips[index];
                  return TaskTripWidget(
                    // Change startCity/endCity with the fetched city from the geocoded location
                    //from the TaskTrip Start/End Location attributes, also check other attributes
                    startCity: "Sveti Nikole",
                    endCity: "Skopje",
                    description: taskTrip.description,
                    price: 200,
                  );
                },
              )
            : _emptyListIndicator("No upcoming deliveries"),
      ),
    );
  }

  Widget _emptyListIndicator(String text) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: greyColor),
          ),
        ),
      ),
    );
  }
}
