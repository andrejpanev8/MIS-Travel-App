part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingRides extends UserEvent {
  final bool forceRefresh;

  const GetUpcomingRides({this.forceRefresh = false});
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

class LoadAllDriversData extends UserEvent {
  final bool forceRefresh;
  const LoadAllDriversData({this.forceRefresh = false});
}

class LoadAllInvitations extends UserEvent {
  final bool forceRefresh;
  const LoadAllInvitations({this.forceRefresh = false});
}

class LoadDrivers extends UserEvent {}

class GetTripInfo extends UserEvent {
  final String tripId;
  const GetTripInfo(this.tripId);
}

class GetAllDrivers extends UserEvent {
  final bool forceRefresh;

  const GetAllDrivers({this.forceRefresh = false});
}

class GetAllInvitations extends UserEvent {
  final bool forceRefresh;

  const GetAllInvitations({this.forceRefresh = false});
}

class CheckEmailExists extends UserEvent {
  final String email;
  const CheckEmailExists(this.email);
}

class SendEmail extends UserEvent {
  final String email;
  const SendEmail(this.email);
}
