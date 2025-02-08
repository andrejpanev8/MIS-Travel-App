import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/presentation/widgets/driverDeliveries.dart';
import 'package:travel_app/presentation/widgets/driverRides.dart';
import 'package:travel_app/utils/text_styles.dart';

import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../utils/color_constants.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  List<Trip> trips = [];
  List<TaskTrip> taskTrips = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(LoginEvent("filips@bravobe.com", "test123"));
    });
  }

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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      _text("Upcoming Rides"),
                      buildDriverTrips(context, trips),
                      _text("Upcoming Deliveries"),
                      buildDriverDeliveries(context, taskTrips),
                    ],
                  );
                },
              );
            }
            return Center(child: _text("You have to login to view your data"));
          },
        ),
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: StyledText().appBarText(color: blackColor),
      ),
    );
  }
}
