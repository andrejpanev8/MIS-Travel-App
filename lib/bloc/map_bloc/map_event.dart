part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapSelectionEvent extends MapEvent {
  final LatLng selectedLocation;
  final String? uniqueKey;
  const MapSelectionEvent({required this.selectedLocation, this.uniqueKey});
}

class MapDoubleSelectionEvent extends MapEvent {
  final LatLng fromSelectedLocation;
  final LatLng toSelectedLocation;
  final String? uniqueKey;
  const MapDoubleSelectionEvent(
      {required this.fromSelectedLocation,
      required this.toSelectedLocation,
      this.uniqueKey});
}

class AddressEntryEvent extends MapEvent {
  final String? address;
  final String? uniqueKey;
  const AddressEntryEvent(this.address, {this.uniqueKey});
}

class AddressDoubleEntryEvent extends MapEvent {
  final String? fromAddress;
  final String? toAddress;
  final String? uniqueKey;

  const AddressDoubleEntryEvent(this.fromAddress, this.toAddress,
      {this.uniqueKey});
}

class LoadWaypointsEvent extends MapEvent {
  final Trip trip;
  const LoadWaypointsEvent(this.trip);
}

class ClearMapEvent extends MapEvent {
  const ClearMapEvent();
}
