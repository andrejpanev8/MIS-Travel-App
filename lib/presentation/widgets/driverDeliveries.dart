import 'package:flutter/material.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/task_trip.dart';
import '../../utils/functions.dart';
import 'empty_list_indicator.dart';
import 'tasks_widget.dart';

Widget buildDriverDeliveries(BuildContext context, List<TaskTrip> taskTrips) {
  return Expanded(
    child: SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
          context: context,
          event: GetDriverUpcomingDeliveries(forceRefresh: true),
        ),
        child: taskTrips.isNotEmpty
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: taskTrips.length,
                itemBuilder: (context, index) {
                  final taskTrip = taskTrips[index];
                  return TaskTripWidget(
                    startCity: "Sveti Nikole",
                    endCity: "Skopje",
                    description: taskTrip.description,
                    price: 200,
                  );
                },
              )
            : emptyListIndicator("No upcoming deliveries"),
      ),
    ),
  );
}
