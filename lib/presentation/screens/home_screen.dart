import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../widgets/driverDeliveries.dart';
import '../widgets/driverRides.dart';
import '../widgets/home_screen_top_nav.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<UserBloc>().add(GetDriverUpcomingRides());
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
            BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is DriverUpcomingTripsLoaded) {
                  return buildDriverTrips(context, state.driverTrips);
                } else if (state is DriverUpcomingDeliveriesLoaded) {
                  return buildDriverDeliveries(context, state.driverDeliveries);
                }
                return Center(child: CircularProgressIndicator());
              },
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
}
