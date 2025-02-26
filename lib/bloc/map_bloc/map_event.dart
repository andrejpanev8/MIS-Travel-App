part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapSelectionEvent extends MapEvent {
  final LatLng selectedLocaton;
  const MapSelectionEvent({required this.selectedLocaton});
}

class MapDoubleSelectionEvent extends MapEvent {
  final LatLng fromSelectedLocation;
  final LatLng toSelectedLocation;
  const MapDoubleSelectionEvent(
      {required this.fromSelectedLocation, required this.toSelectedLocation});
}

class AddressEntryEvent extends MapEvent {
  final String? address;
  final String? type;
  const AddressEntryEvent(this.address, {this.type});
}

class AddressDoubleEntryEvent extends MapEvent {
  final String? fromAddress;
  final String? toAddress;

  const AddressDoubleEntryEvent(this.fromAddress, this.toAddress);
}
