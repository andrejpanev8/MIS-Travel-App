class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  Location.fromJson(Map<String, dynamic> data)
      : latitude = data['latitude'],
        longitude = data['longitude'];

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}
