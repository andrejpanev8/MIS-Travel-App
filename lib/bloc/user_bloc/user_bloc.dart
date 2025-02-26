import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/auth_service.dart';
import 'package:travel_app/data/services/invitation_service.dart';
import 'package:travel_app/data/services/passenger_trip_service.dart';
import 'package:travel_app/data/services/task_trip_service.dart';
import 'package:travel_app/data/services/trip_service.dart';
import 'package:travel_app/data/services/user_service.dart';
import 'package:travel_app/utils/validation_utils.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/invitation.dart';
import '../../data/models/trip.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<Trip>? _cachedDriverTrips;
  List<TaskTripDTO>? _cachedDriverDeliveries;
  List<UserModel>? _cachedDrivers;
  List<Invitation>? _cachedInvitations;

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

      if (event is GetAllDrivers) {
        if (!event.forceRefresh && _cachedDrivers != null) {
          emit(AllDriversLoaded(_cachedDrivers!));
          return;
        }
        List<UserModel> drivers = [];
        emit(ProcessStarted());
        drivers = await UserService().getAllUsersByRole(userRole: UserRole.DRIVER);
        emit(AllDriversLoaded(drivers));
      }

      if (event is GetAllInvitations) {
        if (!event.forceRefresh && _cachedInvitations != null) {
          emit(AllInvitationsLoaded(_cachedInvitations!));
          return;
        }
        List<Invitation> invitations = [];
        emit(ProcessStarted());
        invitations = await InvitationService().getAllInvitations();
        emit(AllInvitationsLoaded(invitations));
      }

      if (event is LoadAllDriversData) {
        emit(ProcessStarted());
        if (!event.forceRefresh &&
            _cachedDrivers != null &&
            _cachedInvitations != null) {
          emit(AllDriversLoaded(_cachedDrivers!));
          emit(AllInvitationsLoaded(_cachedInvitations!));
          return;
        }
        List<UserModel> drivers = [];
        List<Invitation> invitations = [];
        emit(ProcessStarted());
        drivers = await UserService().getAllUsersByRole(userRole: UserRole.DRIVER);
        invitations =
        await InvitationService().getAllInvitations();
        emit(AdminDataLoaded(drivers, invitations));
      }

      if (event is GetTripDetails) {
        UserModel? user;
        List<TaskTrip>? taskTrips;
        List<PassengerTrip>? passengerTrips;
        emit(ProcessStarted());
        user = await UserService().getUserById(event.driverId);
        taskTrips =
        await TaskTripService().getAllTaskTripsForTripId(event.tripId);
        passengerTrips = await PassengerTripService()
            .getAllPassengerTripsForTripId(event.tripId);

        emit(TripDetailsLoaded(user, passengerTrips, taskTrips));
      }

      if (event is UpdateUserInfo) {
        emit(ProcessStarted());

        Map<String, String> errors = {};

        String? nameError = ValidationUtils.nameValidator(event.firstName);
        if (nameError != null) errors["name"] = nameError;

        String? surnameError = ValidationUtils.surnameValidator(event.lastName);
        if (surnameError != null) errors["surname"] = surnameError;

        String? phoneError = ValidationUtils.phoneValidator(event.mobilePhone);
        if (phoneError != null) errors["phoneNumber"] = phoneError;

        if (errors.isNotEmpty) {
          emit(UserValidationFailed(errors));
          return;
        }
        try {
          await UserService().updateUserInfo(
              event.userId, event.firstName, event.lastName, event.mobilePhone);
          emit(UserUpdateSuccess());
        } catch (e) {
          emit(UserUpdateFailure("Failed to update user."));
        }
      }

      if (event is LoadDrivers) {
        emit(ProcessStarted());
        try {
          List<UserModel> drivers =
          await UserService().getAllUsersByRole(userRole: UserRole.DRIVER);
          emit(DriversLoaded(drivers));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if(event is CheckEmailExists) {
        bool exists = await UserService().checkUserExistsByEmail(email: event.email);
        if (exists) {
          emit(EmailExists());
        } else {
          emit(EmailAvailable());
        }
      }
      if(event is RegisterDriver) {

      }
    });
  }
}
