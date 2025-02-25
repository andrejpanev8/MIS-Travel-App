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

class AddressEntryEvent extends MapEvent {
  final String? address;
  const AddressEntryEvent(this.address);
}
