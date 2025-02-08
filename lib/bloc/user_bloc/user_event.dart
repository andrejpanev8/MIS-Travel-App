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

class GetDrivers extends UserEvent {
  final List<UserModel>? drivers;

  const GetDrivers({this.drivers});
}
