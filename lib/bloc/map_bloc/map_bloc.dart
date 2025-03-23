import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/service/passenger_trip_service.dart';
import 'package:travel_app/service/task_trip_service.dart';

import '../../data/models/task_trip.dart';
import '../../data/models/trip.dart';
import '../../service/map_service.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  LatLng currentUserLocation = LatLng(41.99812940, 21.42543550);
  HashMap<String, String> mapLinks = HashMap<String, String>();

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

        emit(MapSingleSelectionLoaded(
            event.selectedLocation, address, staticLink,
            uniqueKey: event.uniqueKey));
      }

      if (event is AddressEntryEvent) {
        emit(ProcessStarted());
        LatLng location = await MapService()
            .getCoordinatesFromAddress(event.address!)
            .then((result) => LatLng(result["latitude"], result["longitude"]));

        String staticLink = "";

        staticLink =
            MapService().generateMapUrl(location.latitude, location.longitude);

        emit(MapSingleSelectionLoaded(location, event.address!, staticLink,
            uniqueKey: event.uniqueKey));
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
        String fromStaticLink = MapService().generateMapUrl(
            event.fromSelectedLocation.latitude,
            event.fromSelectedLocation.longitude);
        String toStaticLink = MapService().generateMapUrl(
            event.toSelectedLocation.latitude,
            event.toSelectedLocation.longitude);

        mapLinks["from"] = fromStaticLink;
        mapLinks["to"] = toStaticLink;

        emit(MapDoubleSelectionLoaded(event.fromSelectedLocation,
            event.toSelectedLocation, addressFrom, addressTo, staticLink));
      }

      if (event is AddressDoubleEntryEvent) {
        emit(ProcessStarted());
        try {
          String staticLink = "";
          List<LatLng> route = [];

          LatLng fromLocation = await MapService()
              .getCoordinatesFromAddress(event.fromAddress!)
              .then(
                  (result) => LatLng(result["latitude"], result["longitude"]));

          LatLng toLocation = await MapService()
              .getCoordinatesFromAddress(event.toAddress!)
              .then(
                  (result) => LatLng(result["latitude"], result["longitude"]));

          route = await MapService().getRoute(fromLocation, toLocation);

          staticLink = MapService().generateMapUrlWithRoute(route);

          String fromStaticLink = MapService()
              .generateMapUrl(fromLocation.latitude, fromLocation.longitude);
          String toStaticLink = MapService()
              .generateMapUrl(toLocation.latitude, toLocation.longitude);

          // event.uniqueKey != null
          //     ? mapLinks[event.uniqueKey!] = staticLink
          //     : null;
          mapLinks["from"] = fromStaticLink;
          mapLinks["to"] = toStaticLink;

          emit(MapDoubleSelectionLoaded(fromLocation, toLocation,
              event.fromAddress!, event.toAddress!, staticLink,
              mapLinks: mapLinks));
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      if (event is LoadWaypointsEvent) {
        List<LatLng> fromLocations = [];
        List<LatLng> toLocations = [];

        List<PassengerTrip> passengerTrips = await PassengerTripService()
            .getAllPassengerTripsForTripId(event.trip.id);
        List<TaskTrip> taskTrips =
            await TaskTripService().getAllTaskTripsForTripId(event.trip.id);

        for (var item in passengerTrips) {
          fromLocations.add(LatLng(
              item.startLocation.latitude, item.startLocation.longitude));
          toLocations.add(
              LatLng(item.endLocation.latitude, item.endLocation.longitude));
        }
        for (var item in taskTrips) {
          fromLocations.add(LatLng(
              item.startLocation.latitude, item.startLocation.longitude));
          toLocations.add(
              LatLng(item.endLocation.latitude, item.endLocation.longitude));
        }

        List<LatLng> route =
            await MapService().getMultiStopRoute(fromLocations, toLocations);

        String mapStaticLink = MapService().generateMapUrlWithRoute(route);

        emit(MapMultiStopRouteLoaded(
            route, mapStaticLink, fromLocations, toLocations));
      }

      if (event is ClearMapEvent) {
        mapLinks.clear();
        emit(MapInitial());
      }
    });
  }
}
