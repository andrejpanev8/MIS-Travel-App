import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/repositories/driver_repository.dart';
import 'package:travel_app/data/repositories/trips_repository.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../../data/models/trip.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<Trip>? _cachedDriverTrips;
  List<TaskTrip>? _cachedDriverDeliveries;
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is GetDriverUpcomingRides) {
        if (!event.forceRefresh && _cachedDriverTrips != null) {
          emit(DriverUpcomingTripsLoaded(_cachedDriverTrips!));
          return;
        }

        List<Trip> driverTrips = [];
        emit(ProcessStarted());
        driverTrips = await DriverRepository.instance.getDriverTrips();
        emit(DriverUpcomingTripsLoaded(driverTrips));
      }

      if (event is GetDriverUpcomingDeliveries) {
        if (!event.forceRefresh && _cachedDriverDeliveries != null) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }

        List<TaskTrip> driverDeliveries = [];
        emit(ProcessStarted());
        driverDeliveries =
            await DriverRepository.instance.getDriverDeliveries();
        emit(DriverUpcomingDeliveriesLoaded(driverDeliveries));
      }

      if (event is LoadDriverData) {
        if (!event.forceRefresh &&
            _cachedDriverDeliveries != null &&
            _cachedDriverTrips != null) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }
        List<Trip> driverTrips = [];
        List<TaskTrip> driverDeliveries = [];
        emit(ProcessStarted());
        driverTrips = await DriverRepository.instance.getDriverTrips();
        driverDeliveries =
            await DriverRepository.instance.getDriverDeliveries();
        emit(DriverDataLoaded(driverTrips, driverDeliveries));
      }

      if (event is GetTripDetails) {
        UserModel user;
        List<TaskTrip> taskTrips;
        List<PassengerTrip> passengerTrips;
        emit(ProcessStarted());
        user = await DriverRepository.instance.getDriverWithId(event.driverId);
        taskTrips = await TripsRepository.instance.getTaskTrips(event.tripId);
        passengerTrips =
            await TripsRepository.instance.getPassengerTrips(event.tripId);

        emit(TripDetailsLoaded(user, passengerTrips, taskTrips));
      }

      if (event is UpdateUserInfo) {
        emit(ProcessStarted());
        try {
          await UserService().updateUserInfo(
              event.firstName, event.lastName, event.mobilePhone);
          emit(UserInitial());
        } catch (e) {
          //TO:DO notify user of error
        }
      }
    });
  }
}
