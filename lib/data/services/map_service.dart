import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapService {
  String generateMapUrl(double lat, double lng) {
    return 'https://static-maps.yandex.ru/1.x/?ll=$lng,$lat&size=600,400&z=14&l=map&pt=$lng,$lat,pm2rdm';
  }

  Future<LatLng?> openMap(BuildContext context, Route route) async {
    final result = await Navigator.push(
      context,
      route,
    );

    if (result != null && result is LatLng) {
      return result;
    }
    return null;
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
}
