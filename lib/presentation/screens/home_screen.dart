import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:travel_app/presentation/widgets/home_screen_top_nav.dart';
import 'package:travel_app/presentation/widgets/rides_wiget.dart';
import 'package:travel_app/utils/color_constants.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../utils/functions.dart';
import '../widgets/tasks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> trips = [];
  List<TaskTrip> taskTrips = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ridesDeliveriesToggle(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _ridesDeliveriesToggle() {
    return BlocListener<HomeScreenBloc, HomeScreenState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state is RidesActive) {
          context.read<UserBloc>().add(GetDriverUpcomingRides());
        } else {
          context.read<UserBloc>().add(GetDriverUpcomingDeliveries());
        }
      },
      child: RidesDeliveriesToggle(),
    );
  }

  void _loadData(BuildContext context) {
    final homeScreenBloc = context.read<HomeScreenBloc>();

    if (homeScreenBloc.state is HomeScreenInitial) {
      context.read<HomeScreenBloc>().add(ToggleActiveScreen());
    }
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
