import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../enums/trip_status.dart';
import '../models/location.dart';
import '../models/trip.dart';

class TripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();
  Future<String?> createTrip(
      {required String startCity,
      required String endCity,
      required DateTime startTime,
      required Location startLocation,
      required int maxCapacity,
      required String driverId}) async {
    try {
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
    } catch (e) {
      return null;
    }
  }

  Future<Trip?> findTripById(String tripId) async {
    try {
      DocumentSnapshot tripDoc =
          await _firestore.collection('trips').doc(tripId).get();
      if (!tripDoc.exists) {
        return null;
      }
      return Trip.fromJson(tripDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
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
      Map<String, dynamic>? driverData =
          await userService.getUserById(driverId);

      if (driverData == null) {
        return null;
      }
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
      return trip.passengerTrips
          .map((passengerTrip) => passengerTrip.user)
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
      return trip.taskTrips.map((passengerTrip) => passengerTrip.user).toList();
    }
    throw Exception("You do not have permission to view task users by trip.");
  }

  Future<bool> setTripStatus(String tripId, TripStatus newStatus) async {
    try {
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
    } catch (e) {
      print(e);
      return false;
    }
  }
}
