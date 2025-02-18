import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/location.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/enums/trip_status_for_client.dart';

final List<TaskTrip> mockTaskTrips = [
  TaskTrip(
      id: "uXBQuOLYrGAW2V6tDiVo",
      startLocation: Location(latitude: 41.9981, longitude: 21.4254),
      endLocation: Location(latitude: 41.6086, longitude: 21.7453),
      description: 'Pick up the package from Skopje and deliver to Ohrid',
      user: UserModel(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        phoneNumber: '+1234567890',
        email: 'john.doe@example.com',
        role: UserRole.CLIENT,
      ),
      tripStatus: ClientTripStatus.INPROGRESS,
      tripId: '1'),
  TaskTrip(
      id: '2',
      startLocation: Location(latitude: 42.0000, longitude: 21.4350),
      endLocation: Location(latitude: 41.9833, longitude: 22.1150),
      description: 'Deliver documents from Tetovo to Bitola',
      user: UserModel(
        id: '2',
        firstName: 'Alice',
        lastName: 'Smith',
        phoneNumber: '+1987654321',
        email: 'alice.smith@example.com',
        role: UserRole.CLIENT,
      ),
      tripStatus: ClientTripStatus.RESERVED,
      tripId: '2'),
  TaskTrip(
      id: '3',
      startLocation: Location(latitude: 41.9981, longitude: 21.4254),
      endLocation: Location(latitude: 42.0000, longitude: 21.4350),
      description: 'Transport food supplies from Skopje to Tetovo',
      user: UserModel(
        id: '3',
        firstName: 'Bob',
        lastName: 'Johnson',
        phoneNumber: '+1122334455',
        email: 'bob.johnson@example.com',
        role: UserRole.CLIENT,
      ),
      tripStatus: ClientTripStatus.FINISHED,
      tripId: '2'),
  TaskTrip(
      id: '4',
      startLocation: Location(latitude: 41.6086, longitude: 21.7453),
      endLocation: Location(latitude: 42.0010, longitude: 21.4480),
      description: 'Package for urgent delivery to Struga',
      user: UserModel(
        id: '4',
        firstName: 'Ethan',
        lastName: 'Williams',
        phoneNumber: '+1444555666',
        email: 'ethan.williams@example.com',
        role: UserRole.CLIENT,
      ),
      tripStatus: ClientTripStatus.CANCELED,
      tripId: '1'),
];
