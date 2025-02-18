import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../widgets/empty_list_indicator.dart';
import '../widgets/infoText_widget.dart';
import '../widgets/rides_widget.dart';
import '../widgets/tasks_widget.dart';
import '../widgets/widget_builder.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  List<Trip> trips = [];
  List<TaskTripDTO> taskTrips = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is UserIsLoggedIn) {
              context.read<UserBloc>().add(LoadDriverData());
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is DriverDataLoaded) {
                    trips = state.driverTrips;
                    taskTrips = state.driverDeliveries;
                  }

                  if (state is DriverUpcomingTripsLoaded) {
                    trips = state.driverTrips;
                  }

                  if (state is DriverUpcomingDeliveriesLoaded) {
                    taskTrips = state.driverDeliveries;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        infoText(AppStrings.upcomingRides),
                        widgetBuilder(
                            context: context,
                            items: trips,
                            itemBuilder: (context, ride) =>
                                RidesWidget(context: context, ride: ride),
                            onRefresh: () => Functions.emitUserEvent(
                                  context: context,
                                  event: GetDriverUpcomingDeliveries(
                                      forceRefresh: true),
                                ),
                            emptyWidget:
                                emptyListIndicator(AppStrings.noUpcomingRides),
                            scrollPhysics: NeverScrollableScrollPhysics()),
                        SizedBox(height: 25),
                        infoText(AppStrings.upcomingDeliveries),
                        widgetBuilder(
                            context: context,
                            items: taskTrips,
                            itemBuilder: (context, task) =>
                                TaskTripWidget(context: context, task: task),
                            onRefresh: () => Functions.emitUserEvent(
                                  context: context,
                                  event: GetDriverUpcomingDeliveries(
                                      forceRefresh: true),
                                ),
                            emptyWidget: emptyListIndicator(
                                AppStrings.noUpcomingDeliveries),
                            scrollPhysics: NeverScrollableScrollPhysics()),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(child: infoText(AppStrings.loginRequiredMessage));
          },
        ),
      ),
    );
  }
}
