import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/services/passenger_trip_service.dart';
import 'package:travel_app/data/services/task_trip_service.dart';

class TripsRepository {
  TripsRepository._instantiate();
  static final TripsRepository instance = TripsRepository._instantiate();

  Future<List<TaskTrip>> getTaskTrips(String tripId) async {
    List<TaskTrip>? tasks =
        await TaskTripService().getAllTaskTripsForTripId(tripId);
    return tasks!;
  }

  Future<List<PassengerTrip>> getPassengerTrips(String tripId) async {
    List<PassengerTrip>? passengerTrips =
        await PassengerTripService().getAllPassengerTripsForTripId(tripId);
    return passengerTrips!;
  }
}
