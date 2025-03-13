import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/service/auth_service.dart';
import 'package:travel_app/service/passenger_trip_service.dart';
import 'package:travel_app/service/task_trip_service.dart';
import 'package:travel_app/service/user_service.dart';

import '../data/enums/trip_status.dart';
import '../data/models/trip.dart';

class TripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();
  late final PassengerTripService passengerTripService;
  late final TaskTripService taskTripService;

  void setPassengerTripService(PassengerTripService service) {
    passengerTripService = service;
  }

  void setTaskTripService(TaskTripService service) {
    taskTripService = service;
  }

  Future<String?> createTrip({required Trip trip}) async {
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role != UserRole.ADMIN) {
      throw Exception("You do not have permission to create a trip.");
    }

    DocumentReference tripRef = _firestore.collection('trips').doc();

    trip.id = tripRef.id;
    trip.passengerTrips = [];
    trip.taskTrips = [];

    await tripRef.set(trip.toJson());

    return tripRef.id;
  }

  Future<Trip?> findTripById(String tripId) async {
    DocumentSnapshot tripDoc =
        await _firestore.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) {
      throw Exception("Trip not found.");
    }
    return Trip.fromJson(tripDoc.data() as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>?> findTripByIdWithDriver(String tripId) async {
    try {
      DocumentSnapshot tripDoc =
          await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists) {
        return null;
      }
      Map<String, dynamic> tripData = {};

      Trip foundTrip = Trip.fromJson(tripDoc.data() as Map<String, dynamic>);

      UserModel? driverData = await userService.getUserById(foundTrip.driverId);

      if (driverData == null) {
        return null;
      }

      tripData["trip"] = foundTrip;
      tripData['driver'] = driverData;

      return tripData;
    } catch (e) {
      return null;
    }
  }

  Future<List<Trip>> getTripsByDriver(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('trips')
          .where('driverId', isEqualTo: driverId)
          .get();

      List<Trip> trips = querySnapshot.docs.map((doc) {
        return Trip.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return trips;
    } catch (e) {
      return [];
    }
  }

  Future<List<Trip>> getAllUpcomingTrips() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('trips')
        .where('tripStatus', isEqualTo: TripStatus.IN_PROGRESS.index)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Trip> upcomingTrips = querySnapshot.docs.map((doc) {
      return Trip.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return upcomingTrips;
  }

  Future<List<Trip>> getUpcomingTripsByDriver(String driverId) async {
    List<Trip> trips = await getTripsByDriver(driverId);
    if (trips.isEmpty) {
      return [];
    }
    return trips
        .where((trip) => trip.tripStatus == TripStatus.IN_PROGRESS)
        .toList();
  }

  Future<List<UserModel>> getPassengerUsersByTrip(String id) async {
    Trip? trip = await findTripById(id);
    if (trip == null) {
      return [];
    }
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role == UserRole.ADMIN ||
        currentUser.id == trip.driverId ||
        currentUser.role == UserRole.CLIENT) {
      List<PassengerTrip?> passengerTrips = await Future.wait(
        trip.passengerTrips.map((passengerTripId) =>
            passengerTripService.findPassengerTripById(passengerTripId)),
      );
      List<PassengerTrip> validPassengerTrips =
          passengerTrips.whereType<PassengerTrip>().toList();
      if (validPassengerTrips.isEmpty) {
        return [];
      }
      return validPassengerTrips
          .map((trip) => trip.user)
          .whereType<UserModel>()
          .toList();
    }
    throw Exception(
        "You do not have permission to view passenger users by trip.");
  }

  Future<List<UserModel>> getTaskUsersByTrip(String id) async {
    Trip? trip = await findTripById(id);
    if (trip == null) {
      return [];
    }
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role == UserRole.ADMIN || currentUser.id == trip.driverId) {
      List<TaskTrip?> taskTrips = await Future.wait(
        trip.taskTrips
            .map((taskTripId) => taskTripService.findTaskTripById(taskTripId)),
      );
      List<TaskTrip> validTaskTrips = taskTrips.whereType<TaskTrip>().toList();
      if (validTaskTrips.isEmpty) {
        return [];
      }
      return validTaskTrips
          .map((trip) => trip.user)
          .whereType<UserModel>()
          .toList();
    }
    throw Exception("You do not have permission to view task users by trip.");
  }

  Future<bool> setTripStatus(String tripId, TripStatus newStatus) async {
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role != UserRole.ADMIN) {
      throw Exception(
          "You do not have permission to change the status of the trip.");
    }

    Trip? trip = await findTripById(tripId);
    if (trip == null) {
      return false;
    }
    DocumentReference tripRef = _firestore.collection('trips').doc(tripId);
    await tripRef.update({'tripStatus': newStatus.index});
    return true;
  }
}
