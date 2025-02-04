import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';

import '../enums/trip_status.dart';

class Trip {
  String startCity;
  String endCity;
  DateTime startTime;
  Location startLocation;
  int maxCapacity;
  User driver;
  List<PassengerTrip> passengerTrips;
  List<TaskTrip> taskTrips;
  TripStatus tripStatus;

  Trip({
    required this.startCity,
    required this.endCity,
    required this.startTime,
    required this.startLocation,
    required this.maxCapacity,
    required this.driver,
    List<PassengerTrip>? passengerTrips,
    List<TaskTrip>? taskTrips,
    required this.tripStatus,
  })  : passengerTrips = passengerTrips ?? [],
        taskTrips = taskTrips ?? [];

  Trip.fromJson(Map<String, dynamic> data)
      : startCity = data['startCity'],
        endCity = data['endCity'],
        startTime = DateTime.parse(data['startTime']),
        startLocation = Location.fromJson(data['startLocation']),
        maxCapacity = data['maxCapacity'],
        driver = User.fromJson(data['driver']),
        passengerTrips = (data['passengerTrips'] as List)
            .map((e) => PassengerTrip.fromJson(e))
            .toList(),
        taskTrips = (data['taskTrips'] as List)
            .map((e) => TaskTrip.fromJson(e))
            .toList(),
        tripStatus = TripStatus.values.firstWhere(
          (e) => e.toString().split('.').last == data['tripStatus'],
          orElse: () => TripStatus.CANCELED,
        );

  Map<String, dynamic> toJson() => {
        'startCity': startCity,
        'endCity': endCity,
        'startTime': startTime.toIso8601String(),
        'startLocation': startLocation.toJson(),
        'maxCapacity': maxCapacity,
        'driver': driver.toJson(),
        'passengerTrips': passengerTrips.map((e) => e.toJson()).toList(),
        'taskTrips': taskTrips.map((e) => e.toJson()).toList(),
        'tripStatus': tripStatus.toString().split('.').last,
      };

  bool containsUser(int id) {
    return passengerTrips.any((trip) => trip.user.id == id);
  }
  int currentCapacity() {
    return maxCapacity - passengerTrips.length;
  }
  bool isSeatAvailable() {
    return maxCapacity > passengerTrips.length;
  }
}
