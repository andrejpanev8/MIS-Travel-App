import 'package:flutter/material.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import 'empty_list_indicator.dart';
import 'rides_widget.dart';

Widget buildDriverTrips(BuildContext context, List<Trip> trips) {
  return Expanded(
    child: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
          context: context,
          event: GetDriverUpcomingRides(forceRefresh: true),
        ),
        child: trips.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                }
              )
            : emptyListIndicator("No upcoming rides available"),
      ),
    ),
  );
}
