part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetDriverUpcomingRides extends UserEvent {
  final bool forceRefresh;

  const GetDriverUpcomingRides({this.forceRefresh = false});
}

class GetDriverUpcomingDeliveries extends UserEvent {
  final bool forceRefresh;

  const GetDriverUpcomingDeliveries({this.forceRefresh = false});
}

class LoadDriverData extends UserEvent {
  final bool forceRefresh;
  const LoadDriverData({this.forceRefresh = false});
}

class GetTripDetails extends UserEvent {
  final String driverId;
  final String tripId;

  const GetTripDetails({required this.driverId, required this.tripId});
}

class UpdateUserInfo extends UserEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String mobilePhone;

  const UpdateUserInfo(
      this.userId, this.firstName, this.lastName, this.mobilePhone);
}

class LoadDrivers extends UserEvent {}

class GetTripInfo extends UserEvent {
  final String tripId;
  const GetTripInfo(this.tripId);
}
