import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../models/location.dart';
import '../models/trip.dart';
import 'auth_service.dart';

class PassengerTripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();

  Future<PassengerTrip?> findPassengerTripById(String tripId) async {
    try {
      DocumentSnapshot tripDoc =
          await _firestore.collection('passenger_trips').doc(tripId).get();
      if (!tripDoc.exists) {
        return null;
      }
      return PassengerTrip.fromJson(tripDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<String?> createPassengerTrip({
    required Location startLocation,
    required Location endLocation,
    required String tripId,
  }) async {
    try {
      UserModel? user = await authService.getCurrentUser();
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      String tripIdGenerated =
          _firestore.collection('passenger_trips').doc().id;

      PassengerTrip newTrip = PassengerTrip(
          id: tripIdGenerated,
          startLocation: startLocation,
          endLocation: endLocation,
          user: user,
          tripId: tripId);

      await _firestore
          .collection('passenger_trips')
          .doc(tripIdGenerated)
          .set(newTrip.toJson());

      await _firestore.collection('trips').doc(tripId).update({
        "passengerTrips": FieldValue.arrayUnion([tripIdGenerated])
      });
      return tripIdGenerated;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingTripsForUser() async {
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      QuerySnapshot passengerTripsSnapshot = await _firestore
          .collection('passenger_trips')
          .where('user.id', isEqualTo: currentUser.id)
          .where('tripStatus', isEqualTo: 0)
          .get();

      List<Map<String, dynamic>> upcomingTrips = [];

      for (var doc in passengerTripsSnapshot.docs) {
        PassengerTrip passengerTrip =
            PassengerTrip.fromJson(doc.data() as Map<String, dynamic>);

        DocumentSnapshot tripDoc = await _firestore
            .collection('trips')
            .doc(passengerTrip.tripId)
            .get();

        if (tripDoc.exists) {
          Trip trip = Trip.fromJson(tripDoc.data() as Map<String, dynamic>);
          upcomingTrips.add({
            'passengerTrip': passengerTrip,
            'trip': trip,
          });
        }
      }

      return upcomingTrips;
    } catch (e) {
      return [];
    }
  }
}
