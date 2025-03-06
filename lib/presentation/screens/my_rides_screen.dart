import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
import 'package:travel_app/data/DTO/PassengerTripDTO.dart';
import 'package:travel_app/data/models/invitation.dart';
import 'package:travel_app/presentation/widgets/drivers_widget.dart';
import 'package:travel_app/presentation/widgets/invitation_widget.dart';
import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/trip.dart';
import '../../data/models/user.dart';
import '../../utils/functions.dart';
import '../../utils/string_constants.dart';
import '../widgets/empty_list_indicator.dart';
import '../widgets/infoText_widget.dart';
import '../widgets/rides_widget.dart';
import '../widgets/tasks_widget.dart';
import '../widgets/widget_builder.dart';
import '../../data/enums/user_role.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  List<Trip> trips = [];
  List<TaskTripDTO> taskTrips = [];
  List<UserModel> drivers = [];
  List<Invitation> invitations = [];
  dynamic userRole;
  List<PassengerTripDTO> clientTrips = [];
  List<TaskTripDTO> clientDeliveries = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is UserIsLoggedIn) {
              userRole = authState.user.role;
            }
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is DriverDataLoaded) {
                  trips = state.driverTrips;
                  taskTrips = state.driverDeliveries;
                }

                if (state is DriverUpcomingRidesLoaded) {
                  trips = state.driverTrips;
                }

                if (state is DriverUpcomingDeliveriesLoaded) {
                  taskTrips = state.driverDeliveries;
                }

                if (state is AdminDataLoaded) {
                  drivers = state.drivers;
                  invitations = state.invitations;
                }

                if (state is AllDriversLoaded) {
                  drivers = state.drivers;
                }

                if (state is AllInvitationsLoaded) {
                  invitations = state.invitations;
                }

                if (state is ClientDataLoaded) {
                  clientTrips = state.clientTrips;
                  clientDeliveries = state.clientDeliveries;
                }

                if (state is ClientUpcomingTripsLoaded) {
                  clientTrips = state.clientTrips;
                }

                if (state is ClientUpcomingDeliveriesLoaded) {
                  clientDeliveries = state.clientDeliveries;
                }

                switch (userRole) {
                  case UserRole.DRIVER:
                    return _driverView();
                  case UserRole.ADMIN:
                    return _adminView();
                  case UserRole.CLIENT:
                    return _clientView();
                  default:
                    return Center(
                        child: infoText(AppStrings.loginRequiredMessage));
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _driverView() {
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
                    event: GetDriverUpcomingRides(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noUpcomingRides),
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
                    event: GetDriverUpcomingDeliveries(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noUpcomingDeliveries),
              scrollPhysics: NeverScrollableScrollPhysics()),
        ],
      ),
    );
  }

  Widget _adminView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          infoText(AppStrings.driversTitle),
          widgetBuilder(
              context: context,
              items: drivers,
              itemBuilder: (context, driver) =>
                  DriversWidget(context: context, driver: driver),
              onRefresh: () => Functions.emitUserEvent(
                    context: context,
                    event: GetAllDrivers(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noDrivers),
              scrollPhysics: NeverScrollableScrollPhysics()),
          const SizedBox(height: 30),
          infoText(AppStrings.invitationsTitle),
          widgetBuilder(
              context: context,
              items: invitations,
              itemBuilder: (context, invitation) =>
                  InvitationWidget(context: context, invitation: invitation),
              onRefresh: () => Functions.emitUserEvent(
                    context: context,
                    event: GetAllInvitations(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noInvitations),
              scrollPhysics: NeverScrollableScrollPhysics())
        ],
      ),
    );
  }

  Widget _clientView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          infoText(AppStrings.upcomingRides),
          widgetBuilder(
              context: context,
              items: clientTrips,
              itemBuilder: (context, ride) =>
                  RidesWidget(context: context, ride: ride.trip),
              onRefresh: () => Functions.emitUserEvent(
                    context: context,
                    event: GetClientUpcomingRides(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noUpcomingRides),
              scrollPhysics: NeverScrollableScrollPhysics()),
          SizedBox(height: 25),
          infoText(AppStrings.upcomingDeliveries),
          widgetBuilder(
              context: context,
              items: clientDeliveries,
              itemBuilder: (context, task) =>
                  TaskTripWidget(context: context, task: task),
              onRefresh: () => Functions.emitUserEvent(
                    context: context,
                    event: GetClientUpcomingDeliveries(forceRefresh: true),
                  ),
              emptyWidget: emptyListIndicator(AppStrings.noUpcomingDeliveries),
              scrollPhysics: NeverScrollableScrollPhysics()),
        ],
      ),
    );
  }
}
