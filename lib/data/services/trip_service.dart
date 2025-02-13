import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/data/services/passenger_trip_service.dart';
import 'package:travel_app/data/services/task_trip_service.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../enums/trip_status.dart';
import '../models/location.dart';
import '../models/trip.dart';

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

  Future<String?> createTrip(
      {required String startCity,
      required String endCity,
      required DateTime startTime,
      required Location startLocation,
      required int maxCapacity,
      required String driverId}) async {
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role != UserRole.ADMIN) {
      throw Exception("You do not have permission to create a trip.");
    }

    DocumentReference tripRef = _firestore.collection('trips').doc();

    Trip newTrip = Trip(
      id: tripRef.id,
      startCity: startCity,
      endCity: endCity,
      startTime: startTime,
      startLocation: startLocation,
      maxCapacity: maxCapacity,
      driverId: driverId,
      passengerTrips: [],
      taskTrips: [],
    );

    await tripRef.set(newTrip.toJson());

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
      Map<String, dynamic> tripData = tripDoc.data() as Map<String, dynamic>;

      String driverId = tripData['driverId'];

      UserModel? driverData = await userService.getUserById(driverId);

      if (driverData == null) {
        return null;
      }
      tripData['driver'] = driverData.toJson();

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
    if (currentUser.role == UserRole.ADMIN || currentUser.id == trip.driverId) {
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

  Future<List<Trip>> filterUpcomingTripsContainingStartCity(String startCity) async {
    List<Trip> upcomingTrips = await getAllUpcomingTrips();
    if (upcomingTrips.isEmpty) {
      return [];
    }
    return upcomingTrips
        .where((trip) =>
            trip.startCity.toLowerCase().contains(startCity.toLowerCase()))
        .toList();
  }

  Future<List<Trip>> filterUpcomingTripsContainingEndCity(String endCity) async {
    List<Trip> upcomingTrips = await getAllUpcomingTrips();
    if (upcomingTrips.isEmpty) {
      return [];
    }
    return upcomingTrips
        .where((trip) =>
            trip.endCity.toLowerCase().contains(endCity.toLowerCase()))
        .toList();
  }

  Future<List<Trip>> filterUpcomingTripsByDate(DateTime date) async {
    String selectedDate = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    QuerySnapshot querySnapshot = await _firestore
        .collection('trips')
        .where('tripStatus', isEqualTo: TripStatus.IN_PROGRESS.index)
        .where('startTime', isGreaterThanOrEqualTo: selectedDate)
        .where('startTime', isLessThan: "${selectedDate}T23:59:59.999999")
        .get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    List<Trip> trips = querySnapshot.docs.map((doc) {
      return Trip.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    return trips;
  }

  Future<bool> setTripStatus(String tripId, TripStatus newStatus) async {
    UserModel? currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("No user is logged in");
    }
    if (currentUser.role != UserRole.ADMIN) {
      print(currentUser.role);
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
