import 'package:intl/intl.dart';
import 'package:travel_app/data/models/location.dart';

import '../../service/filter_service.dart';
import '../enums/trip_status.dart';

class Trip implements HasFilterProperties {
  final String id;
  @override
  final String startCity;
  @override
  final String endCity;
  @override
  final DateTime startTime;
  final Location startLocation;
  final int ridePrice;
  final int deliveryPrice;
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
      required this.ridePrice,
      required this.deliveryPrice,
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
        ridePrice = data['ridePrice'],
        deliveryPrice = data['deliveryPrice'],
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
        'ridePrice': ridePrice,
        'deliveryPrice': deliveryPrice,
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

  String get formattedStartDateTime {
    final DateFormat formatter = DateFormat('yyyy.MM.dd - HH:mm');
    return formatter.format(startTime);
  }

  @override
  String toString() {
    return "$startCity - $endCity - $formattedStartDateTime";
  }
}
