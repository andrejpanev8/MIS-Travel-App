import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/data/services/passenger_trip_service.dart';
import 'package:travel_app/data/services/task_trip_service.dart';
import 'package:travel_app/data/services/trip_service.dart';
import 'package:travel_app/data/services/user_service.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/trip.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<Trip>? _cachedDriverTrips;
  List<TaskTripDTO>? _cachedDriverDeliveries;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is GetDriverUpcomingRides) {
        if (!event.forceRefresh && _cachedDriverTrips != null) {
          emit(DriverUpcomingTripsLoaded(_cachedDriverTrips!));
          return;
        }

        List<Trip> driverTrips = [];
        emit(ProcessStarted());
        driverTrips = await TripService().getAllUpcomingTrips();
        emit(DriverUpcomingTripsLoaded(driverTrips));
      }

      if (event is GetDriverUpcomingDeliveries) {
        if (!event.forceRefresh && _cachedDriverDeliveries != null) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }

        List<TaskTripDTO> driverDeliveries = [];
        emit(ProcessStarted());
        driverDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();
        emit(DriverUpcomingDeliveriesLoaded(driverDeliveries));
      }

      if (event is LoadDriverData) {
        if (!event.forceRefresh &&
            _cachedDriverDeliveries != null &&
            _cachedDriverTrips != null) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }
        UserModel? currentUser = await AuthService().getCurrentUser();
        List<Trip> driverTrips = [];
        List<TaskTripDTO> driverDeliveries = [];
        emit(ProcessStarted());
        driverTrips = await TripService().getTripsByDriver(currentUser!.id);
        driverDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();
        emit(DriverDataLoaded(driverTrips, driverDeliveries));
      }

      if (event is GetTripDetails) {
        UserModel? user;
        List<TaskTrip>? taskTrips;
        List<PassengerTrip>? passengerTrips;
        emit(ProcessStarted());
        // user = await DriverRepository.instance.getDriverWithId(event.driverId);
        user = await UserService().getUserById(event.driverId);
        taskTrips =
            await TaskTripService().getAllTaskTripsForTripId(event.tripId);
        passengerTrips = await PassengerTripService()
            .getAllPassengerTripsForTripId(event.tripId);

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
