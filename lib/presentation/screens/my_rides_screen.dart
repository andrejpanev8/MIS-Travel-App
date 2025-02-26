import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:travel_app/bloc/user_bloc/user_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is UserIsLoggedIn) {
              final userRole = authState.user.role;

              if (userRole == UserRole.DRIVER) {
                context.read<UserBloc>().add(LoadDriverData());
              } else if (userRole == UserRole.ADMIN) {
                context.read<UserBloc>().add(LoadAllDriversData());
              }

              return BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (userRole == UserRole.DRIVER) {
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
                          (state is DriverUpcomingTripsLoaded ||
                                  state is DriverDataLoaded)
                              ? widgetBuilder(
                                  context: context,
                                  items: trips,
                                  itemBuilder: (context, ride) =>
                                      RidesWidget(context: context, ride: ride),
                                  onRefresh: () => Functions.emitUserEvent(
                                        context: context,
                                        event: GetDriverUpcomingDeliveries(
                                            forceRefresh: true),
                                      ),
                                  emptyWidget: emptyListIndicator(
                                      AppStrings.noUpcomingRides),
                                  scrollPhysics: NeverScrollableScrollPhysics())
                              : const Center(
                                  child: CircularProgressIndicator()),
                          SizedBox(height: 25),
                          infoText(AppStrings.upcomingDeliveries),
                          (state is DriverUpcomingDeliveriesLoaded ||
                                  state is DriverDataLoaded)
                              ? widgetBuilder(
                                  context: context,
                                  items: taskTrips,
                                  itemBuilder: (context, task) =>
                                      TaskTripWidget(
                                          context: context, task: task),
                                  onRefresh: () => Functions.emitUserEvent(
                                        context: context,
                                        event: GetDriverUpcomingDeliveries(
                                            forceRefresh: true),
                                      ),
                                  emptyWidget: emptyListIndicator(
                                      AppStrings.noUpcomingDeliveries),
                                  scrollPhysics: NeverScrollableScrollPhysics())
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  } else if (userRole == UserRole.ADMIN) {
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

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          infoText(AppStrings.driversTitle),
                          (state is AllDriversLoaded ||
                                  state is AdminDataLoaded)
                              ? widgetBuilder(
                                  context: context,
                                  items: drivers,
                                  itemBuilder: (context, driver) =>
                                      DriversWidget(
                                          context: context, driver: driver),
                                  onRefresh: () => Functions.emitUserEvent(
                                        context: context,
                                        event:
                                            GetAllDrivers(forceRefresh: true),
                                      ),
                                  emptyWidget:
                                      emptyListIndicator(AppStrings.noDrivers),
                                  scrollPhysics: NeverScrollableScrollPhysics())
                              : const Center(
                                  child: CircularProgressIndicator()),
                          const SizedBox(height: 30),
                          infoText(AppStrings.invitationsTitle),
                          (state is AllInvitationsLoaded ||
                                  state is AdminDataLoaded)
                              ? widgetBuilder(
                                  context: context,
                                  items: invitations,
                                  itemBuilder: (context, invitation) =>
                                      InvitationWidget(
                                          context: context,
                                          invitation: invitation),
                                  onRefresh: () => Functions.emitUserEvent(
                                        context: context,
                                        event: GetAllInvitations(
                                            forceRefresh: true),
                                      ),
                                  emptyWidget: emptyListIndicator(
                                      AppStrings.noInvitations),
                                  scrollPhysics: NeverScrollableScrollPhysics())
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ],
                      ),
                    );
                  }

                  return Center(
                      child: infoText(AppStrings.loginRequiredMessage));
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
