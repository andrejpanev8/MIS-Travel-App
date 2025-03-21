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
  final String? uniqueKey;

  const MapSingleSelectionLoaded(
      this.location, this.address, this.mapStaticLink,
      {this.uniqueKey});
}

class MapDoubleSelectionLoaded extends MapState {
  final LatLng fromLocation;
  final LatLng toLocation;
  final String fromAddress;
  final String toAddress;
  final String mapStaticLink;
  final HashMap<String, String>? mapLinks;

  const MapDoubleSelectionLoaded(this.fromLocation, this.toLocation,
      this.fromAddress, this.toAddress, this.mapStaticLink,
      {this.mapLinks});
}

class MapMultiStopRouteLoaded extends MapState {
  final List<LatLng> route;
  final String mapStaticLink;
  final List<LatLng> fromLocations;
  final List<LatLng> toLocations;

  const MapMultiStopRouteLoaded(
      this.route, this.mapStaticLink, this.fromLocations, this.toLocations);
}
