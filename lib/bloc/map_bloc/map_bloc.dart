import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../service/map_service.dart';

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
            event.selectedLocation, address, staticLink,
            uniqueKey: event.uniqueKey));
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

        emit(MapSingleSelectionLoaded(location, event.address!, mapStaticLink,
            uniqueKey: event.uniqueKey ?? ""));
      }

      if (event is MapDoubleSelectionEvent) {
        emit(ProcessStarted());
        String addressFrom = "";
        String addressTo = "";
        String staticLink = "";
        List<LatLng> route = [];

        addressFrom = await MapService().getAddressFromCoordinates(
                event.fromSelectedLocation.latitude,
                event.fromSelectedLocation.longitude) ??
            "";

        addressTo = await MapService().getAddressFromCoordinates(
                event.toSelectedLocation.latitude,
                event.toSelectedLocation.longitude) ??
            "";

        route = await MapService()
            .getRoute(event.fromSelectedLocation, event.toSelectedLocation);

        staticLink = MapService().generateMapUrlWithRoute(route);

        currentMapLink = staticLink;
        emit(MapDoubleSelectionLoaded(event.fromSelectedLocation,
            event.toSelectedLocation, addressFrom, addressTo, staticLink));
      }

      if (event is AddressDoubleEntryEvent) {
        emit(ProcessStarted());
        try {
          String mapStaticLink = "";
          List<LatLng> route = [];

          LatLng fromLocation = await MapService()
              .getCoordinatesFromAddress(event.fromAddress!)
              .then(
                  (result) => LatLng(result!["latitude"], result["longitude"]));

          LatLng toLocation = await MapService()
              .getCoordinatesFromAddress(event.toAddress!)
              .then(
                  (result) => LatLng(result!["latitude"], result["longitude"]));

          route = await MapService().getRoute(fromLocation, toLocation);

          mapStaticLink = MapService().generateMapUrlWithRoute(route);

          currentMapLink = mapStaticLink;

          emit(MapDoubleSelectionLoaded(fromLocation, toLocation,
              event.fromAddress!, event.toAddress!, mapStaticLink));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }
}
