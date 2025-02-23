import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapService {
  String generateMapUrl(double lat, double lng) {
    return 'https://static-maps.yandex.ru/1.x/?ll=$lng,$lat&size=600,400&z=14&l=map&pt=$lng,$lat,pm2rdm';
    // return "http://staticmapmaker.com/openstreetmap/?center=$lat,$lng&zoom=14&size=600x400";
  }

  Future<LatLng> openMap(BuildContext context, Route route) async {
    final result = await Navigator.push(
      context,
      route,
    );

    if (result != null && result is LatLng) {
      return result;
    }
    return LatLng(41.99812940, 21.42543550);
  }
}
