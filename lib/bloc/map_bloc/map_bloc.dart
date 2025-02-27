import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../data/services/map_service.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  LatLng currentUserLocation = LatLng(41.99812940, 21.42543550);
  String? currentMapLink;
  MapBloc() : super(MapInitial()) {
    on<MapEvent>((event, emit) async {
      if (event is MapSelectionEvent) {
        emit(ProcessStarted());
        String address = "";
        String staticLink = "";

        address = await MapService().getAddressFromCoordinates(
                event.selectedLocation.latitude,
                event.selectedLocation.longitude) ??
            "";
        staticLink = MapService().generateMapUrl(
            event.selectedLocation.latitude, event.selectedLocation.longitude);

        currentMapLink = staticLink;

        emit(MapSingleSelectionLoaded(
            event.selectedLocation ?? currentUserLocation, address, staticLink, event.uniqueKey));
      }

      if (event is AddressEntryEvent) {
        emit(ProcessStarted());
        LatLng location = await MapService()
            .getCoordinatesFromAddress(event.address!)
            .then((result) => LatLng(result!["latitude"], result["longitude"]));

        String mapStaticLink = "";

        mapStaticLink =
            MapService().generateMapUrl(location.latitude, location.longitude);

        currentMapLink = mapStaticLink;

        emit(MapSingleSelectionLoaded(location, event.address!, mapStaticLink, event.uniqueKey));
      }
    });
  }
}
