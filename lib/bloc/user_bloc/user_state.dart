part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class ProcessStarted extends UserState {}

class ProcessFailed extends UserState {}

class DriverUpcomingTripsLoaded extends UserState {
  final List<Trip> driverTrips;

  const DriverUpcomingTripsLoaded(this.driverTrips);
}

class DriverUpcomingDeliveriesLoaded extends UserState {
  final List<TaskTrip> driverDeliveries;

  const DriverUpcomingDeliveriesLoaded(this.driverDeliveries);
}

class DriverDataLoaded extends UserState {
  final List<Trip> driverTrips;
  final List<TaskTrip> driverDeliveries;
  const DriverDataLoaded(this.driverTrips, this.driverDeliveries);
}

class UsersLoaded extends UserState {
  final List<UserModel> users;
  const UsersLoaded(this.users);
}
