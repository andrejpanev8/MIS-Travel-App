import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/presentation/widgets/empty_list_indicator.dart';
import 'package:travel_app/presentation/widgets/rides_widget.dart';
import 'package:travel_app/presentation/widgets/tasks_widget.dart';
import 'package:travel_app/utils/functions.dart';
import 'package:travel_app/utils/string_constants.dart';
import '../../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../widgets/home_screen_top_nav.dart';
import '../widgets/widget_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is DriverUpcomingTripsLoaded) {
                    return widgetBuilder(
                        context: context,
                        items: state.driverTrips,
                        itemBuilder: (context, ride) =>
                            RidesWidget(context: context, ride: ride),
                        onRefresh: () => Functions.emitUserEvent(
                            context: context,
                            event: GetDriverUpcomingRides(forceRefresh: true)),
                        emptyWidget:
                            emptyListIndicator(AppStrings.noUpcomingRides));
                  } else if (state is DriverUpcomingDeliveriesLoaded) {
                    return widgetBuilder(
                        context: context,
                        items: state.driverDeliveries,
                        itemBuilder: (context, task) =>
                            TaskTripWidget(context: context, task: task),
                        onRefresh: () => Functions.emitUserEvent(
                            context: context,
                            event: GetDriverUpcomingDeliveries(
                                forceRefresh: true)),
                        emptyWidget: emptyListIndicator(
                            AppStrings.noUpcomingDeliveries));
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
}
