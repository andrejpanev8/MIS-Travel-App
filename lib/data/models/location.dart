import 'package:latlong2/latlong.dart';

class Location {
  final double latitude;
  final double longitude;
  String? address;

  Location({required this.latitude, required this.longitude, this.address});

  Location.fromJson(Map<String, dynamic> data)
      : latitude = data['latitude'],
        longitude = data['longitude'],
        address = (data['address'] ?? "");

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude, 'address': address ?? ""};

  Location.fromLatLng(LatLng loc)
      : latitude = loc.latitude,
        longitude = loc.longitude;

  LatLng get toLatLng {
    return LatLng(latitude, longitude);
  }
}
