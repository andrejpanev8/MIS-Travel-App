part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class ProcessStarted extends MapState {}

class MapInitial extends MapState {}

class MapSingleSelectionLoaded extends MapState {
  final String? type;
  final LatLng location;
  final String address;
  final String mapStaticLink;
  const MapSingleSelectionLoaded(
      this.location, this.address, this.mapStaticLink,
      {this.type});
}

class MapDoubleSelectionLoaded extends MapState {
  final LatLng fromLocation;
  final LatLng toLocation;
  final String fromAddress;
  final String toAddress;
  final String mapStaticLink;

  const MapDoubleSelectionLoaded(this.fromLocation, this.toLocation,
      this.fromAddress, this.toAddress, this.mapStaticLink);
}
