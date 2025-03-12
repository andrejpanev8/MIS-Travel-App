part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class ProcessStarted extends UserState {}

class ProcessFailed extends UserState {}

class UpcomingRidesLoaded extends UserState {
  final List<Trip> trips;

  const UpcomingRidesLoaded(this.trips);
}

class UpcomingDeliveriesLoaded extends UserState {
  final List<TaskTripDTO> deliveries;

  const UpcomingDeliveriesLoaded(this.deliveries);
}

class DriverUpcomingRidesLoaded extends UserState {
  final List<Trip> driverTrips;

  const DriverUpcomingRidesLoaded(this.driverTrips);
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

class UserValidationFailed extends UserState {
  final Map<String, String> errors;

  const UserValidationFailed(this.errors);

  @override
  List<Object> get props => [errors];
}

class UserUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserUpdateFailure extends UserState {
  final String message;

  const UserUpdateFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AllDriversLoaded extends UserState {
  final List<UserModel> drivers;
  const AllDriversLoaded(this.drivers);
}

class AllInvitationsLoaded extends UserState {
  final List<Invitation> invitations;
  const AllInvitationsLoaded(this.invitations);
}

class TripInfoLoaded extends UserState {
  final Trip? trip;
  final UserModel? driver;
  const TripInfoLoaded(this.trip, this.driver);
}

class DriversAndInvitationsLoaded extends UserState {
  final List<UserModel> drivers;
  final List<Invitation> invitations;

  const DriversAndInvitationsLoaded(
      {required this.drivers, required this.invitations});

  @override
  List<Object> get props => [drivers, invitations];
}

class AdminDataLoaded extends UserState {
  final List<UserModel> drivers;
  final List<Invitation> invitations;
  const AdminDataLoaded(this.drivers, this.invitations);
}

class EmailExists extends UserState {}

class EmailAvailable extends UserState {}

class DriverRegistered extends UserState {}

class EmailSentSuccessfully extends UserState {
  const EmailSentSuccessfully();
}

class EmailSentFailed extends UserState {
  const EmailSentFailed();
}

class DeliveryCreateSuccess extends UserState {}

class DeliveryCreateError extends UserState {}

class ClientDataLoaded extends UserState {
  final List<PassengerTripDTO> clientTrips;
  final List<TaskTripDTO> clientDeliveries;
  const ClientDataLoaded(this.clientTrips, this.clientDeliveries);
}

class ClientUpcomingTripsLoaded extends UserState {
  final List<PassengerTripDTO> clientTrips;

  const ClientUpcomingTripsLoaded(this.clientTrips);
}

class ClientUpcomingDeliveriesLoaded extends UserState {
  final List<TaskTripDTO> clientDeliveries;

  const ClientUpcomingDeliveriesLoaded(this.clientDeliveries);
}

class RideReserveSuccess extends UserState {}

class RideReserveError extends UserState {}

class TripSaveSuccess extends UserState {}

class TripSaveError extends UserState {}

class EditTripInfoLoaded extends UserState {
  final Trip trip;
  final UserModel driver;
  final String startLocationAddress;
  const EditTripInfoLoaded(this.trip, this.driver, this.startLocationAddress);
}
