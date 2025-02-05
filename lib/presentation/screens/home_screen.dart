import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/trip.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<Trip> trips = [];

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(GetDriverUpcomingRides());
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DriverUpcomingTripsLoaded) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<UserBloc>()
                      .add(GetDriverUpcomingRides(forceRefresh: true));
                },
                child: ListView(
                  children: [
                    Center(child: Text("Driver upcoming rides loaded")),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
