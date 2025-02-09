import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';

import '../enums/trip_status.dart';

class Trip {
  final String id;
  final String startCity;
  final String endCity;
  final DateTime startTime;
  final Location startLocation;
  final int maxCapacity;
  final String driverId;
  List<PassengerTrip> passengerTrips;
  List<TaskTrip> taskTrips;
  TripStatus tripStatus;

  Trip({
    this.id = "",
    required this.startCity,
    required this.endCity,
    required this.startTime,
    required this.startLocation,
    required this.maxCapacity,
    required this.driverId,
    List<PassengerTrip>? passengerTrips,
    List<TaskTrip>? taskTrips,
    this.tripStatus = TripStatus.IN_PROGRESS
  })  : passengerTrips = passengerTrips ?? [],
        taskTrips = taskTrips ?? [];

  Trip.fromJson(Map<String, dynamic> data)
      :
        id = data['id'],
        startCity = data['startCity'],
        endCity = data['endCity'],
        startTime = DateTime.parse(data['startTime']),
        startLocation = Location.fromJson(data['startLocation']),
        maxCapacity = data['maxCapacity'],
        driverId = data['driverId'],
        passengerTrips = (data['passengerTrips'] as List)
            .map((e) => PassengerTrip.fromJson(e))
            .toList(),
        taskTrips = (data['taskTrips'] as List)
            .map((e) => TaskTrip.fromJson(e))
            .toList(),
        tripStatus = TripStatus.values[data['tripStatus'] ?? 0];

  Map<String, dynamic> toJson() => {
        'id': id,
        'startCity': startCity,
        'endCity': endCity,
        'startTime': startTime.toIso8601String(),
        'startLocation': startLocation.toJson(),
        'maxCapacity': maxCapacity,
        'driverId': driverId,
        'passengerTrips': passengerTrips.map((e) => e.toJson()).toList(),
        'taskTrips': taskTrips.map((e) => e.toJson()).toList(),
        'tripStatus': tripStatus.index
      };

  bool containsUser(String id) {
    return passengerTrips.any((trip) => trip.user.id == id);
  }
  int currentCapacity() {
    return maxCapacity - passengerTrips.length;
  }
  bool isSeatAvailable() {
    return maxCapacity > passengerTrips.length;
  }
}
