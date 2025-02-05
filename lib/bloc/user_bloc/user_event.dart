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
