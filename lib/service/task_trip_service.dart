import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/service/user_service.dart';

import '../data/DTO/TaskTripDTO.dart';
import '../data/enums/user_role.dart';
import '../data/models/location.dart';
import '../data/models/trip.dart';
import '../data/models/user.dart';
import 'auth_service.dart';

class TaskTripService {
  AuthService authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();
  final TripService tripService = TripService();

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
      {required String pickUpPhoneNumber,
      required Location startLocation,
      required String dropOffPhoneNumber,
      required Location endLocation,
      required String tripId,
      UserModel? user,
      String description = ""}) async {
    user ??= await authService.getCurrentUser();
    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    String taskTripIdGenerated = _firestore.collection('task_trips').doc().id;

    TaskTrip newTrip = TaskTrip(
        id: taskTripIdGenerated,
        pickUpPhoneNumber: pickUpPhoneNumber,
        startLocation: startLocation,
        dropOffPhoneNumber: dropOffPhoneNumber,
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

  Future<String?> createOrUpdateTaskTripWithAdhocUser({
    String? taskTripId,
    required String pickUpPhoneNumber,
    required Location startLocation,
    required String dropOffPhoneNumber,
    required Location endLocation,
    required String tripId,
    String? clientId,
    String? firstName,
    String? lastName,
    String description = "",
  }) async {
    UserModel? adhocUser;

    if (clientId != null) {
      adhocUser = await userService.getUserById(clientId);
    } else {
      adhocUser = UserModel(
        firstName: firstName!,
        lastName: lastName!,
        phoneNumber: "",
        email: "",
        role: UserRole.CLIENT,
      );
    }

    String finalTaskTripId = taskTripId ?? _firestore.collection('task_trips').doc().id;
    DocumentReference taskTripRef = _firestore.collection('task_trips').doc(finalTaskTripId);

    TaskTrip newTrip = TaskTrip(
      id: finalTaskTripId,
      pickUpPhoneNumber: pickUpPhoneNumber,
      startLocation: startLocation,
      dropOffPhoneNumber: dropOffPhoneNumber,
      endLocation: endLocation,
      user: adhocUser!,
      description: description,
      tripId: tripId,
    );

    await taskTripRef.set(newTrip.toJson(), SetOptions(merge: true));

    if (taskTripId == null) {
      await _firestore.collection('trips').doc(tripId).update({
        "taskTrips": FieldValue.arrayUnion([finalTaskTripId])
      });
    }

    return finalTaskTripId;
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

  Future<List<TaskTripDTO>> getAllUpcomingDeliveriesForDriver() async {
    try {
      final driver = await authService.getCurrentUser();
      if (driver == null) {
        throw Exception("User is not authenticated.");
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('trips')
          .where('driverId', isEqualTo: driver.id)
          .get();

      List<Trip> trips = querySnapshot.docs.map((doc) {
        return Trip.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      List<String> tripIds = trips.map((trip) => trip.id).toList();

      List<TaskTrip> taskTrips = await getAllTaskTripsForTripIds(tripIds);

      Map<String, Trip> tripMap = {for (var trip in trips) trip.id: trip};

      List<TaskTripDTO> taskTripDTOs = taskTrips
          .map((taskTrip) => TaskTripDTO(
                trip: tripMap[taskTrip.tripId]!,
                taskTrip: taskTrip,
              ))
          .toList();

      return taskTripDTOs;
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskTripDTO>> getAllUpcomingDeliveries() async {
    try {
      final currentUser = await authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      QuerySnapshot taskTripsSnapshot = await _firestore
          .collection('task_trips')
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

  Future<List<TaskTrip>> getAllTaskTripsForTripIds(List<String> tripIds) async {
    if (tripIds.isEmpty) return [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('task_trips')
          .where('tripId', whereIn: tripIds)
          .get();

      List<TaskTrip> taskTrips = querySnapshot.docs
          .map((doc) => TaskTrip.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return taskTrips;
    } catch (e) {
      return [];
    }
  }
}
