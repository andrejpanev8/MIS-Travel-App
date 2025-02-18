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
  final List<TaskTripDTO> driverDeliveries;

  const DriverUpcomingDeliveriesLoaded(this.driverDeliveries);
}

class DriverDataLoaded extends UserState {
  final List<Trip> driverTrips;
  final List<TaskTripDTO> driverDeliveries;
  const DriverDataLoaded(this.driverTrips, this.driverDeliveries);
}

class TripDetailsLoaded extends UserState {
  final UserModel? driver;
  final List<PassengerTrip>? passengerTrips;
  final List<TaskTrip>? taskTrips;

  const TripDetailsLoaded(this.driver, this.passengerTrips, this.taskTrips);
}
