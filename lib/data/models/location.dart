import 'package:latlong2/latlong.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  Location.fromJson(Map<String, dynamic> data)
      : latitude = data['latitude'],
        longitude = data['longitude'];

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};

  Location.fromLatLng(LatLng loc)
      : latitude = loc.latitude,
        longitude = loc.longitude;

  LatLng get toLatLng {
    return LatLng(latitude, longitude);
  }
}
