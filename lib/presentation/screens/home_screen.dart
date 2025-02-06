import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:travel_app/presentation/widgets/home_screen_top_nav.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<Trip> trips = [];

  @override
  Widget build(BuildContext context) {
    Functions.emitEvent(context: context, event: GetDriverUpcomingRides());
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              RidesDeliveriesToggle(),
              if (state is DriverUpcomingTripsLoaded)
                Flexible(
                    child: _buildDriverTrips(context)), // ✅ Wrap in Flexible
              if (state is DriverUpcomingDeliveriesLoaded)
                Flexible(
                    child:
                        _buildDriverDeliveries(context)), // ✅ Wrap in Flexible
            ],
          );
        },
      ),
    );
  }

  Widget _buildDriverTrips(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
            context: context,
            event: GetDriverUpcomingRides(forceRefresh: true)),
        child: ListView(
          children: [
            Center(child: Text("Driver upcoming rides loaded")),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverDeliveries(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => Functions.emitEvent(
            context: context,
            event: GetDriverUpcomingDeliveries(forceRefresh: true)),
        child: ListView(
          children: [
            Center(child: Text("Driver upcoming deliveries loaded")),
          ],
        ),
      ),
    );
  }
}
