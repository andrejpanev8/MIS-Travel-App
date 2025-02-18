import 'package:travel_app/data/models/location.dart';

import '../enums/trip_status.dart';

class Trip {
  final String id;
  final String startCity;
  final String endCity;
  final DateTime startTime;
  final Location startLocation;
  final int maxCapacity;
  final String driverId;
  List<String> passengerTrips;
  List<String> taskTrips;
  TripStatus tripStatus;

  Trip(
      {this.id = "",
      required this.startCity,
      required this.endCity,
      required this.startTime,
      required this.startLocation,
      required this.maxCapacity,
      required this.driverId,
      List<String>? passengerTrips,
      List<String>? taskTrips,
      this.tripStatus = TripStatus.IN_PROGRESS})
      : passengerTrips = passengerTrips ?? [],
        taskTrips = taskTrips ?? [];

  Trip.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        startCity = data['startCity'],
        endCity = data['endCity'],
        startTime = DateTime.parse(data['startTime']),
        startLocation = Location.fromJson(data['startLocation']),
        maxCapacity = data['maxCapacity'],
        driverId = data['driverId'],
        passengerTrips = List<String>.from(data['passengerTrips'] ?? []),
        taskTrips = List<String>.from(data['taskTrips'] ?? []),
        tripStatus = TripStatus.values[data['tripStatus'] ?? 0];

  Map<String, dynamic> toJson() => {
        'id': id,
        'startCity': startCity,
        'endCity': endCity,
        'startTime': startTime.toIso8601String(),
        'startLocation': startLocation.toJson(),
        'maxCapacity': maxCapacity,
        'driverId': driverId,
        'passengerTrips': passengerTrips,
        'taskTrips': taskTrips,
        'tripStatus': tripStatus.index
      };

  int currentCapacity() {
    return maxCapacity - passengerTrips.length;
  }

  bool isSeatAvailable() {
    return maxCapacity > passengerTrips.length;
  }
}
