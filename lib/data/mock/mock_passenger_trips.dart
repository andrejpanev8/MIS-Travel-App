import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/enums/trip_status_for_client.dart';

final List<PassengerTrip> mockPassengerTrips = [
  PassengerTrip(
    id: '1',
    startLocation: Location(latitude: 41.9981, longitude: 21.4254),
    endLocation: Location(latitude: 41.6086, longitude: 21.7453),
    tripStatus: ClientTripStatus.INPROGRESS,
    user: UserModel(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
      email: 'john.doe@example.com',
      role: UserRole.CLIENT,
    ),
  ),
  PassengerTrip(
    id: '2',
    startLocation: Location(latitude: 42.0000, longitude: 21.4350),
    endLocation: Location(latitude: 41.9833, longitude: 22.1150),
    tripStatus: ClientTripStatus.RESERVED,
    user: UserModel(
      id: '2',
      firstName: 'Alice',
      lastName: 'Smith',
      phoneNumber: '+1987654321',
      email: 'alice.smith@example.com',
      role: UserRole.CLIENT,
    ),
  ),
  PassengerTrip(
    id: '3',
    startLocation: Location(latitude: 41.7416, longitude: 21.1812),
    endLocation: Location(latitude: 41.6086, longitude: 21.7453),
    tripStatus: ClientTripStatus.FINISHED,
    user: UserModel(
      id: '3',
      firstName: 'Bob',
      lastName: 'Johnson',
      phoneNumber: '+1122334455',
      email: 'bob.johnson@example.com',
      role: UserRole.CLIENT,
    ),
  ),
  PassengerTrip(
    id: '4',
    startLocation: Location(latitude: 41.9981, longitude: 21.4254),
    endLocation: Location(latitude: 41.7450, longitude: 22.0161),
    tripStatus: ClientTripStatus.CANCELED,
    user: UserModel(
      id: '4',
      firstName: 'Ethan',
      lastName: 'Williams',
      phoneNumber: '+1444555666',
      email: 'ethan.williams@example.com',
      role: UserRole.CLIENT,
    ),
  ),
];
