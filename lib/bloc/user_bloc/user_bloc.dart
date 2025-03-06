import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/data/DTO/AddDeliveryDTO.dart';
import 'package:travel_app/data/DTO/ReserveDeliveryDTO.dart';
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

import '../../data/DTO/PassengerTripDTO.dart';
import '../../data/DTO/TaskTripDTO.dart';
import '../../data/models/invitation.dart';
import '../../data/models/trip.dart';
import '../../service/filter_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<Trip>? _cachedTrips;
  List<Trip>? _cachedDriverTrips;
  List<TaskTripDTO>? _cachedDeliveries;
  List<TaskTripDTO>? _cachedDriverDeliveries;
  List<UserModel>? _cachedDrivers;
  List<Invitation>? _cachedInvitations;
  List<PassengerTripDTO>? _cachedClientTrips;
  List<TaskTripDTO>? _cachedClientDeliveries;

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is GetUpcomingRides) {
        emit(ProcessStarted());
        if (!event.forceRefresh && _cachedTrips != null) {
          emit(UpcomingRidesLoaded(_cachedTrips!));
          return;
        }

        List<Trip> trips = [];
        trips = await TripService().getAllUpcomingTrips();
        _cachedTrips = trips;
        emit(UpcomingRidesLoaded(trips));
      }

      if (event is GetUpcomingDeliveries) {
        emit(ProcessStarted());
        if (!event.forceRefresh && _cachedDeliveries != null) {
          emit(UpcomingDeliveriesLoaded(_cachedDeliveries!));
          return;
        }

        List<TaskTripDTO> deliveries = [];
        deliveries = await TaskTripService().getAllUpcomingDeliveries();
        _cachedDeliveries = deliveries;
        emit(UpcomingDeliveriesLoaded(deliveries));
      }

      if (event is GetDriverUpcomingRides) {
        emit(ProcessStarted());
        if (!event.forceRefresh && _cachedDriverTrips != null) {
          emit(DriverUpcomingRidesLoaded(_cachedDriverTrips!));
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
        emit(DriverUpcomingRidesLoaded(driverTrips));
      }

      if (event is GetDriverUpcomingDeliveries) {
        emit(ProcessStarted());
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
        emit(ProcessStarted());
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
        emit(ProcessStarted());
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
        emit(ProcessStarted());
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
        emit(ProcessStarted());
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
        emit(ProcessStarted());
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

      if (event is GetTripInfo) {
        emit(ProcessStarted());
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
        emit(ProcessStarted());
        bool exists =
            await UserService().checkUserExistsByEmail(email: event.email);
        if (exists) {
          emit(EmailExists());
        } else {
          emit(EmailAvailable());
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

      if (event is CreateDelivery) {
        emit(ProcessStarted());
        try {
          await TaskTripService().createTaskTrip(
              pickUpPhoneNumber: event.delivery.pickUpPhoneNumber,
              startLocation: event.delivery.startLocation,
              dropOffPhoneNumber: event.delivery.dropOffPhoneNumber,
              endLocation: event.delivery.endLocation,
              tripId: event.delivery.tripId,
              description: event.delivery.description);
          emit(DeliveryCreateSuccess());
        }
        catch (error) {
          emit(DeliveryCreateError());
        }
      }

      if (event is FilterEvent) {
        var filteredTrips = [];
        if (event.state is UpcomingRidesLoaded) {
          emit(ProcessStarted());
          if (_cachedTrips == null) {
            return;
          }
          filteredTrips = _cachedTrips!;
          filteredTrips = _filterList<Trip>(filteredTrips.cast<Trip>(),
              event.fromWhere, event.toWhere, event.dateTime);
          emit(UpcomingRidesLoaded(filteredTrips.cast<Trip>()));
          return;
        }
        if (event.state is UpcomingDeliveriesLoaded) {
          emit(ProcessStarted());
          if (_cachedDeliveries == null) {
            return;
          }
          filteredTrips = _cachedDeliveries!;
          filteredTrips = _filterList<TaskTripDTO>(
              filteredTrips.cast<TaskTripDTO>(),
              event.fromWhere,
              event.toWhere,
              event.dateTime);
          emit(UpcomingDeliveriesLoaded(filteredTrips.cast<TaskTripDTO>()));
          return;
        }
      }

      if (event is ClearCacheEvent) {
        _cachedDriverTrips = null;
        _cachedDriverDeliveries = null;
        _cachedTrips = null;
        _cachedDeliveries = null;
        _cachedDrivers = null;
        _cachedInvitations = null;
        _cachedClientDeliveries = null;
        _cachedClientTrips = null;
      }

      if (event is GetClientUpcomingRides) {
        emit(ProcessStarted());
        if (!event.forceRefresh && _cachedClientTrips != null) {
          emit(ClientUpcomingTripsLoaded(_cachedClientTrips!));
          return;
        }

        List<PassengerTripDTO> clientTrips = [];
        emit(ProcessStarted());
        clientTrips = await PassengerTripService().getUpcomingTripsForUser();
        _cachedClientTrips = clientTrips;
        emit(ClientUpcomingTripsLoaded(clientTrips));
      }

      if (event is GetClientUpcomingDeliveries) {
        emit(ProcessStarted());
        if (!event.forceRefresh && _cachedClientDeliveries != null) {
          emit(ClientUpcomingDeliveriesLoaded(_cachedClientDeliveries!));
          return;
        }

        List<TaskTripDTO> clientDeliveries = [];
        emit(ProcessStarted());
        clientDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();
        _cachedClientDeliveries = clientDeliveries;
        emit(ClientUpcomingDeliveriesLoaded(clientDeliveries));
      }

      if (event is LoadClientTripsDeliveries) {
        emit(ProcessStarted());
        if (!event.forceRefresh &&
            _cachedClientDeliveries != null &&
            _cachedClientTrips != null) {
          emit(ClientDataLoaded(_cachedClientTrips!, _cachedClientDeliveries!));
          return;
        }
        List<PassengerTripDTO> clientTrips = [];
        List<TaskTripDTO> clientDeliveries = [];
        emit(ProcessStarted());
        clientTrips = await PassengerTripService().getUpcomingTripsForUser();
        clientDeliveries =
            await TaskTripService().getUpcomingDeliveriesForUser();
        _cachedClientTrips = clientTrips;
        _cachedClientDeliveries = clientDeliveries;
        emit(ClientDataLoaded(clientTrips, clientDeliveries));
      }
    });
  }
}

List<T> _filterList<T extends HasFilterProperties>(List<T> incomingItems,
    String? fromWhere, String? toWhere, DateTime? dateTime) {
  var items = incomingItems;
  if (fromWhere != null && fromWhere.isNotEmpty) {
    items = FilterService.instance.filterByStartCity(items, fromWhere);
  }
  if (toWhere != null && toWhere.isNotEmpty) {
    items = FilterService.instance.filterByEndCity(items, toWhere);
  }
  if (dateTime != null) {
    items = FilterService.instance.filterByStartTime(items, dateTime);
  }
  return items;
}
