part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class ProcessStarted extends MapState {}

class MapInitial extends MapState {}

class MapSingleSelectionLoaded extends MapState {
  final LatLng location;
  final String address;
  final String mapStaticLink;
  const MapSingleSelectionLoaded(
      this.location, this.address, this.mapStaticLink);
}
