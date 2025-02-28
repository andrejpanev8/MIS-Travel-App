import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/bloc/map_bloc/map_bloc.dart';
import 'package:travel_app/utils/keys.dart';

import '../utils/functions.dart';

class MapService {
  String generateMapUrl(double lat, double lng) {
    return 'https://static-maps.yandex.ru/1.x/?ll=$lng,$lat&size=600,400&z=14&l=map&pt=$lng,$lat,pm2rdm';
  }

  String generateMapUrlWithRoute(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return '';

    double minLat =
        routePoints.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat =
        routePoints.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng =
        routePoints.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng =
        routePoints.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    String polyline =
        routePoints.map((p) => '${p.longitude},${p.latitude}').join(',');

    return 'https://static-maps.yandex.ru/1.x/?size=600,400&l=map'
        '&bbox=$minLng,$minLat~$maxLng,$maxLat' // Auto-fit the zoom level
        '&pt=${routePoints.first.longitude},${routePoints.first.latitude},pm2rdm~'
        '${routePoints.last.longitude},${routePoints.last.latitude},pm2rdm'
        '&pl=c:0000FF,w:5,$polyline';
  }

  Future<LatLng?> openMap(
      BuildContext context, Route route, String uniqueKey) async {
    final result = await Navigator.push(
      context,
      route,
    );

    if (result != null) {
      if (result is LatLng) {
        Functions.emitMapEvent(
            context: context,
            event: MapSelectionEvent(
                selectedLocation: result, uniqueKey: uniqueKey));
      }
      if (result is Map<String, dynamic>) {
        Functions.emitMapEvent(
            context: context,
            event: MapDoubleSelectionEvent(
                fromSelectedLocation: result["from"] as LatLng,
                toSelectedLocation: result["to"] as LatLng));
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCoordinatesFromAddress(
      String address) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$address');

    final response = await http.get(url, headers: {
      'User-Agent': 'QuickRide/1.0 (pigirod652@jarars.com)',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        return {
          "latitude": double.parse(data[0]['lat']),
          "longitude": double.parse(data[0]['lon']),
        };
      }
    }
    return null;
  }

  Future<String?> getAddressFromCoordinates(double lat, double lon) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');

    final response = await http.get(url, headers: {
      'User-Agent': 'QuickRide/1.0 (pigirod652@jarars.com)',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'];
    }
    return null;
  }

  Future<List<LatLng>> getRoute(LatLng from, LatLng to) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsKey&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> coordinates =
          data['features'][0]['geometry']['coordinates'];

      return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
    }
    return [];
  }
}
