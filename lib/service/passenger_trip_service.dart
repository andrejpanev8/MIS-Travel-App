import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/service/user_service.dart';

import '../data/DTO/PassengerTripDTO.dart';
import '../data/models/location.dart';
import '../data/models/trip.dart';
import 'auth_service.dart';

class PassengerTripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();
  final TripService tripService = TripService();

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
    UserModel? user = await authService.getCurrentUser();
    if (user == null) {
      throw Exception("No authenticated user found.");
    }
    Trip? trip = await tripService.findTripById(tripId);
    if (trip == null) {
      throw Exception("Trip not found");
    }
    if (!trip.isSeatAvailable()) {
      throw Exception("Capacity is full. No more seats available.");
    }

    List<PassengerTripDTO> userTrips = await getUpcomingTripsForUser();
    bool alreadyHasReservation = userTrips
        .map((userTrip) => userTrip.trip.id)
        .contains((t) => t == trip.id);

    if (alreadyHasReservation) {
      throw Exception("You have already reserved a seat for this trip.");
    }

    String tripIdGenerated = _firestore.collection('passenger_trips').doc().id;

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
  }

  Future<List<PassengerTripDTO>> getUpcomingTripsForUser() async {
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      QuerySnapshot passengerTripSnapshot = await _firestore
          .collection('passenger_trips')
          .where('user.id', isEqualTo: currentUser.id)
          .where('tripStatus', isEqualTo: 0)
          .get();

      List<PassengerTripDTO> upcomingTrips = [];

      for (var doc in passengerTripSnapshot.docs) {
        PassengerTrip taskTrip =
            PassengerTrip.fromJson(doc.data() as Map<String, dynamic>);

        DocumentSnapshot tripDoc =
            await _firestore.collection('trips').doc(taskTrip.tripId).get();

        if (tripDoc.exists) {
          Trip trip = Trip.fromJson(tripDoc.data() as Map<String, dynamic>);
          PassengerTripDTO taskTripDTO = PassengerTripDTO.fromJson({
            'passengerTrip': taskTrip.toJson(),
            'trip': trip.toJson(),
          });
          upcomingTrips.add(taskTripDTO);
        }
      }

      return upcomingTrips;
    } catch (e) {
      return [];
    }
  }

  Future<List<PassengerTrip>> getAllPassengerTripsForTripId(
      String tripId) async {
    Trip? trip = await tripService.findTripById(tripId);
    if (trip != null) {
      List<Future<PassengerTrip?>> futureTrips = trip.passengerTrips
          .map((passengerTripId) => findPassengerTripById(passengerTripId))
          .toList();

      List<PassengerTrip?> resolvedTrips = await Future.wait(futureTrips);

      return resolvedTrips.whereType<PassengerTrip>().toList();
    }
    return [];
  }
}
