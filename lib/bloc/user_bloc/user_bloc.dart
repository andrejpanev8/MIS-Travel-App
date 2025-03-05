import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/data/enums/user_role.dart';
import 'package:travel_app/data/models/passenger_trip.dart';
import 'package:travel_app/data/models/task_trip.dart';
import 'package:travel_app/data/models/user.dart';
import 'package:travel_app/data/services/email_service.dart';
import 'package:travel_app/service/auth_service.dart';
import 'package:travel_app/service/invitation_service.dart';
import 'package:travel_app/service/passenger_trip_service.dart';
import 'package:travel_app/service/task_trip_service.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/service/user_service.dart';
import 'package:travel_app/utils/validation_utils.dart';

import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/invitation.dart';
import '../../data/models/trip.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<Trip>? _cachedTrips;
  List<Trip>? _cachedDriverTrips;
  List<TaskTripDTO>? _cachedDeliveries;
  List<TaskTripDTO>? _cachedDriverDeliveries;
  List<UserModel>? _cachedDrivers;
  List<Invitation>? _cachedInvitations;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      emit(ProcessStarted());
      if (event is GetUpcomingRides) {
        if (!event.forceRefresh && _cachedTrips != null) {
          emit(UpcomingTripsLoaded(_cachedTrips!));
          return;
        }

        List<Trip> trips = [];
        trips = await TripService().getAllUpcomingTrips();
        _cachedTrips = trips;
        emit(UpcomingTripsLoaded(trips));
      }

      if (event is GetUpcomingDeliveries) {
        if (!event.forceRefresh && _cachedDeliveries != null) {
          emit(UpcomingDeliveriesLoaded(_cachedDeliveries!));
          return;
        }

        List<TaskTripDTO> deliveries = [];
        deliveries = await TaskTripService().getAllUpcomingDeliveries() ?? [];
        _cachedDeliveries = deliveries;
        emit(UpcomingDeliveriesLoaded(deliveries));
      }

      if (event is GetDriverUpcomingRides) {
        if (!event.forceRefresh && _cachedDriverTrips != null) {
          emit(DriverUpcomingTripsLoaded(_cachedDriverTrips!));
          return;
        }
        UserModel? currentUser = await AuthService().getCurrentUser();

        if (currentUser == null) {
          throw Exception("No authenticated user found.");
        }

        List<Trip> driverTrips = [];
        driverTrips =
            await TripService().getUpcomingTripsByDriver(currentUser.id);
        _cachedDriverTrips = driverTrips;
        emit(DriverUpcomingTripsLoaded(driverTrips));
      }

      if (event is GetUpcomingRides) {
        if (!event.forceRefresh && _cachedDriverTrips != null) {
          emit(UpcomingRidesLoaded(_cachedDriverTrips!));
          return;
        }

        List<Trip> trips = [];
        emit(ProcessStarted());
        trips = await TripService().getAllUpcomingTrips();
        _cachedDriverTrips = trips;
        emit(UpcomingRidesLoaded(trips));
      }

      if (event is GetDriverUpcomingDeliveries) {
        if (!event.forceRefresh && _cachedDriverDeliveries != null) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }

        List<TaskTripDTO> driverDeliveries = [];
        driverDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();
        _cachedDriverDeliveries = driverDeliveries;
        emit(DriverUpcomingDeliveriesLoaded(driverDeliveries));
      }

      if (event is LoadDriverTripsDeliveries) {
        if (!event.forceRefresh &&
            _cachedDriverDeliveries != null &&
            _cachedDriverTrips != null) {
          emit(DriverDataLoaded(_cachedDriverTrips!, _cachedDriverDeliveries!));
          return;
        }
        UserModel? currentUser = await AuthService().getCurrentUser();
        List<Trip> driverTrips = [];
        List<TaskTripDTO> driverDeliveries = [];
        driverTrips = await TripService().getTripsByDriver(currentUser!.id);
        driverDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();

        _cachedDriverTrips = driverTrips;
        _cachedDriverDeliveries = driverDeliveries;
        emit(DriverDataLoaded(driverTrips, driverDeliveries));
      }

      if (event is GetAllDrivers) {
        if (!event.forceRefresh && _cachedDrivers != null) {
          emit(AllDriversLoaded(_cachedDrivers!));
          return;
        }
        List<UserModel> drivers = [];
        drivers =
            await UserService().getAllUsersByRole(userRole: UserRole.DRIVER);
        _cachedDrivers = drivers;
        emit(AllDriversLoaded(drivers));
      }

      if (event is GetAllInvitations) {
        if (!event.forceRefresh && _cachedInvitations != null) {
          emit(AllInvitationsLoaded(_cachedInvitations!));
          return;
        }
        List<Invitation> invitations = [];
        invitations = await InvitationService().getAllInvitations();
        _cachedInvitations = invitations;
        emit(AllInvitationsLoaded(invitations));
      }

      if (event is LoadDriversInvitations) {
        if (!event.forceRefresh &&
            _cachedDrivers != null &&
            _cachedInvitations != null) {
          emit(AdminDataLoaded(_cachedDrivers!, _cachedInvitations!));
          return;
        }
        List<UserModel> drivers = [];
        List<Invitation> invitations = [];
        drivers =
            await UserService().getAllUsersByRole(userRole: UserRole.DRIVER);
        invitations = await InvitationService().getAllInvitations();
        _cachedDrivers = drivers;
        _cachedInvitations = invitations;
        emit(AdminDataLoaded(drivers, invitations));
      }

      if (event is GetTripDetails) {
        UserModel? user;
        List<TaskTrip>? taskTrips;
        List<PassengerTrip>? passengerTrips;
        user = await UserService().getUserById(event.driverId);
        taskTrips =
            await TaskTripService().getAllTaskTripsForTripId(event.tripId);
        passengerTrips = await PassengerTripService()
            .getAllPassengerTripsForTripId(event.tripId);

        emit(TripDetailsLoaded(user, passengerTrips, taskTrips));
      }

      if (event is UpdateUserInfo) {
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

      if (event is GetTripInfo) {
        try {
          UserModel? driver;
          Trip? trip;
          await TripService()
              .findTripByIdWithDriver(event.tripId)
              .then((map) => {
                    if (map != null)
                      {trip = map["trip"], driver = map["driver"]}
                  });
          emit(TripInfoLoaded(trip, driver));
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if (event is CheckEmailExists) {
        bool exists =
            await UserService().checkUserExistsByEmail(email: event.email);
        if (exists) {
          emit(EmailExists());
        } else {
          emit(EmailAvailable());
        }
      }

      if (event is FilterEvent) {
        if (event.state is DriverUpcomingTripsLoaded) {
          if (_cachedDriverTrips == null) {
            return;
          }

          List<Trip> filteredTrips = _cachedDriverTrips!;

          if (event.fromWhere != null && event.fromWhere!.isNotEmpty) {
            filteredTrips = filteredTrips
                .where((trip) => trip.startCity.contains(event.fromWhere!))
                .toList();
          }
          if (event.toWhere != null && event.toWhere!.isNotEmpty) {
            filteredTrips = filteredTrips
                .where((trip) => trip.endCity.contains(event.toWhere!))
                .toList();
          }
          if (event.dateTime != null) {
            filteredTrips = filteredTrips
                .where((trip) => trip.startTime.isAfter(event.dateTime!))
                .toList();
          }
          debugPrint("Filtered trips: $filteredTrips");
          emit(DriverUpcomingTripsLoaded(filteredTrips));
          return;
        }
        if (event.state is DriverUpcomingDeliveriesLoaded) {
          emit(DriverUpcomingDeliveriesLoaded(_cachedDriverDeliveries!));
          return;
        }
      }
      if (event is SendEmail) {
        bool emailSent = await EmailService().sendEmail(event.email);
        if (emailSent) {
          emit(EmailSentSuccessfully());
        } else {
          emit(EmailSentFailed());
        }
      }

      if (event is ClearCacheEvent) {
        _cachedDriverTrips = null;
        _cachedDriverDeliveries = null;
        _cachedTrips = null;
        _cachedDeliveries = null;
        _cachedDrivers = null;
        _cachedInvitations = null;
      }
    });
  }
}
