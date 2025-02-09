import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/enums/trip_status.dart';

import '../models/trip.dart';

final List<Trip> mockTrips = [
  Trip(
    id: '1',
    startCity: 'Skopje',
    endCity: 'Ohridovo ezero',
    startTime: DateTime(2025, 1, 1, 8, 30),
    startLocation: Location(latitude: 41.9981, longitude: 21.4254),
    maxCapacity: 4,
    driverId: '2',
    passengerTrips: [
     '1','2'
    ],
    taskTrips: [],
    tripStatus: TripStatus.FINISHED,
  ),
  Trip(
    id: '2',
    startCity: 'Tetovo',
    endCity: 'Bitola',
    startTime: DateTime(2025, 6, 15, 10, 0),
    startLocation: Location(latitude: 42.0000, longitude: 21.4350),
    maxCapacity: 5,
    driverId: '2',
    passengerTrips: [],
    taskTrips: [
      '1','2'
    ],
    tripStatus: TripStatus.IN_PROGRESS,
  ),
];
