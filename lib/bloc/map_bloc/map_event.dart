part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapSelectionEvent extends MapEvent {
  final LatLng selectedLocation;
  final String uniqueKey;
  const MapSelectionEvent({required this.selectedLocation, required this.uniqueKey});
}

class AddressEntryEvent extends MapEvent {
  final String? address;
  final String uniqueKey;
  const AddressEntryEvent(this.address, this.uniqueKey);
}
