import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/repositories/driver_repository.dart';

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
    });
  }
}
