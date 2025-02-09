import 'package:travel_app/data/enums/trip_status_for_client.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
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
      PassengerTrip(
        user: UserModel(
          id: '2',
          firstName: 'Alice',
          lastName: 'Smith',
          phoneNumber: '+1987654321',
          email: 'alice.smith@example.com',
          role: UserRole.CLIENT,
        ),
        startLocation: Location(latitude: 41.9968, longitude: 21.4654),
        endLocation: Location(latitude: 41.6086, longitude: 21.7453),
        tripStatus: ClientTripStatus.FINISHED,
      ),
      PassengerTrip(
        user: UserModel(
          id: '3',
          firstName: 'Bob',
          lastName: 'Johnson',
          phoneNumber: '+1122334455',
          email: 'bob.johnson@example.com',
          role: UserRole.CLIENT,
        ),
        startLocation: Location(latitude: 41.7416, longitude: 21.1812),
        endLocation: Location(latitude: 41.6086, longitude: 21.7453),
        tripStatus: ClientTripStatus.FINISHED,
      ),
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
      TaskTrip(
        user: UserModel(
          id: '3',
          firstName: 'Bob',
          lastName: 'Johnson',
          phoneNumber: '+1122334455',
          email: 'bob.johnson@example.com',
          role: UserRole.CLIENT,
        ),
        startLocation: Location(latitude: 42.0100, longitude: 21.4340),
        endLocation: Location(latitude: 41.9833, longitude: 22.1150),
        description: "Letter delivery",
        tripStatus: ClientTripStatus.INPROGRESS,
      )
    ],
    tripStatus: TripStatus.IN_PROGRESS,
  ),
];
