import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/services/trip_service.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../DTO/TaskTripDTO.dart';
import '../models/location.dart';
import '../models/trip.dart';
import '../models/user.dart';
import 'auth_service.dart';

class TaskTripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();
  final TripService tripService = TripService();

  // void setTripService(TripService service) {
  //   tripService = service;
  // }

  Future<TaskTrip?> findTaskTripById(String tripId) async {
    try {
      DocumentSnapshot tripDoc =
          await _firestore.collection('task_trips').doc(tripId).get();
      if (!tripDoc.exists) {
        return null;
      }
      return TaskTrip.fromJson(tripDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<String?> createTaskTrip(
      {required Location startLocation,
      required Location endLocation,
      required String tripId,
      String description = ""}) async {
    UserModel? user = await authService.getCurrentUser();
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    String taskTripIdGenerated = _firestore.collection('task_trips').doc().id;

    TaskTrip newTrip = TaskTrip(
        id: taskTripIdGenerated,
        startLocation: startLocation,
        endLocation: endLocation,
        user: user,
        description: description,
        tripId: tripId);

    await _firestore
        .collection('task_trips')
        .doc(taskTripIdGenerated)
        .set(newTrip.toJson());

    await _firestore.collection('trips').doc(tripId).update({
      "taskTrips": FieldValue.arrayUnion([taskTripIdGenerated])
    });
    return taskTripIdGenerated;
  }

  Future<List<TaskTripDTO>> getUpcomingDeliveriesForUser() async {
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      QuerySnapshot taskTripsSnapshot = await _firestore
          .collection('task_trips')
          .where('user.id', isEqualTo: currentUser.id)
          .where('tripStatus', isEqualTo: 0)
          .get();

      List<TaskTripDTO> upcomingTrips = [];

      for (var doc in taskTripsSnapshot.docs) {
        TaskTrip taskTrip =
            TaskTrip.fromJson(doc.data() as Map<String, dynamic>);

        DocumentSnapshot tripDoc =
            await _firestore.collection('trips').doc(taskTrip.tripId).get();

        if (tripDoc.exists) {
          Trip trip = Trip.fromJson(tripDoc.data() as Map<String, dynamic>);
          TaskTripDTO taskTripDTO = TaskTripDTO.fromJson({
            'taskTrip': taskTrip.toJson(),
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

  Future<List<TaskTrip>> getAllTaskTripsForTripId(String tripId) async {
    Trip? trip = await tripService.findTripById(tripId);
    if (trip != null) {
      List<Future<TaskTrip?>> futureTrips = trip.taskTrips
          .map((taskTripId) => findTaskTripById(taskTripId))
          .toList();

      List<TaskTrip?> resolvedTrips = await Future.wait(futureTrips);

      return resolvedTrips.whereType<TaskTrip>().toList();
    }
    return [];
  }
}
